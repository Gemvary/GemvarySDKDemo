//
//  NewMianHomeVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/19.
//

import UIKit

/// 新云端Tabbar
class NewMianHomeVC: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 社区
        let newCommunityVC = NewCommunityVC()
        let newCommunityNavi = UINavigationController(rootViewController: newCommunityVC)
        newCommunityNavi.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named: "community_n"), selectedImage: UIImage(named: "community_s"))
                
        // 物业
        let newPropertyListVC = NewPropertyListVC()
        let newPropertyListNavi = UINavigationController(rootViewController: newPropertyListVC)
        newPropertyListNavi.tabBarItem = UITabBarItem(title: "物业", image: UIImage(named: "community_n"), selectedImage: UIImage(named: "community_s"))
        // 智能家居
        let newSmartHomeVC = NewSmartHomeVC()
        let newSmartHomeNavi = UINavigationController(rootViewController: newSmartHomeVC)
        newSmartHomeNavi.tabBarItem = UITabBarItem(title: "智能家居", image: UIImage(named: "smarthome_n"), selectedImage: UIImage(named: "smarthome_s"))
        
        // 新云端接口
        let newCloudAPITestVC = NewCloudAPITestVC()
        let newCloudAPITestNavi = UINavigationController(rootViewController: newCloudAPITestVC)
        newCloudAPITestNavi.tabBarItem = UITabBarItem(title: "新云端接口", image: UIImage(named: "person_n"), selectedImage: UIImage(named: "person_s"))
                
        self.viewControllers = [
            newCommunityNavi,
            //newPropertyListNavi,
            newSmartHomeNavi,
            newCloudAPITestNavi
        ]
        
        // WebSocket开始连接
        WebSocketHandler.setupWebSocket()   
        
    }
    

}
