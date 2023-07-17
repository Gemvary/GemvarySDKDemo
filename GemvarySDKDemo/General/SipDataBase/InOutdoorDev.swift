//
//  AllInOutdoorDevData.swift
//  sip
//
//  Created by Gemvary Apple on 2019/11/29.
//  Copyright © 2019 gemvary. All rights reserved.
//

/// 数据库
import GRDB

/// 门口机/室内机的数据
struct InOutdoorDev: Codable {
    /// 设备码
    var devCode: String?
    /// 设备类型
    var devType: Int?
    /// 设备说明
    var note: String?
    /// 云对讲账号
    var sipAddr: String?
    /// 单元号
    var unitno: String?
    /// 小区编号 数据库需要
    var zoneCode: String?
    
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设备码
        case devCode
        /// 设备类型
        case devType
        /// 设备说明
        case note
        /// 云对讲账号
        case sipAddr
        /// 单元号
        case unitno
        /// 小区编号 数据库需要
        case zoneCode
    }
}

extension InOutdoorDev: MutablePersistableRecord, FetchableRecord {
    
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SipDataBase.dbPool
    
    /// 创建表
    static func createTable() -> Void {
        try! InOutdoorDev.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(SipTableName.inOutdoorDev) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table: SipTableName.inOutdoorDev, temporary: false, ifNotExists: true, body: { (t) in
                // 设备码
                t.column(Columns.devCode.rawValue, Database.ColumnType.text)
                // 设备类型
                t.column(Columns.devType.rawValue, Database.ColumnType.integer)
                // 设备别名
                t.column(Columns.note.rawValue, Database.ColumnType.text)
                // 云对讲账号
                t.column(Columns.sipAddr.rawValue, Database.ColumnType.text)
                // 单元号
                t.column(Columns.unitno.rawValue, Database.ColumnType.text)
                // 小区编码
                t.column(Columns.zoneCode.rawValue, Database.ColumnType.text)
            })
        }
    }
    
    /// 插入
    static func insert(zoneCode: String, inOutdoorDev: InOutdoorDev) -> Void {
        // 创建数据库表
        self.createTable()
        // 插入数据提交事务
        try! InOutdoorDev.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 设备信息
                var inOutdoorDev = inOutdoorDev
                // 设置小区编码
                inOutdoorDev.zoneCode = zoneCode
                // 插入到数据库
                try inOutdoorDev.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 插入数组数据
    static func insert(zoneCode: String, inOutdoorDevs: [InOutdoorDev]) -> Void {
        // 遍历数据
        for inOutdoorDev in inOutdoorDevs {
            // 插入设备数组
            InOutdoorDev.insert(zoneCode: zoneCode, inOutdoorDev: inOutdoorDev)
        }
    }
    
    /// 更新室内机门口机数据信息
    static func update(zoneCode: String, inOutdoorDev: InOutdoorDev) -> Void {
        // 查询所有数据
        var inOutdoorDev = inOutdoorDev
        inOutdoorDev.zoneCode = zoneCode
        InOutdoorDev.update(inOutdoorDev: inOutdoorDev)
    }
    
    /// 更新门口机室内机数据信息
    static func update(inOutdoorDev: InOutdoorDev) -> Void {
        // 创建数据库表
        self.createTable()
        // 更新 提交事务
        try! InOutdoorDev.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                try inOutdoorDev.update(db)
                //swiftDebug("门口机室内机 初始化选中状态成功")
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 查询所有
    static func queryAll() -> [InOutdoorDev] {
        // 创建数据库表
        self.createTable()
        // 查询所有设备的信息
        return try! InOutdoorDev.dbPool.unsafeRead({ (db) -> [InOutdoorDev] in
            return try InOutdoorDev.fetchAll(db)
        })
    }
    
    /// 依据云对讲账号查询设备
    static func qunery(sipAddr: String) -> InOutdoorDev? {
        // 创建数据库表
        InOutdoorDev.createTable()
        // 查询是否存在该小区
        return try! InOutdoorDev.dbPool.unsafeRead({ (db) -> InOutdoorDev? in
            return try InOutdoorDev.filter(Column(Columns.sipAddr.rawValue) == sipAddr).fetchOne(db)
        })
    }
    
    /// 删除所有数据
    static func deleteAll() -> Void {
        // 创建数据库表
        InOutdoorDev.createTable()
        // 删除数据库表中的数据
        try! InOutdoorDev.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 查询所有的设备
                try InOutdoorDev.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
}
