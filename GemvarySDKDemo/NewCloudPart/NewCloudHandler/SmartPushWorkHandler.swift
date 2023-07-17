//
//  SmartPushWorkHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2022/2/25.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

/// 智能家居推送数据接口
class SmartPushWorkHandler: NSObject {

    /// 获取推送消息列表
    static func toList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        SmartPushWorkAPI.toList(target: account) { (object) in
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
                    self.toList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    /// 获取未读消息列表
    static func toUnreadList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        SmartPushWorkAPI.toUnreadList(target: account) { (object) in
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
                    self.toUnreadList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    /// 获取推送信息详情
    static func readUnreadMessage(message_type: Int, message_id: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        SmartPushWorkAPI.readUnreadMessage(target: account, message_type: message_type, message_id: message_id) { (object) in
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
                    self.readUnreadMessage(message_type: message_type, message_id: message_id, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    /// 获取未读消息条数
    static func countUnread(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        SmartPushWorkAPI.countUnread(target: account) { (object) in
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
                    self.countUnread(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    /// 获取紧急报警消息列表
    static func toUrgentList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        SmartPushWorkAPI.toUnreadList(target: account) { (object) in
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
                    self.toUrgentList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
    ///  获取紧急报警消息列表
    static func toUrgentListWithPage(pageNumber: Int, pageSize: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        SmartPushWorkAPI.toUrgentListWithPage(target: account, pageNumber: pageNumber, pageSize: pageSize) { (object) in
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
                    self.toUrgentListWithPage(pageNumber: pageNumber, pageSize: pageSize, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 请求失败
                swiftDebug("绑定失败", res.message!)
                break
            }
        }
    }
    
}
