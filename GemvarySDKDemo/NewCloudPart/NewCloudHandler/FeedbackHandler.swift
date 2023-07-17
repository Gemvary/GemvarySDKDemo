//
//  FeedbackHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/28.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

/// 意见反馈处理
class FeedbackHandler: NSObject {
    /// 上传意见反馈图片
    static func feedbackIotUploadImg(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        FeedbackAPI.feedbackIotUploadImg(data: data) { (status, object) in
            swiftDebug("上传意见反馈图片 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("上传意见反馈图片: ", object as Any)
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
                swiftDebug("上传意见反馈图片 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.feedbackIotUploadImg(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("上传意见反馈图片 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 提交意见反馈
    static func feedbackIot(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        FeedbackAPI.feedbackIot(data: data) { (status, object) in
            swiftDebug("提交意见反馈 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("提交意见反馈: ", object as Any)
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
                swiftDebug("提交意见反馈 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.feedbackIot(data: data, successCallback: successCallback, failedCallback: failedCallback
                    )
                }
                break
            default:
                swiftDebug("提交意见反馈 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 查询用户提交的所有意见反馈
    static func feedbackMyList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        FeedbackAPI.feedbackMyList { (status, object) in
            swiftDebug("查询用户提交的所有意见反馈 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("查询用户提交的所有意见反馈: ", object as Any)
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
                swiftDebug("查询用户提交的所有意见反馈 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.feedbackMyList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("查询用户提交的所有意见反馈 其他情况")
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
