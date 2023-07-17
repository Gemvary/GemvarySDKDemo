//
//  AddressBookHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/28.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

/// 通讯录处理
class AddressBookHandler: NSObject {
    /// 获取标签列表
    static func iotAddressBookTagList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        AddressBookAPI.iotAddressBookTagList { (status, object) in
            swiftDebug("获取标签列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取标签列表 : ", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("获取标签列表 请求错误", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotAddressBookTagList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取标签列表 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 新增标签
    static func iotAddressBookTagAdd(tag: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        AddressBookAPI.iotAddressBookTagAdd(tag: tag) { (status, object) in
            swiftDebug("新增标签 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("新增标签 : ", object as Any)
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
                swiftDebug("新增标签 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotAddressBookTagAdd(tag: tag, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("新增标签 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 删除标签
    static func iotAddressBookTagDelete(tag: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        AddressBookAPI.iotAddressBookTagDelete(tag: tag) { (status, object) in
            swiftDebug("删除标签 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("删除标签 : ", object as Any)
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
                swiftDebug("删除标签 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotAddressBookTagDelete(tag: tag, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("删除标签 其他")
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
