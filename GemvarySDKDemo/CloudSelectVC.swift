//
//  CloudSelectVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/18.
//

import UIKit
import GemvaryNetworkSDK
import GemvarySmartHomeSDK
import SnapKit

/// 选择新旧云端 然后初始化参数
class CloudSelectVC: UIViewController {

    private let cellID: String = "CloudSelectCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [String] = [
        //"旧云端",
        "新云端",
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择不同版本服务器"
        
        self.setupSubViews()
    }
    
}

extension CloudSelectVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.dataList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let text = self.dataList[indexPath.row]
        
        switch text {
        case "旧云端": // 旧云端
            // 智慧社区 服务器地址
            CommunityNetParam.domain = "http://test.gemvary.net:9090"
            // 第三方使用SDK需要初始化参数
            CommunityNetParam.appId = "55deabd864df42afa4a779811f0a668c"
            CommunityNetParam.appSecret = "568f5ac2a827d161a12e1a052e5b6cc7"
            // 智能家居appID赋值
            SmartHomeManager.appId = "55deabd864df42afa4a779811f0a668c"
            
            self.gotoOldCloud()
            break
        case "新云端": // 新云端
            NewCloudNetParam.domain = "http://api.gemvary.tech:8443"
            NewCloudNetParam.appId = "ea7ed63ea8af41aa9d327def9061cd6d"
            NewCloudNetParam.appSecret = "8aab7b3b869208bb8a8b0dd9632ae630"
            
            self.gotoNewCloud()
            break
        default:
            break
        }
        
        
    }
        
}

extension CloudSelectVC {
    
    /// 跳转到旧云端内容
    private func gotoOldCloud() -> Void {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            swiftDebug("当前主窗口为空")
            return
        }
        
        if let accountInfo = AccountInfo.queryNow(), accountInfo.tokenauth != nil, accountInfo.tokencode != nil,
           let zone = Zone.queryNow(), zone.zoneAddress != nil {
            // 设置API的token
            FetchApiToken.requestUserLogin()
            let mainTabbarVC = MainTabbarVC()
            keyWindow.rootViewController = mainTabbarVC
        } else {
            let loginNavi = UINavigationController(rootViewController: LoginVC())
            keyWindow.rootViewController = loginNavi
        }
    }
    
    
    /// 跳转到新云端内容
    private func gotoNewCloud() -> Void {
        
        // 判断新云端的token或数据是否为空
        guard let keyWindow = UIApplication.shared.keyWindow else {
            swiftDebug("当前主窗口为空")
            return
        }
        
//        let newMianHomeVC = NewMianHomeVC()
//        keyWindow.rootViewController = newMianHomeVC
        
        if let accountInfo = AccountInfo.queryNow(), let access_token = accountInfo.access_token, access_token != ""
        // 小区信息不为空
        {
            // token不为空 新云端主页面
            if let zone = Zone.queryNow(), let zoneCode = zone.zoneCode {
                // 非工程模式，酒店模式，有小区选择
                swiftDebug("新云端", zone)
                ScsPhoneWorkAPI.zoneCode = zoneCode
            }
            
            // 设置token
            SmartSDKHandler.setupAccessToken(access_token: access_token)
            
            let newMianHomeVC = NewMianHomeVC()
            keyWindow.rootViewController = newMianHomeVC
        } else {
            // 清空小区数据
            Zone.deleteAll()
            // 跳转到登录页面
            let newLoginAuthVC = NewLoginAuthVC()
            keyWindow.rootViewController = UINavigationController(rootViewController: newLoginAuthVC)
        }
    }
    
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
