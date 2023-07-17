//
//  SmartHomeLogin.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/8/31.
//

import UIKit
import GemvaryToolSDK
import GemvarySmartHomeSDK
import GemvaryNetworkSDK
import GemvaryCommonSDK

/// 智能家居登录
class SmartHomeLogin: NSObject {
    
    /// 当前登录状态 默认未登录
    var loginState: Bool = false
    
    /// 智能家居登录
    @objc static func connectHostDevice() -> Void {
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account, account != "" else {
            swiftDebug("获取当前账号信息为空")
            return
        }
        // 初始化智能家居
        SmartHomeManager.initSmartHome(debug: true, account: account)
        
        // 判断当前网络状态 网络状态容易是false 造成直接走下面动作
//        guard ReachableTool.share.reachable == true else {
//            swiftDebug("智能家居登录 当前网络状态 没有网络")
//            // 接收到的数据
//            SmartHomeSubscribe.reviceMessageData()
//            return
//        }
        
        // 智能家居注册用户
        SmartHomeLogin.requestUserRegister()
    }
    
    /// 智能家居注册用户
    static func requestUserRegister() -> Void {
        // 请求选择小区
        guard let zone = Zone.queryNow() else {
            ProgressHUD.showText(NSLocalizedString("当前选中小区信息为空", comment: ""))
            return
        }
        
        var ownerRoom = OwnerRoom()
        ownerRoom.unitno = ""
        ownerRoom.roomno = ""
        if let ownerRoomNow = OwnerRoom.queryNow() {
            ownerRoom = ownerRoomNow
        }
        
        // 判断当前账号是否为空
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        swiftDebug("智能家居 当前账户信息", account)
        guard let zoneCode = zone.zoneCode, let unitno = ownerRoom.unitno, let roomno = ownerRoom.roomno else {
            swiftDebug("小区代码 或 房间单元号 房间号 为空")
            return
        }
        
        // 注册用户
        JHCloudWorkAPI.userRegister(account: account, zoneCode: zoneCode, unitNo: unitno, roomNo: roomno) { (object) in
            // 判断返回数据是否为空
            guard (object != nil) else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            // 判断返回数据是否为错
            if let object = object as? Error {
                swiftDebug("请求AC相关信息 报错: ", object.localizedDescription)
                // 弹出错误信息
                ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
                // 接收到的数据
                SmartHomeSubscribe.reviceMessageData()
                return
            }
            
            // 保存到InfoManager内
            swiftDebug("请求返回的结果 用户注册:::", object as Any)
            // 解析返回数据内容 转model
            guard let res = try? ModelDecoder.decode(UserRegisterRes.self, param: object as! [String : Any]) else {
                swiftDebug("UserRegisterRes 转换Model失败")
                return
            }
            // 判断返回数据状态码
            switch res.code {
            case CloudResCode.c000000: // 请求成功
                // 所有都设置为默认
                AccountInfo.setupAllDefault()
                
                // 登录智能家居SDK AbleCloud/连接Mqtt
                guard let data = res.data else {
                    swiftDebug("请求返回数据为空")
                    return
                }
                guard let uid = data.uid, let token = data.token, let account = data.account, let mqToken = data.mqToken, let mqUid = data.mqUid else {
                    swiftDebug("返回数据内容为空")
                    return
                }
                // 开始登录智能家居
                SmartHomeManager.login(uid: uid, token: token, userID: account, mqToken: mqToken)
                
                // 设置自主订阅设备 优先绑定上次绑定网络主机
                self.userDeviceListRequest()
                
                // 接收到的数据
                SmartHomeSubscribe.reviceMessageData()
                // 更新智能家居数据
                guard var accountInfo = AccountInfo.query(account: account) else {
                    var accountInfo = AccountInfo()
                    accountInfo.account = account
                    accountInfo.token = token
                    accountInfo.uid = uid
                    accountInfo.mqToken = mqToken
                    accountInfo.mqUid = mqUid
                    accountInfo.selected = true
                    // 插入到数据库 设置选中
                    AccountInfo.insert(accountInfo: accountInfo)
                    return
                }
                
                // 去绑定登录ablecloud 更新数据库
                accountInfo.account = account
                accountInfo.token = token
                accountInfo.uid = uid
                accountInfo.mqToken = mqToken
                accountInfo.mqUid = mqUid
                accountInfo.selected = true
                // 更新已有数据 设置选中
                AccountInfo.update(accountInfo: accountInfo)
                //swiftDebug("查询数据库的所有数据:", AccountInfo.queryAll())
                break
            case CloudResCode.c100000: // 请求失败
                DispatchQueue.main.async {
                    if let message = res.message {
                        ProgressHUD.showText(NSLocalizedString(message, comment: ""))
                    } else {
                        ProgressHUD.showText(NSLocalizedString("请求失败", comment: ""))
                    }
                }
                break
            case CloudResCode.c100004: // token过期 重新获取token后重新请求
                FetchApiToken.requestUserLogin { (result) in
                    SmartHomeLogin.requestUserRegister()
                }
                break
            default:
                DispatchQueue.main.async {
                    if let message = res.message {
                        ProgressHUD.showText(NSLocalizedString(message, comment: ""))
                    }
                }
                break
            }
        }
    }
            
    /// 获取主机设备列表
    static func userDeviceListRequest() -> Void {
        
//        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account, account != "" else {
//            debugPrint("当前账号信息为空")
//            return
//        }
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号为空")
            return
        }
                
        JHCloudWorkAPI.userDeviceList(account: account) { object in
            debugPrint("获取主机设备列表请求; ", object as Any)
            
            guard (object != nil) else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            
            if let object = object as? Error {
                swiftDebug("获取与用户绑定的设备列表 报错: \(object.localizedDescription)")
                ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
                return
            }
            
            guard let res = try? ModelDecoder.decode(UserDeviceListRes.self, param: object as! [String : Any]) else {
                swiftDebug("GetDevicesRes 转换Model失败")
                return
            }
            
            swiftDebug("请求设备数组的数组: ", res as Any)

            switch res.code {
            case CloudResCode.c000000: // 成功
                if let data = res.data {
                    // 过滤出上次绑定的设备
                    let nowDevices = data.filter { (device) -> Bool in
                        return device.useflag == true
                    }
                    
                    if nowDevices.count > 0, let device = nowDevices.first {
                        // 订阅当前用户信息的设备的数据集
                        SmartHomeSubscribe.subscribeClass(device: device, sendData: true)
                    }
                    
                }
                break
            case CloudResCode.c100004: // token失效
                FetchApiToken.requestUserLogin { (result) in
                    self.userDeviceListRequest()
                }
                break
            default: // 错误
                swiftDebug("服务器端请求设备列表错误", res)
                break
            }
            
        }
    }
    
    
    
    
    /// 刷新智能家居信息
    static func refreshAbleCloud() -> Void {
        // 接收到的数据
        SmartHomeSubscribe.reviceMessageData()
    }
    
    /// 设备重新连接
    static func reconnetHostDevice() -> Void {
        /*
         重新请求连接设备 然后订阅数据内容 不请求初始化数据
         */
        // 智能家居注册用户
        SmartHomeLogin.requestUserRegister()
    }
        
}

struct UserRegisterRes: Codable {
    /// 返回状态码
    var code: String?
    /// 返回信息
    var data: UserRegisterData?
    /// 返回状态消息
    var message: String?
}

/// 用户注册返回的数据
struct UserRegisterData: Codable {
    /// 用户账户
    var account: String?
    /// 小度Token
    var duerosToken: String?
    /// ID
    var id: Int?
    /// MQTT Token
    var mqToken: String?
    /// MQTT Uid
    var mqUid: Int?
    /// AbleCloud Token
    var token: String?
    /// AbleCloud Uid
    var uid: Int?
}
