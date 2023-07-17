//
//  FetchApiToken.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/8/31.
//

import GemvaryNetworkSDK
import GemvarySmartHomeSDK
import GemvaryToolSDK
import GemvaryCommonSDK

struct CloudResCode {
    /// 成功
    static let c000000 = "000000"
    /// 通用失败
    static let c100000 = "100000"
    /// 萤石设备接口验证请求头失败
    static let c100001 = "100001"
    /// 超级碗接口验证请求头失败
    static let c100002 = "100002"
    /// WEB页面未登录
    static let c100003 = "100003"
    /// token过期
    static let c100004 = "100004"
}

class FetchApiToken: NSObject {
    
    /// 设置JHCloudWorkAPI的Token
    static func requestUserLogin(callback: ((Bool?) -> Void)? = nil) -> Void {
        // 判断当前的网络状态
//        guard RealReachability.sharedInstance()!.currentReachabilityStatus().rawValue > 0 else {
//            swiftDebug("用户登录 当前网络状态 没有网络")
//            return
//        }
        // 获取当前选中小区编码
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            swiftDebug("当前选中小区内容为空")
            return
        }
        
        // 判断当前账号是否为空
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        
        // SDK登录获取token
        CloudWorkAPI.userLogin(account: account, zone: zoneCode) { (object) in
            
            guard (object != nil) else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                //callback?(false)
                return
            }
            if let object = object as? Error {
                swiftDebug("用户登录 报错: \(object.localizedDescription)")
                // 弹出错误信息
                ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
                //callback?(false)
                return
            }
            
            guard let res = try? ModelDecoder.decode(UserLoginRes.self, param: object as! [String : Any]) else {
                swiftDebug("UserLoginRes 转换Model失败")
                return
            }
            
            swiftDebug("SDK登录获取的token \(res)")
            
            switch res.code {
            case NetResCode.c200: // 成功
                guard let data = res.data else {
                    swiftDebug("获取数据内容为空")
                    return
                }
                if let ablecloudToken = data.ablecloudToken {
                    swiftDebug("获取token消息 ", ablecloudToken)
                }
                if let tokenauth = data.tokenauth {
                    // 设置JHCloudWorkAPI的token
                    JHCloudWorkAPI.loginToken = tokenauth
                }
                callback?(true)
                break
            case NetResCode.c400: // 失败
                ProgressHUD.showText(NSLocalizedString(res.message!, comment: ""))
                break
            case NetResCode.c552: // 免登录失败
                UserTokenLogin.loginWithToken { (result) in
                    FetchApiToken.requestUserLogin()
                }
                break
            default:
                //callback?(false)
                break
            }
        }
    }
    
}

struct UserLoginRes: Codable {
    var code: Int?
    var data: UserLoginData?
    var message: String?
}

/// 用户登录数据内容
struct UserLoginData: Codable {
    /// AbleCloud Token
    var ablecloudToken: String?
    /// AbleCloud Uid
    var ablecloudUid: Int?
    /// 是否为主账号
    var isPrimary: Int?
    /// 登录token
    var tokenauth: String?
    /// token代码(用户账号)
    var tokencode: String?
    var userId: Int?
    var userStatus: Int?
    /// 小区编码
    var zoneCode: String?
}
