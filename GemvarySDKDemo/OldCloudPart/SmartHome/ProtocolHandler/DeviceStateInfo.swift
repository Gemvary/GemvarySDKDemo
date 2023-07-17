//
//  DeviceStateInfo.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK
import GemvarySmartHomeSDK

class DeviceStateInfoHandler: NSObject {

    static func handleData(info: [String: Any]) -> Void {
        
        guard let jsonStr = JSONTool.translationObjToJson(from: info) else {
            swiftDebug("设备状态信息 转换字符串失败")
            return
        }
        
        // 没有成功字段
        guard let res = try? ModelDecoder.decode(DeviceStateInfoRecv.self, param: info) else {
            swiftDebug("DeviceStateInfoRecv 转换Model失败")
            return
        }
        guard let devices = res.devices else {
            swiftDebug("上报设备数据为空")
            return
        }
        // 遍历设备 更新设备的值
        for device in devices {
            if device.dev_class_type == DevClassType.fresh_air_system_ac_jw, jsonStr.contains("\"room_num\":") {
                return
            }
                        
            device.updateDevice()
        }
    }
    
}

/// 设备状态信息 上报 接收的消息
class DeviceStateInfoRecv: NSObject, Codable {
    /// 消息类型 device_state_info
    var msg_type: String?
    /// 命令 up
    var command: String?
    /// 客户端ID 18937f53cf81
    var from_account: String?
    /// 手机/平板 devconn
    var from_role: String?
    /// 上报的设备
    var devices: [UpDevice]?
}

/// 设备状态信息上报的设备
class UpDevice: NSObject, Codable {
    /// 激活 禁用状态
    var active: Int?
    /// 设备名称高
    var dev_name: String?
    /// 设备类型
    var dev_class_type: String?
    /// 房间名称
    var room_name: String?
    /// 设备ID
    var dev_id: Int?
    /// 在线 离线
    var online: Int?
    /// 当前设备的状态
    var dev_state: String?
    ///
    var dev_uptype: Int?
    
    
    //MARK: 转换成Device 数据库查询model并更新值
    /// 转换成Device 数据库查询model并更新值
    func updateDevice() -> Void {
        // 查询当前设备
        guard let dev_name = self.dev_name, var device = Device.query(devName: dev_name) else {
            //swiftDebug("没有查询到该设备")
            return
        }
        
        //swiftDebug("查询到的设备信息是?", device)
        // 设备赋值
        device.active = self.active
        //device.dev_name = self.dev_name
        // 学习时 红外转发设备上报状态 其设备类型会改变 应该根据设备名去查询设备 更新状态 所以不更改设备类型
        //device.dev_class_type = self.dev_class_type
        //device.room_name = self.room_name
        //device.dev_id  = self.dev_id
        device.online = self.online
        device.dev_state = self.dev_state
        if self.dev_uptype != nil && self.dev_class_type == DevClassType.fresh_air_system {
            // 新风设备更新
            device.dev_uptype = self.dev_uptype
        }
        
        Device.update(device: device)
        
    }
}
