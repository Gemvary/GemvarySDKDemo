//
//  Space.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/11/26.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GRDB

struct Space: Codable {
    /// 空间ID
    var id: String?
    /// 空间名称
    var name: String?
    /// 空间位置
    var address: String?
    /// 小区代码
    var zoneCode: String?
    /// 小区名称
    var zoneName: String?
    /// 组织ID
    var orgId: Int?
    /// 组织名称
    var orgName: String?
    /// 空间属性
    var attr: String?
    /// 描述
    var description: String?
    /// 空间别名
    var alias: String?
    /// 承租人
    var lessee: String?
    
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 主键ID
        case row_id
        /// 空间ID
        case id
        /// 空间名称
        case name
        /// 空间位置
        case address
        /// 小区代码
        case zoneCode
        /// 小区名称
        case zoneName
        /// 组织ID
        case orgId
        /// 组织名称
        case orgName
        /// 空间属性
        case attr
        /// 描述
        case description
        /// 空间别名
        case alias
        /// 承租人
        case lessee
    }
    
}

/// 实现CURD方法
extension Space: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = UserDataBase.dbPool
    
    /// 创建表
    static func createTable() -> Void {
        try! self.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(UserTable.space) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table:UserTable.space, temporary: false, ifNotExists: true, body: { (t) in
                /// 空间ID
                t.column(Columns.id.rawValue, Database.ColumnType.text)
                /// 空间名称
                t.column(Columns.name.rawValue, Database.ColumnType.text)
                /// 空间位置
                t.column(Columns.address.rawValue, Database.ColumnType.text)
                /// 小区代码
                t.column(Columns.zoneCode.rawValue, Database.ColumnType.text)
                /// 小区名称
                t.column(Columns.zoneName.rawValue, Database.ColumnType.text)
                /// 组织ID
                t.column(Columns.orgId.rawValue, Database.ColumnType.integer)
                /// 组织名称
                t.column(Columns.orgName.rawValue, Database.ColumnType.text)
                /// 空间属性
                t.column(Columns.attr.rawValue, Database.ColumnType.text)
                /// 描述
                t.column(Columns.description.rawValue, Database.ColumnType.text)
                /// 空间别名
                t.column(Columns.alias.rawValue, Database.ColumnType.text)
                /// 承租人
                t.column(Columns.lessee.rawValue, Database.ColumnType.text)
            })
        }
    }
    
    /// 设置当前空间
    
    /// 插入到空间
    static func insert(space: Space) -> Void {
        // 创建数据库表
        self.createTable()
        // 事务
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 小区信息
                var space = space
                // 插入到数据库
                try space.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 插入所有空间数据
    static func insert(spaces: [Space]) -> Void {
        for space in spaces {
            self.insert(space: space)
        }
    }
    
    
    /// 更新空间
//    static func update(space: Space) -> Void {
//        // 创建数据库表
//        self.createTable()
//        // 更新数据
//        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
//            do {
//                try space.update(db)
//                return Database.TransactionCompletion.commit
//            } catch {
//                return Database.TransactionCompletion.rollback
//            }
//        })
//    }
    
    /// 查询当前空间
//    static func queryNow() -> Space? {
//        // 创建数据库表
//        self.createTable()
//        // 当前选中的小区
//        return try! self.dbPool.unsafeRead({ (db) -> Space? in
//            return try Space.fetchOne(db)
//        })
//    }
    
    /// 根据空间ID查询空间列表中的空间信息
    static func query(spaceID: String) -> Space? {
        // 创建数据库表
        self.createTable()
        // 查询设备数组
        return try! self.dbPool.unsafeRead({ (db) -> Space? in
            return try self.filter(Column(Columns.id.rawValue) == spaceID).fetchOne(db)
        })
    }    
    
    /// 删除所有
    static func deleteAll() -> Void {
        // 创建数据库表
        self.createTable()
        // 删除数据库表中的数据
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 查询所有的设备
                try self.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
}
