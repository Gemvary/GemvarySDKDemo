//
//  RequestHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/25.
//  Copyright © 2020 gemvary. All rights reserved.
//

import UIKit
import GemvaryNetworkSDK
import GemvarySmartHomeSDK
import GemvaryToolSDK
import GemvaryCommonSDK

/// 网络请求的状态码
struct StatusCode {
    /// 成功
    static let c200 = 200
    /// 请求错误
    static let c400 = 400
    /// 未鉴权认证
    static let c401 = 401
    /// 5XX
    static let c500 = 500    
}


class RequestHandler: NSObject {
    
    
    /// 获取验证码
    static func smsSendVerifyCode(phone: String, type: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        RequestAPI.smsSendVerifyCode(phone: phone, type: type, name: "君和社区") { (status, object) in
            swiftDebug("获取验证码:: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取验证码: ", object as Any)
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
                swiftDebug("获取验证码 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.smsSendVerifyCode(phone: phone, type: type, successCallback: successCallback, failedCallback: failedCallback)
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

    //MARK: - 用户API
    /// 获取用户相关的项目列表
    static func projectUserList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        RequestAPI.projectUserList { status, object in
            swiftDebug("获取用户相关的项目列表", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取用户相关的项目列表 成功")
                if object == nil {
                    successCallback?("")
                    return
                }
                guard let resArr: [[String: Any]] = object as? [[String : Any]] else {
                    swiftDebug("获取用户相关项目列表 返回数据不为数组")
                    return
                }

                guard let data = try? ModelDecoder.decode(ProjectUser.self, array: resArr) else {
                    swiftDebug("获取用户相关的项目列表 解析数据失败")
                    return
                }
                swiftDebug("获取项目列表:: ", data)
                // 删除
                ProjectUser.deleteAll()
                // 数据存进数据库
                ProjectUser.insert(projectUsers: [ProjectUser(code: "0000", name: "默认小区", selected: false)])
                ProjectUser.insert(projectUsers: data)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("获取用户相关的项目列表 错误")
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.projectUserList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default: // 其他
                swiftDebug("获取用户相关的项目列表 其他情况")
                break
            }
        }
    }

    //MARK: - 网关代理请求
    /// 网关代理请求
    static func iotGatewayProxy(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        // 判断空间是否为空
        if let accountInfo = AccountInfo.queryNow(), let spaceId = accountInfo.spaceID {
            swiftDebug("选择当前空间", spaceId)
            // 发送固定家庭ID数据
            self.iotGatewayProxy(spaceId: spaceId, data: data) { (success) in
                successCallback!(success)
            } failedCallback: { (failed) in
                failedCallback!(failed)
            }
        } else {
            swiftDebug("当前设备ID")
            // 发送数据
            WebSocketTool.share.sendData(sendMag: data) { object, error in
                swiftDebug("返回数据内容:: ", object as Any, error as Any)
            }
        }
        
    }

    /// 根据空间ID发送数据
    static func iotGatewayProxy(spaceId: String, data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        RequestAPI.iotGatewayProxy(spaceId: spaceId, data: data) { (status, object) in
            
            if object is Error {
                swiftDebug("网关代理请求 数据错误")
                failedCallback?("")
                return
            }
            swiftDebug("网关代理请求 返回内容: ", status as Any, object as Any)
            if status == 0 {
                failedCallback?("请检查网络")
                return
            }
            switch status {
            case StatusCode.c200: // 成功
                //swiftDebug("网关代理请求 : ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                                
                guard object != nil, let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败", object as Any)
                    failedCallback?("")
                    return
                }
                if let jsonDic = object as? [String: Any],  let result: String = jsonDic["result"] as? String, result != "success" {
                    // 状态码不成功
                    failedCallback?(result)
                    successCallback?(jsonStr)
                    return
                }
                
                if let accountInfo = AccountInfo.queryNow(), let spaceId = accountInfo.spaceID, spaceId != "" {
                    // 当前请求的ID和当前房间ID一致时 处理返回数据内容 更新数据库
                    // 解析返回的数据 分消息类型处理
                    ProtocolHandler.jsonStrData(jsonDic: object as! [String : Any])
                }
                // 传回给weex
                successCallback?(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("网关代理请求 请求错误", object as Any)
//                guard object != nil, let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
//                    swiftDebug("转换字符串失败", object as Any)
//                    failedCallback?("")
//                    return
//                }
//                failedCallback?(jsonStr)
                
                guard let object: [String: Any] = object as? [String: Any], let failedRes = try? ModelDecoder.decode(FailedContentRes.self, param: object) else {
                    swiftDebug("转换model失败")
                    failedCallback?("")
                    return
                }
                failedCallback?(failedRes.message)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotGatewayProxy(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                if object == nil {
                    ProgressHUD.showText("请求错误")
                    return
                }
                guard let object: [String: Any] = object as? [String: Any], let failedRes = try? ModelDecoder.decode(FailedContentRes.self, param: object) else {
                    swiftDebug("转换model失败")
                    failedCallback?("")
                    return
                }
                failedCallback?(failedRes.message)
                
//                guard object != nil, let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
//                    swiftDebug("转换字符串失败", object as Any)
//                    failedCallback?("")
//                    return
//                }
//                failedCallback?(jsonStr)
                break
            }
        }
    }

    //MARK: 根据设备的GID获取设备类型信息
    /// 根据GID获取产品信息
    static func iotProductInfo(gid: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        RequestAPI.iotProductInfo(gid: gid) { (status, object) in
            swiftDebug("根据GID获取产品信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("根据GID获取产品信息 : ", object as Any)
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
                swiftDebug("根据GID获取产品信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotProductInfo(gid: gid, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("根据GID获取产品信息 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 请求新云端Weex版本信息
    static func weexGemvaryVersion(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        WeexFileAPI.weexGemvaryVersion { (status, object) in
            swiftDebug("请求Weex版本信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("请求Weex版本信息 : ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                successCallback!(object as? String)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("请求Weex版本信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.weexGemvaryVersion(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("请求Weex版本信息 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 下载新云端weex的zip包
    static func weexGemvaryZip(version: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        WeexFileAPI.weexGemvaryZip(version: version) { (status, object) in
            swiftDebug("下载weex的zip包到本地 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("下载weex的zip包到本地 : ", object as Any)
                successCallback!("")
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("下载weex的zip包到本地 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.weexGemvaryZip(version: version, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("下载weex的zip包到本地 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 海贝斯设备猫眼信息
    static func amazonGetObjByDevId(deviceId: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        RequestAPI.amazonGetObjByDevId(deviceId: deviceId) { (status, object) in
            swiftDebug("海贝斯猫眼设备的云消息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("海贝斯猫眼设备的云消息 : ", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("海贝斯猫眼设备的云消息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    //self.weexKinlongZip(version: version, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("海贝斯猫眼设备的云消息 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 批量删除(清空)消息记录
    static func amazonDeleteBatch(deviceIds: [String], successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        RequestAPI.amazonDeleteBatch(deviceIds: deviceIds) { (status, object) in
            swiftDebug("批量删除(清空)消息记录 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("批量删除(清空)消息记录 : ", object as Any)
                successCallback!("")
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("批量删除(清空)消息记录 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                //NewUserTokenLogin.loginWithToken {
                    //self.weexKinlongZip(version: version, successCallback: successCallback, failedCallback: failedCallback)
                //}
                break
            default:
                swiftDebug("批量删除(清空)消息记录 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 坚朗之家 请求ipa包的版本
    static func kinlongIOSVersion(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        WeexFileAPI.kinlongIOSVersion { (status, object) in
            swiftDebug("请求APP_IPA版本信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("请求APP_IPA版本信息 : ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                successCallback!(object as? String)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("请求APP_IPA版本信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.kinlongIOSVersion(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("请求APP_IPA版本信息 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 天气请求接口2
    static func iotWeatherV2(province: String, city: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        RequestAPI.iotWeatherV2(provinceName: province, cityName: city) { status, object in
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("天气请求接口2 : ", object as Any)
                if object == nil {
                    successCallback?("")
                    return
                }
                
                guard let string = JSONTool.translationObjToJson(from: object as Any) else {
                    successCallback?("转换JSON字符串失败")
                    return
                }
                successCallback!(string)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("天气请求接口2 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotWeatherV2(province: province, city: city, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("天气请求接口2 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 获取用户相关房间列表
    static func projectUserRooms(zoneCode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        RequestAPI.projectUserRooms(zoneCode: zoneCode) { status, object in
            swiftDebug("获取用户相关房间列表:: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取验证码: ", object as Any)
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
                swiftDebug("获取用户相关房间列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.projectUserRooms(zoneCode: zoneCode, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取用户相关房间列表 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 查询已分享的设备列表
    static func iotSpaceIdSharedDeviceList(spaceId: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        RequestAPI.iotSpaceIdSharedDeviceList(spaceId: spaceId) { status, object in
            swiftDebug("查询已分享的设备列表:: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("查询已分享的设备列表: ", object as Any)
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
                swiftDebug("查询已分享的设备列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotSpaceIdSharedDeviceList(spaceId: spaceId, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("查询已分享的设备列表 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 根据设备参数获取产品信息
    static func iotProductInfoList(brand: String, classType: String, gatewayType: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        RequestAPI.iotProductInfoList(brand: brand, classType: classType, gatewayType: gatewayType) { status, object in
            swiftDebug("根据设备参数获取产品信息:: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("根据设备参数获取产品信息: ", object as Any)
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
                swiftDebug("根据设备参数获取产品信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotProductInfoList(brand: brand, classType: classType, gatewayType: gatewayType, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("根据设备参数获取产品信息 其他情况")
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

//MARK: 请求错误失败码
/// 请求失败的结果处理
struct FailedContentRes: Codable {
    /// 失败状态码
    var code: Int?
    /// 失败的信息
    var message: String?
}
