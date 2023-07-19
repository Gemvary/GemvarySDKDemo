//
//  DeviceClass.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB

/// 设备类型信息类
struct DeviceClass: Codable {
    /// 设置rowID
    var id: Int64?
    /// 该类型所属网关
    var gateway_type: String?
    /// 设备类型
    var dev_class_type: String?
    /// 设备类型中文名称
    var dev_class_name: String?
    /// 设备类型英文名称
    var dev_class_name_en: String?
    /// 设备类型繁体名称
    var dev_class_name_tw: String?
    /// 设备类型所属品牌
    var dev_brand: String?
    /// 设备品牌显示名称
    var brand_str: String?
    /// 设备类型中文描述
    var dev_describe: String?
    /// 设备类型英文描述
    var dev_describe_en: String?
    /// 设备类型繁体描述
    var dev_describe_tw: String?
    /// 设备类型私有类型
    var dev_uptype: Int?
    
    /// 品牌
    var brand: String?
    /// 网关类型
    var riu_id: Int? = 0 // 不能定义为Int? 需要默认值为0
        
    /// 数据库表行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case id
        /// 该类型所属网关
        case gateway_type
        /// 设备类型
        case dev_class_type
        /// 设备类型中文名称
        case dev_class_name
        /// 设备类型英文名称
        case dev_class_name_en
        /// 设备类型繁体名称
        case dev_class_name_tw
        /// 设备类型所属品牌
        case dev_brand
        /// 设备品牌显示名称
        case brand_str
        /// 设备类型中文描述
        case dev_describe
        /// 设备类型英文描述
        case dev_describe_en
        /// 设备类型繁体描述
        case dev_describe_tw
        /// 设备类型私有类型
        case dev_uptype
        
        /// 品牌
        case brand
        /// 网关类型
        case riu_id
    }
    
    /// 设置rowID
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

/// 实现CURD功能
extension DeviceClass: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建数据库表
    private static func createTable() -> Void {
        try! DeviceClass.dbPool.write({ (db) -> Void in
            if try db.tableExists(SmartHomeTable.deviceClass) {
                //swiftDebug("表已经存在")
                
                // 新增数据库字段
                let columns: [ColumnInfo] = try db.columns(in: SmartHomeTable.deviceClass)
                
                // 遍历判断是否存在 brand行
                let brand = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.brand.rawValue
                }
                // 不存在 brand行 添加该行
                if brand == false {
                    try db.alter(table: SmartHomeTable.deviceClass, body: { (t) in
                        t.add(column: Columns.brand.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历判断是否存在 riu_id行
                let riu_id = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.riu_id.rawValue
                }
                // 不存在 riu_id行 添加该行
                if riu_id == false {
                    try db.alter(table: SmartHomeTable.deviceClass, body: { (t) in
                        t.add(column: Columns.riu_id.rawValue, Database.ColumnType.integer)
                    })
                }

                let dev_brand = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.dev_brand.rawValue
                }
                if dev_brand == false {
                    try db.alter(table: SmartHomeTable.deviceClass, body: { (t) in
                        t.add(column: Columns.dev_brand.rawValue, Database.ColumnType.text)
                    })
                }
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.deviceClass, temporary: false, ifNotExists: true, body: { (t) in
                // 自增ID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                // 该类型所属网关
                t.column(Columns.gateway_type.rawValue, Database.ColumnType.text)
                // 设备类型
                t.column(Columns.dev_class_type.rawValue, Database.ColumnType.text)
                // 设备类型中文名称
                t.column(Columns.dev_class_name.rawValue, Database.ColumnType.text)
                // 设备类型英文名称
                t.column(Columns.dev_class_name_en.rawValue, Database.ColumnType.text)
                // 设备类型繁体名称
                t.column(Columns.dev_class_name_tw.rawValue, Database.ColumnType.text)
                // 设备类型所属品牌
                t.column(Columns.dev_brand.rawValue, Database.ColumnType.text)
                // 设备品牌显示名称
                t.column(Columns.brand_str.rawValue, Database.ColumnType.text)
                // 设备类型中文描述
                t.column(Columns.dev_describe.rawValue, Database.ColumnType.text)
                // 设备类型英文描述
                t.column(Columns.dev_describe_en.rawValue, Database.ColumnType.text)
                // 设备类型繁体描述
                t.column(Columns.dev_describe_tw.rawValue, Database.ColumnType.text)
                // 设备类型私有类型
                t.column(Columns.dev_uptype.rawValue, Database.ColumnType.integer)
                
                
                /// 品牌
                t.column(Columns.brand.rawValue, Database.ColumnType.text)
                /// 网关类型
                t.column(Columns.riu_id.rawValue, Database.ColumnType.integer)
            })
        })
    }
    
    /// 插入数组数据
    static func insert(deviceClasss: [DeviceClass]) -> Void {
        for deviceClass in deviceClasss {
            DeviceClass.insert(deviceClass: deviceClass)
        }
    }
    
    /// 插入数据
    static func insert(deviceClass: DeviceClass) -> Void {
        // 创建数据库表
        //DeviceClass.createTable()
        // 判断是否存在该设备类型信息
        guard DeviceClass.query(deviceClass: deviceClass) == nil else {
            debugPrint("已经存在该设备类型", deviceClass)
            return
        }
        
        // 创建表
        DeviceClass.createTable()
        // 事务
        try! DeviceClass.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var deviceClassTemp = deviceClass
                // 插入到数据库
                try deviceClassTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 查询数据库是否已经存在该数据
    static func query(deviceClass: DeviceClass) -> DeviceClass? {
        // 创建数据库表
        DeviceClass.createTable()
        // 返回数据
        return try! DeviceClass.dbPool.read({ (db) -> DeviceClass? in
            return try DeviceClass
                .filter(Column(Columns.gateway_type.rawValue) == deviceClass.gateway_type) // 网管类型
                .filter(Column(Columns.dev_brand.rawValue) == deviceClass.dev_brand) // 品牌
                .filter(Column(Columns.brand_str.rawValue) == deviceClass.brand_str) // 品牌名称
                .filter(Column(Columns.dev_class_type.rawValue) == deviceClass.dev_class_type) // 设备类型
                .filter(Column(Columns.dev_class_name.rawValue) == deviceClass.dev_class_name) // 设备名字
                .filter(Column(Columns.dev_uptype.rawValue) == deviceClass.dev_uptype) // 设备上报类型
                .filter(Column(Columns.dev_describe.rawValue) == deviceClass.dev_describe) // 设备描述
                .fetchOne(db)
        })
    }
    
    /// 查询所有
    static func queryAll() -> [DeviceClass] {
        // 创建数据库表
        DeviceClass.createTable()
        // 查询数据
        return try! DeviceClass.dbPool.unsafeRead({ (db) -> [DeviceClass] in
            return try DeviceClass.fetchAll(db)
        })
    }
    
    /// 查询设备类型
    static func query(gateway_type: String?) -> [DeviceClass] {
        // 创建数据库表
        DeviceClass.createTable()
        // 返回查询的网关信息
        return try! DeviceClass.dbPool.read({ (db) -> [DeviceClass] in
            return try DeviceClass
                .filter(Column(Columns.gateway_type.rawValue) == gateway_type)
                .fetchAll(db)
        })
    }
    
    /// 查询设备的信息
    static func query(dev_class_type: String, brand: String) -> DeviceClass?{
        // 创建数据库表
        DeviceClass.createTable()
        // 返回数据库信息
        return try! DeviceClass.dbPool.read({ (db) -> DeviceClass? in
            return try DeviceClass
                .filter(Column(Columns.dev_class_type.rawValue) == dev_class_type)
                .filter(Column(Columns.dev_brand.rawValue) == brand)
                .fetchOne(db)
        })
    }
    
    /// 依据网关类型查询数据
    static func query(gatewayType: String) -> [DeviceClass] {
        // 是否创建表
        DeviceClass.createTable()
        
        return try! self.dbPool.unsafeRead({ (db) -> [DeviceClass] in
            return try DeviceClass
                .filter(Column(Columns.gateway_type.rawValue) == gatewayType)
                .fetchAll(db)
        })
    }
    
    /// 查询设备类型信息
    /// - Parameters:
    ///   - dev_class_type: 设备类型
    ///   - brand: 品牌
    ///   - dev_uptype: 设备上报值
    /// - Returns: 设备类型信息
    static func query(dev_class_type: String, brand: String, dev_uptype: Int) -> DeviceClass? {
        // 创建数据库表
        DeviceClass.createTable()
        //
        return try! self.dbPool.unsafeRead({ (db) -> DeviceClass? in
            return try DeviceClass
                .filter(Column(Columns.dev_class_type.rawValue) == dev_class_type)
                .filter(Column(Columns.brand.rawValue) == brand)
                .filter(Column(Columns.dev_uptype.rawValue) == dev_uptype)
                .fetchOne(db)
        })
    }
    
    
    /// 查询设备类型
    static func query(dev_class_type: String) -> DeviceClass? {
        // 创建数据库表
        DeviceClass.createTable()
        //
        return try! self.dbPool.unsafeRead({ (db) -> DeviceClass? in
            return try DeviceClass
                .filter(Column(Columns.dev_class_type.rawValue) == dev_class_type)
                .fetchOne(db)
        })
    }
    
    /// 删除所有
    static func deleteAll() -> Void {
        // 创建数据库表
        DeviceClass.createTable()
        // 事务 删除
        try! DeviceClass.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除所有
                try DeviceClass.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
}
