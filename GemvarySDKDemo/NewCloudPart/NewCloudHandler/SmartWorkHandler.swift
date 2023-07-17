//
//  SmartWorkHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2022/1/15.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK

/// 智能家居新改接口
class SmartWorkHandler: NSObject {

    /// 获取主机设备列表
    static func userDeviceList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号信息为空")
            return
        }
        SmartWorkAPI.userDeviceList(account: account) { (object) in
            if object == nil {
                swiftDebug("网络请求错误")
                failedCallback!("")
                return
            }
            if object is Error {
                if let object = object as? Error {
                    let description = object.localizedDescription
                    failedCallback!(description)
                    return
                }
            }
            swiftDebug("获取主机列表信息:: ", object as Any)
            
            guard let res = try? ModelDecoder.decode(JHCloudWorkRes.self, param: object as! [String : Any]) else {
                swiftDebug("JHCloudWorkRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                // 转换为JSON字符串
                guard let json = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    failedCallback!("")
                    return
                }
                successCallback!(json)
                break
            case CloudResCode.c100000: // 通用失败
                break
            case CloudResCode.c100003: // 会话已过期，请重新登录
                swiftDebug("重新登录智能家居???")
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.userDeviceList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    
    /// 授权子账号
    static func authorizeBind(subAccount: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account, let smartDevCode = accountInfo.smartDevCode else {
            swiftDebug("当前账号信息为空")
            return
        }
        
        SmartWorkAPI.authorizeBind(account: subAccount, devCode: smartDevCode, mainAccount: account) { (object) in
            if object == nil {
                swiftDebug("网络请求错误")
                failedCallback!("")
                return
            }
            if object is Error {
                if let object = object as? Error {
                    let description = object.localizedDescription
                    failedCallback!(description)
                    return
                }
            }
            
            guard let res = try? ModelDecoder.decode(JHCloudWorkRes.self, param: object as! [String : Any]) else {
                swiftDebug("JHCloudWorkRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                // 转换为JSON字符串
                guard let json = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    failedCallback!("")
                    return
                }
                successCallback!(json)
                break
            case CloudResCode.c100000: // 通用失败
                break
            case CloudResCode.c100003: // 会话已过期，请重新登录
                swiftDebug("重新登录智能家居???")
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.authorizeBind(subAccount: subAccount, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
            
        }
        
    }
    
    /// 获取子账号列表
    static func getSubaccounts(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let smartDevCode = accountInfo.smartDevCode else {
            swiftDebug("当前账号信息为空")
            return
        }
        
        SmartWorkAPI.getSubaccounts(devcode: smartDevCode) { (object) in
           if object == nil {
               swiftDebug("网络请求错误")
               failedCallback!("")
               return
           }
           if object is Error {
               if let object = object as? Error {
                   let description = object.localizedDescription
                   failedCallback!(description)
                   return
               }
           }
            
            guard let res = try? ModelDecoder.decode(JHCloudWorkRes.self, param: object as! [String : Any]) else {
                swiftDebug("JHCloudWorkRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                // 转换为JSON字符串
                guard let json = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    failedCallback!("")
                    return
                }
                successCallback!(json)
                break
            case CloudResCode.c100000: // 通用失败
                break
            case CloudResCode.c100003: // 会话已过期，请重新登录
                swiftDebug("重新登录智能家居???")
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.getSubaccounts(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
       }
    }
    
    /// 删除子账号
    static func authorizeUnbind(subAccount: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        // 获取当前账号信息
        guard let accountInfo = AccountInfo.queryNow() else {
            swiftDebug("当前账号信息为空")
            return
        }
        guard let account = accountInfo.account, let smartDevCode = accountInfo.smartDevCode else {
            return
        }
        SmartWorkAPI.authorizeUnbind(account: subAccount, devCode: smartDevCode, mainAccount: account) { (object) in
            if object == nil {
                swiftDebug("网络请求错误")
                failedCallback!("")
                return
            }
            if object is Error {
                if let object = object as? Error {
                    let description = object.localizedDescription
                    failedCallback!(description)
                    return
                }
            }
            
            guard let res = try? ModelDecoder.decode(JHCloudWorkRes.self, param: object as! [String : Any]) else {
                swiftDebug("JHCloudWorkRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                guard let json = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    failedCallback!("")
                    return
                }
                successCallback!(json)
                break
            case CloudResCode.c100000: // 通用失败
                break
            case CloudResCode.c100003: // 会话已过期，请重新登录
                swiftDebug("重新登录智能家居???")
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.authorizeUnbind(subAccount: subAccount, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    /// 解绑当前主设备
    static func unBindDevice(devcode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        // 获取当前账号信息
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号信息为空")
            return
        }
        
        SmartWorkAPI.unBindDevice(account: account, devcode: devcode) { (object) in
            if object == nil {
                swiftDebug("网络请求错误")
                failedCallback!("")
                return
            }
            if object is Error {
                if let object = object as? Error {
                    let description = object.localizedDescription
                    failedCallback!(description)
                    return
                }
            }
            
            guard let res = try? ModelDecoder.decode(JHCloudWorkRes.self, param: object as! [String : Any]) else {
                swiftDebug("JHCloudWorkRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                // 转换为JSON字符串
                guard let json = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    failedCallback!("")
                    return
                }
                successCallback!(json)
                break
            case CloudResCode.c100000: // 通用失败
                break
            case CloudResCode.c100003: // 会话已过期，请重新登录
                swiftDebug("重新登录智能家居???")
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.unBindDevice(devcode: devcode, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    
    /// 获取子账号列表
    static func getSubaccounts(devCode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        SmartWorkAPI.getSubaccounts(devcode: devCode) { (object) in
           if object == nil {
               swiftDebug("网络请求错误")
               failedCallback!("")
               return
           }
           if object is Error {
               if let object = object as? Error {
                   let description = object.localizedDescription
                   failedCallback!(description)
                   return
               }
           }
            
            guard let res = try? ModelDecoder.decode(JHCloudWorkRes.self, param: object as! [String : Any]) else {
                swiftDebug("JHCloudWorkRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                // 转换为JSON字符串
                guard let json = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    failedCallback!("")
                    return
                }
                successCallback!(json)
                break
            case CloudResCode.c100000: // 通用失败
                break
            case CloudResCode.c100003: // 会话已过期，请重新登录
                swiftDebug("重新登录智能家居???")
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.getSubaccounts(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
       }
    }
    
    /// 授权子账号
    static func authorizeBind(subAccount: String, devCode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号信息为空")
            return
        }
        
        SmartWorkAPI.authorizeBind(account: subAccount, devCode: devCode, mainAccount: account) { (object) in
            if object == nil {
                swiftDebug("网络请求错误")
                failedCallback!("")
                return
            }
            if object is Error {
                if let object = object as? Error {
                    let description = object.localizedDescription
                    failedCallback!(description)
                    return
                }
            }
            
            guard let res = try? ModelDecoder.decode(JHCloudWorkRes.self, param: object as! [String : Any]) else {
                swiftDebug("JHCloudWorkRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                // 转换为JSON字符串
                guard let json = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    failedCallback!("")
                    return
                }
                successCallback!(json)
                break
            case CloudResCode.c100000: // 通用失败
                break
            case CloudResCode.c100003: // 会话已过期，请重新登录
                swiftDebug("重新登录智能家居???")
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.authorizeBind(subAccount: subAccount, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
            
        }
        
    }
    
    /// 删除子账号
    static func authorizeUnbind(subAccount: String, devCode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        // 获取当前账号信息
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号信息为空")
            return
        }
        SmartWorkAPI.authorizeUnbind(account: subAccount, devCode: devCode, mainAccount: account) { (object) in
            if object == nil {
                swiftDebug("网络请求错误")
                failedCallback!("")
                return
            }
            if object is Error {
                if let object = object as? Error {
                    let description = object.localizedDescription
                    failedCallback!(description)
                    return
                }
            }
            
            guard let res = try? ModelDecoder.decode(JHCloudWorkRes.self, param: object as! [String : Any]) else {
                swiftDebug("JHCloudWorkRes 转换Model失败")
                return
            }
            
            switch res.code {
            case CloudResCode.c000000: // 成功
                guard let json = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    failedCallback!("")
                    return
                }
                successCallback!(json)
                break
            case CloudResCode.c100000: // 通用失败
                break
            case CloudResCode.c100003: // 会话已过期，请重新登录
                swiftDebug("重新登录智能家居???")
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.authorizeUnbind(subAccount: subAccount, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    
}

/// 智能家居设备用户列表
struct JHCloudWorkRes: Codable {
    /// 状态码
    var code: String?
    /// 状态消息
    var message: String?
}

