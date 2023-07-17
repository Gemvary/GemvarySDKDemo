//
//  OrgUnitHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/28.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

//MARK: 组织结构请求的处理
/// 组织结构请求的处理
class OrgUnitHandler: NSObject {
    
    /// 添加组织
    static func iotOrgUnitAdd(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitAdd(data: data) { (status, object) in
            swiftDebug("添加组织 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("添加组织 : ", object as Any)
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
                swiftDebug("添加组织 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitAdd(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("添加组织 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 添加组织及成员
    static func iotOrgUnitAddAndStaffs(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitAddAndStaffs(data: data) { (status, object) in
            swiftDebug("添加组织及成员 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("添加组织及成员 : ", object as Any)
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
                swiftDebug("添加组织及成员 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitAddAndStaffs(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("添加组织及成员 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 更新组织信息
    static func iotOrgUnitUpdate(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitUpdate(data: data) { (status, object) in
            swiftDebug("更新组织信息 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("更新组织信息 : ", object as Any)
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
                swiftDebug("更新组织信息 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitUpdate(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("更新组织信息 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 删除组织
    static func iotOrgUnitDelete(id: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitDelete(id: id) { (status, object) in
            swiftDebug("删除组织 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("删除组织 : ", object as Any)
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
                swiftDebug("删除组织 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitDelete(id: id, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("删除组织 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取组织列表
    static func iotOrgUnitList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitList { (status, object) in
            swiftDebug("获取组织列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取组织列表 : ", object as Any)
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
                swiftDebug("获取组织列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取组织列表 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 批量添加组织成员
    static func iotOrgUnitStaffBatchAdd(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitStaffBatchAdd(data: data) { (status, object) in
            swiftDebug("批量添加组织成员 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("批量添加组织成员 : ", object as Any)
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
                swiftDebug("批量添加组织成员 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitStaffBatchAdd(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("批量添加组织成员 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 删除组织成员
    static func iotOrgUnitStaffDelete(id: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitStaffDelete(id: id) { (status, object) in
            swiftDebug("删除组织成员 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("删除组织成员 : ", object as Any)
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
                swiftDebug("删除组织成员 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitStaffDelete(id: id, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("删除组织成员 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取组织成员列表
    static func iotOrgUnitIdStaffList(id: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitIdStaffList(id: id) { (status, object) in
            swiftDebug("获取组织成员列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取组织成员列表 : ", object as Any)
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
                swiftDebug("获取组织成员列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitIdStaffList(id: id, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取组织成员列表 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 添加组织角色及权限
    static func iotOrgUnitRoleAdd(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitRoleAdd(data: data) { (status, object) in
            swiftDebug("添加组织角色及权限 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("添加组织角色及权限 : ", object as Any)
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
                swiftDebug("添加组织角色及权限 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitRoleAdd(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("添加组织角色及权限 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 更新组织角色及权限
    static func iotOrgUnitRoleUpdate(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitRoleUpdate(data: data) { (status, object) in
            swiftDebug("更新组织角色及权限 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("更新组织角色及权限 : ", object as Any)
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
                swiftDebug("更新组织角色及权限 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitRoleUpdate(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("更新组织角色及权限 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 删除组织角色及权限
    static func iotOrgUnitRoleDelete(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitRoleDelete(data: data) { (status, object) in
            swiftDebug("删除组织角色及权限 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("删除组织角色及权限 : ", object as Any)
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
                swiftDebug("删除组织角色及权限 请求错误", object as Any)
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
                    self.iotOrgUnitRoleDelete(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("删除组织角色及权限 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取组织角色列表
    static func iotOrgUnitOrgIdRoleList(orgId: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitOrgIdRoleList(orgId: orgId) { (status, object) in
            swiftDebug("获取组织角色列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取组织角色列表 : ", object as Any)
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
                swiftDebug("获取组织角色列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitOrgIdRoleList(orgId: orgId, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取组织角色列表 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取成员角色列表
    static func iotOrgUnitStaffRoleList(orgId: Int, account: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitStaffRoleList(orgId: orgId, account: account) { (status, object) in
            swiftDebug("获取成员角色列表 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取成员角色列表 : ", object as Any)
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
                swiftDebug("获取成员角色列表 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitStaffRoleList(orgId: orgId, account: account, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取成员角色列表 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }


    /// 授予成员角色
    static func iotOrgUnitStaffGrantRole(data: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitStaffGrantRole(data: data) { (status, object) in
            swiftDebug("授予成员角色 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("授予成员角色 : ", object as Any)
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
                swiftDebug("授予成员角色 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitStaffGrantRole(data: data, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("授予成员角色 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取组织角色相关的树形数据
    static func iotOrgUnitOrgIdRoletree(orgId: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitOrgIdRoletree(orgId: orgId) { (status, object) in
            swiftDebug("获取组织角色相关的树形数据 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取组织角色相关的树形数据 : ", object as Any)
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
                swiftDebug("获取组织角色相关的树形数据 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitOrgIdRoletree(orgId: orgId, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取组织角色相关的树形数据 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取组织角色树形数据
    static func iotOrgUnitOrgIdRoleRoleIdTree(orgId: Int, roleId: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitOrgIdRoleRoleIdTree(orgId: orgId, roleId: roleId) { (status, object) in
            swiftDebug("获取组织角色树形数据 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取组织角色树形数据 : ", object as Any)
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
                swiftDebug("获取组织角色树形数据 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitOrgIdRoleRoleIdTree(orgId: orgId, roleId: roleId, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取组织角色树形数据 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取当前组织下的设备分享给了那些用户
    static func iotOrgUnitOrgIdSharingDeviceUserList(orgId: Int, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitOrgIdSharingDeviceUserList(orgId: orgId) { (status, object) in
            swiftDebug("获取当前组织下的设备分享给了那些用户 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取当前组织下的设备分享给了那些用户 : ", object as Any)
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
                swiftDebug("获取当前组织下的设备分享给了那些用户 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitOrgIdSharingDeviceUserList(orgId: orgId, successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取当前组织下的设备分享给了那些用户 其他")
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            }
        }
    }

    /// 获取用户相关组织下的设备分享给了那些用户
    static func iotOrgUnitSharingDeviceUserList(successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        OrgUnitAPI.iotOrgUnitSharingDeviceUserList() { (status, object) in
            swiftDebug("获取用户相关组织下的设备分享给了那些用户 返回内容: ", status as Any, object as Any)
            switch status {
            case StatusCode.c200: // 成功
                swiftDebug("获取用户相关组织下的设备分享给了那些用户 : ", object as Any)
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
                swiftDebug("获取用户相关组织下的设备分享给了那些用户 请求错误", object as Any)
                guard let jsonStr = JSONTool.translationObjToJson(from: object as Any) else {
                    swiftDebug("转换字符串失败")
                    return
                }
                failedCallback?(jsonStr)
                break
            case StatusCode.c401: // 未鉴权认证
                NewUserTokenLogin.loginWithToken {
                    self.iotOrgUnitSharingDeviceUserList(successCallback: successCallback, failedCallback: failedCallback)
                }
                break
            default:
                swiftDebug("获取用户相关组织下的设备分享给了那些用户 其他")
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
