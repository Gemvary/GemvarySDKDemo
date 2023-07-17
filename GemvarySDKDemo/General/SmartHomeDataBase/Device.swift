//
//  Device.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB
import GemvarySmartHomeSDK

class Device: NSObject, Codable {
    /// 自增长ID
    var id: Int64?
    /// 设备ID
    var dev_id: Int?
    /// 设备名字
    var dev_name: String?
    /// 设备类型
    var dev_class_type: String?
    /// 房间名称
    var room_name: String?
    /// 网关ID
    var riu_id: Int?
    /// 设备Mac地址
    var dev_addr: String?
    /// Zigbee设备短地址 根据不同设备类型不同
    var dev_net_addr: String?
    /// 设备似有类型
    var dev_uptype: Int?
    /// 端点ID
    var dev_key: Int?
    /// 给界面使用
    var brand_logo: String?
    /// 品牌
    var brand: String?
    /// 是否激活
    var active: Int?
    /// 是否在线
    var online: Int?
    /// 设备状态
    var dev_state: String?
    /// 新版本不再使用
    var dev_scene: Int?
    /// 附加参数(特殊设备使用)
    var dev_additional: String?
    /// 1在主页显示 0不显示
    var shortcut_flag: String?
    /// 自定义功能参数(JSON字符串)
    var func_define: String?
    /// 64 新版本不再使用
    var study_flag: Int?
    /// 设备通道(M9)
    var channel_id: Int?
    /// 设备所属网关地址
    var host_mac: String?
    /// 广告播放开关
    var smart_flag: Int?
    
    
    /// device表的行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 自增长
        case id
        /// 设备ID
        case dev_id
        /// 设备名字
        case dev_name
        /// 设备类型
        case dev_class_type
        /// 房间名称
        case room_name
        /// 网关ID
        case riu_id
        /// 设备Mac地址
        case dev_addr
        /// Zigbee设备短地址 根据不同设备类型不同
        case dev_net_addr
        /// 设备似有类型
        case dev_uptype
        /// 端点ID
        case dev_key
        /// 给界面使用
        case brand_logo
        /// 品牌
        case brand
        /// 是否激活
        case active
        /// 是否在线
        case online
        /// 设备状态
        case dev_state
        /// 新版本不再使用
        case dev_scene
        /// 附加参数(特殊设备使用)
        case dev_additional
        /// 1在主页显示 0不显示
        case shortcut_flag
        /// 自定义功能参数(JSON字符串)
        case func_define
        /// 64 新版本不再使用
        case study_flag
        /// 设备通道ID (M9)
        case channel_id
        /// 设备所属网关地址
        case host_mac
        /// 广告播放开关
        case smart_flag
    }
    
    func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

extension Device: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建表
    private static func createTable() -> Void {
        try! self.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(SmartHomeTable.device) {
                //swiftDebug("表已经存在")
                // 判断数据库表是否含有 host_mac 字段
                let columns: [ColumnInfo] = try db.columns(in: SmartHomeTable.device)
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
                
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.device, temporary: false, ifNotExists: true, body: { (t) in
                // 自增ID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                // 设备ID
                t.column(Columns.dev_id.rawValue, Database.ColumnType.integer)
                // 设备名字
                t.column(Columns.dev_name.rawValue, Database.ColumnType.text)
                // 设备类型
                t.column(Columns.dev_class_type.rawValue, Database.ColumnType.text)
                // 房间名称
                t.column(Columns.room_name.rawValue, Database.ColumnType.text)
                // 网关ID
                t.column(Columns.riu_id.rawValue, Database.ColumnType.integer)
                // 设备mac地址
                t.column(Columns.dev_addr.rawValue, Database.ColumnType.text)
                // Zigbee设备短地址 根据不同设备类型不同
                t.column(Columns.dev_net_addr.rawValue, Database.ColumnType.text)
                // 设备私有类型
                t.column(Columns.dev_uptype.rawValue, Database.ColumnType.integer)
                // 端点ID
                t.column(Columns.dev_key.rawValue, Database.ColumnType.integer)
                // icon logo
                t.column(Columns.brand_logo.rawValue, Database.ColumnType.text)
                // 品牌
                t.column(Columns.brand.rawValue, Database.ColumnType.text)
                // 是否激活
                t.column(Columns.active.rawValue, Database.ColumnType.integer)
                // 是否在线
                t.column(Columns.online.rawValue, Database.ColumnType.integer)
                // 设备状态
                t.column(Columns.dev_state.rawValue, Database.ColumnType.text)
                // 新版本不再使用
                t.column(Columns.dev_scene.rawValue, Database.ColumnType.integer)
                // 附加参数(特殊设备使用)
                t.column(Columns.dev_additional.rawValue, Database.ColumnType.text)
                // 1在主页显示 0不显示
                t.column(Columns.shortcut_flag.rawValue, Database.ColumnType.text)
                // 自定义功能参数(JSON字符串)
                t.column(Columns.func_define.rawValue, Database.ColumnType.text)
                // 64 新版本不再使用
                t.column(Columns.study_flag.rawValue, Database.ColumnType.integer)
                // 设备通道(M9)
                t.column(Columns.channel_id.rawValue, Database.ColumnType.integer)
                // 设备所属网关地址
                t.column(Columns.host_mac.rawValue, Database.ColumnType.text)
                // 广告播放开关
                t.column(Columns.smart_flag.rawValue, Database.ColumnType.integer)
            })
        }
    }
    
    // MARK: 插入
    /// 插入单个数据
    static func insert(device: Device) -> Void {
        // 保证设备不存在
        guard (Device.query(device: device) == nil) else {
            // 设备存在 直接返回不添加 更新设备
            //swiftDebug("设备已经存在 更新设备")
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
    
    //MARK: 查询
    /// 查询所有
    static func queryAll() -> [Device] {
        // 创建数据库
        Device.createTable()
        // 查询
        return try! dbPool.unsafeRead({ (db) -> [Device] in
            let devices = try Device.fetchAll(db)
            /// 数组元素
            return devices
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
    
    /// 根据设备信息查询设备信息
    static func query(device: Device) -> Device? {
        //swiftDebug("查询设备内容:", device)
        // 创建数据库表
        Device.createTable()
        // 查询设备
        return try! Device.dbPool.unsafeReentrantRead({ (db) -> Device? in
            return try Device
                .filter(Column(Columns.dev_id.rawValue) == device.dev_id)
                .filter(Column(Columns.dev_name.rawValue) == device.dev_name)
                .filter(Column(Columns.dev_addr.rawValue) == device.dev_addr)
                .fetchOne(db)
        })
    }
    
    /// 查询超级碗设备
    static func query(lifeSmartDevice: Device) -> [Device] {
        Device.createTable()
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            /*
             查询条件: 地址一致 设备类型不能为超级碗 设备ID不能等于超级碗
             */
            return try Device.filter(Column(Columns.dev_class_type.rawValue) != DevClassType.lifesmart_repeater).filter(Column(Columns.dev_class_type.rawValue) != DevClassType.rgb_light_aqra).filter(Column(Columns.dev_id.rawValue) != lifeSmartDevice.dev_id).filter(Column(Columns.dev_addr.rawValue) == lifeSmartDevice.dev_addr).fetchAll(db)
        })
    }
    
    /// 根据设备名称查询设备信息
    static func query(devName: String) -> Device? {
        Device.createTable()
        return try! Device.dbPool.unsafeRead({ (db) -> Device? in
            return try Device.filter(Column(Columns.dev_name.rawValue) == devName).fetchOne(db)
        })
    }
        
    /// 根据设备地址查询设备信息
    static func query(devAddr: String) -> Device? {
        Device.createTable()
        return try! Device.dbPool.unsafeRead({ (db) -> Device? in
            return try Device.filter(Column(Columns.dev_addr.rawValue) == devAddr).fetchOne(db)
        })
    }
    
    /// 按房间名称查询设备列表(无房间名称查询所有设备)
    static func query(room_name: String) -> [Device] {
        Device.createTable()
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device.filter(Column(Columns.room_name.rawValue) == room_name).fetchAll(db)
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
    
    /// 查询某类型设备列表
    static func query(devClassType: String) -> [Device] {
        // 创建数据库表
        Device.createTable()
        // 查询设备数组
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device.filter(Column(Columns.dev_class_type.rawValue) == devClassType).fetchAll(db)
        })
    }
    
    /// 根据设备类型数组查询设备列表
    static func query(devClassTypeList: [String]) -> [Device] {
        var devices: [Device] = [Device]()
        for devClassType in devClassTypeList {
            // 数组拼接
            devices = devices + Device.query(devClassType: devClassType)
        }
        
        //swiftDebug("添加的设备内容?", devices)
        return devices
    }
    
    /// 依据设备地址查询相同设备地址的设备列表
    static func queryDevices(devAddr: String) -> [Device] {
        Device.createTable()
        return try! Device.dbPool.unsafeRead({ (db) -> [Device] in
            return try Device.filter(Column(Columns.dev_addr.rawValue) == devAddr).fetchAll(db)
            
        })
    }
    
    /// 查询所有设备的设备类型列表
    static func queryAllDeviceClassTypeList() -> [String] {
        var devClassTypeList: [String] = [String]()
        for device in Device.queryAll() {
            if devClassTypeList.contains(device.dev_class_type!) == false {
                devClassTypeList.append(device.dev_class_type!)
            }
        }
        return devClassTypeList
    }
    
    /// 按房间名称查询设备名称列表(无房间名称查询所有设备)
    static func queryDevNameList(roomName: String) -> [String] {
        var devNameList: [String] = [String]()
        for device in Device.queryAll() {
            devNameList.append(device.dev_name!)
        }
        return devNameList
    }
        
    /// 根据房间名 设备名字删除设备
    static func query(devName: String, roomName: String) -> Device? {
        /// 创建数据库表
        Device.createTable()
        // 提交事务
        return try! Device.dbPool.unsafeRead({ (db) -> Device? in
            return try Device.filter(Column(Columns.dev_name.rawValue) == devName).filter(Column(Columns.room_name.rawValue) == roomName).fetchOne(db)
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
    
    
    //MARK: 删除
    /// 更具设备名称删除设备
    static func delete(devName: String) -> Void {
        // 查询设备
        let device = Device.query(devName: devName)
        // 删除设备
        Device.delete(device: device!)
    }
    
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
    
    /// 根据房间名 设备名字删除设备
    static func delete(devName: String, roomName: String) -> Void {
        /// 查询设备
        guard let device = Device.query(devName: devName, roomName: roomName) else {
            return
        }
        
        /// 创建数据库表
        Device.createTable()
        // 提交事务
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除数据
                try device.delete(db)
                // 发送通知
                
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
        
    }
    
    
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
    
    //MARK: 更新
    /// 更新设备信息
    static func update(device: Device) -> Void {
        // 创建数据库表
        Device.createTable()
        // 提交事务 更新  更新设备信息 需要设置rowID
        try! Device.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值
                try device.update(db)
                //swiftDebug("数据库操作更新OK。。。")
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })        
    }
    
}
