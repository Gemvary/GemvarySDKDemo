//
//  SmartHomeHandler.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/8/31.
//

import UIKit
import GemvaryToolSDK
import GemvarySmartHomeSDK

class SmartHomeHandler: NSObject {

    
    /// 当前设备信息
    private static var deviceInfo: [String: Any] = [String: Any]()
    
    /// 搜索局域网设备
    @objc public static func searchLanDevice() -> Void {
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号为空")
            return
        }
        // 开始搜索局域网
        LanLibService.share.searchLanDevice(account: account)
        
    }
        
    /// 连接智能家居
    @objc public static func initSmartHome() -> Void {
                
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号为空")
            return
        }
        
        // 获取TCP状态
        LanLibService.share.getTcpStatus()
        // 局域网初始化
        LanLibService.share.searchLanDevice(account: account)
    }
    
    /// 订阅空间
    @objc public static func subscribeSpace(callback: ((Error?) -> Void)? = nil) -> Void {
        // 当前设备信息为空
        self.deviceInfo = [String: Any]()
        
        guard let accountInfo = AccountInfo.queryNow(), let spaceID = accountInfo.spaceID, let access_token = accountInfo.access_token else {
            swiftDebug("当前空间信息为空")
            return
        }
        
        WebSocketTool.share.connectSocket(spaceID: spaceID, access_token: access_token) { result, error in
            callback!(nil)
        }
    }
    
    /// 智能家居订阅数据( 或 绑定设备)
    @objc public static func subscribe(deviceInfo: [String: Any], callback: ((Error?) -> Void)? = nil) -> Void {
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号信息为空")
            return
        }
        
        guard let devcode: String = deviceInfo["devcode"] as? String else {
            swiftDebug("不是主机设备")
            return
        }
        
        if let access_token = accountInfo.access_token {
            // 绑旧款主机设备
            WebSocketTool.share.connectSocket(devCode: devcode, access_token: access_token) { result, error in
                swiftDebug("绑定是否成功")
                callback!(nil)
            }
        }
       
        // 如果设备信息有局域网 就订阅局域网数据
        if let ip: String = deviceInfo["ip"] as? String {
            // 如果有IP字段 可以先连接局域网
            LanLibService.share.subscribeData(account: account, serverIP: ip, deviceID: devcode) { error in
                guard error == nil else {
                    swiftDebug("局域网 订阅数据失败")
                    callback!(error)
                    return
                }
                callback!(nil)
            }
        }
        // 设备信息赋值
        self.deviceInfo = deviceInfo
    }
    
    /// 智能家居发送数据
    @objc public static func sendData(msg: String, callback: (([String : Any]? , Error?) -> Void)? = nil) -> Void {
        
//        guard let accountInfo = AccountInfo.queryNow() else {
//            swiftDebug("当前账户信息为空")
//            return
//        }
        
//        if let smartDevCode = accountInfo.smartDevCode, smartDevCode != "" {
//            // 发送旧款主机
//            // websocket
//            WebSocketTool.share.sendData(sendMag: msg) { object, error in
//                swiftDebug("")
//                guard let object = object, let dict = JSONTool.translationJsonToDic(from: object) else {
//                    swiftDebug("转换字典失败")
//                    return
//                }
//                callback!(dict, error)
//            }
//        }
        
        // 新云端V3收发数据处理
        //if let spaceID = accountInfo.spaceID, spaceID != "" {
            // 发送空间数据
            RequestHandler.iotGatewayProxy(data: msg) { (success) in
                swiftDebug("发送数据 成功", success as Any)
                // 处理解析后的数据
                guard let jsonDic = JSONTool.translationJsonToDic(from: success!) else {
                    swiftDebug("转换字段数据失败")
                    return
                }
                // 解析数据
                ProtocolHandler.jsonStrData(jsonDic: jsonDic)
                callback!(jsonDic, nil)
            } failedCallback: { (failed) in
                swiftDebug("发送数据 失败", failed as Any)
                callback!([String: Any](), nil)
            }
        //}
                
        // 局域网收发数据
//        if let ip: String = self.deviceInfo["ip"] as? String, ip != "" {
//            // lan device
//            LanLibService.share.sendDataToGateway(json: msg) { object in
//                guard let content = object, let dic = JSONTool.translationJsonToDic(from: content) else {
//                    swiftDebug("转换字典失败")
//                    return
//                }
//                callback?(dic, nil)
//            }
//        }
    }
    
    /// 接收智能家居数据
    @objc public static func reviceData( _ callback:((String?) -> Void)? = nil) -> Void {
        
        // 局域网上报数据
        LanLibService.share.receiveData { msg in
            callback!(msg)
        }
        
        // websockt上报数据
        WebSocketTool.share.receiveData { dict in
            swiftDebug("WebSocket上报数据: ", dict as Any)
            // 把数据转换为字符串
            if let dictData = dict, let jsonStr = JSONTool.translationObjToJson(from: dictData) {
                callback!(jsonStr)
            }
        }
    }
    
    
    /// 智能家居断开连接
    @objc public static func disconnet() -> Void {
        // 断开websocket
        WebSocketTool.share.disconnect()
        // 断开局域网
        LanLibService.share.disconnectTCP()
    }
    
    
    /// 智能家居接收消息处理
    static func handlerJSONStrData(jsonStr: String) -> Void {
        // 字符串转换成字典类型
        guard let jsonDic = JSONTool.translationJsonToDic(from: jsonStr) else {
            return
        }
        
        guard let msgReceive = try? ModelDecoder.decode(MsgReceive.self, param: jsonDic) else {
            swiftDebug("接收到的数据 解析失败")
            return
        }
        // 处理返回的数据 发送到日志服务器
        //SmartHomeTest.handlerTestMsg(msg: msgReceive, info: jsonDic)
        
        // 判断消息类型
        switch msgReceive.msg_type {
        case MsgType.device_state_info:
            // 设备状态上报 处理数据
            DeviceStateInfoHandler.handleData(info: jsonDic)
            break
        case MsgType.device_learn_state_info:
            // 红外转发器学习成功上报状态
            DeviceLearnStateInfoHandler.handleData(info: jsonDic)
            break
        case MsgType.device_frontdisplay_manager:
            // 设备参数首页面显示
            //swiftDebug("设备首页信息显示")
            
            break
        case MsgType.device_have_function:
            // 功能属性查询 设备类型具备的属性
            DeviceHaveFunctionHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.device_manager:
            // 设备管理类处理消息
            DeviceManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.room_manager:
            // 房间管理
            RoomManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.smart_linkage_manager:
            // 联动管理
            SmartLinkageManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.scene_control_manager:
            // 情景管理
            SceneControlManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.device_class_info:
            // 设备类型信息
            DeviceClassInfoHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.data_manager:
            // 数据管理 数据备份 发送weex
            swiftDebug("数据管理 数据备份")
            break
        case MsgType.lock_open_logs:
            // 开门记录
            //if (self.lockPasswdManagerBlock != nil) {
                swiftDebug("开门记录 准备传值")
                //self.lockOpenLogsBlock?(jsonDic, jsonStr)
            //}
            break
        case MsgType.lock_passwd_manager:
            // 密钥管理
            //if (self.lockPasswdManagerBlock != nil) {
                swiftDebug("密钥管理 准备传值")
                //self.lockPasswdManagerBlock?(msgReceive, jsonDic)
            //}
            break
        case MsgType.authority_manager:
            // 权限管理
            //if (self.authorityManagerBlock != nil) {
                swiftDebug("权限管理 准备传值")
                //self.authorityManagerBlock?(jsonDic, jsonStr)
                //self.authorityManagerBlock?(msgReceive, jsonDic)
            //}
            break
        case MsgType.hardware_and_software_version:
            // 版本信息
            break
        case MsgType.gateway_manager:
            // 主机管理
            //GatewayManagerHandler.handlerMsgGatewayManager(msg: jsonDic)
            break
        case MsgType.host_manager:
            // 宿主机管理 赋值给gateway类变量
            //WeexGatewayModule.hostManagerStr = jsonStr
            break
        case MsgType.device_online_manager:
            // 上报设备在线离线消息
            DeviceOnlineManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.user_manager: // 用户管理
            break
        default:
            swiftDebug("未知的消息类型数据: \(jsonStr)")
            break
        }
        
        // 判断是否需要订阅数据
        if msgReceive.command == Command.start || msgReceive.command == Command.stop {
            return
        }
        
        if msgReceive.msg_type == MsgType.device_state_info || msgReceive.command == Command.active || msgReceive.msg_type == MsgType.device_online_manager || msgReceive.msg_type == MsgType.host_manager {
            return
        }
        
    }
    
    /// 跳转子设备页面
    static func gotoNodeDeviceVC(naviVC: UINavigationController, device: Device) -> Void {
        
        guard let dev_class_type = device.dev_class_type else {
            swiftDebug("获取设备类型为空")
            return
        }
        
        var nodeDeviceVC: NodeDeviceVC = NodeDeviceVC()
        
        switch dev_class_type {
        case DevClassType.light_one: // 单键开关
            nodeDeviceVC = LightOneVC()
            break
        case DevClassType.light_two: // 双键开关
            break
        case DevClassType.dimmer: // 调光开关
            break
        case DevClassType.curtain: // 窗帘
            break
        case DevClassType.socket: // 智能插座
            break
        default:
            break
        }
        // 设备信息赋值
        nodeDeviceVC.device = device
        // 跳转页面
        naviVC.pushViewController(nodeDeviceVC, animated: true)
    }
    
    
}

/// 智能家居接受数据解析
class MsgReceive: NSObject, Codable {
    /// 消息类型
    var msg_type: String?
    /// 命令
    var command: String?
    /// 结果
    var result: String?
}

/// 智能家居消息返回result的状态
class MsgResult {
    /// 数据错误
    static let data_error = "data_error"
    /// 成功
    static let success = "success"
    /// 失败
    static let failed = "failed"
    /// 相同设备
    static let same = "same"
}
