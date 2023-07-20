//
//  AppDelegate.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import UIKit
import GemvaryNetworkSDK
import GemvarySmartHomeSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        // 智慧社区 服务器地址
        CommunityNetParam.domain = "http://test.gemvary.net:9090"
        // 第三方使用SDK需要初始化参数
        CommunityNetParam.appId = "55deabd864df42afa4a779811f0a668c"
        CommunityNetParam.appSecret = "568f5ac2a827d161a12e1a052e5b6cc7"
        // 智能家居appID赋值
        SmartHomeManager.appId = "55deabd864df42afa4a779811f0a668c"
        // 新云端
        NewCloudNetParam.domain = "http://api.gemvary.tech:8443"
        NewCloudNetParam.appId = "ea7ed63ea8af41aa9d327def9061cd6d"
        NewCloudNetParam.appSecret = "8aab7b3b869208bb8a8b0dd9632ae630"
                                
        self.setupRootVC()
        
        return true
    }
   
    ///  设置根视图
    private func setupRootVC() -> Void {
        
//        if let accountInfo = AccountInfo.queryNow(), accountInfo.tokenauth != nil, accountInfo.tokencode != nil,
//           let zone = Zone.queryNow(), zone.zoneAddress != nil {
//
//            // 设置API的token
//            FetchApiToken.requestUserLogin()
//
//            let mainTabbarVC = MainTabbarVC()
//            self.window?.rootViewController = mainTabbarVC
//        } else {
//            let loginNavi = UINavigationController(rootViewController: LoginVC())
//            self.window?.rootViewController = loginNavi
//        }
        
        // 选择新旧服务器
        let cloudSelectVC = CloudSelectVC()
        self.window?.rootViewController = UINavigationController(rootViewController: cloudSelectVC)
    }
}


/// 新增通知名字
extension Notification.Name {
    ///  新设备上报
    public static let new_device_manager = Notification.Name(rawValue: "new_device_manager")
    /// 设备入网
    public static let device_join_control = Notification.Name(rawValue: "new_device_manager")
    
}
