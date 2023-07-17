//
//  OwnerRoom.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import GRDB

/// 社区列表页面 房间信息
struct OwnerRoom: Codable {
    /// ID
    var id: Int64?
    /// 蓝牙
    var bluetooth: String?
    /// 门口机列表 暂时不存在数据库中
    var indoorList: [String]?
    /// 房间号
    var roomno: String?
    /// 单元名
    var unitName: String?
    /// 单元号
    var unitno: String?
    /// 用户ID
    var userId: Int?
    /// 楼层号 (新房屋组织架构)
    var floorNo: String?
    /// 小区编码
    var zoneCode: String?
    /// 被选中
    var selected: Bool?
    
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case id
        /// 小区名字
        case bluetooth
        /// 门口机列表
        case indoorList
        /// 房间号
        case roomno
        /// 单元名
        case unitName
        /// 单元号
        case unitno
        /// 用户ID
        case userId
        /// 楼层号
        case floorNo
        /// 小区编码
        case zoneCode
        /// 房间是否有选中
        case selected
    }
    
    /// 设置rowID
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
}

extension OwnerRoom: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SipDataBase.dbPool
    
    //MARK: 创建
    /// 创建表
    static func createTable() -> Void {
        try! OwnerRoom.dbPool.write { (db) -> Void in
            
            try db.create(table: SipTableName.ownerRoom, temporary: false, ifNotExists: true, body: { (t) in
                t.column(Columns.id.rawValue, Database.ColumnType.integer).primaryKey()
                t.column(Columns.bluetooth.rawValue, Database.ColumnType.text)
                t.column(Columns.roomno.rawValue, Database.ColumnType.text)
                t.column(Columns.unitName.rawValue, Database.ColumnType.text)
                t.column(Columns.unitno.rawValue, Database.ColumnType.text)
                t.column(Columns.userId.rawValue, Database.ColumnType.integer)
                t.column(Columns.floorNo.rawValue, Database.ColumnType.text)
                t.column(Columns.zoneCode.rawValue, Database.ColumnType.text)
                t.column(Columns.selected.rawValue, Database.ColumnType.boolean)
                t.column(Columns.indoorList.rawValue, Database.ColumnType.text)
            })
        }
    }
    
    
    static func insert(ownerRoom: OwnerRoom) -> Void {
        guard OwnerRoom.query(ownerRoom: ownerRoom) == nil else {
            var ownerRoom = ownerRoom
            ownerRoom.selected = false
            OwnerRoom.updateDefault(ownerRoom: ownerRoom)
            return
        }
            
        OwnerRoom.createTable()
                        
        try! OwnerRoom.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var ownerRoomTemp = ownerRoom
                ownerRoomTemp.selected = false
                try ownerRoomTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
        
    }
    
    
    static func insert(ownerRooms: [OwnerRoom]) -> Void {

        for ownerRoom in ownerRooms {
            OwnerRoom.insert(ownerRoom: ownerRoom)
        }
    }
    
    
    static func updateSelected(ownerRoom: OwnerRoom) -> Void {
        OwnerRoom.createTable()
        
        for ownerRoomTemp in OwnerRoom.queryAll() {
            OwnerRoom.updateDefault(ownerRoom: ownerRoomTemp)
        }
        
        guard let tempOwnerRoom = OwnerRoom.query(ownerRoom: ownerRoom) else {
            debugPrint("更新房间信息 数据库中没有该房间信息")
            return
        }
        
        try! OwnerRoom.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var ownerRoom = ownerRoom
                ownerRoom.selected = true
                ownerRoom.id = tempOwnerRoom.id
                try ownerRoom.update(db)
                debugPrint("更新当前家庭 数据 更新选中状态成功")
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }

    static func updateDefault(ownerRoom: OwnerRoom) -> Void {
        OwnerRoom.createTable()
        
        try! OwnerRoom.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var ownerRoom = ownerRoom
                ownerRoom.selected = false
                try ownerRoom.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    
    static func query(ownerRoom: OwnerRoom) -> OwnerRoom? {
        OwnerRoom.createTable()
        
        return try! OwnerRoom.dbPool.unsafeRead({ (db) -> OwnerRoom? in
            return try OwnerRoom.filter(Column(Columns.id.rawValue) == ownerRoom.id).fetchOne(db)
        })
    }
    
    static func queryNow() -> OwnerRoom? {
        OwnerRoom.createTable()
        
        return try! OwnerRoom.dbPool.unsafeRead({ (db) -> OwnerRoom? in
            return try OwnerRoom.filter(Column(Columns.selected.rawValue) == true).fetchOne(db)
        })
    }
    
    
    static func query(unitno: String) -> OwnerRoom? {
        OwnerRoom.createTable()
        
        return try! OwnerRoom.dbPool.unsafeRead({ (db) -> OwnerRoom? in
            return try OwnerRoom.filter(Column(Columns.unitno.rawValue) == unitno).fetchOne(db)
        })
    }
    
    
    static func queryAll() -> [OwnerRoom] {
        OwnerRoom.createTable()
        return try! OwnerRoom.dbPool.unsafeRead({ (db) -> [OwnerRoom] in
            let ownerRooms = try OwnerRoom.fetchAll(db)
            return ownerRooms
        })
    }
    

    static func delete(ownerRoom: OwnerRoom) -> Void {        
        OwnerRoom.createTable()
    }
}
