//
//  SmartHomeSubscribe.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/8/31.
//

import UIKit
import GemvaryToolSDK
import GemvarySmartHomeSDK
import GemvaryCommonSDK

/// 智能家居订阅数据
class SmartHomeSubscribe: NSObject {
    
    /// 订阅数据状态 默认未订阅
    static var subscribeState: Bool = false
    
    /// 订阅设备数据集(外网/局域网)  是否发送初始化数据
    static func subscribeClass(device: HostDevice, sendData: Bool) -> Void {
        swiftDebug("subscribeClass 开始订阅 ", device)
        // 清除智能家居设备的数据 只有在设备订阅成功后删除数据
            
        if device.online == false && device.plat == DevicePlat.jhcloud {
            //ProgressHUD.showText(NSLocalizedString("设备离线，请检查设备", comment: ""))
            swiftDebug("设备离线 不能订阅")
            return
        }
        
        if device.online != nil, device.online == false {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                DispatchQueue.main.async {
                    ProgressHUD.showText(NSLocalizedString("智能主机离线状态", comment: ""))
                }
            }
        }
        
        // 断开MQTT连接
        guard let deviceInfo = ModelEncoder.encoder(toDictionary: device) else {
            swiftDebug("解析主机数据失败")
            return
        }
        
        // 智能家居 订阅数据
        SmartHomeManager.subscribe(deviceInfo: deviceInfo) { (error) in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    // 弹出POP 绑定设备成功
                    if sendData == true {
                        ProgressHUD.showText(NSLocalizedString("智能家居设备绑定失败", comment: ""))
                    }
                    self.subscribeState = false
                }
                if device.plat == DevicePlat.ablecloud {
                    debugPrint("这是AbleCloud环境")
                }
                return
            }
            DispatchQueue.main.async {
                // 弹出POP 绑定设备成功
                if sendData == true {
                    ProgressHUD.showText(NSLocalizedString("智能家居设备绑定成功", comment: ""))
                }
            }
            self.subscribeState = true
            // 删除数据
            //SmartHomeDataBase.deleteAllSmartHomeDB()
            // mqtt订阅数据
            guard var accountInfo = AccountInfo.queryNow() else {
                swiftDebug("智能家居 当前账号为空")
                return
            }
            
            swiftDebug("当前绑定的 设备信息::: ", device)
                        
            // 更新数据库
            accountInfo.smartDevCode = device.devcode // 账号当前设备码
            accountInfo.bindType = device.bindType // 账号当前绑定类型
            AccountInfo.update(accountInfo: accountInfo)
            
            //swiftDebug("当前账户 的信息::: ", accountInfo)
            //swiftDebug("当前账户 的信息 数据库::: ", AccountInfo.queryNow()!)
            
            if sendData == true {
                // 需要发送初始化数据 当重新连接时不需要发送初始化数据
                // 发送数据
                SmartHomeSubscribe.sendInitDataToWeex()
                swiftDebug("发送订阅数据的请求，，，")
            }
        }
    }
    
    /// 发送通知 初始化数据到weex
    static func sendInitDataToWeex() -> Void {
        
        // 发送初始化数据
        self.sendInitData()
    }
    
    
    /// 发送数据
    static func sendInitData() -> Void {
        
        guard let accountInfo = AccountInfo.queryNow(), let account  = accountInfo.account, account != "" else {
            swiftDebug("当前用户账号为空")
            return
        }
        
        let device_manager_query = [
            "msg_type": "device_manager", // 设备管理
            "command": "query",
            "from_role": "phone",
            "from_account": "sdk",
            "room_name": "",
            "dev_name": "",
            "query_all": "yes",
        ]
                
        let room_manager_query = [
            "msg_type" : "room_manager",
            "command" : "query",
            "from_role" : "phone",
            "from_account" : "sdk",
            "room_name" : ""
        ]
        
        let scene_control_manager_query_all = [
            "msg_type" : "scene_control_manager",
            "command" : "query_all",
            "from_role" : "phone",
            "from_account" : account,
        ]
        
        let device_class_info_query = [
            "msg_type": "device_class_info",
            "command": "query",
            "from_role": "phone",
            "from_account": "",
            "riu_id": 0, // 默认0
        ] as [String : Any]
        
        let sendList = [device_manager_query, room_manager_query, scene_control_manager_query_all, device_class_info_query]
        for data_dict in sendList {
            if let data_json = JSONTool.translationObjToJson(from: data_dict) {
                
                SmartHomeManager.sendMsgDataToDevice(msg: data_json) { object, error in
                    debugPrint("发送数据返回内容:: ", object as Any, error as Any)
                }
            }
        }
        // 订阅数据
        self.reviceMessageData()
    }
    
    
    //MARK: 处理订阅来的数据·
    /// 处理订阅收到的数据
    static func reviceMessageData(_ callBack: ((String) -> Void)? = nil) -> Void {
        // 智能家居返回的数据
        
        SmartHomeManager.reviceSubscribeData { (msg) in
            swiftDebug("正常 返回来的闭包内容: ", msg as Any)
            guard msg != nil, msg != "" else {
                callBack!("")
                return
            }
            // 异步
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                // 智能家居解析解析数据字符串
                SmartHomeHandler.handlerJSONStrData(jsonStr: msg!)
                /// 闭包返回数据
                //callBack?(msg!)
            }
            // 主线程
            DispatchQueue.main.async {
                /// 闭包返回数据
                callBack?(msg!)
            }
        }
    }
    
    //MARK: 取消订阅数据(外网/局域网)
    /// 取消订阅数据(外网/局域网)
    static func unSubscribeClass(device: HostDevice) -> Void {
        
        guard let deviceInfo = ModelEncoder.encoder(toDictionary: device) else {
            swiftDebug("设备信息为空")
            return
        }
        // 智能家居取消订阅设备
        SmartHomeManager.unSubscribe(deviceInfo: deviceInfo)
    }
    
            
}

/// 智能家居平台
struct DevicePlat {
    /// AbleCloud云
    static let ablecloud = "ablecloud"
    /// jhcloud MQTT
    static let jhcloud = "jhcloud"
    /// 局域网 Host小主机
    static let hostlan = "hostlan"
}
