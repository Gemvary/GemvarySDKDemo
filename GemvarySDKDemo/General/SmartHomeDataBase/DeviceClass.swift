//
//  DeviceClass.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB

class DeviceClass: NSObject, Codable {
    /// 品牌
    var brand: String?
    /// 品牌名字
    var brand_str: String?
    /// 网关名字
    var gateway_type: String?
    /// 设备类型
    var dev_class_type: String?
    /// 设备类型名字
    var dev_class_name: String?
    /// 设备描述
    var dev_describe: String?
    /// 设备上报类型 新增加字段 与旧版本解析会引起崩溃
    var dev_uptype: Int?
    
    /// 数据库表名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 品牌
        case brand
        /// 品牌名称
        case brand_str
        /// 网关类型
        case gateway_type
        /// 设备类型
        case dev_class_type
        /// 设备类型名称
        case dev_class_name
        /// 设备描述
        case dev_describe
        /// 设备上报类型
        case dev_uptype
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

extension DeviceClass: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建数据库表
    private static func createTable() -> Void {
        
        try! DeviceClass.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(SmartHomeTable.deviceClass) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.deviceClass, temporary: false, ifNotExists: true, body: { (t) in
                /// 品牌
                t.column(Columns.brand.rawValue, Database.ColumnType.text)
                /// 品牌名字
                t.column(Columns.brand_str.rawValue, Database.ColumnType.text)
                /// 网关名字
                t.column(Columns.gateway_type.rawValue, Database.ColumnType.text)
                /// 设备类型
                t.column(Columns.dev_class_type.rawValue, Database.ColumnType.text)
                /// 设备类型名字
                t.column(Columns.dev_class_name.rawValue, Database.ColumnType.text)
                /// 设备描述
                t.column(Columns.dev_describe.rawValue, Database.ColumnType.text)
                /// 设备上报类型
                t.column(Columns.dev_uptype.rawValue, Database.ColumnType.integer)
            })
        }
        
    }
    
    //MARK: 插入
    /// 插入单个数据
    static func insert(deviceClass: DeviceClass) -> Void {
        
        guard DeviceClass.query(deviceClass: deviceClass) == nil else {
            //swiftDebug("已经存在该设备类型", deviceClass)
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
    
    
    /// 插入数组数据
    static func insert(deviceClasss: [DeviceClass]) -> Void {
        for deviceClass in deviceClasss {
            DeviceClass.insert(deviceClass: deviceClass)
        }
    }
    
    // MARK: 查询
    /// 查询所有数据
    static func queryAll() -> [DeviceClass] {
        DeviceClass.createTable()
        
        return try! self.dbPool.unsafeRead({ (db) -> [DeviceClass] in
            return try DeviceClass.fetchAll(db)
        })
    }
    
    /// 依据网关类型查询数据
    static func query(gatewayType: String) -> [DeviceClass] {
        // 是否创建表
        DeviceClass.createTable()
        
        return try! self.dbPool.unsafeRead({ (db) -> [DeviceClass] in
            return try DeviceClass.filter(Column(Columns.gateway_type.rawValue) == gatewayType).fetchAll(db)
        })
    }
    
    /// 查询数据库是否已经存在该数据
    static func query(deviceClass: DeviceClass) -> DeviceClass? {
        // 创建数据库表
        DeviceClass.createTable()
        // 返回数据
        return try! self.dbPool.unsafeRead({ (db) -> DeviceClass? in
            return try DeviceClass
                .filter(Column(Columns.gateway_type.rawValue) == deviceClass.gateway_type) // 网管类型
                .filter(Column(Columns.brand.rawValue) == deviceClass.brand) // 品牌
                .filter(Column(Columns.brand_str.rawValue) == deviceClass.brand_str) // 品牌名称
                .filter(Column(Columns.dev_class_type.rawValue) == deviceClass.dev_class_type) // 设备类型
                .filter(Column(Columns.dev_class_name.rawValue) == deviceClass.dev_class_name) // 设备名字
                .filter(Column(Columns.dev_uptype.rawValue) == deviceClass.dev_uptype) // 设备上报类型
                .filter(Column(Columns.dev_describe.rawValue) == deviceClass.dev_describe) // 设备描述
                .fetchOne(db)
        })
    }
    
    
    /// 查询设备类型
    static func query(dev_class_type: String) -> DeviceClass? {
        // 创建数据库表
        DeviceClass.createTable()
        //
        return try! self.dbPool.unsafeRead({ (db) -> DeviceClass? in
            return try DeviceClass.filter(Column(Columns.dev_class_type.rawValue) == dev_class_type).fetchOne(db)
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
    
    
    // MARK: 删除
    /// 删除所有数据
    static func deleteAll() -> Void {
        //　是否创建表
        DeviceClass.createTable()
        // 事务
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
    
    /// 删除数据库表
    static func deleteTable() -> Void {
        DeviceClass.createTable()
        try! DeviceClass.dbPool.write { (db) -> Void in
            // 删除数据库表
            try db.drop(table: SmartHomeTable.deviceClass)
        }
    }
}
