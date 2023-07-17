//
//  MessageHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/28.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

//MARK: - 消息处理
/// 消息处理
class MessageHandler: NSObject {
    /// 查询报警消息
    static func iotAlarmMessage(page: Int, size: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let spaceId = accountInfo.spaceID else {
            swiftDebug("当前空间ID为空")
            return
        }
        
        MessageAPI.iotAlarmMessage(spaceId: spaceId, page: page, size: size) { (status, object) in
            swiftDebug("查询报警消息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("查询报警消息: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("查询报警消息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotAlarmMessage(page: page, size: size, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("查询报警消息 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 根据日期查询报警消息列表
    static func iotAlarmMessageSpaceIdDate(date: String, page: Int, size: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let spaceId = accountInfo.spaceID else {
            swiftDebug("当前空间ID为空")
            return
        }
        
        MessageAPI.iotAlarmMessageSpaceIdDate(spaceId: spaceId, date: date, page: page, size: size) { (status, object) in
            swiftDebug("根据日期查询报警消息列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("根据日期查询报警消息列表: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("根据日期查询报警消息列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotAlarmMessageSpaceIdDate(date: date, page: page, size: size, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("根据日期查询报警消息列表 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }                
    }
    
    
    /// 报警消息设置为已读状态
    static func iotAlarmMessageRead(ids: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        MessageAPI.iotAlarmMessageRead(ids: ids) { (status, object) in
            swiftDebug("报警消息设置为已读状态 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("报警消息设置为已读状态: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("报警消息设置为已读状态 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotAlarmMessageRead(ids: ids, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("报警消息设置为已读状态 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 删除报警消息
    static func iotAlarmMessageDelete(ids: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        MessageAPI.iotAlarmMessageDelete(ids: ids) { (status, object) in
            swiftDebug("删除报警消息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("删除报警消息: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("删除报警消息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotAlarmMessageDelete(ids: ids, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("删除报警消息 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 查询提醒消息
    static func iotRemindMessage(page: Int, size: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let spaceId = accountInfo.spaceID else {
            swiftDebug("当前空间ID为空")
            return
        }
        
        MessageAPI.iotRemindMessage(spaceId: spaceId, page: page, size: size) { (status, object) in
            swiftDebug("查询提醒消息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("查询提醒消息: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback?(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("查询提醒消息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotRemindMessage(page: page, size: size, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("查询提醒消息 其他情况")
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 提醒消息设置为已读状态
    static func iotRemindMessageRead(ids: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        MessageAPI.iotRemindMessageRead(ids: ids) { (status, object) in
            swiftDebug("提醒消息设置为已读状态 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("提醒消息设置为已读状态: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("提醒消息设置为已读状态 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotRemindMessageRead(ids: ids, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("提醒消息设置为已读状态 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 删除提醒信息
    static func iotRemindMessageDelete(ids: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        MessageAPI.iotRemindMessageDelete(ids: ids) { (status, object) in
            swiftDebug("删除提醒信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("删除提醒信息: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("删除提醒信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotRemindMessageDelete(ids: ids, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("删除提醒信息 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 根据日期删除报警信息
    static func iotAlarmMessageDeleteSpaceIdDate(date: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let spaceId = accountInfo.spaceID else {
            swiftDebug("当前空间ID为空")
            return
        }
        
        MessageAPI.iotAlarmMessageDeleteSpaceIdDate(spaceId: spaceId, date: date) { (status, object) in
            swiftDebug("根据日期删除报警信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("根据日期删除报警信息: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("根据日期删除报警信息")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("根据日期删除报警信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotAlarmMessageDeleteSpaceIdDate(date: date, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("根据日期删除报警信息 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    
    
    /// 根据日期及设备类型查询执行提醒信息
    static func iotRemindMessageSpaceIdDateType(date: String, type: String, page: Int, size: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let spaceId = accountInfo.spaceID else {
            swiftDebug("当前空间ID为空")
            return
        }
        
        MessageAPI.iotRemindMessageSpaceIdDateType(spaceId: spaceId, date: date, type: type, page: page, size: size) { (status, object) in
            swiftDebug("根据日期及设备类型查询执行提醒信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("根据日期及设备类型查询执行提醒信息: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("根据日期及设备类型查询执行提醒信息 ")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("根据日期及设备类型查询执行提醒信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotRemindMessageSpaceIdDateType(date: date, type: type, page: page, size: size, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("根据日期及设备类型查询执行提醒信息 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
        
    }
    
    /// 根据日期及设备类型批量删除执行提醒信息
    static func iotRemindMessageDeleteSpaceIdDateType(date: String, type: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let spaceId = accountInfo.spaceID else {
            swiftDebug("当前空间ID为空")
            return
        }  
        
        MessageAPI.iotRemindMessageDeleteSpaceIdDateType(spaceId: spaceId, date: date, type: type) { (status, object) in
            swiftDebug("根据日期及设备类型批量删除执行提醒信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("根据日期及设备类型批量删除执行提醒信息: ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("根据日期及设备类型批量删除执行提醒信息 ")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("根据日期及设备类型批量删除执行提醒信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotRemindMessageDeleteSpaceIdDateType(date: date, type: type, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("根据日期及设备类型批量删除执行提醒信息 其他情况")
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
