//
//  Room.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB

class Room: NSObject, Codable {
    /// 设置rowID
    var id: Int64?
    /// 房间名称
    var room_name: String?
    /// icon路径
    var room_backgroup: String?
    /// 房间类型
    var room_class_type: Int?
    
    /// 数据库表行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case id
        /// 房间名称
        case room_name
        /// 图片
        case room_backgroup
        /// 房间类型
        case room_class_type
    }
    
    /// 设置rowID
    func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

/// 房间的curd
extension Room: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建数据库表
    private static func createTable() -> Void {
        try! Room.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(SmartHomeTable.room) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.room, temporary: false, ifNotExists: true, body: { (t) in
                /// 自增ID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                /// 房间名称
                t.column(Columns.room_name.rawValue, Database.ColumnType.text)
                /// 图片路径
                t.column(Columns.room_backgroup.rawValue, Database.ColumnType.text)
                /// 房间类型
                t.column(Columns.room_class_type.rawValue, Database.ColumnType.integer)
            })
        }
    }
    
    //MARK: 插入
    /// 插入单个房间数据
    static func insert(room: Room) -> Void {
        // 查询房间
        guard Room.query(room: room) == nil else {
            //swiftDebug("该房间信息已经存在")
            // 更新
            Room.update(room: room)
            return
        }
        // 创建数据库表
        Room.createTable()
        // 提交事务
        try! Room.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var roomTemp = room
                // 插入到数据库
                try roomTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 插入房间数组数据
    static func insert(rooms: [Room]) -> Void {
        for room in rooms {
            Room.insert(room: room)
        }
    }
    
    //MARK: 查询房间
    /// 查询所有
    static func queryAll() -> [Room] {
        Room.createTable()
        return try! Room.dbPool.read { (db) -> [Room] in
            // 插入到数据库
            return try Room.fetchAll(db)
        }
    }
    
    /// 房间名字查询房间
    static func query(roomName: String) -> Room? {
        Room.createTable()
        return try! Room.dbPool.unsafeRead({ (db) -> Room? in
            return try Room.filter(Column(Columns.room_name.rawValue) == roomName).fetchOne(db)
        })
    }
    
    /// 根据设备查询设备
    static func query(room: Room) -> Room? {
        Room.createTable()
        return try! Room.dbPool.unsafeRead({ (db) -> Room? in
            return try Room
                .filter(Column(Columns.room_name.rawValue) == room.room_name)
                .filter(Column(Columns.room_class_type.rawValue) == room.room_class_type)
                .filter(Column(Columns.room_backgroup.rawValue) == room.room_backgroup)
                .fetchOne(db)
        })
    }
    
    
    //MARK: 更新
    /// 更新房间
    static func update(room: Room) -> Void {
        // 创建数据库
        Room.createTable()
        // 事务 更新需要rowID
        try! Room.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值更新
                try room.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    //MARK: 删除
    /// 根据房间名称删除房间
    static func delete(roomName: String) -> Void {
        // 查询房间
        guard let room: Room = Room.query(roomName: roomName) else {
            return
        }
        // 删除房间
        Room.delete(room: room)
    }
    
    /// 删除某一房间
    static func delete(room: Room) -> Void {
        // 创建数据库表
        Room.createTable()
        // 提交事务 删除
        try! Room.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除数据
                try room.delete(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 删除所有房间
    static func deleteAll() -> Void {
        // 创建数据库表
        Room.createTable()
        // 提交事务 删除
        try! Room.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除数据
                try Room.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
}
