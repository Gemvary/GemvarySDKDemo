//
//  AccountInfo.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/6/4.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GRDB

/// 用来保存用户的信息
struct AccountInfo: Codable {
    /// 设置rowID
    var id: Int64?
    /// 账号
    var account: String?
    
    /// AbleCloud Token      /***   智慧社区相关字段   ** */
    var ablecloudToken: String?
    /// AbleCloud Uid
    var ablecloudUid: Int?
    /// 云对讲类型
    var cloudIntercomType: Int?
    /// 是否为主账号
    var isPrimary: Int?
    /// 后台服务地址编号
    var serverId: String?
    /// SIP账号
    var sipId: String?
    ///  SIP密码
    var sipPassword: String?
    /// 云对讲服务器地址
    var sipServer: String?
    /// 手机免登录校验码
    var tokenauth: String?
    /// 手机免登录识别号
    var tokencode: String?
    /// 云之讯账号token
    var ucsToken: String?
    /// 判断登录用户是业主还是管理员
    var userDesc: Int?
    /// 用户ID
    var userId: Int?
    /// 免打扰状态
    var userStatus: Int?
    /// 室内机/C5-DS地址(有线安防地址)
    var indoorDevCode: String?
    
    
    /// 智能家居主机地址       /***   旧智能家居相关字段   ** */
    var smartDevCode: String?
    //var smartdevcode: String? // 智能家居主机数据
    /// MQTT Token
    var mqToken: String?
    /// MQTT Uid
    var mqUid: Int?
    /// AbleCloud Token
    var token: String?
    /// AbleCloud Uid
    var uid: Int?
    /// 是否是工程模式
    //var projectMode: Bool? = false
    /// 绑定类型
    var bindType: String? = BindType.main
    /// 局域网内设备的IP
    var server_ip: String?
    
    
    /// 极光认证的Token     /***   新智能家居相关字段   ** */
    var loginToken: String?
    /// 鉴权token
    var access_token: String?
    /// 鉴权token时间
    var expires_in: Int?
    /// 刷新token
    var refresh_token: String?
    /// 刷新token时间
    var refresh_expires_in: Int?
    /// token类型
    var token_type: String?
    /// 当前主机 主机(新云端智能家居主机地址)
    var dev_addr: String?
    /// 当前主机的gid
    var gid: String?
    /// 昵称
    var nickname: String?
    /// 电话
    var phone: String?
    /// 头像路径
    var photo: String?
    /// 空间ID 新增字段(与智能家居dev_code字段一起用来区别是否为新旧状态) 2022.03.01
    var spaceID: String?
    
    /// 是否选中
    var selected: Bool?
    
    /// 设置行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case id
        /// 账号
        case account
        
        /***   智慧社区相关字段   ** */
        /// AbleCloud Token
        case ablecloudToken
        /// AbleCloud Uid
        case ablecloudUid
        /// 云对讲类型
        case cloudIntercomType
        /// 是否为主账号
        case isPrimary
        /// 后台服务地址编号
        case serverId
        /// SIP账号
        case sipId
        ///  SIP密码
        case sipPassword
        /// 云对讲服务器地址
        case sipServer
        /// 手机免登录校验码
        case tokenauth
        /// 手机免登录识别号
        case tokencode
        /// 云之讯账号token
        case ucsToken
        /// 判断登录用户是业主还是管理员
        case userDesc
        /// 用户ID
        case userId
        /// 免打扰状态
        case userStatus
        /// 室内机地址(有线安防)
        case indoorDevCode
        
        /***   旧智能家居相关字段   ** */
        /// 智能家居主机地址
        case smartDevCode
        /// MQTT Token
        case mqToken
        /// MQTT Uid
        case mqUid
        /// AbleCloud Token
        case token
        /// AbleCloud Uid
        case uid
        /// 绑定类型 main: 管理员 主账号 sub: 子账号
        case bindType
        /// 局域网内设备的IP
        case server_ip
        
        /***   新智能家居相关字段   ** */
        /// 极光认证的Token
        case loginToken
        /// 鉴权token
        case access_token
        /// 鉴权token时间
        case expires_in
        /// 刷新token
        case refresh_token
        /// 刷新token时间
        case refresh_expires_in
        /// token类型
        case token_type
        /// 当前主机 主机地址序列号
        case dev_addr
        /// 当前主机的gid
        case gid
        /// 昵称
        case nickname
        /// 电话
        case phone
        /// 头像路径
        case photo
        /// 空间ID 用来区分新旧兼容状态 2022.03.01
        case spaceID
        
        /// 是否选中
        case selected
    }
    
    /// 设置rowID
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

/// 用户信息表CURD操作
extension AccountInfo: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = UserDataBase.dbPool
    
    /// 创建数据库表
    static func createTable() -> Void {
        try! self.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(UserTable.accountInfo) {
                //swiftDebug("表已经存在")
                // 新增数据库字段
                let columns: [ColumnInfo] = try db.columns(in: UserTable.accountInfo)
                // 遍历是否包含 dev_addr行
                let dev_addr = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.dev_addr.rawValue
                }
                // 不存在 dev_addr行 添加该行
                if dev_addr == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.dev_addr.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 gid行
                let gid = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.gid.rawValue
                }
                // 不存在 gid行 添加该行
                if gid == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.gid.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 nickname行
                let nickname = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.nickname.rawValue
                }
                // 不存在 nickname行 添加该行
                if nickname == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.nickname.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 phone行
                let phone = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.phone.rawValue
                }
                // 不存在 phone行 添加该行
                if phone == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.phone.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 photo行
                let photo = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.photo.rawValue
                }
                // 不存在 photo行 添加该行
                if photo == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.photo.rawValue, Database.ColumnType.text)
                    })
                }
                // 新云端增加空间ID字段 用来区分新旧兼容状态 2022.03.01
                // 遍历是否包含 spaceID行
                let spaceID = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.spaceID.rawValue
                }
                // 不存在 spaceID行 添加该行
                if spaceID == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.spaceID.rawValue, Database.ColumnType.text)
                    })
                }
                
                // 遍历是否包含 ablecloudToken行
                let ablecloudToken = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.ablecloudToken.rawValue
                }
                // 不存在 ablecloudToken行 添加该行
                if ablecloudToken == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.ablecloudToken.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历判断是否含有 ablecloudUid 行
                let ablecloudUid = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.ablecloudUid.rawValue
                }
                // 不存在 ablecloudUid行 添加该行
                if ablecloudUid == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.ablecloudUid.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 cloudIntercomType行
                let cloudIntercomType = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.cloudIntercomType.rawValue
                }
                // 不存在 cloudIntercomType行 添加该行
                if cloudIntercomType == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.cloudIntercomType.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 isPrimary行
                let isPrimary = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.isPrimary.rawValue
                }
                // 不存在 isPrimary行 添加该行
                if isPrimary == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.isPrimary.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 serverId行
                let serverId = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.serverId.rawValue
                }
                // 不存在 serverId行 添加该行
                if serverId == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.serverId.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 sipId行
                let sipId = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.sipId.rawValue
                }
                // 不存在 sipId行 添加该行
                if sipId == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.sipId.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 sipPassword行
                let sipPassword = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.sipPassword.rawValue
                }
                // 不存在 sipPassword行 添加该行
                if sipPassword == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.sipPassword.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 sipServer行
                let sipServer = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.sipServer.rawValue
                }
                // 不存在 sipServer行 添加该行
                if sipServer == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.sipServer.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 tokenauth行
                let tokenauth = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.tokenauth.rawValue
                }
                // 不存在 tokenauth行 添加该行
                if tokenauth == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.tokenauth.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 tokencode行
                let tokencode = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.tokencode.rawValue
                }
                // 不存在 tokencode行 添加该行
                if tokencode == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.tokencode.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 ucsToken行
                let ucsToken = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.ucsToken.rawValue
                }
                // 不存在 ucsToken行 添加该行
                if ucsToken == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.ucsToken.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 userDesc行
                let userDesc = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.userDesc.rawValue
                }
                // 不存在 userDesc行 添加该行
                if userDesc == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.userDesc.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 userId行
                let userId = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.userId.rawValue
                }
                // 不存在 userId行 添加该行
                if userId == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.userId.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 userStatus行
                let userStatus = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.userStatus.rawValue
                }
                // 不存在 userStatus行 添加该行
                if userStatus == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.userStatus.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 indoorDevCode行
                let indoorDevCode = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.indoorDevCode.rawValue
                }
                // 不存在 indoorDevCode行 添加该行
                if indoorDevCode == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.indoorDevCode.rawValue, Database.ColumnType.text)
                    })
                }
                
                // 遍历是否包含 smartDevCode行 设备 地址
                let smartDevCode = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.smartDevCode.rawValue
                }
                // 不存在 smartDevCode行 添加该行
                if smartDevCode == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.smartDevCode.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 mqToken行
                let mqToken = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.mqToken.rawValue
                }
                // 不存在 mqToken行 添加该行
                if mqToken == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.mqToken.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 mqUid行
                let mqUid = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.mqUid.rawValue
                }
                // 不存在 mqUid行 添加该行
                if mqUid == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.mqUid.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 token行
                let token = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.token.rawValue
                }
                // 不存在 token行 添加该行
                if token == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.token.rawValue, Database.ColumnType.text)
                    })
                }
                // 遍历是否包含 uid行
                let uid = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.uid.rawValue
                }
                // 不存在 uid行 添加该行
                if uid == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.uid.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历是否包含 bindType行
                let bindType = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.bindType.rawValue
                }
                // 不存在 bindType行 添加该行
                if bindType == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.bindType.rawValue, Database.ColumnType.text)
                    })
                }
                /// 查询是否存在server_ip行
                let server_ip = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.server_ip.rawValue
                }
                if server_ip == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.server_ip.rawValue, Database.ColumnType.text)
                    })
                }
                
                /// 查询是否存在loginToken行
                let loginToken = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.loginToken.rawValue
                }
                if loginToken == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.loginToken.rawValue, Database.ColumnType.text)
                    })
                }
                /// 查询是否存在access_token行
                let access_token = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.access_token.rawValue
                }
                if access_token == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.access_token.rawValue, Database.ColumnType.text)
                    })
                }
                /// 查询是否存在expires_in行
                let expires_in = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.expires_in.rawValue
                }
                if expires_in == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.expires_in.rawValue, Database.ColumnType.integer)
                    })
                }
                /// 查询是否存在refresh_expires_in行
                let refresh_expires_in = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.refresh_expires_in.rawValue
                }
                if refresh_expires_in == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.refresh_expires_in.rawValue, Database.ColumnType.integer)
                    })
                }
                /// 查询是否存在refresh_token行
                let refresh_token = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.refresh_token.rawValue
                }
                if refresh_token == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.refresh_token.rawValue, Database.ColumnType.text)
                    })
                }
                /// 查询是否存在token_type行
                let token_type = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.token_type.rawValue
                }
                if token_type == false {
                    try db.alter(table: UserTable.accountInfo, body: { (t) in
                        t.add(column: Columns.token_type.rawValue, Database.ColumnType.text)
                    })
                }
                                
                return
            }
            // 创建数据库
            try db.create(table: UserTable.accountInfo, temporary: false, ifNotExists: true, body: { (t) in
                // 设置rowID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                // 账号
                t.column(Columns.account.rawValue, Database.ColumnType.text)
                
                /***   智慧社区相关字段   ** */
                // AbleCloud Token
                t.column(Columns.ablecloudToken.rawValue, Database.ColumnType.text)
                // AbleCloud Uid
                t.column(Columns.ablecloudUid.rawValue, Database.ColumnType.integer)
                // 是否为主账号
                t.column(Columns.isPrimary.rawValue, Database.ColumnType.integer)
                // 后台服务地址编号
                t.column(Columns.serverId.rawValue, Database.ColumnType.text)
                // SIP账号
                t.column(Columns.sipId.rawValue, Database.ColumnType.text)
                // SIP账号密码
                t.column(Columns.sipPassword.rawValue, Database.ColumnType.text)
                // 云对讲服务器地址
                t.column(Columns.sipServer.rawValue, Database.ColumnType.text)
                // 手机免登录校验码
                t.column(Columns.tokenauth.rawValue, Database.ColumnType.text)
                // 手机免登录识别号
                t.column(Columns.tokencode.rawValue, Database.ColumnType.text)
                // 云之讯账号token
                t.column(Columns.ucsToken.rawValue, Database.ColumnType.text)
                // 用户ID
                t.column(Columns.userId.rawValue, Database.ColumnType.integer)
                // 免打扰状态
                t.column(Columns.userStatus.rawValue, Database.ColumnType.integer)
                // 判断当前登录用户是业主还是管理员
                t.column(Columns.userDesc.rawValue, Database.ColumnType.integer)
                // 室内机地址(有线安防)
                t.column(Columns.indoorDevCode.rawValue, Database.ColumnType.text)
                // 判断云对讲的类型
                t.column(Columns.cloudIntercomType.rawValue, Database.ColumnType.integer)
                
                /***   旧智能家居相关字段   ** */
                // 设备 地址
                t.column(Columns.smartDevCode.rawValue, Database.ColumnType.text)
                // mqtt token
                t.column(Columns.mqToken.rawValue, Database.ColumnType.text)
                // mqtt uid
                t.column(Columns.mqUid.rawValue, Database.ColumnType.integer)
                // ablecloud token
                t.column(Columns.token.rawValue, Database.ColumnType.text)
                // ablecloud uid
                t.column(Columns.uid.rawValue, Database.ColumnType.integer)
                // 绑定类型
                t.column(Columns.bindType.rawValue, Database.ColumnType.text)
                // 局域网内设备的IP
                t.column(Columns.server_ip.rawValue, Database.ColumnType.text)
                
                /***   新智能家居相关字段   ** */
                // 极光认证token
                t.column(Columns.loginToken.rawValue, Database.ColumnType.text)
                // 鉴权token
                t.column(Columns.access_token.rawValue, Database.ColumnType.text)
                // 鉴权token时间
                t.column(Columns.expires_in.rawValue, Database.ColumnType.integer)
                // 刷新token
                t.column(Columns.refresh_token.rawValue, Database.ColumnType.text)
                // 刷新token时间
                t.column(Columns.refresh_expires_in.rawValue, Database.ColumnType.integer)
                // token类型
                t.column(Columns.token_type.rawValue, Database.ColumnType.text)
                // 当前主机的地址
                t.column(Columns.dev_addr.rawValue, Database.ColumnType.text)
                // 当前主机的gid
                t.column(Columns.gid.rawValue, Database.ColumnType.text)
                // 昵称
                t.column(Columns.nickname.rawValue, Database.ColumnType.text)
                // 电话
                t.column(Columns.phone.rawValue, Database.ColumnType.text)
                // 头像
                t.column(Columns.photo.rawValue, Database.ColumnType.text)
                // 空间ID 用来区分新旧兼容状态 2022.03.01
                t.column(Columns.spaceID.rawValue, Database.ColumnType.text)
                // 是否选中
                t.column(Columns.selected.rawValue, Database.ColumnType.boolean)
            })
        }
    }
    
    /// 插入
    static func insert(accountInfo: AccountInfo) -> Void {
        // 创建数据库表
        self.createTable()
        // 提交事务
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var accountInfoTemp = accountInfo
                // 插入到数据库
                try accountInfoTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 更新
    static func update(accountInfo: AccountInfo) -> Void {
        // 创建数据库表
        self.createTable()
        // 提交事务
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值更新
                try accountInfo.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    
    /// 更新当前用户信息
    static func updateNow(userInfo: AccountInfo) -> Void {
        // 创建数据库表
        self.createTable()
        // 查询所有数据
        for userInfoTemp in self.queryAll() {
            // 设置成初始化状态 其他房间变成未选中模式
            self.setupDefault(accountInfo: userInfoTemp)
        }
        
        // 提交事务 更新
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值
                var userInfoTemp = userInfo
                userInfoTemp.selected = true
                try userInfoTemp.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    
    /// 设置所有的账号为默认
    static func setupAllDefault() -> Void {
        // 遍历数据
        for accountInfo in self.queryAll() {
            self.setupDefault(accountInfo: accountInfo)
        }
    }
    
    /// 设置默认数据
    static func setupDefault(accountInfo: AccountInfo) -> Void {
        // 创建数据库表
        self.createTable()
        // 提交事务 更新
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                var accountInfoTemp = accountInfo
                accountInfoTemp.selected = false
                // 更新数据
                try accountInfoTemp.update(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 查询
    static func query(account: String) -> AccountInfo? {
        // 创建数据库表
        self.createTable()
        // 根据账号查询账号信息
        return try! self.dbPool.read({ (db) -> AccountInfo? in
            return try AccountInfo.filter(Column(Columns.account.rawValue) == account).fetchOne(db)
        })
    }
    
    /// 查询是否存在该账户信息
    static func query(accountInfo: AccountInfo) -> AccountInfo? {
        // 创建数据库表
        self.createTable()
        guard let account = accountInfo.account else {
            return nil
        }
        return try! self.dbPool.read({ (db) -> AccountInfo? in
            // 查询 账号相等 或 登录token相等时 返回数据
            return try AccountInfo.filter(Column(Columns.account.rawValue) == account).fetchOne(db)
        })
    }
    
    /// 查询当前用户信息
    static func queryNow() -> AccountInfo? {
        // 创建数据库表
        self.createTable()
        // 查询当前账号
        return try! self.dbPool.read({ (db) -> AccountInfo? in
            return try AccountInfo.filter(Column(Columns.selected.rawValue) == true).fetchOne(db)
        })
    }

    /// 查询所有的账号
    static func queryAll() -> [AccountInfo] {
        // 创建数据库表
        self.createTable()
        // 查询返回内容
        return try! self.dbPool.read({ (db) -> [AccountInfo] in
            return try AccountInfo.fetchAll(db)
        })
    }
    
    /// 删除
    static func delete() -> Void {
        // 创建数据库表
        self.createTable()
        
    }
    
    /// 删除表中所有数据
    static func deleteAll() -> Void {
        // 创建数据库表
        self.createTable()
        // 删除数据
                
    }
}


/// 用户的类型
struct UserDesc {
    /// 管理员
    static let admin = 1
    /// 业主
    static let owner = 0
}

import GemvaryToolSDK

/// 用户数据库内容
class AccountInfoOC: NSObject, Codable {
    /// 设置rowID
    var id: Int64?
    /// 账号
    @objc var account: String?
    
    /// AbleCloud Token      /***   智慧社区相关字段   ** */
    @objc var ablecloudToken: String?
    /// 云对讲类型
    var cloudIntercomType: Int?
    /// 是否为主账号
    var isPrimary: Int?
    /// 后台服务地址编号
    @objc var serverId: String?
    /// SIP账号
    @objc var sipId: String?
    ///  SIP密码
    @objc var sipPassword: String?
    /// 云对讲服务器地址
    @objc var sipServer: String?
    /// 手机免登录校验码
    @objc var tokenauth: String?
    /// 手机免登录识别号
    @objc var tokencode: String?
    /// 云之讯账号token
    @objc var ucsToken: String?
    /// 判断登录用户是业主还是管理员
    var userDesc: Int?
    /// 用户ID
    var userId: Int?
    /// 免打扰状态
    var userStatus: Int?
    /// 室内机/C5-DS地址(有线安防地址)
    @objc var indoorDevCode: String?
    
    /// 智能家居主机地址       /***   旧智能家居相关字段   ** */
    @objc var smartDevCode: String?
    //var smartdevcode: String? // 智能家居主机数据
    /// MQTT Token
    @objc var mqToken: String?
    /// MQTT Uid
    var mqUid: Int?
    /// AbleCloud Token
    @objc var token: String?
    /// AbleCloud Uid
    var uid: Int?
    /// 是否是工程模式
    //var projectMode: Bool? = false
    /// 绑定类型
    @objc var bindType: String? = BindType.main
    /// 局域网内设备的IP
    @objc var server_ip: String?
        
    /// 极光认证的Token     /***   新智能家居相关字段   ** */
    @objc var loginToken: String?
    /// 鉴权token
    @objc var access_token: String?
    /// 鉴权token时间
    var expires_in: Int?
    /// 刷新token
    @objc var refresh_token: String?
    /// 刷新token时间
    var refresh_expires_in: Int?
    /// token类型
    @objc var token_type: String?
    /// 当前主机 主机(新云端智能家居主机地址)
    @objc var dev_addr: String?
    /// 当前主机的gid
    @objc var gid: String?
    /// 昵称
    @objc var nickname: String?
    /// 电话
    @objc var phone: String?
    /// 头像路径
    @objc var photo: String?
    /// 空间ID 新增字段(与智能家居dev_code字段一起用来区别是否为新旧状态) 2022.03.01
    @objc var spaceID: String?
    
    /// 是否选中
    var selected: Bool?
        
    /// 查询当前数据
    @objc static func queryNow() -> AccountInfoOC {
        guard let userInfo = AccountInfo.queryNow() else {
            return AccountInfoOC()
        }
        
        // 转换值
        guard let data = ModelEncoder.encoder(toDictionary: userInfo),
            let userInfoOC = try? ModelDecoder.decode(AccountInfoOC.self, param: data) else {
            return AccountInfoOC()
        }
        
        // 返回处理后的数据
        return userInfoOC
    }
}

