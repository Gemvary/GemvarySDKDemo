//
//  UserHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/28.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

/// 用户处理
class UserHandler: NSObject {
    
    /// 修改用户信息
    static func userUpdate(nickname: String, photo: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        UserAPI.userUpdate(nickname: nickname, photo: photo) { (status, object) in
            swiftDebug("更新用户信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("更新用户信息 : ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                // 更新数据库信息
                guard var accountInfo = AccountInfo.queryNow() else {
                    successCallback?(jsonStr)
                    return
                }
                // 更新头像路径
                accountInfo.photo = photo
                accountInfo.nickname = nickname
                AccountInfo.update(accountInfo: accountInfo)
                
                successCallback?(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("更新用户信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.userUpdate(nickname: nickname, photo: photo, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("更新用户信息 其他状态")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 上传用户头像
    static func userUploadAvatar(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        UserAPI.userUploadAvatar(data: data) { (status, object) in
            swiftDebug("从手机相册选择照片 上传 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("从手机相册选择照片 上传 : ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let object = object as? [String: Any], let url = object["url"] as? String else {
                    swiftDebug("上传照片的连接为空")
                    return
                }
                // 清除当前图片的缓存(可不用)
//                SDWebImageTool.clearCacheImage(url)
                
                // 组装字典数据
                let data = ["msg_type": "get_photo_url", "content": url]

                guard let dataStr = JSONTool.translationObjToJson(from: data) else {
                    swiftDebug("转换字符串 失败")
                    return
                }
                // 发送通知
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeexNotiName.subscription), object: nil, userInfo: ["data": dataStr])
                // 获取当前用户的信息
                guard let accountInfo = AccountInfo.queryNow(), let nickname = accountInfo.nickname else {
                    swiftDebug("当前用户信息为空")
                    return
                }
                // 更新用户信息
                self.userUpdate(nickname: nickname, photo: url)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("从手机相册选择照片 上传 请求错误", object as Any)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.userUploadAvatar(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("从手机相册选择照片 上传 其他状态")
                break
            }
        }
    }

    /// 获取个人信息
    static func userInfo(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        UserAPI.userInfo { (status, object) in
            swiftDebug("获取个人信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取个人信息 : ", object as Any)
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
                swiftDebug("获取个人信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.userDisable(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取个人信息 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 停用账号
    static func userDisable(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        UserAPI.userDisable { (status, object) in
            swiftDebug("停用用户 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("停用用户 : ", object as Any)
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
                swiftDebug("停用用户 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.userDisable(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("停用用户 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 查询用户
    static func userSearch(account: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        UserAPI.userSearch(account: account) { (status, object) in
            swiftDebug("设备分享 查询用户:: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("设备分享 查询用户: ", object as Any)
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
                swiftDebug("设备分享 查询用户 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.userSearch(account: account, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("设备分享 查询用户 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 查询分享设备列表
    static func userShareDeviceList(account: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        UserAPI.userShareDeviceList(account: account) { (status, object) in
            swiftDebug("查询分享设备列表:: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("查询分享设备列表: ", object as Any)
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
                swiftDebug("查询分享设备列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.userSearch(account: account, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("查询分享设备列表 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    
    /// 用户取消注册
    static func userDeletionRegistration(verifyCode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        UserAPI.userDeletionRegistration(verifyCode: verifyCode) { (status, object) in
            swiftDebug("用户取消注册:: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("用户取消注册: ", object as Any)
                
                // 跳转到登录界面
//                NewUserTokenLogin.gotoLoginVC()
                
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
                swiftDebug("用户取消注册 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.userDeletionRegistration(verifyCode: verifyCode, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("用户取消注册 其他情况")
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
