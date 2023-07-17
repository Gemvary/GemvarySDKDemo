//
//  UserDataBase.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import GRDB

struct UserTable {
    static let accountInfo = "accountInfo"
    static let projectUser = "projectUser"
    static let space = "space"
}

struct UserDataBase {
    
    static let user_database = "user_database.db"
    
    private static var dbPath: String = {
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/\(UserDataBase.user_database)")
        
        return filePath
    }()
    
    private static var configuration: Configuration = {

        var configuration = Configuration()
        configuration.busyMode = Database.BusyMode.timeout(5.0)
        
        return configuration
    }()
        
    
    static var dbPool: DatabasePool = {
        
        let db = try! DatabasePool(path: UserDataBase.dbPath, configuration: UserDataBase.configuration)
        db.releaseMemory()
        
        return db
    }()
}
