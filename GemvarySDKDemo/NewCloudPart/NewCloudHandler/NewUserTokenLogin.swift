//
//  UserTokenLogin.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/6/4.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryNetworkSDK
import GemvaryToolSDK

/// 网络请求返回内容(基本返回内容)
struct NetWorkBaseRes: Codable {
    /// 操作状态返回码
    var code: Int?
    /// 返回信息
    var message: String?
}


/// 使用登录功能 新云端智能家居token刷新
class NewUserTokenLogin: NSObject {
    
    /// 使用免登录 返回回调 重复请求该方法
    @objc static func loginWithToken(callBack: @escaping () -> Void) -> Void {

        // 判断账号的tokenauth tokencode是否为空
        guard var accountInfo = AccountInfo.queryNow(), let refresh_token = accountInfo.refresh_token, refresh_token != "" else {
            swiftDebug("智能家居用户信息 刷新Token信息为空")
            return
        }

        // 刷新token
        RequestAPI.authRefreshToken(token: refresh_token) { (status, object) in
            swiftDebug("刷新Token:", status as Any, object as Any)
            // 判断状态码值
            switch status {
            case StatusCode.c200: // 成功
                guard object != nil, let res = try? ModelDecoder.decode(AuthLoginData.self, param: object as! [String : Any]) else {
                    swiftDebug("数据转换model失败")
                    self.repeatLogin(title: "Token失效 重新登录")
                    return
                }
                swiftDebug("请求成功返回内容: ", res)
                // 保存用户数据
                accountInfo.access_token = res.access_token
                accountInfo.expires_in = res.expires_in
                accountInfo.refresh_token = res.refresh_token
                accountInfo.refresh_expires_in = res.refresh_expires_in
                accountInfo.token_type = res.token_type
                // 更新数据库
                AccountInfo.update(accountInfo: accountInfo)
                if let access_token = res.access_token {
                    NewCloudNetParam.access_token = access_token
                }
                // 刷新websocket连接
                WebSocketHandler.setupWebSocket()

                callBack()
                break
            case StatusCode.c400: // 登录失败
                swiftDebug("刷新Token 请求错误: ", object as Any)
                self.repeatLogin(title: "登录失败 重新登录")
                break
            case StatusCode.c401: // 未鉴权认证
                swiftDebug("刷新Token 未鉴权认证")
                //self.repeatLogin(title: "Token失效 重新登录")
                self.repeatLogin(title: "Token失效 重新登录")
                break
            case StatusCode.c500:
                swiftDebug("服务器其他的错误", object as Any)
                self.repeatLogin(title: "Token失效 重新登录")
                break
            default:
                swiftDebug("刷新Token 其他情况")
                self.repeatLogin(title: "Token失效 重新登录")
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
    @objc static func gotoLoginVC() -> Void {
        swiftDebug("退出登录 跳转到登录页面")
        // 新的登陆界面
//        let userLoginVC: UserLoginVC = UserLoginVC()
//        let userLoginNavi = BaseCustomNavi(rootViewController: userLoginVC)
//        // 设置根视图
//        if let keyWindow = UIApplication.shared.keyWindow {
//            DispatchQueue.main.async {
//                keyWindow.rootViewController = userLoginNavi
//            }
//        }
//        // token清空
//        NewCloudNetParam.access_token = ""
//        // 清空小区数据库
//        Zone.deleteAll()
//
//        // 断开websocket连接
//        SmartHomeHandler.disconnet()
        
        // 信鸽推送停止服务
//        PushServiceTool.share.stopPush()
        // 更新账户数据库
//        if var accountInfo = AccountInfo.queryNow() {
//            // 清空token
//            accountInfo.access_token = nil
//            accountInfo.refresh_token = nil
//            AccountInfo.update(accountInfo: accountInfo)
//            // 停止推送
//            PushServiceTool.share.stopPush()
//
//            // 删除所有空间
//            //Space.deleteAll()
//            // 空间ID和设备码不清空，方便下次进入继续使用
//            //accountInfo.spaceID = nil
//            //accountInfo.dev_code = nil
//
//            // 清空智能家居数据表
//            SmartHomeDataBase.deleteTable()
//        }
        
        // 获取当前用户信息内容
//        if var accountInfo = AccountInfo.queryNow() {
//            swiftDebug("查询当前用户信息为空")
//            // 赋值数据
//            accountInfo.sipId = nil
//            accountInfo.sipPassword = nil
//            accountInfo.sipServer = nil
//            accountInfo.tokenauth = nil
//            accountInfo.tokencode = nil
//            accountInfo.userId = nil
//            accountInfo.ucsToken = nil
//            // 更新当前用户信息
//            AccountInfo.updateNow(userInfo: accountInfo)
//        }
        
    }    
}

