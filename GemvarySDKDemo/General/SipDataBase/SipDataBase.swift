//
//  SipDataBase.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import GRDB

struct SipTableName {
    static let invitation = "invitation"
    static let inOutdoorDev = "inOutdoorDev"
    static let zone = "zone"
    static let ownerRoom = "ownerRoom"
    static let notice = "notice"
    static let callRecord = "callRecord"
}

struct SipDataBase {
    
    private struct DataBaseName {
        static let sip_database = "sip_database.db"
    }
    
    private static var dbPath: String = {
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/\(DataBaseName.sip_database)")
        
        return filePath
    }()
    
    private static var configuration: Configuration = {
        var configuration = Configuration()
        configuration.busyMode = Database.BusyMode.timeout(5.0)
        return configuration
    }()
        
    static var dbPool: DatabasePool = {
        let db = try! DatabasePool(path: SipDataBase.dbPath, configuration: SipDataBase.configuration)
        db.releaseMemory()
        return db
    }()
    
}
