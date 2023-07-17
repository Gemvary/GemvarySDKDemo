//
//  Notice.swift
//  sip
//
//  Created by Gemvary Apple on 2019/12/11.
//  Copyright © 2019 gemvary. All rights reserved.
//

import GRDB

/// 智慧社区通知显示
struct Notice: Codable {
    /// 设置rowID
    var rowID: Int64?
    /// 通知结束时间
    var endtime: String?
    /// 通知ID
    var id: Int?
    /// 通知链接
    var link: String?
    /// 通知类型
    var ntype: String?
    /// 通知标志
    var pushflag: Bool?
    /// 推送时间
    var pushtime: String?
    /// 房间编号
    var roomno: String?
    /// 通知开始时间
    var starttime: String?
    /// 通知简介
    var summary: String?
    /// 通知标题
    var title: String?
    /// 单元名字
    var unitName: String?
    /// 单元编号
    var unitno: String?
    /// 小区编码
    var zoneCode: String?
    /// 账号
    var account: String?
    /// 本地服务器地址
    var domain: String?
        
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case rowID
        /// 通知结束时间
        case endtime
        /// 通知ID
        case id
        /// 通知链接
        case link
        /// 通知类型
        case ntype
        /// 通知标志
        case pushflag
        /// 推送时间
        case pushtime
        /// 房间编号
        case roomno
        /// 通知开始时间
        case starttime
        /// 通知简介
        case summary
        /// 通知标题
        case title
        /// 单元名
        case unitName
        /// 单元编号
        case unitno
        /// 小区编码
        case zoneCode
        /// 账号
        case account
        /// 本地服务器域名地址
        case domain
    }
    
    /// 设置rowid
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.rowID = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
    
}

/// 社区通知的增删改查CURD
extension Notice: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SipDataBase.dbPool
    
    /// 创建表
    static func createTable() -> Void {
        try! self.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(SipTableName.notice) {
                //swiftDebug("表已经存在")
                // 获取所有数据库表行
                let columns: [ColumnInfo] = try db.columns(in: SipTableName.notice)
                let rowID = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.rowID.rawValue
                }
                // 没有主键 需要新增主键(先删除表，再创建数据表)
                if rowID == false {
                    // 删除数据表库内容
                    try db.drop(table: SipTableName.notice)
                    // 创建数据库
                    try db.create(table: SipTableName.notice, temporary: false, ifNotExists: true, body: { (t) in
                        // 自增ID
                        t.autoIncrementedPrimaryKey(Columns.rowID.rawValue)
                        // 结束时间
                        t.column(Columns.endtime.rawValue, Database.ColumnType.text)
                        // 通知ID
                        t.column(Columns.id.rawValue, Database.ColumnType.integer)
                        // 通知链接
                        t.column(Columns.link.rawValue, Database.ColumnType.text)
                        // 通知类型
                        t.column(Columns.ntype.rawValue, Database.ColumnType.text)
                        // 通知标志
                        t.column(Columns.pushflag.rawValue, Database.ColumnType.boolean)
                        // 推送时间
                        t.column(Columns.pushtime.rawValue, Database.ColumnType.text)
                        // 房间编号
                        t.column(Columns.roomno.rawValue, Database.ColumnType.text)
                        // 通知开始时间
                        t.column(Columns.starttime.rawValue, Database.ColumnType.text)
                        // 通知标题
                        t.column(Columns.title.rawValue, Database.ColumnType.text)
                        // 通知简介
                        t.column(Columns.summary.rawValue, Database.ColumnType.text)
                        // 单元名
                        t.column(Columns.unitName.rawValue, Database.ColumnType.text)
                        // 单元编号
                        t.column(Columns.unitno.rawValue, Database.ColumnType.text)
                        // 小区编码
                        t.column(Columns.zoneCode.rawValue, Database.ColumnType.text)
                        // 账号
                        t.column(Columns.account.rawValue, Database.ColumnType.text)
                    })
                    return
                }
                // 遍历是否包含 account行
                let account = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.account.rawValue
                }
                // 不存在 account行 添加该行
                if account == false {
                    try db.alter(table: SipTableName.notice, body: { (t) in
                        t.add(column: Columns.account.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 domain行
                let domain = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.domain.rawValue
                }
                // 不存在 domain行 添加该行
                if domain == false {
                    try db.alter(table: SipTableName.notice, body: { (t) in
                        t.add(column: Columns.domain.rawValue, Database.ColumnType.text)
                    })
                }
                return
            }
            // 创建数据库
            try db.create(table: SipTableName.notice, temporary: false, ifNotExists: true, body: { (t) in
                // 自增ID
                t.autoIncrementedPrimaryKey(Columns.rowID.rawValue)
                // 结束时间
                t.column(Columns.endtime.rawValue, Database.ColumnType.text)
                // 通知ID
                t.column(Columns.id.rawValue, Database.ColumnType.integer)
                // 通知链接
                t.column(Columns.link.rawValue, Database.ColumnType.text)
                // 通知类型
                t.column(Columns.ntype.rawValue, Database.ColumnType.text)
                // 通知标志
                t.column(Columns.pushflag.rawValue, Database.ColumnType.boolean)
                // 推送时间
                t.column(Columns.pushtime.rawValue, Database.ColumnType.text)
                // 房间编号
                t.column(Columns.roomno.rawValue, Database.ColumnType.text)
                // 通知开始时间
                t.column(Columns.starttime.rawValue, Database.ColumnType.text)
                // 通知标题
                t.column(Columns.title.rawValue, Database.ColumnType.text)
                // 通知简介
                t.column(Columns.summary.rawValue, Database.ColumnType.text)
                // 单元名
                t.column(Columns.unitName.rawValue, Database.ColumnType.text)
                // 单元编号
                t.column(Columns.unitno.rawValue, Database.ColumnType.text)
                // 小区编码
                t.column(Columns.zoneCode.rawValue, Database.ColumnType.text)
                // 账号
                t.column(Columns.account.rawValue, Database.ColumnType.text)
                // 服务器域名地址
                t.column(Columns.domain.rawValue, Database.ColumnType.text)
            })
        }
    }
    
    /// 插入数据
    static func insert(notice: Notice) -> Void {
        // 创建数据库表
        Notice.createTable()
        // 查询是否存在该数据
        if let notice = Notice.query(notice: notice) {
            swiftDebug("通知数据已经存在 不用保存", notice)
            return
        }
        // 获取当前小区信息
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            swiftDebug("当前选中的小区为空")
            return
        }
        // 获取当前账号信息
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号信息为空")
            return
        }
        // 事务
        try! Notice.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var noticeTemp = notice
                // 小区编码赋值
                noticeTemp.zoneCode = zoneCode
                // 账号赋值
                noticeTemp.account = account
                // 当前服务器域名地址
//                noticeTemp.domain = domain
                // 插入到数据库
                try noticeTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 更新数据
    static func update(notice: Notice) -> Void {
        // 创建数据库表
        Notice.createTable()
       // 提交事务 更新
        try! Notice.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                let noticeTemp = notice
                try noticeTemp.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }

    /// 查询通知内容
    static func query(notice: Notice) -> Notice? {
        // 创建数据库表
        self.createTable()
        // 查询
        return try! Notice.dbPool.unsafeRead({ (db) -> Notice? in
            return try Notice.filter(Column(Columns.id.rawValue) == notice.id).fetchOne(db)
        })
    }
    
    /// 查询所有
    static func queryAll() -> [Notice] {
        // 创建数据库
        Notice.createTable()
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            swiftDebug("当前选中的小区为空")
            return [Notice]()
        }
        // 获取当前账号信息
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号信息为空")
            return [Notice]()
        }
        // 查询
        return try! Notice.dbPool.unsafeRead({ (db) -> [Notice] in
            let notices = try Notice
                .filter(Column(Columns.zoneCode.rawValue) == zoneCode)
                .filter(Column(Columns.account.rawValue) == account || Column(Columns.account.rawValue) == "" || Column(Columns.account.rawValue) == nil)
//                .filter(Column(Columns.domain.rawValue) == domain || Column(Columns.domain.rawValue) == "" || Column(Columns.domain.rawValue) == nil)
                .fetchAll(db)
            /// 数组元素
            return notices
        })
    }
    
    /// 删除所有
    static func deleteAll() -> Void {
        // 创建数据库表
        Notice.createTable()
        // 删除数据库表中的数据
        try! Notice.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 查询所有的设备
                try Notice.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
}
