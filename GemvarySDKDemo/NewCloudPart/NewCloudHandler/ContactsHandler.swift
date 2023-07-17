//
//  ContactsHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/28.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

/// 联系人请求处理
class ContactsHandler: NSObject {
    
    //MARK: 联系人
    /// 添加联系人
    static func iotContactsAdd(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        ContactsAPI.iotContactsAdd(data: data) { (status, object) in
            swiftDebug("添加联系人 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("添加联系人 : ", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("添加联系人 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotContactsAdd(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("添加联系人 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 批量添加联系人
    static func iotContactsBatchAdd(name: String, phone: String, description: String, group: String, tags: [String], successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        ContactsAPI.iotContactsBatchAdd(name: name, phone: phone, description: description, group: group, tags: tags) { (status, object) in
            swiftDebug("批量添加联系人 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("批量添加联系人 : ", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("批量添加联系人 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotContactsBatchAdd(name: name, phone: phone, description: description, group: group, tags: tags, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("批量添加联系人 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 更新联系人信息
    static func iotContactsUpdate(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        ContactsAPI.iotContactsUpdate(data: data) { (status, object) in
            swiftDebug("更新联系人信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("更新联系人信息 : ", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("更新联系人信息 转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("更新联系人信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotContactsUpdate(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("更新联系人信息 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 删除联系人
    static func iotContactsDelete(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        ContactsAPI.iotContactsDelete(data: data) { (status, object) in
            swiftDebug("删除联系人 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("删除联系人 : ", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("删除联系人 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotContactsDelete(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("删除联系人 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取联系人列表
    static func iotContactsList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        ContactsAPI.iotContactsList { (status, object) in
            swiftDebug("获取联系人列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取联系人列表 : ", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("获取联系人列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotContactsList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取联系人列表 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 根据关键字搜索联系人
    static func iotContactsSearch(keyword: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        ContactsAPI.iotContactsSearch(keyword: keyword) { (status, object) in
            swiftDebug("根据关键字搜索联系人 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("根据关键字搜索联系人 : ", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("根据关键字搜索联系人 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotContactsSearch(keyword: keyword, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("根据关键字搜索联系人 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
}
