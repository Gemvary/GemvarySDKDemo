//
//  DeviceOnlineManager.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK

class DeviceOnlineManagerHandler: NSObject {

    static func handleData(msg: MsgReceive, info: [String: Any]) -> Void {
        
        if let jsonStr = JSONTool.translationObjToJson(from: info) {
            
        }
        
        guard let res = try? ModelDecoder.decode(DeviceOnlineManagerRecv.self, param: info) else {
            swiftDebug("DeviceOnlineManagerRecv 转换Model失败")
            return
        }
        // 遍历设备 更新设备的值
        for device in res.devices! {
            device.updateDevice()
        }
    }
    
}

/// 设备在线状态
class DeviceOnlineManagerRecv: NSObject, Codable {
    /// 命令 up
    var command: String?
    /// 地址
    var dev_addr: String?
    /// 上报设备内容
    var devices: [DeviceOnline]?
    /// 客户端ID
    var from_account: String?
    /// 手机/平板/其他
    var from_role: String?
    /// 消息类型 device_online_manager
    var msg_type: String?
    /// 协议版本
    var pro_ver: String?
    /// 网关ID
    var riu_id: Int?
}

/// 设备是否在线判断
class DeviceOnline: NSObject, Codable {
    /// 品牌
    //var brand: String?
    /// 设备地址
    var dev_addr: String?
    /// 设备key
    //var dev_key: Int?
    /// 在线状态
    var online: Int?
    /// 设备网络地址
    ///var dev_net_addr: String?
    
    /// 更新设备
    func updateDevice() -> Void {
        /// 查询所有设备
        guard let dev_addr = self.dev_addr else {
            swiftDebug("设备地址为空")
            return
        }
        // 查询同一设备地址的设备
        let devices: [Device] = Device.queryDevices(devAddr: dev_addr)
        
        for device in devices {
            var deviceTemp = device
            deviceTemp.online = self.online
            Device.update(device: deviceTemp)
        }
    }
}
