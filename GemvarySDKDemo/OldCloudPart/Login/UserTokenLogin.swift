//
//  UserTokenLogin.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/24.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

/// 免登录方法类
class UserTokenLogin: NSObject {
    
    @objc static var zoneCode: String = String()
    @objc static var tokenauth: String = String()
    @objc static var tokencode: String = String()
    
    /// 使用免登录 返回回调 重复请求该方法
    @objc static func loginWithToken(callBack: @escaping (Bool) -> Void) -> Void {
        
        // 判断选中小区是否为空
//        guard let zone: Zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
//            debugPrint("选中小区信息为空")
//            return
//        }
        // 判断账号的tokenauth tokencode是否为空
//        guard let accountInfo = AccountInfo.queryNow(), let tokenauth = accountInfo.tokenauth, let tokencode = accountInfo.tokencode else {
//            debugPrint("当前用户信息为空")
//            return
//        }
        
        // (免)无验证码登录
        PhoneWorkAPI.phoneTokenLogin(zoneCode: self.zoneCode, tokenauth: self.tokenauth, tokencode: self.tokencode) { (object) in
            // 判断返回数据是否为空
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            // 判断返回数据是否错误
            if object is Error {
                if let obj = object as? Error {
                    let description = obj.localizedDescription
                    debugPrint("请求免登录 报错: \(description)")
                    return
                }
            }
            // 解析返回数据内容 转model
            guard let res = try? ModelDecoder.decode(PhoneTokenLoginRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneTokenLoginRes 转换Model失败")
                return
            }
            debugPrint("免登录的结果", res)
            // 判断返回数据状态码
            switch res.code {
            case 200: // 登录成功 返回免登录成功 然后递归之前请求
                callBack(true)
                break
            case 553: // 免登录失败 重新登录
                self.repeatLogin(title: "免登录验证已过期，请重新登录")
                break
            case 554: // 账号已过有效期 请重新登录
                self.repeatLogin(title: "账号已过有效期，请重新授权")
                break
            default:
                break
            }
        }
    }
    
    /// 免登录失败 重新登录授权
    @objc static func repeatLogin(title: String) -> Void {
        /// 弹出提示框
        let alertVC = UIAlertController(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString(title, comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        if title == NSLocalizedString("确定要退出帐号?", comment: "") {
            // 当点击退出登录时 增加取消按钮
            alertVC.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: UIAlertAction.Style.cancel, handler: { (action) in

            }))
        }
        // 确认按钮
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: UIAlertAction.Style.destructive, handler: { (action) in
            // 跳转到登录页面
            self.gotoLoginVC()
        }))
        
        UIApplication.shared.keyWindow!.rootViewController!.present(alertVC, animated: true, completion: nil)
    }
    
    /// 跳转到登录界面
    static func gotoLoginVC() -> Void {
        let loginVC: LoginVC = LoginVC()
        let loginNavi = UINavigationController(rootViewController: loginVC)
        // 跳转到登录页面
        UIApplication.shared.keyWindow?.rootViewController = loginNavi
        // 数据库清除
        Zone.deleteAll()
        
    }
    
    //MARK: 账户退出登录
    static func logoutAccount() -> Void {
        // 退出登录
        PhoneWorkAPI.phoneLogout { (object) in
            // 判断返回数据是否为空
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            // 判断返回数据是否错误
            if object is Error {
                if let obj = object as? Error {
                    let description = obj.localizedDescription
                    debugPrint("退出登录 报错: \(description)")
                    return
                }
            }
            // 解析返回数据内容
            guard let res = try? ModelDecoder.decode(PhoneLogoutRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneLogoutRes 转换Model失败")
                return
            }
            // 判断返回数据状态码
            switch res.code {
            case 200: // 成功
                break
            case 400: // 失败
                break
            case 552: // 免登录
                UserTokenLogin.loginWithToken { (result) in
                    self.logoutAccount()
                }
                break
            default:
                break
            }
        }
    }
    
    
}

/// 退出登录返回数据
struct PhoneLogoutRes: Codable {
    /// 验证码
    var code: Int?
    /// 返回信息
    var message: String?
}
