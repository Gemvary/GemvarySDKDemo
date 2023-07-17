//
//  SmartHomeDataBase.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GRDB


class SmartHomeTable: NSObject {
    /// 设备管理
    static let device = "device"
    /// 设备类型信息
    static let deviceClass = "deviceClass"
    /// 联动管理
    static let smartLinkage = "smartLinkage"
    /// 房间管理
    static let room = "room"
    /// 设备功能属性
    static let function = "function"
    /// 场景管理
    static let scene = "scene"
    /// 设备参数常用 首页显示
    static let frontDisplay = "frontDisplay"
}

class SmartHomeDataBase: NSObject {
    /// 智能家居数据库名字
    private struct DataBaseName {
        /// 数据库名字
        static let smarthome_database = "smarthome_database.db"
    }
    /// 数据库路径
    private static var dbPath: String = {
        // 根据传入的数据库名称拼接数据库的路径
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/\(DataBaseName.smarthome_database)")
        
        //print("数据库地址：", filePath as Any)
        return filePath
    }()
    
    /// 数据库配置
    private static var configuration: Configuration = {
        // 配置
        var configuration = Configuration()
        // 设置超时
        configuration.busyMode = Database.BusyMode.timeout(5.0)
        // 试图访问锁着的数据
        //configuration.busyMode = Database.BusyMode.immediateError
        
        return configuration
    }()
    
    // MARK: 创建数据 多线程
    /// 数据库 基本处理
//    static var dbQueue: DatabaseQueue = {
//        // 创建数据库
//        let db = try! DatabaseQueue(path: SmartHomeDataBase.dbPath, configuration: SmartHomeDataBase.configuration)
//        db.releaseMemory()
//        // 设备版本
//        return db
//    }()
    
    /// 数据库 用于高并发数据处理
    static var dbPool: DatabasePool = {
        // 创建数据库
        let db = try! DatabasePool(path: SmartHomeDataBase.dbPath, configuration: SmartHomeDataBase.configuration)
        db.releaseMemory()
        // 设备版本
        return db
    }()
    
    //MARK: 删除数据库文件
    /// 删除数据库文件
    static func deleteDataBaseFile() -> Void {
        // 删除数据库文件
        GlobalTools.deleteFile(fileName: DataBaseName.smarthome_database)
    }
    
    
    // MARK: AbleCloud退出登录 删除智能家居的全部数据
//    static func deleteAllSmartHomeDB() -> Void {
//        // 房间管理
//        Room.deleteAll()
//        // 设备类型信息
//        DeviceClass.deleteAll()
//        // 场景管理
//        Scene.deleteAll()
//        // 设备管理
//        Device.deleteAll()
//        // 联动
//        SmartLinkage.deleteAll()
//        // 功能参数
//        Function.deleteAll()
//        // 设备首页显示参数
//        FrontDisplay.deleteAll()
//        // 设置常用
//        //AccountInfo.setupDefault(accountInfo: AccountInfo.share)
//    }
}
