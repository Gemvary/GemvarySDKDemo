//
//  Device.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB
import GemvarySmartHomeSDK

/// 设备信息类
struct Device: Codable {
    /// 设置rowID
    var id: Int64?
    /// 设备gid
    var gid: String?
    /// 设备名称
    var dev_name: String?
    /// 设备逻辑ID
    var dev_id: Int?
    /// 设备类型
    var dev_class_type: String?
    /// 所属房间
    var room_name: String?
    /// 所属网关ID (非必须)   未配网时默认1 配网后为G模块:3 485:5 S模块: 7
    var riu_id: Int? = 1
    /// 所属主机唯一ID 针对子设备
    var host_mac: String?
    /// 设备唯一ID
    var dev_addr: String?
    /// 设备网络地址
    var dev_net_addr: String?
    /// 设备私有类型
    var dev_uptype: Int?
    /// 设备通道(键值)
    var dev_key: Int?
    /// 设备品牌
    var brand: String?
    /// 设备激活状态
    var active: Int?
    /// 设备在线状态
    var online: Int?
    /// 心跳状态
    var heartbeat: Int?
    /// 设备状态 是一个json字符串
    var dev_state: String?
    /// 设备厂商模型
    var model: String?
    /// 设备附近参数
    var dev_additional: String?
    /// 设备是否设置快捷显示
    var shortcut_flag: String?
    /// 针对红外设备的自定义数据
    var data: String?
    /// 设备所属场景情况 目前暂未使用
    var dev_scene: Int?
    /// 设备通道 针对M9设备
    var channel_id: Int?
    /// 设备状态更新标志
    var state_update_flag: Int?
    /// 心跳时间
    var duration: Int?
    /// 设备认证情况
    var authorization: Int?
    /// 该设备需要在首页显示的参数
    var frontdisplay: String?
    /// 当前执行的命令
    var func_cmd: String?
    /// 重发次数
    var resend_count: Int?
    /// 上一个状态
    var old_status: String?
    /// 状态刷新时间
    var udatetime: Int?
    /// 版本号
    var soft_ver: Int?
    /// 是否为分享设备(分享设备)
    var shared: Bool?
    /// 是否有空间ID(分享设备)
    var spaceId: String?
    /// 广告播放开关
    var smart_flag: Int?
    /// 产品ID
    var product_id: String?
    /// 组织ID
    var group_id: String?
    /// 品牌logo
    var brand_logo: String?
    /// 扩展标签
    var exe_flag: Int?
    /// 功能定义
    var func_define: String?
    /// 固件版本
    var hw_ver: String?
    /// 学习标签
    var study_flag: Int?
    /// 网关地址
    var gateway_type: String?
    
    /// 数据库表行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case id
        /// 设备gid
        case gid
        /// 设备名称
        case dev_name
        /// 设备逻辑ID
        case dev_id
        /// 设备类型
        case dev_class_type
        /// 所属房间
        case room_name
        /// 所属网管ID (非必须)
        case riu_id
        /// 所属主机唯一ID 针对子设备
        case host_mac
        /// 设备唯一ID
        case dev_addr
        /// 设备网络地址
        case dev_net_addr
        /// 设备私有类型
        case dev_uptype
        /// 设备通道(键值)
        case dev_key
        /// 设备品牌
        case brand
        /// 设备激活状态
        case active
        /// 设备在线状态
        case online
        /// 心跳状态
        case heartbeat
        /// 设备状态 是一个json字符串
        case dev_state
        /// 设备厂商模型
        case model
        /// 设备附近参数
        case dev_additional
        /// 设备是否设置快捷显示
        case shortcut_flag
        /// 针对红外设备的自定义数据
        case data
        /// 设备所属场景情况 目前暂未使用
        case dev_scene
        /// 设备通道 针对M9设备
        case channel_id
        /// 设备状态更新标志
        case state_update_flag
        /// 心跳时间
        case duration
        /// 设备认证情况
        case authorization
        /// 该设备需要在首页显示的参数
        case frontdisplay
        /// 当前执行的命令
        case func_cmd
        /// 重发次数
        case resend_count
        /// 上一个状态
        case old_status
        /// 状态刷新时间
        case udatetime
        /// 版本号
        case soft_ver
        /// 是否为分享设备
        case shared
        /// 空间ID(分享设备具有)
        case spaceId
        /// 广告播放开关
        case smart_flag
        /// 产品ID
        case product_id
        /// 组织ID
        case group_id
        /// 品牌logo
        case brand_logo
        /// 扩展标签
        case exe_flag
        /// 功能定义
        case func_define
        /// 固件版本
        case hw_ver
        /// 学习标签
        case study_flag
        /// 网关类型
        case gateway_type
    }
    
    /// 设置rowID
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

/// 实现CURD功能
extension Device: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建数据库表
    private static func createTable() -> Void {
        try! self.dbPool.write({ (db) -> Void in
            if try db.tableExists(SmartHomeTable.device) {
                //swiftDebug("表已经存在")
                // 新增数据库字段
                let columns: [ColumnInfo] = try db.columns(in: SmartHomeTable.device)
                // 遍历是否包含 gid行
                let gid = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.gid.rawValue
                }
                // 不存在 gid行 添加该行
                if gid == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.gid.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 dev_name行
                let dev_name = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.dev_name.rawValue
                }
                // 不存在 dev_name行 添加该行
                if dev_name == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.dev_name.rawValue, Database.ColumnType.text)
                    })
                }
                /// 版本号
                let soft_ver = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.soft_ver.rawValue
                }
                // 不存在 soft_ver行 添加该行
                if soft_ver == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.soft_ver.rawValue, Database.ColumnType.integer)
                    })
                }
                // 是否分享设备(分享设备具有)
                let shared = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.shared.rawValue
                }
                // 不存在 shared行 添加该行
                if shared == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.shared.rawValue, Database.ColumnType.boolean)
                    })
                }
                /// 空间ID(分享设备具有)
                let spaceId = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.spaceId.rawValue
                }
                // 不存在 spaceId行 添加该行
                if spaceId == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.spaceId.rawValue, Database.ColumnType.text)
                    })
                }
                // 君和社区需要新增字段
                // 遍历是否包含 host_mac行
                let host_mac = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.host_mac.rawValue
                }
                // 不存在 host_mac行 添加该行
                if host_mac == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.host_mac.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 smart_flag行
                let smart_flag = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.smart_flag.rawValue
                }
                // 不存在 smart_flag行 添加该行
                if smart_flag == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.smart_flag.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 product_id行
                let product_id = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.product_id.rawValue
                }
                // 不存在 product_id行 添加该行
                if product_id == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.product_id.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 group_id行
                let group_id = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.group_id.rawValue
                }
                // 不存在 group_id行 添加该行
                if group_id == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.group_id.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 brand_logo行
                let brand_logo = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.brand_logo.rawValue
                }
                // 不存在 brand_logo行 添加该行
                if brand_logo == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.brand_logo.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 exe_flag行
                let exe_flag = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.exe_flag.rawValue
                }
                // 不存在 exe_flag行 添加该行
                if exe_flag == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.exe_flag.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 func_define行
                let func_define = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.func_define.rawValue
                }
                // 不存在 func_define行 添加该行
                if func_define == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.func_define.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 hw_ver行
                let hw_ver = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.hw_ver.rawValue
                }
                // 不存在 hw_ver行 添加该行
                if hw_ver == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.hw_ver.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 study_flag行
                let study_flag = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.study_flag.rawValue
                }
                // 不存在 study_flag行 添加该行
                if study_flag == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.study_flag.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历判断是否存在 gateway_type行
                let gateway_type = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.gateway_type.rawValue
                }
                // 不存在 gateway_type行 添加该行
                if gateway_type == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.gateway_type.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历判断是否存在 heartbeat行
                let heartbeat = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.heartbeat.rawValue
                }
                // 不存在 heartbeat行 添加该行
                if heartbeat == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.heartbeat.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历判断是否存在 model行
                let model = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.model.rawValue
                }
                // 不存在 model行 添加该行
                if model == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.model.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历判断是否存在 data行
                let data = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.data.rawValue
                }
                // 不存在 data行 添加该行
                if data == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.data.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历判断是否存在 state_update_flag行
                let state_update_flag = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.state_update_flag.rawValue
                }
                // 不存在 state_update_flag行 添加该行
                if state_update_flag == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.state_update_flag.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历判断是否存在 duration行
                let duration = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.duration.rawValue
                }
                // 不存在 duration行 添加该行
                if duration == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.duration.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历判断是否存在 authorization行
                let authorization = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.authorization.rawValue
                }
                // 不存在 authorization行 添加该行
                if authorization == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.authorization.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历判断是否存在 frontdisplay行
                let frontdisplay = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.frontdisplay.rawValue
                }
                // 不存在 frontdisplay行 添加该行
                if frontdisplay == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.frontdisplay.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历判断是否存在 func_cmd行
                let func_cmd = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.func_cmd.rawValue
                }
                // 不存在 func_cmd行 添加该行
                if func_cmd == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.func_cmd.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历判断是否存在 resend_count行
                let resend_count = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.resend_count.rawValue
                }
                // 不存在 resend_count行 添加该行
                if resend_count == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.resend_count.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历判断是否存在 resend_count行
                let old_status = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.old_status.rawValue
                }
                // 不存在 old_status行 添加该行
                if old_status == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.old_status.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历判断是否存在 udatetime行
                let udatetime = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.udatetime.rawValue
                }
                // 不存在 udatetime行 添加该行
                if udatetime == false {
                    try db.alter(table: SmartHomeTable.device, body: { (t) in
                        t.add(column: Columns.udatetime.rawValue, Database.ColumnType.text)
                    })
                }
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.device, temporary: false, ifNotExists: true, body: { (t) in
                // 自增ID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                // 设备gid
                t.column(Columns.gid.rawValue, Database.ColumnType.text)
                // 设备名称
                t.column(Columns.dev_name.rawValue, Database.ColumnType.text)
                // 设备逻辑ID
                t.column(Columns.dev_id.rawValue, Database.ColumnType.integer)
                // 设备类型
                t.column(Columns.dev_class_type.rawValue, Database.ColumnType.text)
                // 所属房间
                t.column(Columns.room_name.rawValue, Database.ColumnType.text)
                // 所属网管ID (非必须)
                t.column(Columns.riu_id.rawValue, Database.ColumnType.integer)
                // 所属主机唯一ID 针对子设备
                t.column(Columns.host_mac.rawValue, Database.ColumnType.text)
                // 设备唯一ID
                t.column(Columns.dev_addr.rawValue, Database.ColumnType.text)
                // 设备网络地址
                t.column(Columns.dev_net_addr.rawValue, Database.ColumnType.text)
                // 设备私有类型
                t.column(Columns.dev_uptype.rawValue, Database.ColumnType.integer)
                // 设备通道(键值)
                t.column(Columns.dev_key.rawValue, Database.ColumnType.integer)
                // 设备品牌
                t.column(Columns.brand.rawValue, Database.ColumnType.text)
                // 设备激活状态
                t.column(Columns.active.rawValue, Database.ColumnType.integer)
                // 设备在线状态
                t.column(Columns.online.rawValue, Database.ColumnType.integer)
                // 心跳状态
                t.column(Columns.heartbeat.rawValue, Database.ColumnType.integer)
                // 设备状态 是一个json字符串
                t.column(Columns.dev_state.rawValue, Database.ColumnType.text)
                // 设备厂商模型
                t.column(Columns.model.rawValue, Database.ColumnType.text)
                // 设备附近参数
                t.column(Columns.dev_additional.rawValue, Database.ColumnType.text)
                // 设备是否设置快捷显示
                t.column(Columns.shortcut_flag.rawValue, Database.ColumnType.text)
                // 针对红外设备的自定义数据
                t.column(Columns.data.rawValue, Database.ColumnType.text)
                // 设备所属场景情况 目前暂未使用
                t.column(Columns.dev_scene.rawValue, Database.ColumnType.integer)
                // 设备通道 针对M9设备
                t.column(Columns.channel_id.rawValue, Database.ColumnType.integer)
                // 设备状态更新标志
                t.column(Columns.state_update_flag.rawValue, Database.ColumnType.integer)
                // 心跳时间
                t.column(Columns.duration.rawValue, Database.ColumnType.integer)
                // 设备认证情况
                t.column(Columns.authorization.rawValue, Database.ColumnType.integer)
                // 该设备需要在首页显示的参数
                t.column(Columns.frontdisplay.rawValue, Database.ColumnType.text)
                // 当前执行的命令
                t.column(Columns.func_cmd.rawValue, Database.ColumnType.text)
                // 重发次数
                t.column(Columns.resend_count.rawValue, Database.ColumnType.integer)
                // 上一个状态
                t.column(Columns.old_status.rawValue, Database.ColumnType.text)
                // 状态刷新时间
                t.column(Columns.udatetime.rawValue, Database.ColumnType.integer)
                // 版本号
                t.column(Columns.soft_ver.rawValue, Database.ColumnType.integer)
                // 是否为分享设备(分享设备具有)
                t.column(Columns.shared.rawValue, Database.ColumnType.boolean)
                // 空间ID（分享设备具有)
                t.column(Columns.spaceId.rawValue, Database.ColumnType.text)
                // 广告播放开关
                t.column(Columns.smart_flag.rawValue, Database.ColumnType.integer)
                // 产品ID
                t.column(Columns.product_id.rawValue, Database.ColumnType.text)
                // 组织ID
                t.column(Columns.group_id.rawValue, Database.ColumnType.text)
                // 品牌logo
                t.column(Columns.brand_logo.rawValue, Database.ColumnType.text)
                // 扩展标签
                t.column(Columns.exe_flag.rawValue, Database.ColumnType.integer)
                // 功能定义
                t.column(Columns.func_define.rawValue, Database.ColumnType.text)
                // 固件版本
                t.column(Columns.hw_ver.rawValue, Database.ColumnType.text)
                // 学习标签
                t.column(Columns.study_flag.rawValue, Database.ColumnType.integer)
                // 网关类型
                t.column(Columns.gateway_type.rawValue, Database.ColumnType.text)
            })
        })
    }
    
    /// 插入单个数据
    static func insert(device: Device) -> Void {
        // 保证设备不存在
        if let deviceTemp = Device.query(device: device) {
            var device = device
            // 设备存在 直接返回不添加 更新设备
            swiftDebug("设备已经存在 更新设备")
            device.id = deviceTemp.id
            Device.update(device: device)
            return
        }
        // 创建表
        Device.createTable()
        // 事务
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var deviceTemp = device
                // 插入到数据库
                try deviceTemp.insert(db)
                swiftDebug("插入新设备成功:: ", device)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 插入设备数组
    static func insert(devices: [Device]) -> Void {
        for device in devices {
            Device.insert(device: device)
        }
    }
    
    /// 根据设备信息查询设备信息
    static func query(device: Device) -> Device? {
        swiftDebug("查询设备内容:", device)
        // 创建数据库表
        Device.createTable()
        // 查询设备
        return try! Device.dbPool.unsafeReentrantRead({ (db) -> Device? in
            return try Device
                //.filter(Column(Columns.dev_id.rawValue) == device.dev_id)
                .filter(Column(Columns.dev_name.rawValue) == device.dev_name) // 同地址不同名字多设备添加
                .filter(Column(Columns.dev_addr.rawValue) == device.dev_addr)
                .fetchOne(db)
        })
    }
    
    /// 查询所有设备的设备类型列表
    static func queryAllDeviceClassTypeList() -> [String] {
        var devClassTypeList: [String] = [String]()
        for device in Device.queryAll() {
            if let dev_class_type = device.dev_class_type,
                devClassTypeList.contains(dev_class_type) == false {
                devClassTypeList.append(dev_class_type)
            }
        }
        return devClassTypeList
    }
    
    /// 查询所有
    static func queryAll() -> [Device] {
        // 创建数据库
        Device.createTable()
        // 查询
        return try! Device.dbPool.read({ (db) -> [Device] in
            /// 数组元素
            return try Device.fetchAll(db)
        })
    }
    
    /// 查询网关设备列表
    static func queryGateway() -> [Device] {
        // 创建数据库
        Device.createTable()
        // 查询网关设备
//        return try! Device.dbPool.read({ (db) -> [Device] in
//            let devices = try Device
//                .filter(Column(Columns.dev_class_type.rawValue) == DevClassType.gateway || Column(Columns.dev_class_type.rawValue) == DevClassType.gateway_nx1n2)
//                .fetchAll(db)
//            /// 数组元素
//            return devices
//        })
        return try! Device.dbPool.read({ (db) -> [Device] in
            let devices = try Device
                .filter(Column(Columns.dev_class_type.rawValue).like("%\(DevClassType.gateway)%"))
                .fetchAll(db)
            /// 数组元素
            return devices
        })
    }
    
    /// 按房间名称查询设备名称列表(无房间名称查询所有设备)
    static func queryDevNameList(roomName: String) -> [String] {
        var devNameList: [String] = [String]()
        for device in Device.queryAll() {
            if let dev_name = device.dev_name {
                devNameList.append(dev_name)
            }
        }
        return devNameList
    }
    
    /// 查询某类型设备列表
    static func query(devClassType: String) -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 查询设备数组
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device.filter(Column(Columns.dev_class_type.rawValue) == devClassType).fetchAll(db)
        })
    }
    
    /// 查询某网关类型设备
    static func queryRFModuleDevice() -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 查询设备数组
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device.filter(Column(Columns.gateway_type.rawValue) == "RF_Module").fetchAll(db)
        })
    }
    
    
    /// 查询房间内的设备
    static func query(room_name: String) -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 查询房间内容的设备
        return try! Device.dbPool.read({ (db) -> [Device] in
            let devices = try Device
                .filter(Column(Columns.room_name.rawValue) == room_name)
                .fetchAll(db)
            /// 数组元素
            return devices
        })
    }
    
    /// 查询某一房间某一类型设备
    static func query(room_name: String, dev_class_type: String) -> [Device] {
        // 创建数据库表
        self.createTable()
        // 查询房间内容的设备
        return try! self.dbPool.read({ (db) -> [Device] in
            let devices = try Device
                .filter(Column(Columns.room_name.rawValue) == room_name)
                .filter(Column(Columns.dev_class_type.rawValue) == dev_class_type)
                .fetchAll(db)
            /// 数组元素
            return devices
        })
    }
    
    /// 根据设备类型查询所有设备
    static func query(dev_class_type: String) -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 查询该设备类型下的所有设备
        return try! Device.dbPool.read({ (db) -> [Device] in
            let devices = try Device
                .filter(Column(Columns.dev_class_type.rawValue) == dev_class_type)
                .fetchAll(db)
            /// 数组元素
            return devices
        })
    }
    
    /// 根据房间名 设备名字删除设备
    static func query(devName: String, roomName: String) -> Device? {
        /// 创建数据库表
        Device.createTable()
        // 提交事务
        return try! Device.dbPool.read({ (db) -> Device? in
            return try Device
                .filter(Column(Columns.dev_name.rawValue) == devName)
                .filter(Column(Columns.room_name.rawValue) == roomName)
                .fetchOne(db)
        })
    }
    
    /// 根据设备名称查询设备信息
    static func query(devName: String) -> Device? {
        Device.createTable()
        return try! Device.dbPool.read({ (db) -> Device? in
            return try Device
                .filter(Column(Columns.dev_name.rawValue) == devName)
                .fetchOne(db)
        })
    }
    
    /// 更具设备地址查询所有设备
    static func query(dev_addr: String) -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 返回查询的设备
        return try! Device.dbPool.read({ (db) -> [Device] in
            return try Device
                .filter(Column(Columns.dev_addr.rawValue) == dev_addr)
                .fetchAll(db)
            
        })
    }
    
    /// 根据设备地址查询某一设备
    static func queryDevice(dev_addr: String) -> Device? {
        // 创建数据库表
        Device.createTable()
        // 返回查询的设备
        return try! Device.dbPool.read({ (db) -> Device? in
            return try Device
                .filter(Column(Columns.dev_addr.rawValue) == dev_addr)
                .fetchOne(db)
        })
    }
    
    static func queryHostDevice(dev_addr: String) -> Device? {
        Device.createTable()
        
        return try! Device.dbPool.read({ (db) -> Device? in
            return try Device
                .filter(Column(Columns.dev_addr.rawValue) == dev_addr)
                .filter(Column(Columns.dev_class_type.rawValue) == DevClassType.gem_cube || Column(Columns.dev_class_type.rawValue) == DevClassType.modbus_gw || Column(Columns.dev_class_type.rawValue) == DevClassType.gem_zb485_gw || Column(Columns.dev_class_type.rawValue) == DevClassType.gateway_n3 ||
                        Column(Columns.dev_class_type.rawValue) == DevClassType.gateway_n5 ||
                        Column(Columns.dev_class_type.rawValue) == "combination_panel"
            )
                .fetchOne(db)
        })
    }
    
    static func queryHostDevice(group_id: String) -> Device? {
        Device.createTable()
        
        return try! Device.dbPool.read({ (db) -> Device? in
            return try Device
                .filter(Column(Columns.group_id.rawValue) == group_id)
                .filter(Column(Columns.dev_class_type.rawValue) == DevClassType.gem_cube || Column(Columns.dev_class_type.rawValue) == DevClassType.modbus_gw || Column(Columns.dev_class_type.rawValue) == DevClassType.gem_zb485_gw || Column(Columns.dev_class_type.rawValue) == DevClassType.gateway_n3 ||
                        Column(Columns.dev_class_type.rawValue) == DevClassType.gateway_n5 ||
                        Column(Columns.dev_class_type.rawValue) == "combination_panel"
                )
                .fetchOne(db)
        })
    }
    
    
    /// 查询主机下的设备列表
    static func query(host_mac: String) -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 返回查询的设备
        return try! Device.dbPool.read({ (db) -> [Device] in
            return try Device.filter(Column(Columns.host_mac.rawValue) == host_mac).fetchAll(db)
        })
    }
    
    /// 查询M9红外设备
    static func queryM9Infra(dev_addr: String) -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 提交事务
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device
                .filter(Column(Columns.dev_addr.rawValue) == dev_addr)
                .filter(Column(Columns.dev_class_type.rawValue) == DevClassType.user_def_device || Column(Columns.dev_class_type.rawValue) == DevClassType.gem_tv_m9ir || Column(Columns.dev_class_type.rawValue) == DevClassType.gem_ac_m9ir || Column(Columns.dev_class_type.rawValue) == DevClassType.gem_fan_m9ir)
                .fetchAll(db)
        })
    }
    
    /// 查询空调设备
    static func queryACDevices() -> [Device] {
        self.createTable()

        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device
                .filter(Column(Columns.dev_class_type.rawValue) == DevClassType.ac || Column(Columns.dev_class_type.rawValue) == DevClassType.aircondition || Column(Columns.dev_class_type.rawValue) == DevClassType.gem_ac_m9ir)
                .fetchAll(db)
        })
    }
    
    /// 通过产品ID查询设备
    static func queryDevices(product_id: String) -> [Device] {
        self.createTable()

        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device
                .filter(Column(Columns.product_id.rawValue) == product_id)
                .fetchAll(db)
        })
    }
    
    /// 替换设备信息
    
    
    
    /// 查询某网关类型设备的设备类型
    static func queryRFModuleDevClassType() -> [String] {
        // 创建数据库表
        Device.createTable()
        // 查询设备数组
        return try! Device.dbPool.unsafeRead({ (db) -> [String] in
            let devices = try Device.filter(Column(Columns.gateway_type.rawValue) == "RF_Module").fetchAll(db)
            var deviceType = [String]()
            for device in devices {
                if let dev_class_type = device.dev_class_type,  deviceType.contains(dev_class_type) == false {
                    deviceType.append(dev_class_type)
                }
            }
            return deviceType
        })
    }
    
    /// 根据是否常用查询某房间设备列表
    static func query(shortcutFlag: String) -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 查询设备数组
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device.filter(Column(Columns.shortcut_flag.rawValue) == shortcutFlag).fetchAll(db)
        })
    }
    
    /// 根据设备id查询设备类型
    static func query(devID: Int) -> Device? {
        // 创建数据库表
        Device.createTable()
        return try! Device.dbPool.unsafeReentrantRead({ (db) -> Device? in
            return try Device.filter(Column(Columns.dev_id.rawValue) == devID).fetchOne(db)
        })
    }
    
    
    /// 依据设备地址查询相同设备地址的设备列表
    static func queryDevices(devAddr: String) -> [Device] {
        Device.createTable()
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device.filter(Column(Columns.dev_addr.rawValue) == devAddr).fetchAll(db)
            
        })
    }
    
    /// 查询设备
    static func query(dev_addr: String, dev_key: Int, channel_id: Int, dev_class_type: String) -> Device? {
        // 创建数据库表
        Device.createTable()
        // 提交事务
        return try! Device.dbPool.unsafeRead({ (db) -> Device? in
            return try Device
                .filter(Column(Columns.dev_addr.rawValue) == dev_addr)
                .filter(Column(Columns.dev_key.rawValue) == dev_key)
                .filter(Column(Columns.channel_id.rawValue) == channel_id)
                .filter(Column(Columns.dev_class_type.rawValue) == dev_class_type)
                .fetchOne(db)
        })
    }
    
    /// 查询指定dev_key的设备
    static func query(dev_addr: String, dev_key: Int, dev_class_type: String) -> Device? {
        // 创建数据库表
        Device.createTable()
        // 提交事务
        return try! Device.dbPool.unsafeRead({ (db) -> Device? in
            return try Device
                .filter(Column(Columns.dev_addr.rawValue) == dev_addr)
                .filter(Column(Columns.dev_key.rawValue) == dev_key)
                .filter(Column(Columns.dev_class_type.rawValue) == dev_class_type)
                .fetchOne(db)
        })
    }
    
    /// 更新设备信息
    static func update(device: Device) -> Void {
        // 创建数据库表
        Device.createTable()
        // 提交事务 更新  更新设备信息 需要设置rowID
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值
                try device.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 更新设备在线状态
    static func update(online: Int, dev_addr: String) -> Void {
        Device.createTable()
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                if var device = try Device.filter(Column(Columns.dev_addr.rawValue) == dev_addr).fetchOne(db) {
                    device.online = online
                    try device.update(db)
                } else {
                    swiftDebug("该地址设备没查询到，请核实")
                }
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 更新设备信息
    static func update(host_mac: String, dev_addr: String, dev_net_addr: String, riu_id: Int, dev_uptype: Int, brand: String, online: Int, duration: Int, devAddr: String) -> Void {
        Device.createTable()
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                if var device = try Device.filter(Column(Columns.dev_addr.rawValue) == devAddr).fetchOne(db) {
                    device.host_mac = host_mac
                    device.dev_addr = dev_addr
                    device.dev_net_addr = dev_net_addr
                    device.riu_id = riu_id
                    device.dev_uptype = dev_uptype
                    device.brand = brand
                    device.online = online
                    device.duration = duration
                    try device.update(db)
                } else {
                    swiftDebug("更新设备信息，该地址设备没查询到，请核实")
                }
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    

    static func update(host_mac: String, dev_addr: String, riu_id: Int, online: Int, duration: Int, devAddr: String, dev_class_type: String) -> Void {
        Device.createTable()
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                if var device = try Device.filter(Column(Columns.dev_addr.rawValue) == devAddr).filter(Column(Columns.dev_class_type.rawValue) != dev_class_type).fetchOne(db) {
                    device.host_mac = host_mac
                    device.dev_addr = dev_addr
                    device.riu_id = riu_id
                    device.online = online
                    device.duration = duration
                    try device.update(db)
                } else {
                    swiftDebug("更新设备信息，该地址设备没查询到，请核实")
                }
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    
    static func update(host_mac: String, dev_addr: String, riu_id: Int, online: Int, duration: Int, groupId: String, dev_class_type: String) -> Void {
        Device.createTable()
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                if var device = try Device.filter(Column(Columns.group_id.rawValue) == groupId).filter(Column(Columns.dev_class_type.rawValue) != dev_class_type).fetchOne(db) {
                    device.host_mac = host_mac
                    device.dev_addr = dev_addr
                    device.riu_id = riu_id
                    device.online = online
                    device.duration = duration
                    try device.update(db)
                } else {
                    swiftDebug("更新设备信息，该地址设备没查询到，请核实")
                }
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 普通设备的替换
    static func update(gid: String, dev_addr: String, dev_net_addr: String, duration: Int, online: Int, host_mac: String, groupId: String) -> Void {
        Device.createTable()
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                if var device = try Device.filter(Column(Columns.group_id.rawValue) == groupId).fetchOne(db) {
                    device.gid = gid
                    device.dev_addr = dev_addr
                    device.dev_net_addr = dev_net_addr
                    device.host_mac = host_mac
                    device.online = online
                    device.duration = duration
                    try device.update(db)
                } else {
                    swiftDebug("更新设备信息，该地址设备没查询到，请核实")
                }
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 485设备替换，替换子设备
    static func update(gid: String, dev_addr: String, duration: Int, online: Int, host_mac: String, groupId: String, dev_class_type: String) -> Void {
        Device.createTable()
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                if var device = try Device.filter(Column(Columns.group_id.rawValue) == groupId).filter(Column(Columns.dev_class_type.rawValue) != dev_class_type).fetchOne(db) {
                    device.gid = gid
                    device.dev_addr = dev_addr
                    device.host_mac = host_mac
                    device.online = online
                    device.duration = duration
                    try device.update(db)
                } else {
                    swiftDebug("更新设备信息，该地址设备没查询到，请核实")
                }
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    
    static func update(host_mac: String, old_host_mac: String) -> Void {
        Device.createTable()
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                if var device = try Device.filter(Column(Columns.host_mac.rawValue) == old_host_mac).filter(Column(Columns.dev_addr.rawValue) != old_host_mac).fetchOne(db) {
                    device.host_mac = host_mac
                    try device.update(db)
                } else {
                    swiftDebug("更新设备信息，该地址设备没查询到，请核实")
                }
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    
    // (String ,String ,String ,int ,int ,String ,String ,String )
    static func update(gid: String, dev_addr: String, dev_net_addr: String, duration: Int, online: Int, host_mac: String, groupId: String, dev_class_type: String) -> Void {
        Device.createTable()
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                if var device = try Device.filter(Column(Columns.group_id.rawValue) == groupId).filter(Column(Columns.dev_class_type.rawValue) != dev_class_type).fetchOne(db) {
                    device.gid = gid
                    device.dev_addr = dev_addr
                    device.dev_net_addr = dev_net_addr
                    device.host_mac = host_mac
                    device.online = online
                    device.duration = duration
                    try device.update(db)
                } else {
                    swiftDebug("更新设备信息，该地址设备没查询到，请核实")
                }
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
        
    /*
     设备数据库处理增加内容适配
     
     @Query("UPDATE device SET online = :online WHERE dev_addr = :dev_addr")
     void updateDevicesOnline(int online,String dev_addr);

     @Query("UPDATE device SET host_mac= :host_mac,dev_addr = :dev_addr,dev_net_addr = :dev_net_addr, riu_id = :riu_id, dev_uptype = :dev_uptype, brand = :brand,online = :online ,duration = :duration WHERE dev_addr = :devAddr")
     void updateDevByDevAddr(String host_mac,String dev_addr,String dev_net_addr,int riu_id, int dev_uptype,String brand,int online,int duration,String devAddr);

     @Query("UPDATE device SET host_mac= :host_mac,dev_addr = :dev_addr, riu_id = :riu_id, online = :online ,duration = :duration WHERE dev_addr = :devAddr and dev_class_type != :dev_class_type")
     void updateDevByDevAddrFor485SubDevices(String host_mac,String dev_addr,int riu_id,int online,int duration,String devAddr,String dev_class_type);
     @Query("UPDATE device SET host_mac= :host_mac,dev_addr = :dev_addr, riu_id = :riu_id,online = :online ,duration = :duration WHERE group_id = :groupId and dev_class_type != :dev_class_type")
     void updateDevByGroupIdFor485SubDevices(String host_mac,String dev_addr,int riu_id,int online,int duration,String groupId,String dev_class_type);

     //普通设备的替换
     @Query("UPDATE device SET gid= :gid,dev_addr = :dev_addr, dev_net_addr = :dev_net_addr,duration = :duration,online = :online ,host_mac= :host_mac WHERE group_id = :groupId")
     void updateDevsForReplace(String gid,String dev_addr,String dev_net_addr,int duration,int online,String host_mac,String groupId);

     //485设备的替换,替换子设备
     @Query("UPDATE device SET gid= :gid,dev_addr = :dev_addr,duration = :duration,online = :online ,host_mac= :host_mac WHERE group_id = :groupId and dev_class_type != :dev_class_type")
     void update485SubDevsForReplace(String gid,String dev_addr,int duration,int online,String host_mac,String groupId,String dev_class_type);

     @Query("UPDATE device SET host_mac= :host_mac WHERE host_mac = :old_host_mac and dev_addr != :old_host_mac")
     void updateGatewayOtherDevsForReplace(String host_mac,String old_host_mac);

     @Query("UPDATE device SET gid= :gid,dev_addr = :dev_addr, dev_net_addr = :dev_net_addr,duration = :duration,online = :online ,host_mac= :host_mac WHERE group_id = :groupId and dev_class_type != :dev_class_type")
     void updateGatewaySubDevsForReplace(String gid,String dev_addr,String dev_net_addr,int duration,int online,String host_mac,String groupId,String dev_class_type);
     */
    
    
    /// 删除某一设备
    static func delete(device: Device) -> Void {
        // 创建数据库表
        Device.createTable()
        // 提交事务
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除数据
                try device.delete(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    // 数据库操作：gateway.a7,gateway.a10,gateway.m6gw,acgw.zhh删除这类型的设备时，dev_addr相同的子设备一起删除
    
    /// 根据地址删除设备
//    static func delete(dev_addr: String) -> Void {
//        // 创建数据库表
//        Device.createTable()
//        // 提交事务
//
//    }
    
    
    /// 删除所有设备
    static func deleteAll() -> Void {
        // 创建数据库表
        Device.createTable()
        // 删除数据
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 查询所有的设备
                try Device.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
}
