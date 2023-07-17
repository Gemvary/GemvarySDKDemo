//
//  ProjectUser.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/8/26.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GRDB

/// 用户项目(小区)
struct ProjectUser: Codable {
    /// 主键ID
    var id: Int64?
    /// 项目编码
    var code: String?
    /// 项目名字
    var name: String?
    /// 是否选中
    var selected: Bool?
    
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 主键ID
        case id
        /// 项目编码
        case code
        /// 项目名字
        case name
        /// 是否选中
        case selected
    }
}

/// 实现数据库的CURD
extension ProjectUser: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = UserDataBase.dbPool
    
    /// 创建表
    static func createTable() -> Void {
        try! ProjectUser.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(UserTable.projectUser) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table:UserTable.projectUser, temporary: false, ifNotExists: true, body: { (t) in
                // 主键ID
                t.column(Columns.id.rawValue, Database.ColumnType.integer).primaryKey()
                // 项目编码
                t.column(Columns.code.rawValue, Database.ColumnType.text)
                // 项目名字
                t.column(Columns.name.rawValue, Database.ColumnType.text)
                // 选中状态
                t.column(Columns.selected.rawValue, Database.ColumnType.boolean)
            })
        }
    }
    
    /// 插入
    static func insert(projectUser: ProjectUser) -> Void {
        // 创建数据库表
        self.createTable()
        // 事务
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 小区信息
                var projectUser = projectUser
                // selected默认为false
                projectUser.selected = false
                // 插入到数据库
                try projectUser.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 插入数组
    static func insert(projectUsers: [ProjectUser]) -> Void {
        for projectUser in projectUsers {
            if self.query(projectUser: projectUser) == nil {
                //swiftDebug("用户相关项目 数据不存在")
                // 遍历插入数据
                ProjectUser.insert(projectUser: projectUser)
            }            
        }
    }
    
    /// 查询数据是否存在
    static func query(projectUser: ProjectUser) -> ProjectUser? {
        // 创建数据库表
        self.createTable()
        // 查询是否存在该小区
        return try! self.dbPool.unsafeRead({ (db) -> ProjectUser? in
            return try ProjectUser.filter(Column(Columns.code.rawValue) == projectUser.code).fetchOne(db)
        })
    }
    
    /// 查询所有数据
    static func queryAll() -> [ProjectUser] {
        // 创建数据库表
        self.createTable()
        // 查询所有小区信息
        return try! self.dbPool.unsafeRead({ (db) -> [ProjectUser] in
            return try ProjectUser.fetchAll(db)
        })
    }
    
    /// 查询当前选中的数据
    static func queryNow() -> ProjectUser? {
        // 创建数据库表
        self.createTable()
        // 当前选中的小区
        return try! self.dbPool.unsafeRead({ (db) -> ProjectUser? in
            return try ProjectUser.filter(Column(Columns.selected.rawValue) == true).fetchOne(db)
        })
    }
    
    /// 更新
    static func updateNow(projectUser: ProjectUser) -> Void {
        // 创建数据库表
        self.createTable()
        // 所有更新状态
        for projectUser in self.queryAll() {
            // 设置成初始化值
            //swiftDebug("设备状态?", zoneDefault)
            self.setDefault(projectUser: projectUser)
        }
        
        // 提交事务 更新
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 查询所有数据
                var projectUser = projectUser
                projectUser.selected = true
                try projectUser.update(db)
                //swiftDebug("小区数据 更新选中状态成功")
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 设置为默认状态 未选中
    static func setDefault(projectUser: ProjectUser) -> Void {
        // 创建数据库表
        self.createTable()
        // 提交事务 更新
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 查询所有数据
                var projectUser = projectUser
                projectUser.selected = false
                try projectUser.update(db)
                //swiftDebug("小区数据 初始化选中状态成功")
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
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
                try ProjectUser.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
}
