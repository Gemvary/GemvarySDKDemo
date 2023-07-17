//
//  CallRecord.swift
//  sip
//
//  Created by Gemvary Apple on 2019/12/6.
//  Copyright © 2019 gemvary. All rights reserved.
//

import GRDB
import Foundation

/// 通话记录
struct CallRecord: Codable {
    /// 地址
    var address: String?
    /// 账号
    var account: String?
    /// 小区编码
    var zoneCode: String?
    /// 呼叫类型
    var callTag: Int?
    /// 时间
    var time: Date?
    
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 地址
        case address
        /// 账号
        case account
        /// 小区编码
        case zoneCode
        /// 呼叫类型
        case callTag
        /// 时间
        case time
    }
}

/// 创建数据的CURD操作
extension CallRecord: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SipDataBase.dbPool
    
    /// 创建表
    static func createTable() -> Void {
        try! self.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(SipTableName.callRecord) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table: SipTableName.callRecord, temporary: false, ifNotExists: true, body: { (t) in
                // 地址
                t.column(Columns.address.rawValue, Database.ColumnType.text)
                // 账号
                t.column(Columns.account.rawValue, Database.ColumnType.text)
                // 小区编码
                t.column(Columns.zoneCode.rawValue, Database.ColumnType.text)
                // 呼叫类型
                t.column(Columns.callTag.rawValue, Database.ColumnType.integer)
                // 时间
                t.column(Columns.time.rawValue, Database.ColumnType.date)
            })
        }
    }
    

    /// 插入通话记录
    static func insertOutCallrecords(address: String) -> Void {
        self.createTable()
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            swiftDebug("当前小区信息为空")
            return
        }
        
        let callTag = CallLogTag.callOut.rawValue
                
        var callRecord = CallRecord(address: address, account: account, zoneCode: zoneCode, callTag: callTag, time: Date())
        
        // 事务
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 插入到数据库
                try callRecord.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    ///  添加通话未接来电记录
    static func insertNotAnswerCallrecords(address: String) -> Void {
        self.createTable()
    }
    
    /// 添加通话未接来电记录Now
    static func insertNotAnswerCallrecordsNow(address: String) -> Void {
        self.createTable()
    }
    

    /// 添加免打扰来电记录
    static func insertUndisturbCallrecords(address: String) -> Void {
        self.createTable()
    }
    
    /// 添加通话已接来电记录
    static func insertAnswerCallrecords() -> Void {
        self.createTable()
                
        guard var lastData = self.queryLastNoAnswerData() else {
            // 最新未接来电数据为空
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return
        }
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            return
        }
        
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值
                lastData.account = account
                lastData.zoneCode = zoneCode
                
                try lastData.update(db)
                //swiftDebug("数据库操作更新OK。。。")
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
        
    }

    ///  查询最新未接来电数据
    private static func queryLastNoAnswerData() -> CallRecord? {
        self.createTable()
        
        // 查询结果
        return try! dbPool.unsafeRead({ (db) -> CallRecord? in
            let callRecords = try CallRecord.filter(Column(Columns.callTag.rawValue) == CallLogTag.noAnswer.rawValue).fetchAll(db).sorted(by: { data1, data2 in
                // time值越大 时间最早
                if let time1 = data1.time, let time2 = data2.time {
                    return time1.timeIntervalSince1970 > time2.timeIntervalSince1970
                } else {
                    // 不用排序
                    return false
                }
            })
            // 数组元素
            if callRecords.count > 0 {
                return callRecords.first
            } else {
                return nil
            }
        })
    }

    /// 查询所有数据内容
    static func queryAll() -> [CallRecord] {
        // 创建数据库表
        self.createTable()
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return [CallRecord]()
        }
        
        // 查询结果
        return try! dbPool.unsafeRead({ (db) -> [CallRecord] in
            let callRecords = try CallRecord.filter(Column(Columns.account.rawValue) == account).fetchAll(db)
            /// 数组元素
            return callRecords
        })
    }
    
    /// 根据address和callTag查询
    static func query(callTag: CallLogTag) -> [CallRecord] {
        self.createTable()
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return [CallRecord]()
        }
        
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            return [CallRecord]()
        }
        
        return try! self.dbPool.unsafeRead({ (db) -> [CallRecord] in
            return try CallRecord
                .filter(Column(Columns.account.rawValue) == account)
                .filter(Column(Columns.zoneCode.rawValue) == zoneCode)
                .filter(Column(Columns.callTag.rawValue) == callTag.rawValue)
                .fetchAll(db)
        })
    }
    
    /// 根据地址和tag查询数据个数
    static func searchCallRecordNumber(callTag: Int, address: String) -> Int {
        self.createTable()
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return 0
        }
        
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            return 0
        }
        
        return try! self.dbPool.unsafeRead({ (db) -> Int in
            return try CallRecord
                .filter(Column(Columns.account.rawValue) == account)
                .filter(Column(Columns.zoneCode.rawValue) == zoneCode)
                .filter(Column(Columns.callTag.rawValue) == callTag)
                .filter(Column(Columns.address.rawValue) == address)
                .fetchAll(db).count
        })
    }
    
    /// 查询指定通话类型和指定地址的通话记录
    static func searchCallRecordForCallTag(callTag: Int, address: String) -> [Date] {
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return [Date]()
        }
        
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            return [Date]()
        }
        
        return try! self.dbPool.unsafeRead({ (db) -> [Date] in
             let dataArray = try CallRecord
                .filter(Column(Columns.account.rawValue) == account)
                .filter(Column(Columns.zoneCode.rawValue) == zoneCode)
                .filter(Column(Columns.callTag.rawValue) == callTag)
                .filter(Column(Columns.address.rawValue) == address)
                .fetchAll(db)
            
            var dateList = [Date]()
            for data in dataArray {
                if let time = data.time {
                    dateList.append(time)
                }
            }
            return dateList
        })
    }
    
    
    /// 删除所有
//    static func deleteAll() -> Void {
//        self.createTable()
//
//        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
//            do {
//                try CallRecord.deleteAll(db)
//                return Database.TransactionCompletion.commit
//            } catch {
//                return Database.TransactionCompletion.rollback
//            }
//        })
//    }
    
    /// 删除指定通话记录数据
    static func delete(callTag: CallLogTag, address: String) -> Void {
        self.createTable()
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return
        }
        
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            return
        }
        
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                try CallRecord
                    .filter(Column(Columns.account.rawValue) == account)
                    .filter(Column(Columns.zoneCode.rawValue) == zoneCode)
                    .filter(Column(Columns.address.rawValue) == address)
                    .filter(Column(Columns.callTag.rawValue) == callTag.rawValue)
                    .deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 超过7天 删除数据
    static func deleteBeyond7Days() -> Void {
        
        
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                swiftDebug("删除数据", try CallRecord.filter(Column(Columns.time.rawValue) <= Date()).fetchOne(db) as Any)
                // 删除七天数据
                try CallRecord.filter(Column(Columns.time.rawValue) <= Date()).deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    
}


/// 呼叫记录的标签
enum CallLogTag: Int {
    /// 未接通
    case noAnswer = 0
    /// 已接通
    case answer  = 1
    /// 呼出
    case callOut = 2
    /// 免打扰
    case dndCall = 3
}
