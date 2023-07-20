//
//  ProtocolHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/5/29.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryToolSDK
import GemvarySmartHomeSDK

/// 智能家居数据处理类
struct ProtocolHandler {
    /// 开锁记录 闭包
    static var lockOpenLogsBlock:((_ info: [String: Any], _ json: String) -> Void)?
    /// 密钥管理 闭包
    static var lockPasswdManagerBlock:((_ recv: MsgReceive,  _ info: [String: Any]) -> Void)?
    /// 权限管理 闭包
    static var authorityManagerBlock:((_ recv: MsgReceive,  _ info: [String: Any]) -> Void)?
    
    /// 处理 智能家居返回 JSON数据
    static func jsonStrData(jsonDic: [String: Any]) -> Void {
        // 解析数据 转model
        guard let msgReceive = try? ModelDecoder.decode(MsgReceive.self, param: jsonDic) else {
            swiftDebug("转换model失败")
            return
        }
        
        guard let jsonStr = JSONTool.translationObjToJson(from: jsonDic) else {
            swiftDebug("设备上报信息 数据转字符串失败")
            return
        }
        
        // 处理智能家居返回的信息
        switch msgReceive.msg_type {
        case MsgType.device_frontdisplay_manager:
            break
        case MsgType.device_manager: // 设备管理
            DeviceManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.device_have_function: // 设备功能属性
            DeviceHaveFunctionHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.room_manager: // 房间管理
            RoomManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.smart_linkage_manager: // 联动管理
            SmartLinkageManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.scene_control_manager: // 场景管理
            SceneControlManagerHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.device_class_info: // 设备类型信息
            DeviceClassInfoHandler.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.new_device_manager: // 新设备入网上报 通知客户端
            // 发送通知给添加设备页面
            NotificationCenter.default.post(name: NSNotification.Name.new_device_manager, object: nil, userInfo: ["data":jsonStr])
            break
        case MsgType.device_online_manager: // 设备在线管理
            //DeviceOnlineManagerHandle.handleData(msg: msgReceive, info: jsonDic)
            break
        case MsgType.device_state_info: // 设备状态信息
            DeviceStateInfoHandler.handleData(info: jsonDic)
            break
        case MsgType.device_learn_state_info: // 红外转发器学习成功上报状态
            DeviceLearnStateInfoHandler.handleData(info: jsonDic)
            break
        case MsgType.lock_passwd_manager: // 指纹锁密钥管理
            break
        case MsgType.lock_open_logs: // 开锁记录
            break
        case MsgType.authority_manager:
            break
        case MsgType.fresh_smarthome_infos: // 刷新智能家居信息
            // 重新请求智能家居信息
            break
        case MsgType.anti_hijacking_manager: // 指纹锁防劫持设置
            break
        case MsgType.device_control: // 设备控制
            break
        case MsgType.host_manager: // 主机管理
            break
        case MsgType.lock_open_logs: // 指纹锁 开锁记录
            swiftDebug("开门记录 准备传值")
            guard let jsonStr = JSONTool.translationObjToJson(from: jsonDic) else {
                swiftDebug("参数显示信息 字典转字符串失败")
                return
            }
            self.lockOpenLogsBlock?(jsonDic, jsonStr)
            break
        case MsgType.lock_passwd_manager: // 指纹锁 密钥管理
            swiftDebug("密钥管理 准备传值")
            self.lockPasswdManagerBlock?(msgReceive, jsonDic)
            break
        case MsgType.authority_manager: // 指纹锁 权限管理
            swiftDebug("权限管理 准备传值")
            self.authorityManagerBlock?(msgReceive, jsonDic)
            break
        case MsgType.device_join_control: // 设备入网 刷新数据
            // 上报设备入网信息
            NotificationCenter.default.post(name: NSNotification.Name.device_join_control, object: nil, userInfo: ["data":jsonStr])

            break
        default:
            swiftDebug("其他消息类型", msgReceive.msg_type as Any)
            break
        }
        
        
        
        // 发送订阅数据内容
//        if msgReceive.msg_type == MsgType.scene_control_manager && msgReceive.command == Command.add {
//            swiftDebug("添加新场景 不订阅")
//            return
//        }
        
//        guard let jsonStr = JSONTool.translationObjToJson(from: jsonDic) else {
//            swiftDebug("智能家居数据 转换字符串 失败")
//            return
//        }
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeexNotiName.subscription), object: nil, userInfo: ["data": jsonStr])
    }
}

/// 确认消息发送
struct MessageConfirmPushSend: Codable {
    /// 消息类型
    var msg_type: String? = MsgType.message_confirm
    /// 消息命令
    var command: String? = Command.push
    /// 操作角色
    var from_role: String? = FromRole.phone
    /// 账号
    var from_account: String?
    /// 联动ID
    var id: Int?
    /// 功能命令
    var func_cmd: String?
    
    /// 初始化方法
    init(id: Int, func_cmd: String) {
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("获取当前账号为空")
            return
        }
        self.from_account = account
        self.id = id
        self.func_cmd = func_cmd
    }
}
