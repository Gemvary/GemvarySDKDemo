//
//  DeviceManager.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK
import GemvarySmartHomeSDK

/// 设备管理 device_manager
class DeviceManagerHandler: NSObject {

    static func handleData(msg: MsgReceive, info: [String: Any]) -> Void {
        
        // 返回字符串
        guard let jsonStr = JSONTool.translationObjToJson(from: info) else {
            return
        }
        
        guard msg.result == MsgResult.success || msg.result == nil else {
            swiftDebug("处理 device_manager 数据 失败")
            return
        }
        
        switch msg.command {
        case Command.add: // 添加设备
            guard let res = try? ModelDecoder.decode(DeviceManagerAddRecv.self, param: info) else {
                return
            }
            // 插入到数据库中
            res.insertDevice()
            // 请求全部设备类型的所有参数类型的功能属性
            DeviceHaveFunctionQueryHandler.send(classTypes: Device.queryAllDeviceClassTypeList())
            
            break
        case Command.delete: // 删除设备
            guard let res = try? ModelDecoder.decode(DeviceManagerDeleteRecv.self, param: info) else {
                return
            }
            res.delete()
            
            break
        case Command.modify_func_name: // 更改名字
            if let jsonStr = JSONTool.translationObjToJson(from: info) {
                // 设备状态上报 订阅更新 weex
            }
            guard let res = try? ModelDecoder.decode(DeviceManagerModifyFuncNameRecv.self, param: info) else {
                swiftDebug("DeviceManagerModifyFuncNameRecv 转换Model失败")
                return
            }
            res.updateDevice()
            break
        case Command.active: // 激活禁用
            if let jsonStr = JSONTool.translationObjToJson(from: info) {
                // 设备状态上报 订阅更新 weex
            }
            guard let res = try? ModelDecoder.decode(DeviceManagerActiveRecv.self, param: info) else {
                swiftDebug("DeviceManagerActiveRecv 转换Model失败")
                return
            }
            // 更新数据库
            res.updateDevice()
            break
        case Command.modify: // 更改
            if let jsonStr = JSONTool.translationObjToJson(from: info) {
            }
            guard let res = try? ModelDecoder.decode(DeviceManagerModifyRecv.self, param: info) else {
                swiftDebug("DeviceManagerModifyRecv 转换Model失败")
                return
            }
            swiftDebug("设备更改内容 ", res)
            res.updateDevice()
            break
        case Command.query: // 查询设备
            
            guard let res = try? ModelDecoder.decode(DeviceManagerQueryRecv.self, param: info) else {
                swiftDebug("DeviceManagerQueryRecv 转换Model失败")
                return
            }
            if res.query_all == "yes", let devices = res.devices {
                // 智能家居数据删除所有数据
                Device.deleteAll()
                //
                Device.insert(devices: devices)
                // 发送命令 查询设备属性
                DeviceHaveFunctionQueryHandler.send(classTypes: Device.queryAllDeviceClassTypeList())
                // 操作数据库完成 weex查询数据库内容
            }
            
            break
        case Command.shortcut: // 设备设置成常用
            guard let res = try? ModelDecoder.decode(DeviceManagerShortcutRecv.self, param: info) else {
                swiftDebug("DeviceManagerShortcutRecv 转换Model失败")
                return
            }
            // 更新数据库
            res.updateDevice()
            break
        case Command.ad_setting: // 广告开关
            guard let res = try? ModelDecoder.decode(DeviceManagerAdSettingRecv.self, param: info) else {
                swiftDebug("DeviceManagerShortcutRecv 转换Model失败")
                return
            }
            // 更新数据库
            res.update()
            if let jsonStr = JSONTool.translationObjToJson(from: info) {
                // 设备状态上报 订阅更新 weex
            }
            break
        default: // 其他命令
            break
        }
    }
    
}

/// 设备管理 添加 接受消息
class DeviceManagerAddRecv: NSObject, Codable {
    /// 消息类型 device_manager
    var msg_type: String?
    /// 命令 add
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 房间名称
    var room_name: String?
    /// 网关ID
    var riu_id: Int?
    /// 设备类型
    var dev_class_type: String?
    /// 设备名称
    var dev_name: String?
    /// 设备地址
    var dev_addr: String?
    /// 设备私有地址
    var dev_net_addr: String?
    /// 设备私有类型 设备上报
    var dev_uptype: Int?
    /// 端点ID
    var dev_key: Int?
    /// 界面icon
    var brand_logo: String?
    /// 品牌
    var brand: String?
    /// 设备状态
    var dev_state: String?
    /// 特殊设备使用
    var dev_additional: String?
    /// 操作返回结果
    var result: String?
    /// 设备ID
    var dev_id: Int?
    /// 在线离线
    var online: Int?
    /// 激活禁用
    var active: Int?
    /// 自定义功能参数
    var func_define: String?
    /// 设备通道(M9)
    var channel_id: Int?
    /// 设备所属网关地址
    var host_mac: String?
    ///
    var comm_type: Int?
        
    //MARK: 初始化device并插入值到数据库
    /// 初始化device并插入值到数据库
    func insertDevice() -> Void {
        // 初始化设备值
        var device = Device()
        device.dev_id = self.dev_id
        device.dev_name = self.dev_name
        device.dev_class_type = self.dev_class_type
        device.room_name = self.room_name
        device.riu_id = self.riu_id
        device.dev_addr = self.dev_addr
        device.dev_net_addr = self.dev_net_addr
        device.dev_uptype = self.dev_uptype
        device.dev_key = self.dev_key
        device.brand_logo = self.brand_logo
        device.brand = self.brand
        device.active = self.active
        device.online = self.online
        device.dev_state = self.dev_state
        device.dev_scene = 0
        device.dev_additional = self.dev_additional
        device.shortcut_flag = "0"
        device.func_define = self.func_define
        device.study_flag = 0
        device.channel_id = self.channel_id
        device.host_mac = self.host_mac
        
        // 插入值到数据库
        Device.insert(device: device)
    }
}

/// 设备管理 删除设备 接收消息
class DeviceManagerDeleteRecv: NSObject, Codable {
    /// 消息类型
    var msg_type: String?
    /// 命令
    var command: String?
    /// 房间名字
    var room_name: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 设备名字
    var dev_name: String?
    /// 操作返回结果
    var result: String?
    
    /// 根据房间名 设备名 删除设备
    func delete() -> Void {
        // 判断数据库是否有该设备
        guard let dev_name = self.dev_name, let room_name = self.room_name, let device = Device.query(devName: dev_name, roomName: room_name) else {
            swiftDebug("没有查询到该设备")
            return
        }
        // 删除设备
        Device.delete(device: device)
        
        
        if device.dev_class_type == DevClassType.cateye || device.dev_class_type == DevClassType.doorbell || device.dev_class_type == DevClassType.cateye {
            // 删除设备时 删除摄像头/猫眼/可视门铃的缓存内容
            //let pathStr = LocalFilePath.getLocalFile(device: device)
            // 删除本地缓存文件
            //LocalFilePath.deleteLocalFile(pathStr: pathStr)
        }
    }
    
}

/// 设备管理 修改某个设备的功能 接收的消息
class DeviceManagerModifyFuncNameRecv: NSObject, Codable {
    /// 消息类型 device_manager
    var msg_type: String?
    /// 命令 modify_func_name
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 房间名字
    var room_name: String?
    /// 网关ID
    var riu_id: Int?
    /// 设备类型
    var dev_class_type: String?
    /// 设备名字
    var dev_name: String?
    /// 设备地址
    var dev_addr: String?
    /// 功能定义函数
    var func_define: String?
    /// 操作返回结果
    var result: String?
    
    //MARK: 转换成Device 数据库查询model并更新值
    /// 转换成Device 数据库查询model并更新值
    func updateDevice() -> Void {
        // 查询当前设备
        if let dev_name = self.dev_name, var device = Device.query(devName: dev_name) {
            // 设备赋值
            device.riu_id = self.riu_id
            device.dev_class_type = self.dev_class_type
            device.room_name = self.room_name
            device.dev_name  = self.dev_name
            device.dev_addr = self.dev_addr
            device.func_define = self.func_define
            
            // 数据库更新数据
            Device.update(device: device)
        }
    }
}

/// 设备管理 设备的激活和禁用 接收消息
class DeviceManagerActiveRecv: NSObject, Codable {
    /// 激活 禁用
    var active: Int?
    /// 命令 激活 禁用
    var command: String?
    /// 设备地址
    var dev_addr: String?
    /// 设备类型
    var dev_class_type: String?
    /// 设备名字
    var dev_name: String?
    /// 客户端ID
    var from_account: String?
    /// 手机/平板
    var from_role: String?
    /// 消息类型 设备管理
    var msg_type: String?
    /// 操作返回结果
    var result: String?
    /// 网关ID
    var riu_id: Int?
    /// 房间名字
    var room_name: String?
    
    
    /// 转换成Device 数据库查询device并更新值
    func updateDevice() -> Void {
        // 查询当前设备
        if let dev_name = self.dev_name, var device = Device.query(devName: dev_name) {
            // 设备赋值
            device.active = self.active
            device.dev_addr = self.dev_addr
            device.dev_class_type = self.dev_class_type
            device.dev_name = self.dev_name
            device.room_name = self.room_name
            device.riu_id  = self.riu_id
            device.room_name = self.room_name
                
            // 数据库更新数据
            Device.update(device: device)
        }
    }
}

/// 设备管理 修改某个设备信息
class DeviceManagerModifyRecv: NSObject, Codable {
    /// 品牌logo
    var brand_logo: String?
    /// 命令
    var command: String?
    /// 设备地址
    var dev_addr: String?
    /// 设备类型
    var dev_class_type: String?
    /// 设备名字
    var dev_name: String?
    /// 客户端ID
    var from_account: String?
    /// 手机/平板
    var from_role: String?
    /// 消息类型
    var msg_type: String?
    /// 旧的设备名字
    var old_dev_name: String?
    /// 旧的房间名字
    var old_room_name: String?
    /// 协议版本
    var pro_ver: String?
    /// 操作返回结果
    var result: String?
    /// 网关ID
    var riu_id: Int?
    /// 房间名字
    var room_name: String?
    /// 是否常用
    var shortcut_flag: String?
    
    //MARK: 转换成Device 数据库查询device并更新值
    /// 转换成Device 数据库查询device并更新值
    func updateDevice() -> Void {
        // 查询当前设备
        if let old_dev_name = self.old_dev_name, var device = Device.query(devName: old_dev_name) {
            // 设备赋值
            device.brand_logo = self.brand_logo
            device.dev_addr = self.dev_addr
            device.dev_name = self.dev_name
            device.dev_class_type = self.dev_class_type
            device.room_name = self.room_name
            device.riu_id  = self.riu_id
            device.room_name = self.room_name
            device.shortcut_flag = self.shortcut_flag
            
            /// 数据库更新数据
            Device.update(device: device)
        }
    }
}

/// 设备管理 查询 接收消息
class DeviceManagerQueryRecv: NSObject, Codable {
    /// 房间名字
    var room_name: String?
    /// 平板/手机
    var from_role: String?
    /// 客户端唯一ID
    var from_account: String?
    /// 是否查询所有
    var query_all: String?
    /// 消息类型 设备管理
    var msg_type: String?
    /// 命令 查询
    var command: String?
    /// 设备列表
    var devices: [Device]?
    /// 操作返回结果
    var result: String?
}

/// 设备管理 是否常用 接收消息
class DeviceManagerShortcutRecv: NSObject, Codable {
    /// 品牌
    var brand_logo: String?
    /// 命令 shortcut
    var command: String?
    /// 设备地址
    var dev_addr: String?
    /// 设备类型
    var dev_class_type: String?
    /// 设备名称
    var dev_name: String?
    /// 客户端ID
    var from_account: String?
    /// 平板/手机
    var from_role: String?
    /// 消息类型 device_manager
    var msg_type: String?
    /// 旧设备名称
    //var old_dev_name: String?
    /// 操作结果
    var result: String?
    /// 网关ID
    var riu_id: Int?
    /// 房间名称
    var room_name: String?
    /// 是否常用
    var shortcut_flag: String?
    
    /// 转换成Device 数据库查询device并更新值
    func updateDevice() -> Void {
        // 查询当前设备
        if let dev_name = self.dev_name, var device = Device.query(devName: dev_name) {
            // 设备赋值
            device.dev_addr = self.dev_addr
            device.dev_name = self.dev_name
            device.riu_id  = self.riu_id
            device.room_name = self.room_name
            device.shortcut_flag = self.shortcut_flag
            
            // 数据库更新数据
            Device.update(device: device)
        }
    }
}

/// 设置红外设备的广告联动 ad_setting
class DeviceManagerAdSettingRecv: NSObject, Codable {
    /// 消息类型
    var msg_type: String?
    /// 命令
    var command: String?
    ///
    var from_role: String?
    ///
    var from_account: String?
    ///
    var dev_class_type: String?
    ///
    var dev_name: String?
    ///
    var dev_addr: String?
    ///
    var room_name: String?
    ///
    var riu_id: Int?
    ///
    var ad_enable: Int?
    
    /// 更新设备
    func update() -> Void {
        // 查询当前设备
        if let dev_name = self.dev_name, var device = Device.query(devName: dev_name) {
            // 设备赋值
            device.dev_addr = self.dev_addr
            device.dev_name = self.dev_name
            device.riu_id  = self.riu_id
            device.room_name = self.room_name
            device.smart_flag = self.ad_enable
            
            // 数据库更新数据
            Device.update(device: device)
        }
    }
    
}


//MARK: - 发送数据的协议内容
//MARK: device_manager add
struct DeviceManagerAddSend: Codable {
    var brand: String?
    var brand_logo: String?
    var dev_addr: String?
    var dev_class_type: String?
    var dev_key: Int? = 1 // 默认为1
    var dev_name: String?
    var dev_net_addr: String?
    var dev_state: String?
    var dev_uptype: Int? = 0
    var channel_id: Int?
    var riu_id: Int?
    var room_name: String?
    var host_mac: String?
    var gateway_type: String?
    var command: String? = Command.add
    var from_account: String?
    var from_role: String? = FromRole.phone
    var msg_type: String? = MsgType.device_manager
    
    init(from_account: String) {
        self.from_account = from_account
    }
}

//MARK: device_manager delete
struct DeviceManagerDeleteSend: Codable {
    var msg_type: String? = MsgType.device_manager
    var command: String? = Command.delete
    var from_role: String? = FromRole.phone
    var from_account: String?
    var dev_name: String?
    var room_name: String?
    
    init(from_account: String, dev_name: String, room_name: String) {
        self.from_account = from_account
        self.dev_name = dev_name
        self.room_name = room_name
    }
    
}


struct DeviceManagerModifySend: Codable {
    var brand_logo: String?
    var dev_addr: String?
    var dev_class_type: String?
    var dev_name: String?
    var old_dev_name: String?
    var old_room_name: String?
    var riu_id: Int?
    var room_name: String?
    var shortcut_flag: Int?
    var command: String? = Command.modify
    var from_account: String?
    var from_role: String? = FromRole.phone
    var msg_type: String? = MsgType.device_manager
    
}

/// 修改某个设备为常用
struct DeviceManagerShortcutSend: Codable {
    var brand_logo: String?
    var dev_addr: String?
    var dev_class_type: String?
    var dev_name: String?
    var old_dev_name: String?
    var riu_id: Int?
    var room_name: String?
    var shortcut_flag: Int?
    var command: String? = Command.shortcut
    var from_account: String?
    var from_role: String = FromRole.phone
    var msg_type: String? = MsgType.device_manager
    
}


/// 设备的 激活与禁用
struct DeviceManagerActiveSend: Codable {
    var msg_type: String? = MsgType.device_manager
    var from_role: String? = FromRole.phone
    var command: String? = Command.active
    var from_account: String?
    var room_name: String?
    var riu_id: Int?
    var dev_name: String?
    var dev_class_type: String?
    var dev_addr: String?
    var active: Int?
    
}

/// 查询 设备信息
struct DeviceManagerInfoQuerySend: Codable {
    var msg_type: String? = MsgType.device_manager
    var command: String? = Command.query
    var from_role: String? = FromRole.phone
    var room_name: String?
    var from_account: String?
    var dev_name: String?
    var query_all: String?
    
    init(from_account: String, room_name: String, dev_name: String, query_all: String) {
        self.from_account = from_account
        self.room_name = room_name
        self.dev_name = dev_name
        self.query_all = query_all
    }
}

public class QueryAll: NSObject {
    @objc public static let yes = "yes"
    @objc public static let no = "no"
}


/// 修改某个设备功能ID名称
struct DeviceManagerModifyFuncNameSend: Codable {
    var msg_type: String? = MsgType.device_manager
    var command: String? = Command.modify_func_name
    var from_role: String? = FromRole.phone
    var from_account: String?
    var room_name: String?
    var riu_id: Int?
    var dev_class_type: String?
    var dev_addr: String?
    var dev_name: String?
    var func_define: String?
    
    init(from_account: String) {
        self.from_account = from_account
    }
}

/// 设置保存设备的SlaveId
struct DeviceManagerAddSlaveIndexSend: Codable {
    var msg_type: String? = MsgType.device_manager
    var command: String? = "add_slaveIndex"//Command.add
    var from_account: String?
    var from_role: String?
    var dev_slaveIndex: Int?
    var dev_addr: String?
    var dev_class_type: String?
    var dev_name: String?
    var riu_id: Int?
    var room_name: String?
    
    init(from_account: String, from_role: String, dev_slaveIndex: Int, dev_addr: String, dev_class_type: String, dev_name: String, riu_id: Int, room_name: String) {
        self.from_account = from_account
        self.from_role = from_role
        self.dev_slaveIndex = dev_slaveIndex
        self.dev_addr = dev_addr
        self.dev_class_type = dev_class_type
        self.dev_name = dev_name
        self.riu_id = riu_id
        self.room_name = room_name
    }
}


/// 设置红外设备广告联动
struct DeviceManagerAdSettingSend: Codable {
    var msg_type: String? = MsgType.device_manager
    var command: String? = Command.ad_setting
    var from_role: String? = FromRole.phone
    var from_account: String?
    var ad_enable: Int?
    var dev_addr: String?
    var dev_class_type: String?
    var dev_name: String?
    var riu_id: Int?
    var room_name: String?
    
    init(from_account: String, ad_enable: Int, dev_addr: String, dev_class_type: String, dev_name: String, riu_id: Int, room_name: String) {
        self.from_account = from_account
        self.ad_enable = ad_enable
        self.dev_addr = dev_addr
        self.dev_class_type = dev_class_type
        self.dev_name = dev_name
        self.riu_id = riu_id
        self.room_name = room_name
    }
}
