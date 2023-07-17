//
//  SmartLinkage.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB

class SmartLinkage: NSObject, Codable {
    /// 设置rowID
    var id: Int64?
    /// 联动名称
    var linkage_name: String?
    /// 状态 1:激活 0:禁用
    var state: Int?
    /// && 所有条件满足执行 || 任意条件满足执行
    var conditions: String?
    /// 联动动作报警提示内容
    var content: String?
    /// 触发时间间隔 默认0
    var retrigger_time: Int?
    /// 联动ID
    var linkage_id: Int?
    
    /// 设置行名字
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case id
        /// 联动名称
        case linkage_name
        /// 状态
        case state
        /// 条件
        case conditions
        /// 报警提示内容
        case content
        /// 触发时间间隔
        case retrigger_time
        /// 联动ID
        case linkage_id
    }
    
    /// 设置rowid
    func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

extension SmartLinkage: MutablePersistableRecord, FetchableRecord {
    
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建表
    private static func createTable() -> Void {
                
        try! SmartLinkage.dbPool.write({ (db) ->Void in
            // 判断是否存在数据库
            if try db.tableExists(SmartHomeTable.smartLinkage) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.smartLinkage, temporary: false, ifNotExists: true, body: { (t) in
                /// 设置rowID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                // 联动名字
                t.column(Columns.linkage_name.rawValue, Database.ColumnType.text)
                // 状态
                t.column(Columns.state.rawValue, Database.ColumnType.integer)
                // 满足条件
                t.column(Columns.conditions.rawValue, Database.ColumnType.text)
                // 联动动作 报警内容
                t.column(Columns.content.rawValue, Database.ColumnType.text)
                // 触法时间
                t.column(Columns.retrigger_time.rawValue, Database.ColumnType.integer)
                // 联动ID
                t.column(Columns.linkage_id.rawValue, Database.ColumnType.integer)
            })
        })
    }
    
    //MARK: 联动 插入增加
    /// 插入联动数据
    static func insert(smartLinkage: SmartLinkage) -> Void {
        //
        guard SmartLinkage.query(linkageID: smartLinkage.linkage_id!) == nil else {
            // 查询 数据已经存在 更新
            SmartLinkage.update(smartLinkage: smartLinkage)
            return
        }
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
    
    //MARK: 联动 查询
    /// 通过联动ID 查询
    static func query(linkageID: Int) -> SmartLinkage? {
        // 检测是否创建数据库
        SmartLinkage.createTable()
        return try! SmartLinkage.dbPool.unsafeRead({ (db) -> SmartLinkage? in
            return try SmartLinkage.filter(Column(Columns.linkage_id.rawValue) == linkageID).fetchOne(db)
        })
    }
    
    //MARK: 联动 更新
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
    
    
    //MARK: 联动 删除
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
    
    /// 根据联动ID删除数据
    static func delete(linkageID: Int) -> Void {
        // 创建数据库表
        SmartLinkage.createTable()
        // 提交事务
        try! SmartLinkage.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除
                try SmartLinkage.filter(Column(Columns.linkage_id.rawValue) == linkageID).deleteAll(db)
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
