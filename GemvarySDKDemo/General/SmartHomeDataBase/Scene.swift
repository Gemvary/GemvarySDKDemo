//
//  Scene.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB

/// 场景
struct Scene: Codable {
    /// 设置rowID
    var id: Int64?
    /// 场景类型 0: 全局 1:区域
    var type: Int?
    /// 场景状态 1:当前执行的场景 0:非执行场景
    var state: Int?
    /// 场景是否正在执行
    var executing: Int?
    /// 场景值
    var scene_value: Int?
    /// 场景动作列表数据,当场景ID为有效ID时返回该字段数据
    //var action: [Action]?
    /// 场景icon
    var icon: String?
    /// 场景所属区域
    var room_name: String?
    /// 场景逻辑ID
    var scene_id: Int?
    /// 场景名称
    var scene_name: String?
    /// 场景类型 0全局场景，1区域场景
    var scene_type: Int?
    
    /// 数据库表行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowID
        case id
        /// 场景逻辑ID
        case scene_id
        /// 场景类型 0: 全局 1:区域
        case type
        /// 场景icon
        case icon
        /// 场景状态 1:当前执行的场景 0:非执行场景
        case state
        /// 场景所属区域
        case room_name
        /// 场景名称
        case scene_name
        /// 场景是否正在执行
        case executing
        /// 场景值
        case scene_value
        ///
        case scene_type
    }
    
    /// 设置rowID
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

/// 实现CURD功能
extension Scene: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建数据库表
    private static func createTable() -> Void {
        try! self.dbPool.write({ (db) -> Void in
            if try db.tableExists(SmartHomeTable.scene) {
                //swiftDebug("表已经存在")
                // 新增数据库字段
                let columns: [ColumnInfo] = try db.columns(in: SmartHomeTable.scene)
                // 遍历是否包含 scene_type行
                let scene_type = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.scene_type.rawValue
                }
                // 不存在 scene_type行 添加该行
                if scene_type == false {
                    try db.alter(table: SmartHomeTable.scene, body: { (t) in
                        t.add(column: Columns.scene_type.rawValue, Database.ColumnType.integer)
                    })
                }
                // 遍历判断是否存在 scene_value行
                let scene_value = columns.contains { (columns) -> Bool in
                    return columns.name == Columns.scene_value.rawValue
                }
                if scene_value == false {
                    try db.alter(table: SmartHomeTable.scene, body: { (t) in
                        t.add(column: Columns.scene_value.rawValue, Database.ColumnType.integer)
                    })
                }
                
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.scene, temporary: false, ifNotExists: true, body: { (t) in
                // 自增ID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                // 场景逻辑ID
                t.column(Columns.scene_id.rawValue, Database.ColumnType.integer)
                // 场景类型 0: 全局 1:区域
                t.column(Columns.type.rawValue, Database.ColumnType.integer)
                // 场景icon
                t.column(Columns.icon.rawValue, Database.ColumnType.text)
                // 场景状态 1:当前执行的场景 0:非执行场景
                t.column(Columns.state.rawValue, Database.ColumnType.integer)
                // 场景所属区域
                t.column(Columns.room_name.rawValue, Database.ColumnType.text)
                // 场景名称
                t.column(Columns.scene_name.rawValue, Database.ColumnType.text)
                // 场景是否正在执行
                t.column(Columns.executing.rawValue, Database.ColumnType.integer)
                // 场景值
                t.column(Columns.scene_value.rawValue, Database.ColumnType.integer)
                // scene_type
                t.column(Columns.scene_type.rawValue, Database.ColumnType.integer)
            })
        })
    }
    
    /// 插入多个场景
    static func insert(scenes: [Scene]) -> Void {
        for scene in scenes {
            // 插入数据
            Scene.insert(scene: scene)
        }
    }
    
    /// 插入单个场景
    static func insert(scene: Scene) -> Void {
        // 判断是否存在
        guard Scene.query(scene: scene) == nil else {
            //swiftDebug("插入场景内容重复")
            return
        }
        
        // 创建表
        //Scene.createTable()
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
        
    /// 查询所有
    static func queryAll() -> [Scene] {
        // 创建数据库
        Scene.createTable()
        // 查询
        return try! Scene.dbPool.read({ (db) -> [Scene] in
            let scenes = try Scene.fetchAll(db)
            /// 数组元素
            return scenes
        })
    }
    
    /// 根据场景ID查询
    static func query(sceneID: Int) -> Scene? {
        Scene.createTable()
        // 返回查询结果
        return try! Scene.dbPool.read({ (db) -> Scene? in
            return try Scene
                .filter(Column(Columns.scene_id.rawValue) == sceneID)
                .fetchOne(db)
        })
    }
    
    /// 根据场景查询场景
    static func query(scene: Scene) -> Scene? {
        // 创建数据库表
        Scene.createTable()
        // 返回查询结果
        return try! Scene.dbPool.read({ (db) -> Scene? in
            return try Scene
                .filter(Column(Columns.scene_id.rawValue) == scene.scene_id)
                .filter(Column(Columns.scene_name.rawValue) == scene.scene_name)
                .filter(Column(Columns.room_name.rawValue) == scene.room_name)
                .fetchOne(db)
        })
    }
    
    /// 通过房间名称查询场景
    static func query(room_name: String) -> [Scene] {
        // 创建数据库表
        Scene.createTable()
        // 返回查询结果
        return try! Scene.dbPool.read({ (db) -> [Scene] in
            return try Scene
                .filter(Column(Columns.room_name.rawValue) == room_name)
                .fetchAll(db)
        })
    }
    
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
    
    /// 删除所有场景
    static func deleteAll() -> Void {
        // 是否有数据库表
        self.createTable()
        // 事务
        try! self.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除所有数据
                try self.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
}

/// Gateway
struct Action: Codable {
    /// 动作ID，查询列表时存在
    var action_id: Int?
    /// 1-设备动作属性，从设备具备功能属性查询;2-执行某个场景;3-触发报警;4-安防动作，撤防、布防（一般室内机使用）;5-激活/禁用某个联动;6-等待;8-执行确认，会发一条消息到用户确认才确定是否继续执行该联动
    var type: Int?
    /// 动作的执行条件，&&（条件全满足），||（条件任意满足）
    var conditions: String?
    /// 执行动作的条件,不需要条件就写空数组
    var conds: [Condition]?
    /// 动作参数,根据type取值,type=1主机设备列表的dev_id;type=4默认0;type=6默认0;
    var obj_id: Int?
    /// 房间名称, type=1有效
    var room_name: String?
    /// type=4有效， 撤防/布防 [ disarm, defence ]
    var security_mode: String?
    /// 设备名称, type=1有效
    var dev_name: String?
    /// 设备动作命令, type=1有效
    var func_cmd: String?
    /// 功能附加值，默认空字符串, type=1有效
    var func_value: String?
    /// 报警内容, type=3有效，报警通知的文字内容，最大30个汉字
    var content: String?
    /// 0：持续，1：瞬间, type=3有效
    var alarm_type: Int?
    /// 0：报警，1:提醒, type=3有效
    var alarm_level: Int?
    /// 功能参数 type=1有效，具有参数的属性参数值
    var value: Int?
    /// 时间
    var time: Int?
    /// 该动作当前是否有效状态 默认:1
    var valid: Int?
    /// 执行顺序 默认:0
    var seq: Int?
    /// type=6有效，等待时间，单位秒  0~60
    var inter_time: Int?
}

/// 执行动作的条件,不需要条件就写空数组
struct Condition: Codable {
    /// 条件ID，查询列表时存在
    var cond_id: Int?
    /// 1-设备动作属性，从设备具备功能属性查询,2-场景切换触发,3-安防动作，撤防、布防（一般室内机使用）,4-时间做为条件,5-当前地区（未使用）,6-当前天气（未使用）
    var type: Int?
    /// type=1有效，满足的条件,表“设备功能属性的JSON对象参数表”的param_type=0时，该字段可以不需要或者写空字符串；param_type=1/2且data_range=1/2时，该字段可以选>/</=, data_range=3时该字段选=，具体看实际设备功能属性
    var conds: String?
    /// 动作参数,根据type取值, type=1主机设备列表的dev_id;type=2场景ID,默认0;type=3默认0;type=4默认0;type=5默认0;type=6默认0
    var obj_id: Int?
    /// 房间名称, type=1有效
    var room_name: String?
    /// type=4有效，撤防/布防 [ disarm, defence ]
    var security_mode: String?
    /// 设备名称, type=1有效
    var dev_name: String?
    /// 设备动作命令, type=1有效
    var func_cmd: String?
    /// 场景名称, type=2时必须填写该字段
    var scene_name: String?
    /// 功能附加值，默认空字符串或者不带该字段, type=1有效，默认为空字符串
    var func_value: String?
    /// 功能参数, type=1有效，具有参数的属性参数值，比如光照度等类似参数放在这里
    var value: Int?
    /// type=4有效，某年做为条件
    var year: Int?
    /// type=4有效，某月做为条件
    var month: Int?
    /// type=4有效，某日做为条件
    var date: Int?
    /// type=4有效，某周几做为条件
    var week: Int?
    /// 时间, type=4有效，某时某分，单位秒（转为秒）
    var time: Int?
    /// 区域名称, ype=5有效，未使用可以写空字符串
    var area: String?
    /// 默认1，该条件当前是否有效状态
    var valid: Int?
}
