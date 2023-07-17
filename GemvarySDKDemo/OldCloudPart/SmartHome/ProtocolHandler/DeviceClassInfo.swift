//
//  DeviceClassInfo.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK
import GemvarySmartHomeSDK

class DeviceClassInfoHandler: NSObject {

    static func handleData(msg: MsgReceive, info: [String: Any]) -> Void {
        
        guard let msgRes = try? ModelDecoder.decode(DeviceClassInfoRecv.self, param: info) else {
            return
        }
        
        switch msgRes.command {
        case Command.query:
            
            if msgRes.device_class != nil {
                // 删除数据库
                DeviceClass.deleteAll()
                // 插入到数据库
                DeviceClass.insert(deviceClasss: msgRes.device_class!)
            }
            break
        default:
            break
        }
    }
    
}

/// 查询支持设备类型信息 device_class_info
class DeviceClassInfoRecv: NSObject, Codable {
    /// 消息类型
    var msg_type: String?
    /// 命令
    var command: String?
    /// 平板/手机
    var from_role: String?
    /// 所属网关类型列表ID
    var riu_id: Int?
    /// 客户端唯一ID
    var from_account: String?
    /// 设备类型
    var device_class: [DeviceClass]?
    /// 操作返回结果
    var result: String?
}
