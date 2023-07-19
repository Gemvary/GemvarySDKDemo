//
//  MassProdHandler.swift
//  KL_Home
//
//  Created by Gemvary Apple on 2021/1/28.
//  Copyright © 2021 gemvary. All rights reserved.
//

import UIKit
import GemvaryToolSDK
import GemvaryNetworkSDK

class MassProdHandler: NSObject {

    /// 注册设备
    static func massProdRegisterDevice(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        MassProdAPI.massProdRegisterDevice(data: data) { (status, object) in
            swiftDebug("注册设备 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("注册设备: ", object as Any)
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
                swiftDebug("注册设备 请求错误", object as Any)
                guard object != nil, let object: [String: Any] = object as? [String: Any], let failedRes = try? ModelDecoder.decode(FailedContentRes.self, param: object),
                        let message = failedRes.message else {
                    swiftDebug("转换model失败")
                    guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                        swiftDebug("转换字符串失败")
                        return
                    }
                    failedCallback?(jsonStr)
                    return
                }
                failedCallback?(message)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.massProdRegisterDevice(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("注册设备 其他情况")
                guard object != nil, let object: [String: Any] = object as? [String: Any], let failedRes = try? ModelDecoder.decode(FailedContentRes.self, param: object),
                        let message = failedRes.message else {
                    swiftDebug("转换model失败")
                    guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                        swiftDebug("转换字符串失败")
                        return
                    }
                    failedCallback?(jsonStr)
                    return
                }
                failedCallback?(message)
                break
            }
        }
    }
    
    /// 添加设备
    static func iotMassProdAddDevice(spaceId: String, devAddr: String, manufacturerId: String, productId: String, riu_id: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        // qualityInspector 该字段不用填
        MassProdAPI.iotMassProdAddDevice(spaceId: spaceId, devAddr: devAddr, manufacturerId: manufacturerId, productId: productId, qualityInspector: "", riu_id: riu_id) { (status, object) in
            swiftDebug("添加设备 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("添加设备: ", object as Any)
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
                swiftDebug("添加设备 请求错误", object as Any)
                guard object != nil, let object: [String: Any] = object as? [String: Any], let failedRes = try? ModelDecoder.decode(FailedContentRes.self, param: object),
                        let message = failedRes.message else {
                    swiftDebug("转换model失败")
                    guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                        swiftDebug("转换字符串失败")
                        return
                    }
                    failedCallback?(jsonStr)
                    return
                }
                failedCallback?(message)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotMassProdAddDevice(spaceId: spaceId, devAddr: devAddr, manufacturerId: manufacturerId, productId: productId, riu_id: riu_id, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("添加设备 其他情况")
                guard object != nil, let object: [String: Any] = object as? [String: Any], let failedRes = try? ModelDecoder.decode(FailedContentRes.self, param: object),
                        let message = failedRes.message else {
                    swiftDebug("转换model失败")
                    guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                        swiftDebug("转换字符串失败")
                        return
                    }
                    failedCallback?(jsonStr)
                    return
                }
                failedCallback?(message)
                break
            }
        }
    }
    
    
}
