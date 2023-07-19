//
//  Function.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB
import GemvarySmartHomeSDK

struct FuncAttr: Codable {
    /// 设备类型
    var dev_class_type: String?
    /// 功能属性信息
    var functions: [Function]?
}

/// 设备功能属性信息类
struct Function: Codable {
    /// 设置rowID
    var id: Int64?
    /// 1.固定取值 2.自定义取值 3.枚举值
    var data_range: Int?
    /// JSON字符串
    var enum_str: String?
    /// 设备功能属性命令
    var func_command: String?
    /// 设备功能属性名字
    var func_name: String?
    /// 最大值
    var max: Float?
    /// 最小值
    var min: Float?
    /// 0.该属性没带参数 1.有参数，参数为数值型参数 2.有参数，参数为字符串
    var param_type: Int?
    /// 单位
    var unit: Int?
    /**    新建属性~ 从上一层结构体中获取        **/
    /// 属性类型
    var function_part: String?
    /// 设备类型
    var dev_class_type: String?
    
    /// 创建数据库表行名
    private enum Columns: String, CodingKey, ColumnExpression {
        /// 设置rowid
        case id
        /// 属性类型
        case function_part
        /// 设备类型
        case dev_class_type
        /// 1.固定取值 2.自定义取值 3.枚举值
        case data_range
        /// JSON字符串
        case enum_str
        /// 设备功能属性命令
        case func_command
        /// 设备功能属性名字
        case func_name
        /// 最大值
        case max
        /// 最小值
        case min
        /// 0.该属性没带参数 1.有参数，参数为数值型参数 2.有参数，参数为字符串
        case param_type
        /// 单位
        case unit
    }
        
    /// 设置rowid
    mutating func didInsert(with rowID: Int64, for column: String?) {
        self.id = rowID
    }
    
    /// 解决数据重复的问题
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: Database.ConflictResolution.replace, update: Database.ConflictResolution.replace)
}

extension Function: MutablePersistableRecord, FetchableRecord {
    /// 获取数据库对象
    private static let dbPool: DatabasePool = SmartHomeDataBase.dbPool
    
    /// 创建数据库表
    private static func createTable() -> Void {
        
        try! Function.dbPool.write { (db) -> Void in
            // 判断是否存在数据库
            if try db.tableExists(SmartHomeTable.function) {
                //swiftDebug("表已经存在")
                return
            }
            // 创建数据库
            try db.create(table: SmartHomeTable.function, temporary: false, ifNotExists: true, body: { (t) in
                // 自增ID
                t.autoIncrementedPrimaryKey(Columns.id.rawValue)
                /// 外键 周末可以试试
                //t.foreignKey([Columns.function_part.rawValue], references: "")
                /// 属性类型 可做外键
                t.column(Columns.function_part.rawValue, Database.ColumnType.text)
                /// 品牌名字 可做外键
                t.column(Columns.dev_class_type.rawValue, Database.ColumnType.text)
                // 参数取值范围
                t.column(Columns.data_range.rawValue, Database.ColumnType.integer)
                // json字符串
                t.column(Columns.enum_str.rawValue, Database.ColumnType.text)
                // 设备功能属性命令
                t.column(Columns.func_command.rawValue, Database.ColumnType.text)
                // 设备功能属性名字
                t.column(Columns.func_name.rawValue, Database.ColumnType.text)
                // 最大值
                t.column(Columns.max.rawValue, Database.ColumnType.double)
                // 最小值
                t.column(Columns.min.rawValue, Database.ColumnType.double)
                // 参数类型
                t.column(Columns.param_type.rawValue, Database.ColumnType.integer)
                // 单位
                t.column(Columns.unit.rawValue, Database.ColumnType.integer)
            })
        }
    }
    
    // 功能参数
    static func insert(function: Function) -> Void {
        // 查询数据是否存在
        guard Function.query(function: function) == nil else {
            debugPrint("设备属性 已经存在...", function)
            return
        }
        // 创建数据库
        Function.createTable()
        // 事务
        try! Function.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            // 插入到数据库
            do {
                if function.function_part == FunctionPart.param {
                    //swiftDebug("参数内容:: ", function)
                }
                var functionTemp = function
                try functionTemp.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 功能数组 插入到数据库
    static func insert(functionPart: String, funcAttr: FuncAttr) -> Void {
        if functionPart == FunctionPart.param {
            debugPrint("准备插入的数据::", functionPart, funcAttr)
        }
        if let functions = funcAttr.functions, let dev_class_type = funcAttr.dev_class_type {
            for function in functions {
                var functionTemp = function
                // 功能属性
                functionTemp.function_part = functionPart
                // 设备类型
                functionTemp.dev_class_type = dev_class_type
                // 输入到数据库
                Function.insert(function: functionTemp)
            }
        }
        
    }
    
    /// 遍历循环
    static func insert(functionPart: String, funcAttrs: [FuncAttr]) -> Void {
        
        for funcAttr in funcAttrs {
            Function.insert(functionPart: functionPart, funcAttr: funcAttr)
        }
    }
        
    /// 查询
    static func query(devClassType: String, functionPart: String, funcCommand: String) -> Function? {
        // 创建数据库表
        Function.createTable()
        
        // 查询
        return try! Function.dbPool.unsafeReentrantRead({ (db) -> Function? in
            // 命令重新赋值
            var funcCommand = funcCommand
            
            guard let function = try Function.filter(Column(Columns.dev_class_type.rawValue) == devClassType).filter(Column(Columns.function_part.rawValue) == functionPart).filter(Column(Columns.func_command.rawValue) == funcCommand).fetchOne(db) else {
                // 查询到功能属性为空
                if devClassType == DevClassType.curtain {
                    // 窗帘电机
                    if funcCommand == FuncCommnad.on {
                        funcCommand = "open"
                    }
                    if funcCommand == FuncCommnad.off {
                        funcCommand = "close"
                    }
                }
                
                return try Function
                    .filter(Column(Columns.dev_class_type.rawValue) == devClassType)
                    .filter(Column(Columns.function_part.rawValue) == functionPart)
                    .filter(Column(Columns.func_command.rawValue) == funcCommand)
                    .fetchOne(db)
            }
            
            return function
        })
    }
    
    /// 查询
    static func query(devClassType: String, functionPart: String, funcName: String) -> Function? {
        // 创建数据库表
        Function.createTable()
        // 查询
        return try! Function.dbPool.unsafeRead({ (db) -> Function? in
            return try Function
                .filter(Column(Columns.dev_class_type.rawValue) == devClassType)
                .filter(Column(Columns.function_part.rawValue) == functionPart)
                .filter(Column(Columns.func_name.rawValue) == funcName)
                .fetchOne(db)
        })
    }
    
    /// 查询该条件下的所有数据
    static func query(dev_class_type: String, function_part: String) -> [Function] {
        // 创建数据库表
        Function.createTable()
        // 查询
        return try! Function.dbPool.unsafeRead({ (db) -> [Function] in
            return try Function
                .filter(Column(Columns.dev_class_type.rawValue) == dev_class_type)
                .filter(Column(Columns.function_part.rawValue) == function_part)
                .fetchAll(db)
        })
    }
    
    /// 查询设备类型
    static func queryDevClassTypeList(functionPart: String) -> [String] {
        Function.createTable()
        // 查询
        let functions: [Function] = try! Function.dbPool.unsafeRead({ (db) -> [Function] in
            
            return try Function
                .filter(Column(Columns.function_part.rawValue) == functionPart)
                .fetchAll(db)
        })
        // 设备类型数组
        var devClassTypeList: [String] = [String]()
        
        for function in functions {
            if let dev_class_type = function.dev_class_type, devClassTypeList.contains(dev_class_type) == false {
                // 添加到数组中
                devClassTypeList.append(dev_class_type)
            }
        }
        
        return devClassTypeList
    }
    
    /// 查询设备功能属性是否具有
    static func query(function: Function) -> Function? {
        // 创建数据库
        Function.createTable()
        
        // 查询
        return try! Function.dbPool.unsafeRead({ (db) -> Function? in
            return try Function
                .filter(Column(Columns.dev_class_type.rawValue) == function.dev_class_type)
                .filter(Column(Columns.function_part.rawValue) == function.function_part)
                .filter(Column(Columns.func_name.rawValue) == function.func_name)
                .filter(Column(Columns.func_command.rawValue) == function.func_command)
                .fetchOne(db)
        })
    }
    
    /// 查询该条件下的所有数据
    static func queryAll() -> [Function] {
        // 创建数据库表
        Function.createTable()
        // 查询
        return try! Function.dbPool.unsafeRead({ (db) -> [Function] in
            return try Function.fetchAll(db)
        })
    }
    
    /// 更新
    static func update(function: Function) -> Void {
        // 创建数据库表
        Function.createTable()
        
        // 提交事务 更新  更新设备信息 需要设置rowID
        try! Function.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 赋值
                try function.update(db)
                //swiftDebug("数据库操作更新OK。。。")
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
        
    /// 删除所有数据库
    static func deleteAll() -> Void {
        // 创建数据库
        Function.createTable()
        // 事务
        try! Function.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除所有数据
                try Function.deleteAll(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    /// 删除
    static func delete(function: Function) -> Void {
        // 创建数据库表
        Function.createTable()
        // 事务
        try! Function.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除数据
                try function.delete(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
    
    static func delete(functionPart: String) -> Void {
        // 创建数据库表
        Function.createTable()
        // 事务
        try! Function.dbPool.writeInTransaction(Database.TransactionKind.exclusive, { (db) -> Database.TransactionCompletion in
            do {
                // 删除数据
                try Function
                    .filter(Column(Columns.function_part.rawValue) == functionPart)
                    .deleteAll(db)
                
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        })
    }
    
}
