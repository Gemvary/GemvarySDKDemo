//
//  Zone.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import GRDB

struct Zone: Codable {
    /// 小区ID
    var id: Int64?
    /// 小区名字
    var zoneName: String?
    /// 小区编码
    var zoneCode: String?
    /// 创建时间
    var zoneCreated: String?
    /// 小区地址
    var zoneAddress: String?
    /// 详细地址
    var detailAddress: String?
    /// 小区房间
    var zoneNote: String?
    /// 状态
    var status: Int?
    /// 选中状态
    var selected: Bool?
    
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID 小区ID
        case id
        /// 小区名字
        case zoneName
        /// 小区编码
        case zoneCode
        /// 创建时间
        case zoneCreated
        /// 小区地址
        case zoneAddress
        /// 详细地址
        case detailAddress
        /// 小区房间
        case zoneNote
        /// 状态
        case status
        /// 选中状态
        case selected
    }
    
    /// 设置rowID
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
}


extension Zone: MutablePersistableRecord, FetchableRecord {

    private static let dbPool: DatabasePool = SipDataBase.dbPool
    
    static func createTable() -> Void {
        try! Zone.dbPool.write { (db) -> Void in
            
            try db.create(table: SipTableName.zone, temporary: false, ifNotExists: true, body: { (t) in
                t.column(Columns.id.rawValue, Database.ColumnType.integer).primaryKey()
                t.column(Columns.zoneName.rawValue, Database.ColumnType.text)
                t.column(Columns.zoneCode.rawValue, Database.ColumnType.text)
                t.column(Columns.zoneCreated.rawValue, Database.ColumnType.text)
                t.column(Columns.zoneAddress.rawValue, Database.ColumnType.text)
                t.column(Columns.detailAddress.rawValue, Database.ColumnType.text)
                t.column(Columns.zoneNote.rawValue, Database.ColumnType.text)
                t.column(Columns.status.rawValue, Database.ColumnType.integer)
                t.column(Columns.selected.rawValue, Database.ColumnType.boolean)
            })
        }
    }
        
    static func insert(zone: Zone) -> Void {
        
        Zone.createTable()
        
        try! Zone.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var zone = zone
                zone.selected = false
                try zone.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
        
    static func insert(zones: [Zone]) -> Void {
        for zone in zones {
            Zone.insert(zone: zone)
        }
    }
    
    static func updateSelected(zone: Zone) -> Void {
        Zone.createTable()
        for zoneDefault in Zone.queryAll() {
            Zone.updateDefault(zone: zoneDefault)
        }
        
        try! Zone.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var zoneTemp = zone
                zoneTemp.selected = true
                try zoneTemp.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    static func updateDefault(zone: Zone) -> Void {
        Zone.createTable()
        
        try! Zone.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var zone = zone
                zone.selected = false
                try zone.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
        
    }
        
    static func queryAll() -> [Zone] {
        Zone.createTable()
        
        return try! Zone.dbPool.unsafeRead({ (db) -> [Zone] in
            return try Zone.fetchAll(db)
        })
    }
    
    static func queryNow() -> Zone? {
        Zone.createTable()
        
        return try! Zone.dbPool.unsafeRead({ (db) -> Zone? in
            return try Zone.filter(Column(Columns.selected.rawValue) == true).fetchOne(db)
        })
    }
    
    static func query(zone: Zone) -> Zone? {
        Zone.createTable()
        
        return try! Zone.dbPool.unsafeRead({ (db) -> Zone? in
            return try Zone.filter(Column(Columns.id.rawValue) == zone.id).fetchOne(db)
        })
    }
    
    static func query(zoneCode: String) -> Zone? {
        Zone.createTable()
        
        return try! Zone.dbPool.unsafeRead({ (db) -> Zone? in
            return try Zone.filter(Column(Columns.zoneCode.rawValue) == zoneCode).fetchOne(db)
        })
    }
        
    static func deleteAll() -> Void {
        Zone.createTable()
        
        try! Zone.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                try Zone.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }    
}
