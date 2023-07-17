//
//  SmartHomeBind.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/8/31.
//

import UIKit
import GemvaryToolSDK
import GemvarySmartHomeSDK
import GemvaryNetworkSDK
import GemvaryCommonSDK

class SmartHomeBind: NSObject {
    
    /// 当前绑定的智能家居设备
    private static var nowBindDevice: HostDevice = HostDevice()
    /// 设备是否绑定
    private static var deviceBindSuccess: Bool = Bool()
    
    /// 绑定智能家居设备
    static func bindDevice(device: HostDevice) -> Void {
        
        swiftDebug("当前设备绑定的列表内容:: ", device)
        // 获取当前设备
        //let device = self.getCurrentBindDevice(devCode: devCode)
        //swiftDebug("当前绑定的设备内容:", device)
        
        
        
        // 另一种绑定方法
        self.bindDeviceCode(device: device)
    }
    
    
    //MARK: 智能家居绑定设备
    /// 智能家居绑定设备
    static func bindDeviceCode(device: HostDevice) -> Void {
        
        //let device = self.getCurrentBindDevice(devCode: devCode)
        //swiftDebug("当前绑定的设备内容:", device)
        
        // 网络绑定设备
        self.jhBindDevice(device: device) { (result) in
            // 设置当前用户的主机
            self.setUseDeviceRequest(device: device)
        }
    }
    
    
    
    //MARK: 绑定网络设备
    /// 绑定外网设备
//    private static func netBindDeviceRequest(device: HostDevice) -> Void {
//        
//        // 判断当前设备是否为子账号
//        if device.bindType == BindType.sub || device.bindType == BindType.main {
//            // 设置当前用户的绑定主机
//            self.setUseDeviceRequest(device: device)
//            return
//        }
//        
//        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
//            swiftDebug("当前用户信息为空")
//            return
//        }
//        
//        guard let devcode = device.devcode else {
//            swiftDebug("当前主机设备码为空")
//            return
//        }
//        
//        JHCloudWorkAPI.bindDevice(devCode: devcode, account: account) { (object) in
//            if let object = object as? Error {
//                swiftDebug("通过设备码绑定设备 报错: \(object.localizedDescription)")
//                self.deviceBindSuccess = false
//                return
//            }
//
//            guard let res = try? ModelDecoder.decode(DeviceBindRes.self, param: object as! [String : Any]) else {
//                swiftDebug("DeviceBindRes 转换Model失败")
//                return
//            }
//            swiftDebug("绑定外网设备返回结果: ", object as Any)
//            switch res.code {
//            case CloudResCode.c000000: // 成功
//                if let data = res.data, data.devcode != nil {
//                    self.nowBindDevice = device
//                    // 设置当前用户绑定的主机
//                    self.setUseDeviceRequest(device: device)
//                }
//                break
//            case CloudResCode.c100000: // 绑定失败
//                // 获取当前设备绑定的主账号
//                self.getUsersRequest(device: device)
//                break
//            case CloudResCode.c100004: // token失效
//                FetchApiToken.requestUserLogin { (result) in
//                    self.netBindDeviceRequest(device: device)
//                }
//                break
//            default: // 请求失败
//                swiftDebug("绑定失败", res.message!)
//                break
//            }
//        }
//    }
    
    /// 绑定设备
    private static func jhBindDevice(device: HostDevice, callback: ((Bool?) -> Void)? = nil) -> Void {
        // 判断当前设备是否为子账号
//        if device.bindType == BindType.sub || device.bindType == BindType.main {
//            // 设置当前用户的绑定主机
//            self.setUseDeviceRequest(device: device)
//            return
//        }
        swiftDebug("请求token::: ", JHCloudWorkAPI.loginToken)
        //swiftDebug("", JHCloudWorkAPI)
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        
        guard let devcode = device.devcode else {
            swiftDebug("当前主机设备码为空")
            return
        }
        
        JHCloudWorkAPI.bindDevice(devCode: "140078f4c71c30200ad0", account: account) { (object) in
            if let object = object as? Error {
                swiftDebug("通过设备码绑定设备 报错: \(object.localizedDescription)")
                self.deviceBindSuccess = false
                return
            }

            guard let res = try? ModelDecoder.decode(DeviceBindRes.self, param: object as! [String : Any]) else {
                swiftDebug("DeviceBindRes 转换Model失败")
                return
            }
            swiftDebug("绑定外网设备返回结果: ", res)
            switch res.code {
            case CloudResCode.c000000: // 成功
                if let data = res.data, data.devcode != nil {
                    self.nowBindDevice = device
                    // 设置当前用户绑定的主机
                    //self.setUseDeviceRequest(device: device)
                    callback?(true)
                }
                break
            case CloudResCode.c100000: // 绑定失败
                // 获取当前绑定的主账号
                self.getUsersRequest(device: device)
                break
            case CloudResCode.c100004: // token失效
                FetchApiToken.requestUserLogin { (result) in
                    self.jhBindDevice(device: device, callback: callback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
        
    /// 绑定设备成功
    private static func bindDeviceSuccess(device: HostDevice) -> Void {
        // 绑定失败
        if self.deviceBindSuccess == false {
            // 绑定设备失败 查询当前绑定的设备
            self.getUsersRequest(device: device)
        } else {
            // 绑定成功
            self.setUseDeviceRequest(device: device)
        }
    }
    
    /// 绑定设备成功 订阅数据
    private static func bindDeviceSubscribeData(device: HostDevice) -> Void {
        
        swiftDebug("绑定成功 订阅数据", device)
        
//        for deviceModel in SmartHomeDevices.bindDeviceList {
//            if let accountInfo = AccountInfo.queryNow(), deviceModel.devcode == accountInfo.devcode, device.devcode != accountInfo.devcode {
//                // 取消 上个设备的订阅数据集
//                SmartHomeSubscribe.unSubscribeClass(device: deviceModel)
//            }
//
//        }
        swiftDebug("准备订阅当前的设备数据")
        // 客户端(手机)开始订阅数据
        SmartHomeSubscribe.subscribeClass(device: device, sendData: true)
    }
    
    /// 获取主机设备的用户列表
    private static func getUsersRequest(device: HostDevice) -> Void {
        // 判断当前账号是否为空
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        guard let devcode = device.devcode else {
            swiftDebug("设备码为空")
            return
        }
        // 绑定设备失败 查询当前绑定的设备
        JHCloudWorkAPI.getUsers(devcode: devcode) { (object) in
            
            guard (object != nil) else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            
            if let object = object as? Error {
                swiftDebug("请求设备的用户列表 报错: \(object.localizedDescription)")
                ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
                return
            }
            
            swiftDebug("请求设备的用户列表: \(String(describing: object))")
            
            guard let res = try? ModelDecoder.decode(GetUsersRes.self, param: object as! [String : Any]) else {
                swiftDebug("GetUsersRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                // 当前设备为子账号 可以订阅设备
                guard let data = res.data else {
                    swiftDebug("获取用户设备数据为空")
                    return
                }
                let isContains = data.contains(where: { (deviceUser) -> Bool in
                    if deviceUser.account == account {
                        return true
                    } else {
                        return false
                    }
                })
                
                if isContains == false {
                    // 设备用户列表没有该账号 无法订阅
                    var deviceModel = HostDevice()
                    for device in data {
                        if device.bindType == BindType.main {
                            deviceModel = device
                        }
                    }
                    if let account = deviceModel.account {
                        ProgressHUD.showText(NSLocalizedString("绑定设备失败,当前设备已被\(account)绑定", comment: ""))
                    } else {
                        ProgressHUD.showText(NSLocalizedString("绑定设备失败,当前设备账户信息为空", comment: ""))
                    }
                    return
                }
                
                for deviceUser in data {
                    if deviceUser.account == account, let devcode = deviceUser.devcode {
                        //  获取当前的设备信息
                        let device = self.getCurrentBindDevice(devCode: devcode)
                        // 订阅设备的数据
                        self.bindDeviceSubscribeData(device: device)
                    }
                }
                break
            case CloudResCode.c100004: // token设置不对
                FetchApiToken.requestUserLogin { (result) in
                    self.getUsersRequest(device: device)
                }
                break
            default:
                break
            }
        }
    }
    
    /// 用户选择某个设备作为主设备进行控制
    private static func setUseDeviceRequest(device: HostDevice) -> Void {
        // 判断当前账号是否为空
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        guard let devcode = device.devcode else {
            // 设备信息为空 也就是没有成功赋值
            ProgressHUD.showText(NSLocalizedString("绑定失败,没有获取到设备信息", comment: ""))
            return
        }
        // 绑定成功 选定主机
        JHCloudWorkAPI.setUseDevice(account: account, devcode: devcode) { (object) in
            
            guard (object != nil) else {
                swiftDebug("手机Ablecloud选定主机 网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            
            if let object = object as? Error {
                swiftDebug("手机Ablecloud选定主机 报错: \(object.localizedDescription)")
                ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
                return
            }
            
            swiftDebug("手机Ablecloud选定主机: \(String(describing: object))")
            
            guard let res = try? ModelDecoder.decode(SetUseDeviceRes.self, param: object as! [String : Any]) else {
                swiftDebug("GetUsersRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000:
                // 绑定设备成功 订阅数据
                self.bindDeviceSubscribeData(device: device)
                break
            case CloudResCode.c100000: // 账号选定主机
                // 获取主机的主账号
                self.getUsersRequest(device: device)
                break
            case CloudResCode.c100004: // 刷新token
                FetchApiToken.requestUserLogin { (result) in
                    self.setUseDeviceRequest(device: device)
                }
                break
            default:
                ProgressHUD.showText("绑定失败")
                break
            }
        }
    }
    
    /// 获取当前绑定智能家居设备
    private static func getCurrentBindDevice(devCode: String) -> HostDevice {
        var bindDevice = HostDevice()
        
//        for deviceTemp in SmartHomeDevices.bindDeviceList {
//            if deviceTemp.devcode == devCode {
//                bindDevice = deviceTemp
//            }
//        }
        // 返回设备
        return bindDevice
    }
    
    //MARK: 解绑智能家居设备
    /// 解绑智能家居设备
    static func unbindDevice(devCode: String) -> Void {
        swiftDebug("WeexGatewayModule unbindDev 解绑设备：\(devCode)")
        
        swiftDebug("解绑设备 当前账号信息: ", AccountInfo.queryNow() as Any)
        
        let bindDevice = self.getCurrentBindDevice(devCode: devCode)
                
        // 判断当前网络状态
        self.platUnbindDevice(device: bindDevice)
        
        // API解绑主机设备
        self.jhCloudUnBindDevice(devcode: devCode) { (result) in
            swiftDebug("解绑设备的结果: ", result)
        }
    }
    
    
    //MARK: 主机解绑
    /// 平台解绑主机设备
    static func platUnbindDevice(device: HostDevice) -> Void {
        // model转字典
        guard let deviceInfo = ModelEncoder.encoder(toDictionary: device) else {
            swiftDebug("转换字典失败")
            return
        }
        
        // 解绑设备
        SmartHomeManager.unbindDevice(deviceInfo: deviceInfo) { (error) in
            guard error == nil else {
                swiftDebug("解绑主机设备失败: ", error as Any)
                ProgressHUD.showText("解绑主机失败")
                return
            }
            guard var accountInfo = AccountInfo.queryNow() else {
                swiftDebug("智能家居 当前账号为空")
                return
            }
            // 更新数据库
            accountInfo.smartDevCode = "" // 设备码为空
            accountInfo.bindType = BindType.main // 绑定类型为主账号
            AccountInfo.update(accountInfo: accountInfo)
            swiftDebug("解绑主机设备 成功")
            ProgressHUD.showText("解绑主机成功")
        }
    }
    
    /// 主机解绑
    static func jhCloudUnBindDevice(devcode: String, callback: ((Bool?) -> Void)? = nil) -> Void {
        // 判断当前用户账号是否为空
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户账号为空")
            return
        }
        // 用户解绑设备
        JHCloudWorkAPI.unBindDevice(account: account, devcode: devcode) { (object) in
            
            guard let object = object else {
                swiftDebug("网络请求错误")
                DispatchQueue.main.async {
                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                }
                return
            }
            
            if object is Error {
                if let obj = object as? Error {
                    let description = obj.localizedDescription
                    DispatchQueue.main.async {
                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
                    }
                    swiftDebug("解绑设备失败 报错: \(object)")
                    return
                }
            }
            // 转换成model
            guard let res = try? ModelDecoder.decode(UnbindDeviceRes.self, param: object as! [String : Any]) else {
                swiftDebug("API解绑主机设备 解析数据 失败", object as Any)
                return
            }
            swiftDebug("打印解绑设备的返回数据: \(res as Any)")
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                guard var accountInfo = AccountInfo.queryNow() else {
                    swiftDebug("智能家居 当前账号为空")
                    return
                }
                // 更新数据库
                accountInfo.smartDevCode = "" // 设备码为空
                accountInfo.bindType = BindType.main // 绑定类型为主账号
                AccountInfo.update(accountInfo: accountInfo)
                //ProgressHUD.showText(NSLocalizedString("解绑主机成功", comment: ""))
                swiftDebug("API解绑设备成功")
                break
            case CloudResCode.c100000: // 失败
                if let message = res.message {
                    ProgressHUD.showText(message)
                } else {
                    ProgressHUD.showText(NSLocalizedString("解绑主机失败", comment: ""))
                }
                break
            case CloudResCode.c100004: // 刷新token
                FetchApiToken.requestUserLogin { (result) in
                    self.jhCloudUnBindDevice(devcode: devcode)
                }
                break
            default:
                swiftDebug("解绑设备失败 其他情况: ", object as Any)
                break
            }
        }
    }
}

/// 绑定类型
struct BindType {
    /// 主账号
    static let main = "main"
    /// 子账号
    static let sub = "sub"
}

/// 解绑设备返回的数据格式
struct UnbindDeviceRes: Codable {
    /// 返回码
    var code: String?
    /// 返回数据
    var data: String?
    /// 操作结果数据
    var message: String?
}

/// 设置当前主机返回信息内容
struct SetUseDeviceRes: Codable {
    /// 返回码
    var code: String?
    /// 返回数据
    var data: String?
    /// 操作结果数据
    var message: String?
}

/// 智能家居设备用户列表
struct GetUsersRes: Codable {
    /// 状态码
    var code: String?
    /// 返回数据
    var data: [HostDevice]?
    /// 状态消息
    var message: String?
}

/// 智能家居绑定数据返回
struct DeviceBindRes: Codable {
    /// 状态码
    var code: String?
    /// 数据
    var data: HostDevice?
    /// 状态消息
    var message: String?
}
