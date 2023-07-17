//
//  DeviceLearnStateInfo.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK

class DeviceLearnStateInfoHandler: NSObject {

    /// 处理数据
    static func handleData(info: [String: Any]) -> Void {
        
        if let jsonStr = JSONTool.translationObjToJson(from: info) {
        }
        //
        guard let res = try? ModelDecoder.decode(DeviceLearnStateInfoRecv.self, param: info) else {
            swiftDebug("DeviceLearnStateInfoRecv 转换Model失败")
            return
        }
        // 遍历设备 更新设备的值
        for device in res.devices! {
            device.updateDevice()
        }
    }
}

/// 设备学习状态 接收到消息
class DeviceLearnStateInfoRecv: NSObject, Codable {
    /// 消息类型 device_learn_state_info
    var msg_type: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 命令 up
    var command: String?
    /// 操作返回结果
    var result: String?
    /// 学习状态上报的设备
    var devices: [LearnStateDeviceUp]?
    
}

/// 设备学习状态上报设备
class LearnStateDeviceUp: NSObject, Codable {
    /// 激活 禁用
    var active: Int?
    /// 是否在线
    var online: Int?
    /// 设备ID
    var dev_id: Int?
    /// 设备名字
    var dev_name: String?
    /// 设备类型
    var dev_class_type: String?
    /// 设备状态
    var dev_state: String?
    /// 房间名称
    var room_name: String?
    /// 设备自定义功能参数
    var func_define: String?
    
    
    //MARK: 转换成Device 数据库查询model并更新值
    /// 转换成Device 数据库查询model并更新值
    func updateDevice() -> Void {
        // 查询当前设备
        if let dev_name = self.dev_name, var device: Device = Device.query(devName: dev_name) {
            //swiftDebug("查询到的设备信息是?", device)
            // 设备赋值
            device.active = self.active
            device.online = self.online
            // device.dev_id  = self.dev_id
            // device.dev_name = self.dev_name
            // 学习时 红外转发设备上报状态 其设备类型会改变 应该根据设备名去查询设备 更新状态 所以不更改设备类型
            //device.dev_class_type = self.dev_class_type
            device.dev_state = self.dev_state
            // device.room_name = self.room_name
            device.func_define = self.func_define
            
            Device.update(device: device)
        }
    }
}
