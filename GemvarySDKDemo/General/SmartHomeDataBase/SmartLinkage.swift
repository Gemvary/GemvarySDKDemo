//
//  SmartLinkage.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB

/// 联动管理类
struct SmartLinkage: Codable {
    /// 设置rowID
    var id: Int64?
    /// 联动列表逻辑ID
    var smart_linkage_id: Int?
    /// 联动名称
    var linkage_name: String?
    /// 联动状态 1 有效 0 无效
    var state: Int?
    /// 联动条件状态 || 任意满足 && 全部满足
    var conditions: String?
    /// 触发时间间隔 默认0
    var retrigger_time: Int?
    /// 触发时间间隔 默认不使用
    var retrigger_left_time: Int?
    /// 联动是否正在执行
    var executing: Int?
    
    /// 数据库表行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case id
        /// 联动列表逻辑ID
        case smart_linkage_id
        /// 联动名称
        case linkage_name
        /// 联动状态 1 有效 0 无效
        case state
        /// 联动条件状态 || 任意满足 && 全部满足
        case conditions
        /// 触发时间间隔 默认0
        case retrigger_time
        /// 触发时间间隔 默认不使用
        case retrigger_left_time
        /// 联动是否正在执行
        case executing
    }
    
    /// 设置rowID
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

/// 实现CURD功能
extension SmartLinkage: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建数据库表
    private static func createTable() -> Void {
        try! self.dbPool.write({ (db) -> Void in
            if try db.tableExists(SmartHomeTable.smartLinkage) {
                //swiftDebug("表已经存在")
                // 获取联动所有的行名
                let columns: [ColumnInfo] = try db.columns(in: SmartHomeTable.smartLinkage)
                let id = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.id.rawValue
                }
                // 没有主键 需要新增主键(先删除表，再创建数据表)
                if id == false {
                    debugPrint("联动数据库表 没有主键")
                    // 删除数据表库内容
                    try db.drop(table: SmartHomeTable.smartLinkage)
                    // 创建数据库
                    try db.create(table: SmartHomeTable.smartLinkage, temporary: false, ifNotExists: true, body: { (t) in
                        // 自增ID
                        t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                        // 联动列表逻辑ID
                        t.column(Columns.smart_linkage_id.rawValue, Database.ColumnType.integer)
                        // 联动名称
                        t.column(Columns.linkage_name.rawValue, Database.ColumnType.text)
                        // 联动状态 1 有效 0 无效
                        t.column(Columns.state.rawValue, Database.ColumnType.integer)
                        // 联动条件状态 || 任意满足 && 全部满足
                        t.column(Columns.conditions.rawValue, Database.ColumnType.text)
                        // 触发时间间隔 默认0
                        t.column(Columns.retrigger_time.rawValue, Database.ColumnType.integer)
                        // 触发时间间隔 默认不使用
                        t.column(Columns.retrigger_left_time.rawValue, Database.ColumnType.integer)
                        // 联动是否正在执行
                        t.column(Columns.executing.rawValue, Database.ColumnType.integer)
                    })
                    return
                }
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.smartLinkage, temporary: false, ifNotExists: true, body: { (t) in
                // 自增ID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                // 联动列表逻辑ID
                t.column(Columns.smart_linkage_id.rawValue, Database.ColumnType.integer)
                // 联动名称
                t.column(Columns.linkage_name.rawValue, Database.ColumnType.text)
                // 联动状态 1 有效 0 无效
                t.column(Columns.state.rawValue, Database.ColumnType.integer)
                // 联动条件状态 || 任意满足 && 全部满足
                t.column(Columns.conditions.rawValue, Database.ColumnType.text)
                // 触发时间间隔 默认0
                t.column(Columns.retrigger_time.rawValue, Database.ColumnType.integer)
                // 触发时间间隔 默认不使用
                t.column(Columns.retrigger_left_time.rawValue, Database.ColumnType.integer)
                // 联动是否正在执行
                t.column(Columns.executing.rawValue, Database.ColumnType.integer)
            })
        })
    }
    
    /// 插入联动数据
    static func insert(smartLinkage: SmartLinkage) -> Void {
        // 创建表
        SmartLinkage.createTable()
        // 事务
        try! SmartLinkage.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var smartLinkageTemp = smartLinkage
                // 插入到数据库
                try smartLinkageTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 插入数据数组
    static func insert(smartLinkages: [SmartLinkage]) -> Void {
        for smartLinkage in smartLinkages {
            // 插入数据
            SmartLinkage.insert(smartLinkage: smartLinkage)
        }
    }
            
    /// 通过联动ID 查询
    static func query(linkageID: Int) -> SmartLinkage? {
        // 检测是否创建数据库
        SmartLinkage.createTable()
        return try! SmartLinkage.dbPool.read({ (db) -> SmartLinkage? in
            return try SmartLinkage
                //.filter(Column(Columns.linkage_id.rawValue) == linkageID)
                .fetchOne(db)
        })
    }
    
    /// 更新数据
    static func update(smartLinkage: SmartLinkage) -> Void {
        // 创建数据库表
        SmartLinkage.createTable()
        // 提交事务 更新
        try! SmartLinkage.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值更新
                try smartLinkage.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
        
    /// 删除所有联动数据
    static func deleteAll() -> Void {
        // 创建数据库表
        SmartLinkage.createTable()
        // 提交事务
        try! SmartLinkage.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除
                try SmartLinkage.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 删除某一联动
    static func delete(smartLinkage: SmartLinkage) -> Void {
        // 创建数据库表
        SmartLinkage.createTable()
        // 提交事务
        try! SmartLinkage.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除
                try smartLinkage.delete(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
            
        })
    }
}
