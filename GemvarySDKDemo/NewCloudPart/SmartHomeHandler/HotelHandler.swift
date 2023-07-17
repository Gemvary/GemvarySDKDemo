//
//  HotelHandler.swift
//  Gem_Home
//
//  Created by SongMengLong on 2023/4/7.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

/// 酒店接口处理
class HotelHandler: NSObject {

    /// 获取酒店项目列表
    static func engHotelList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.engHotelList(callBack: { (status, object) in
            swiftDebug("获取酒店项目列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取酒店项目列表 : ", object as Any)
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
                swiftDebug("获取酒店项目列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.engHotelList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取酒店项目列表 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        })
    }
    
    /// 获取指定酒店房屋组织结构
    static func engHotelUnitTree(hotelCode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.engHotelUnitTree(hotelCode: hotelCode, callBack: { (status, object) in
            swiftDebug("获取指定酒店房屋组织结构 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取指定酒店房屋组织结构 : ", object as Any)
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
                swiftDebug("获取指定酒店房屋组织结构 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.engHotelUnitTree(hotelCode: hotelCode, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取指定酒店房屋组织结构 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        })
    }
    
    /// 获取社区项目列表
    static func engZoneList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.engZoneList(callBack: { (status, object) in
            swiftDebug("获取指定酒店房屋组织结构 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取指定酒店房屋组织结构 : ", object as Any)
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
                swiftDebug("获取指定酒店房屋组织结构 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.engZoneList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取指定酒店房屋组织结构 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        })
    }
    
    /// 获取指定项目房屋组织结构
    static func engZoneUnitTree(zoneCode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.engZoneUnitTree(zoneCode: zoneCode, callBack: { (status, object) in
            swiftDebug("获取指定项目房屋组织结构 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取指定项目房屋组织结构 : ", object as Any)
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
                swiftDebug("获取指定项目房屋组织结构 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.engZoneUnitTree(zoneCode: zoneCode, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取指定项目房屋组织结构 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        })
    }
    
    
    /// 酒店列表
    @available(*, deprecated, message: "接口废弃")
    static func hotelList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.hotelList { (status, object) in
            swiftDebug("酒店列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("酒店列表 : ", object as Any)
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
                swiftDebug("酒店列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.hotelList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("酒店列表 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }        
    }
    
    /// 酒店房间列表
    @available(*, deprecated, message: "接口废弃")
    static func hotelUnitTree(hotelCode: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.hotelUnitTree(hotelCode: hotelCode) { (status, object) in
            swiftDebug("酒店房间列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("酒店房间列表 : ", object as Any)
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
                swiftDebug("酒店房间列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.hotelUnitTree(hotelCode: hotelCode, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("酒店房间列表 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 酒店绑定设备
    static func smartBindSkillDevice(plat: String, devCode: String, type: Int, devSn: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.smartBindSkillDevice(plat: plat, devCode: devCode, type: type, devSn: devSn) { (status, object) in
            swiftDebug("酒店绑定设备 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("酒店绑定设备 : ", object as Any)
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
                swiftDebug("酒店绑定设备 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.smartBindSkillDevice(plat: plat, devCode: devCode, type: type, devSn: devSn, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("酒店绑定设备 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 酒店设备详情
    static func smartSkillDevice(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.smartSkillDevice { (status, object) in
            swiftDebug("酒店设备详情 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("酒店设备详情 : ", object as Any)
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
                swiftDebug("酒店设备详情 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.smartSkillDevice(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("酒店设备详情 其他情况")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }
    
    /// 酒店解绑设备
    static func smartUnbindSkillDevice(type: Int, devId: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        HotelAPI.smartUnbindSkillDevice(type: type, devId: devId) { (status, object) in
            swiftDebug("酒店解绑设备 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("酒店解绑设备 : ", object as Any)
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
                swiftDebug("酒店解绑设备 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.smartUnbindSkillDevice(type: type, devId: devId, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("酒店解绑设备 其他情况")
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
