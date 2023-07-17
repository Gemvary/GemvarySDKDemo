//
//  MsgTypeCommand.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/10/12.
//

import GemvarySmartHomeSDK

/// 设备入网 打开设备允许入网
struct DeviceJoinControlAction: Codable {
    var msg_type: String? = MsgType.device_join_control
    var command: String? = Command.allow
    var from_role: String? = FromRole.phone
    var from_account: String? = "" // 默认空字符串
    var dev_sn: String? = "" // 默认空字符串
    var dev_class_type: String?
    var gateway_type: String?
    var dev_whitelist: String? = "open"
    var time: Int? = 60 //0--255
    var riu_id: Int? = 0
    var brand: String?
        
    /// 开始入网 allow 停止入网 stop
    init(command: String, deviceClass: DeviceClass) {
        self.command = command
        self.dev_class_type = deviceClass.dev_class_type
        self.gateway_type = deviceClass.gateway_type
        self.brand = deviceClass.brand
    }
}

/// 指定某设备重新入网
struct DeviceJoinControlSend: Codable {
    /*
     "msg_type": "device_join_control",
     "command": "allow/stop",
     "from_role": "phone",
     "from_account": "phone",
     "dev_sn": "",
     "dev_class_type": "light_one",
     "gateway_type": "",
     "riu_id": 5,
     "time":60,//0--255
     "brand": "gemvary.rs485",
     "dev_name": "单键开关",
     "room_name": "默认房间"
     */
    var msg_type: String? = MsgType.device_join_control
    var command: String?
    var from_role: String? = FromRole.phone
    var from_account: String? = ""
    var dev_sn: String?
    var dev_class_type: String?
    var gateway_type: String?
    var riu_id: Int? = 0
    var time: Int? = 60
    var brand: String?
    var dev_name: String?
    var room_name: String?
    
    init(command: String?, device: Device?) {
        self.command = command
        self.dev_sn = device?.dev_addr
        self.dev_class_type = device?.dev_class_type
        self.gateway_type = ""
        self.riu_id = device?.riu_id
        self.brand = device?.brand
        self.dev_name = device?.dev_name
        self.room_name = device?.room_name
    }
    
    
}


/// 白名单是否打开
class DevWhiteList: NSObject {
    /// 打开白名单
    @objc public static let open = "open"
    /// 关闭白名单
    @objc public static let close = "close"
}


//MARK: 房间管理相关请求
/// 请求房间类型 发送数据
struct RoomClassInfoQuerySend: Codable {
    var msg_type: String? = MsgType.room_class_info
    var command: String? = Command.query
    var from_role: String? = FromRole.phone
    var from_account: String?
    
    init(from_account: String) {
        self.from_account = from_account
    }
}

/// 请求房间类型 返回数据
struct RoomClassInfoQueryRecv: Codable {
    var msg_type: String? = MsgType.room_class_info
    var command: String? = Command.query
    var from_role: String? = FromRole.phone
    var from_account: String?
    var room_class: [RoomClass]?
    var result: String?
}

struct RoomClass: Codable {
    /// 房间类型名称
    var room_class_name: String?
    /// 房间类型
    var room_class_type: Int?
}

/// 房间类型
public class RoomClassType: NSObject {
    /// 客厅:1
    @objc public static let livingroom = 1
    /// 餐厅:2
    @objc public static let dinnerroom = 2
    /// 卧室:3
    @objc public static let bedroom = 3
    /// 书房:4
    @objc public static let studyroom = 4
    /// 厨房:5
    @objc public static let kitchen = 5
    /// 洗手间:6
    @objc public static let washroom = 6
    /// 阳台:7
    @objc public static let balcony = 7
    /// 花园:8
    @objc public static let garden = 8
    /// 桑拿房:9
    @objc public static let sauna_room = 9
    /// 健身房:10
    @objc public static let gym = 10
    /// 游泳池:11
    @objc public static let swimming_pool = 11
    /// 车库:12
    @objc public static let garage = 12
    /// 吧台:13
    @objc public static let bar_counter = 13
    /// 娱乐间:14
    @objc public static let entertainment_room = 14
}

/// 新增房间 发送数据
struct RoomManagerAddSend: Codable {
    var msg_type: String? = MsgType.room_manager
    var command: String = Command.add
    var from_role: String? = FromRole.phone
    /// 房间背景图
    var room_backgroup: String?
    /// 房间类型
    var room_class_type: Int?
    var room_name: String?
    var from_account: String?
    
    init(room_backgroup: String, room_class_type: Int, room_name: String, from_account: String) {
        self.room_backgroup = room_backgroup
        self.room_class_type = room_class_type
        self.room_name = room_name
        self.from_account = from_account
    }
}


//MARK: 设备管理相关请求


//MARK: 联动管理相关请求


struct Zigbee2rs485ManagerSerialConfigSend: Codable {
    var msg_type: String? = "zigbee2rs485_manager"
    var command: String? = "serial_config"
    var from_role: String? = FromRole.phone
    var from_account: String?
    var dev_addr: String?
    var dev_net_addr: String?
    var riu_id: Int?
    /// 穿口号
    var serial_port: Int?
    /// 串口波特率
    var baud_rate: Int?
    /// 数据位
    var data_bits: Int?
    /// 校验位
    var parity_bit: Int?
    /// 停止位
    var stop_bit: Int?
    /// 流控制
    var flow_ctrl: Int?
    
}

/*
 {
    "msg_type": "zigbee2rs485_manager",
     "command": "heatbeat_config",
     "from_role": "phone",
     "from_account": "phone",
     "dev_addr": "4cf8cdf3c7ea7e8",
     "dev_net_addr": "4cf8cdf3c7ea7e8",
     "riu_id": 3,
     "enable": 1,
     "time": 25,//second
     "raw": "aa12bc23987698"//pass data
 }
 */
/// 配置心跳包
struct Zigbee2Rs485ManagerHeatbeatConfigSend: Codable {
    var msg_type: String? = "zigbee2rs485_manager"
    var command: String? = "heatbeat_config"
    var from_role: String? = FromRole.phone
    var from_account: String?
    var dev_addr: String?
    var dev_net_addr: String?
    var riu_id: Int?
    /// 使能，1：启用，0禁用
    var enable: Int?
    /// 心跳发送数据
    var raw: String?

    init(from_account: String) {
        self.from_account = from_account
    }
}

/*
 {
     "msg_type": "device_frontdisplay_manager",
     "command": "modify",
     "room_name": "room",
     "from_role": "phone",
     "from_account": "13242902164",
     "dev_name": "devname",
     "dev_id": 1,
     "frontdisplay":"[{"param_name":"PM2.5","func_cmd":"pm25"}]"
 }
 */
/// 设置参数在首页显示
struct DeviceFrontdisplayManagerModifySend: Codable {
    var msg_type: String? = MsgType.device_frontdisplay_manager
    var command: String? = Command.modify
    var from_role: String? = FromRole.phone
    var room_name: String?
    var from_account: String?
    var dev_name: String?
    var dev_id: Int?
    var frontdisplay: String?
}

/*
 {
     "msg_type": "device_frontdisplay_manager",
     "command": "query",
     "room_name": "room",//房间
     "from_role": "phone",
     "from_account": "13242902164",
     "dev_name": "devname",//设备名称
     "dev_id": 1,//设备ID
     "query_all":"yes/no"
 }
 */
/// 查询设备哪些参数显示在首页
struct DeviceFrontdisplayManagerQuerySend: Codable {
    var msg_type: String? =  MsgType.device_frontdisplay_manager
    var command: String? = Command.query
    var room_name: String?
    var from_role: String? = FromRole.phone
    var from_account: String?
    var dev_name: String?
    var dev_id: Int?
    var query_all: String?
    
}

/*
 {
     "admin": "13242902164",//主机管理员手机APP账号
     "command": "backup/restore",
     "from_account": "18927419985",
     "from_role": "phone",
     "mac": "84107890870c182608cf",//备份和恢复的主机唯一码
     "msg_type": "data_manager"
 }
 */
/// 数据备份恢复
struct DataManagerSend: Codable {
    var admin: String?
    var command: String?
    var from_account: String?
    var from_role: String? = FromRole.phone
    var mac: String?
    var msg_type: String? = MsgType.data_manager
}

/*
 {
     "msg_type": " m9cube_voice_manager",
     "from_role": "phone",
     "from_account": "",
     "command": "setting",
     "dev_name": "",
     "dev_class_type": "",
     "room_name": "",
     "volume":55
 }
 */
///  语音面板管理

struct M9CubeVoiceManagerSettingSend: Codable {
    
}
