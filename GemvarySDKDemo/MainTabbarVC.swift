//
//  MainTabbarVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/25.
//

import UIKit

class MainTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 登录智能家居
        SmartHomeLogin.connectHostDevice()
        
        // 社区
        let communityListNavi = UINavigationController(rootViewController: CommunityListVC())
        communityListNavi.tabBarItem = UITabBarItem(title: "社区功能", image: UIImage(named: "community_n"), selectedImage: UIImage(named: "community_n"))
        // 物业
        let propertyListVCNavi = UINavigationController(rootViewController: PropertyListVC())
        propertyListVCNavi.tabBarItem = UITabBarItem(title: "物业功能", image: UIImage(named: "community_n"), selectedImage: UIImage(named: "community_n"))
        // 智能家居
        let smartHomeNavi = UINavigationController(rootViewController: SmartHomeMainVC())
        smartHomeNavi.tabBarItem = UITabBarItem(title: "智能家居", image: UIImage(named: "community_n"), selectedImage: UIImage(named: "community_n"))
        // 用户中心
        let userCenterNavi = UINavigationController(rootViewController: UserCenterVC())
        userCenterNavi.tabBarItem = UITabBarItem(title: "用户中心", image: UIImage(named: "community_n"), selectedImage: UIImage(named: "community_n"))

                
        self.viewControllers = [communityListNavi, propertyListVCNavi, smartHomeNavi, userCenterNavi]
    }
    
}
