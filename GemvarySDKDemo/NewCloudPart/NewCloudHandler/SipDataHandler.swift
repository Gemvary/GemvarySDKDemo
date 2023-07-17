//
//  SipDataHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2021/8/26.
//

import UIKit
import GemvaryToolSDK
import GemvaryNetworkSDK
import GemvaryCommonSDK

/// 智慧社区模块的相关网络请求
class SipDataHandler: NSObject {
    
    /// 当前小区房间列表
    static var ownerRooms: [OwnerRoom] = [OwnerRoom]()
    /// 蓝牙设备列表
    static var bleOutDoorList: [[String: Any]] = [[String: Any]]()    
    
    //MARK: 请求房间信息
    /// 请求房间
    @objc static func fetchRoomInfoList() -> Void {
        // 查询当前小区编码
        guard let zone = Zone.queryNow() else {
            swiftDebug("当前小区查询为空")
            return
        }
        
        if zone.zoneCode == "ABCD" {
            // 请求自定义房间
            self.requestUserRoomList()
        } else {
            // 请求用户所有房间
            self.requestPhoneOwnerRoomList()
        }
    }
    
    /// 获取住户的房间信息
    private static func requestPhoneOwnerRoomList() -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            return
        }
        /// 获取住户房间信息和室内机机器码
        ScsPhoneWorkAPI.phoneOwnerRoomList { (object) in
            //swiftDebug("请求房间信息列表111", object as Any)
            // 判断数据是否为空
            guard let object: [String : Any] = object as? [String : Any] else {
                swiftDebug("网络请求错误")
                DispatchQueue.main.async {
                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                }
                return
            }
            // 判断返回数据是否为错
            if object is Error {
                if let obj = object as? Error {
                    let description = obj.localizedDescription
                    DispatchQueue.main.async {
                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
                    }
                    swiftDebug("获取房间信息及机器码 报错: \(description)")
                    return
                }
            }
            swiftDebug("当前房间列表信息 1:", object as Any)
            // 解析返回数据内容
            guard let res = try? ModelDecoder.decode(PhoneOwnerRoomListRes.self, param: object) else {
                swiftDebug("PhoneOwnerRoomListRes 转换Model失败")
                return
            }
            // 判断返回数据状态码
            switch res.code {
            case NetResCode.c200: // 成功
                // 用户房间列表数据
                guard let data = res.data else {
                    swiftDebug("小区房间列表 数据为空")
                    return
                }
                // 房间列表赋值
                self.ownerRooms = data
                break
            case NetResCode.c552: // 免登录
                NewUserTokenLogin.loginWithToken {
                    SipDataHandler.requestPhoneOwnerRoomList()
                }
                break
            default:
                break
            }
        }
    }
    
    /// 获取用户自助添加的房间信息列表
    private static func requestUserRoomList() -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            return
        }
        // 请求门口机/室内机设备信息列表
        ScsPhoneWorkAPI.userRoomList { (object) in
            // 判断返回数据是否为空
            guard let object = object else {
                swiftDebug("网络请求错误")
                DispatchQueue.main.async {
                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                }
                return
            }
            // 判断返回数据是否网络错误
            if object is Error {
                if let obj = object as? Error {
                    let description = obj.localizedDescription
                    DispatchQueue.main.async {
                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
                    }
                    swiftDebug("获取房间信息及机器码 报错: \(description)")
                    return
                }
            }
            swiftDebug("当前房间列表信息 2:", object as Any)
            // 解析返回的数据内容
            guard let object: [String: Any] = object as? [String : Any], let res = try? ModelDecoder.decode(UserRoomListRes.self, param: object) else {
                swiftDebug("UserRoomListRes 转换Model失败")
                return
            }
            // 判断返回数据状态码
            switch res.code {
            case NetResCode.c200: // 成功
                // 请求成功 变量赋值
                guard let data = res.data else {
                    swiftDebug("房间列表 转换数组 失败")
                    return
                }
                swiftDebug("自定义房间 用户房间信息内容:: ", data)
                break
            case NetResCode.c552: // 免登录请求
                NewUserTokenLogin.loginWithToken {
                    SipDataHandler.requestUserRoomList()
                }


                break
            default:
                break
            }
        }
    }
    
    //MARK: 请求所有小区门口机室内机信息数据
    /// 请求所有小区门口机及室内机信息列表
    @objc static func requestAllInOutdoorDev() -> Void {
        // 判断当前网络状态
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络状态 没有网络")
            return
        }
        
        // 删除所有门口机室内机信息数据
        InOutdoorDev.deleteAll()
        // 多线程
        let groupQueue:DispatchGroup = DispatchGroup()
        // 删除子账号线程
        let queue:DispatchQueue = DispatchQueue(label: "requestAllInOutdoorDev")
        /// 请求门口机数据
        for zone in Zone.queryAll() {
            groupQueue.enter()
            /// 室内机
            self.requestAllIndoorDev(zoneCode: zone.zoneCode!, groupQueue: groupQueue)
            groupQueue.enter()
            /// 门口机
            self.requestAllOutdoorDev(zoneCode: zone.zoneCode!, groupQueue: groupQueue)
        }
        
        groupQueue.notify(queue: queue) {
            // 智能家居设备绑定成功处理方法
            //swiftDebug("插入所有的设备数据?", InOutdoorDev.queryAll())
        }
    }
    
    /// 请求门口机数据列表
    private static func requestAllOutdoorDev(zoneCode: String, groupQueue: DispatchGroup) -> Void {
        // 获取所有门口机和管理机数据
//        PubWorkAPI.allOutdoorDev(zoneCode: zoneCode) { (object) in
//            // 判断数据是否为空
//            guard let object = object else {
//                swiftDebug("网络请求错误")
//                DispatchQueue.main.async {
//                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
//                }
//                groupQueue.leave()
//                return
//            }
//            // 判断返回数据是否错误
//            if object is Error {
//                if let obj = object as? Error {
//                    let description = obj.localizedDescription
//                    DispatchQueue.main.async {
//                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
//                    }
//                    swiftDebug("请求所有门口机设备 报错: \(description)")
//                    groupQueue.leave()
//                    return
//                }
//            }
//            // 解析返回的数据
//            guard let res = try? ModelDecoder.decode(AllInOutdoorDevRes.self, param: object as! [String : Any] ) else {
//                swiftDebug("AllInOutdoorDevRes 转换Model失败")
//                return
//            }
//            // 判断返回数据状态码
//            switch res.code {
//            case NetResCode.c200: // 成功
//                if let data = res.data {
//                    // 门口机管理机设备列表不空时 插入数据库
//                    InOutdoorDev.insert(zoneCode: zoneCode, inOutdoorDevs: data)
//                }
//                groupQueue.leave()
//                break
//            case NetResCode.c552: // 免登录请求
//                NewUserTokenLogin.loginWithToken {
//                    SipDataHandler.requestAllOutdoorDev(zoneCode: zoneCode, groupQueue: groupQueue)
//                }
//                break
//            default:
//                groupQueue.leave()
//                break
//            }
//        }
    }
    
    /// 请求所有室内机数据
    private static func requestAllIndoorDev(zoneCode: String, groupQueue: DispatchGroup) -> Void {
        // 请求所有室内机设备数据
//        PubWorkAPI.allIndoorDev(zoneCode: zoneCode) { (object) in
//            // 判断返回数据是否为空
//            guard let object = object else {
//                swiftDebug("网络请求错误")
//                DispatchQueue.main.async {
//                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
//                }
//                groupQueue.leave()
//                return
//            }
//            // 判断返回数据是否错误
//            if object is Error {
//                if let obj = object as? Error {
//                    let description = obj.localizedDescription
//                    DispatchQueue.main.async {
//                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
//                    }
//                    swiftDebug("请求所有室内机设备 报错: \(description)")
//                    groupQueue.leave()
//                    return
//                }
//            }
//            // 解析返回数据 转model
//            guard let res = try? ModelDecoder.decode(AllInOutdoorDevRes.self, param: object as! [String : Any] ) else {
//                swiftDebug("AllInOutdoorDevRes 转换Model失败")
//                return
//            }
//            // 判断返回数据状态码
//            switch res.code {
//            case NetResCode.c200: // 成功
//                if let data = res.data {
//                    // 插入数据库
//                    InOutdoorDev.insert(zoneCode: zoneCode, inOutdoorDevs: data)
//                }
//                groupQueue.leave()
//                break
//            case NetResCode.c552: // 免登录请求
//                NewUserTokenLogin.loginWithToken {
//                    SipDataHandler.requestAllIndoorDev(zoneCode: zoneCode, groupQueue: groupQueue)
//                }
//                break
//            default:
//                groupQueue.leave()
//                break
//            }
//        }
    }
    
    //MARK: 请求获取蓝牙开锁的门口机列表
    /// 请求获取蓝牙开锁的门口机列表
    static func requestPhoneOutdoorList() -> Void {
        // 判断当前网络状态
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络状态 没有网络")
            return
        }
        // 获取蓝牙开锁门口机列表
        ScsPhoneWorkAPI.phoneOutdoorList { (object) in
            // 判断返回数据是否为空
            if object == nil {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            // 判断返回数据是否错误
            if object is Error {
                if let object = object as? Error {
                    ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
                    swiftDebug("请求蓝牙开锁门口机列表 报错: \(object.localizedDescription)")
                    return
                }
            }
            swiftDebug("请求住户可进行蓝牙开锁门口机列表", object as Any)
            // 解析返回数据内容
            guard let object: [String : Any] = object as? [String : Any], let res = try? ModelDecoder.decode(PhoneOutdoorListRes.self, param: object) else {
                swiftDebug("PhoneOutdoorListRes 转换Model失败")
                return
            }
            // 判断返回数据状态码
            switch res.code {
            case NetResCode.c200: // 成功
                // 蓝牙开锁数据转换数组
                guard let data = res.data, let dictArray = ModelEncoder.encoder(toDictionaryArray: data) else {
                    // 蓝牙开锁设备数据转换失败 赋值初始化
                    self.bleOutDoorList = [[String: Any]]()
                    return
                }
                // 账号蓝牙开锁设备列表赋值
                self.bleOutDoorList = dictArray
                break
            case NetResCode.c552: // token失败
                NewUserTokenLogin.loginWithToken {
                    SipDataHandler.requestPhoneOutdoorList()
                }
                break
            default:
                break
            }
        }
    }
    
    //MARK: 请求 上传VoIP的Token信息
    /// 请求 上传VoIP的Token信息
    @objc static func requestPhoneReportOstype() -> Void {
        // 判断当前网络状态
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络状态 没有网络")
            return
        }
        // 获取设备的token
        guard let apns_token = UserDefaults.standard.object(forKey: "DeviceToken") as? String else {
            swiftDebug("获取设备的token失败")
            return
        }
        
        var apns_type = 0
        
        // 上传VoIP的Token信息
//        ScsPhoneWorkAPI.phoneReportOstype(apns_token: apns_token, apns_type: apns_type) { (object) in
//            // 判断返回数据是否为空
//            if object == nil {
//                swiftDebug("网络请求错误")
//                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
//                return
//            }
//            // 判断返回数据是否错误
//            if object is Error {
//                if let object = object as? Error {
//                    ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
//                    swiftDebug("上传VoIP的Token信息 报错: \(object.localizedDescription)")
//                    return
//                }
//            }
//            // 解析返回数据内容
//            guard let res = try? ModelDecoder.decode(PhoneReportOstypeRes.self, param: object as! [String : Any]) else {
//                swiftDebug("PhoneReportOstypeRes 转换Model失败")
//                return
//            }
//            // 判断返回数据状态码
//            switch res.code {
//            case NetResCode.c200: // 成功
//                swiftDebug("VOIP token上传成功")
//                break
//            case NetResCode.c400:
//                swiftDebug("VOIP token上传失败")
//                break
//            case NetResCode.c552: // 免登录
//                NewUserTokenLogin.loginWithToken {
//                    SipDataHandler.requestPhoneReportOstype()
//                }
//                break
//            default:
//                break
//            }
//        }
    }
    
    //MARK: 获取所有来电号码
    /// 获取所有来电号码
    static func requestAllPhoneNum() -> Void {
        // 获取所有来电号码
//        PstnWorkAPI.allPhoneNum { (object) in
//            // 判断返回内容是否为空
//            if object == nil {
//                swiftDebug("网络请求错误")
//                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
//                return
//            }
//            // 判断返回内容是否错误
//            if object is Error {
//                if let object = object as? Error {
//                    ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
//                    swiftDebug("请求 获取所有来电号码 报错: \(object.localizedDescription)")
//                    return
//                }
//            }
//            swiftDebug("获取所有来电号码数据", object as Any)
//            // 解析返回内容 转model
//            guard let res  = try? ModelDecoder.decode(AllPhoneNumRes.self, param: object as! [String : Any]) else {
//                swiftDebug("AllPhoneNumRes 转换Model失败")
//                return
//            }
//            // 判断返回内容状态码
//            switch res.code {
//            case NetResCode.c200: // 成功
//                swiftDebug("获取所有来电号码成功")
//                break
//            case NetResCode.c400: // 失败
//                swiftDebug("获取所有来电号码失败")
//                break
//            case NetResCode.c552: // 未登录
//                NewUserTokenLogin.loginWithToken {
//                    SipDataHandler.requestAllPhoneNum()
//                }
//                break
//            default:
//                break
//            }
//        }
    }
    
}


// MARK: 用户自主添加房间列表Res Model
/// 用户自主添加房间列表Res
struct UserRoomListRes: Codable {
    /// 状态码
    var code: Int?
    /// 返回数据
    var data: [UserRoomListData]?
    /// 状态信息
    var message: String?
}

/// 用户自主添加房间信息
struct UserRoomListData: Codable {
    /// 小区名称
    var zoneName: String?
    /// 关联用户ID
    var userId: Int?
    /// 房间ID
    var id: Int?
    /// 房间名字
    var roomName: String?
}


/// 获取住户有权进行蓝牙开锁的门口挤列表 返回数据
struct PhoneOutdoorListRes: Codable {
    /// 返回状态码
    var code: Int?
    /// 返回数据
    var data: [PhoneOutdoorListData]?
    /// 返回状态消息
    var message: String?
}

/// 用户蓝牙开锁门口机信息内容
struct PhoneOutdoorListData: Codable {
    /// 蓝牙mac地址
    var bleMac: String?
    /// 设备码
    var devCode: String?
    /// 唯一ID
    var id: Int?
    /// 房间号
    var roomNo: String?
    /// 单元号
    var unitNo: String?
}

/// 获取所有来电号码
struct AllPhoneNumRes: Codable {
    /// 状态码
    var code: Int?
    /// 返回怒数据
    var data: [String]?
    /// 状态消息
    var message: String?
}

/// 上传VoIP的Token信息 返回内容
struct PhoneReportOstypeRes: Codable {
    /// 状态码
    var code: Int?
    /// 状态消息
    var message: String?
}
