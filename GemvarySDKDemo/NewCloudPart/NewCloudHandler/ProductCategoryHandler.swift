//
//  ProductCategoryHandler.swift
//  KL_Home
//
//  Created by Gemvary Apple on 2021/8/23.
//  Copyright © 2021 gemvary. All rights reserved.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK

/// 获取产品类型信息
class ProductCategoryHandler: NSObject {

    /// 获取产品分类列表
    static func iotProductCategoryList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        ProductCategoryAPI.iotProductCategoryList { (status, object) in
            swiftDebug("获取产品分类列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取产品分类列表 : ", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    successCallback!("")
                    return
                }
                successCallback?(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("获取产品分类列表 请求错误", object as Any)
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
                    self.iotProductCategoryList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取产品分类列表 其他")
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
    
    /// 根据父分类ID获取产品列表
    static func iotProductCategoryParentIdProduct(parentId: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        ProductCategoryAPI.iotProductCategoryParentIdProduct(parentId: parentId) { (status, object) in
            swiftDebug("根据父分类ID获取产品列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("根据父分类ID获取产品列表 : ", object as Any)
                if object == nil {
                    successCallback!("")
                    return
                }
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    successCallback!("")
                    return
                }
                successCallback!(jsonStr)
                break
            case StatusCode.c400: // 请求错误
                swiftDebug("根据父分类ID获取产品列表 请求错误", object as Any)
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
                    self.iotProductCategoryParentIdProduct(parentId: parentId, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("根据父分类ID获取产品列表 其他")
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
