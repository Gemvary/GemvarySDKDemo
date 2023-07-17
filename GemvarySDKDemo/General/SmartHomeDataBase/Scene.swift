//
//  Scene.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB

class Scene: NSObject, Codable {
    /// 设置rowID
    var id: Int64?
    /// 场景的ID
    var scene_id: Int?
    /// 场景图片
    var icon: String?
    /// 场景类型 0:全局场景 1:房间场景
    var type: Int?
    /// 场景名字
    var scene_name: String?
    /// 房间名字
    var room_name: String?
    /// 是否执行中
    var executing: Int?
    /// 是否为当前场景
    var state: Int?
    
    /// 设置行名字
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowid
        case id
        /// 场景ID
        case scene_id
        /// 图片
        case icon
        /// 场景类型
        case type
        /// 场景名字
        case scene_name
        /// 房间名字
        case room_name
        /// 是否执行中
        case executing
        /// 是否为当前场景
        case state
    }
    
    /// 设置rowid
    func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

extension Scene: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建数据库表
    private static func createTable() -> Void {
        try! Scene.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(SmartHomeTable.scene) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.scene, temporary: false, ifNotExists: true, body: { (t) in
                // 自增ID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                // 场景ID
                t.column(Columns.scene_id.rawValue, Database.ColumnType.integer)
                // 场景图片
                t.column(Columns.icon.rawValue, Database.ColumnType.text)
                // 场景类型
                t.column(Columns.type.rawValue, Database.ColumnType.integer)
                // 场景名字
                t.column(Columns.scene_name.rawValue, Database.ColumnType.text)
                // 房间名字
                t.column(Columns.room_name.rawValue, Database.ColumnType.text)
                // 是否执行中
                t.column(Columns.executing.rawValue, Database.ColumnType.integer)
                // 是否为当前场景
                t.column(Columns.state.rawValue, Database.ColumnType.integer)
            })
        }
    }
    
    
    //MARK: 场景 插入
    /// 插入单个场景
    static func insert(scene: Scene) -> Void {
        // 判断是否存在
        guard Scene.query(scene: scene) == nil else {
            //swiftDebug("插入场景内容重复")
            return
        }
        
        // 创建表
        Scene.createTable()
        // 事务
        try! Scene.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var sceneTemp = scene
                // 插入到数据库
                try sceneTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 插入多个场景
    static func insert(scenes: [Scene]) -> Void {
        for scene in scenes {
            // 插入数据
            Scene.insert(scene: scene)
        }
    }
    
    //MARK: 场景 查询
    /// 查询场景
    static func queryAll() -> [Scene] {
        Scene.createTable()
        // 返回查询结果
        return try! Scene.dbPool.unsafeRead({ (db) -> [Scene] in
            return try Scene.fetchAll(db)
        })
    }
    
    /// 根据场景ID查询
    static func query(sceneID: Int) -> Scene? {
        Scene.createTable()
        // 返回查询结果
        return try! Scene.dbPool.unsafeRead({ (db) -> Scene? in
            return try Scene.filter(Column(Columns.scene_id.rawValue) == sceneID).fetchOne(db)
        })
    }
    
    /// 根据场景查询场景
    static func query(scene: Scene) -> Scene? {
        // 创建数据库表
        Scene.createTable()
        // 返回查询结果
        return try! Scene.dbPool.unsafeRead({ (db) -> Scene? in
            return try Scene
                .filter(Column(Columns.scene_id.rawValue) == scene.scene_id)
                .filter(Column(Columns.scene_name.rawValue) == scene.scene_name)
                .filter(Column(Columns.room_name.rawValue) == scene.room_name)
                .fetchOne(db)
        })
    }
    
    
    /// 根据房间名字查询所有场景
    static func query(roomName: String) -> [Scene] {
        Scene.createTable()
        // 返回查询结果
        return try! Scene.dbPool.unsafeRead({ (db) -> [Scene] in
            return try Scene.filter(Column(Columns.room_name.rawValue) == roomName).fetchAll(db)
        })
    }
    
    //MARK: 场景 更新
    /// 更新场景
    static func update(scene: Scene) -> Void {
        /// 创建数据库表
        Scene.createTable()
        // 事务 更新场景
        try! Scene.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值
                try scene.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    //MARK: 场景 删除
    /// 删除所有场景
    static func deleteAll() -> Void {
        // 是否有数据库表
        Scene.createTable()
        // 事务
        try! Scene.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除所有数据
                try Scene.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 删除某一场景
    static func delete(scene: Scene) -> Void {
        // 是否有数据库表
        Scene.createTable()
        // 事务
        try! Scene.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除数据
                try scene.delete(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 根据场景ID删除
    static func delete(sceneID: Int) -> Void {
        // 查询场景
        guard let scene = Scene.query(sceneID: sceneID) else {
            return
        }
        // 删除
        Scene.delete(scene: scene)
    }
}
