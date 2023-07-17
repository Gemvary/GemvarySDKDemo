//
//  PropertyListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import UIKit

/// 物业功能列表
class PropertyListVC: UIViewController {
    
    private let cellID = "CommunityListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [String] = ["物业报修", "投诉建议", "物业缴费", "小区活动", "小区动态", "投票表决", "问卷调查"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "物业功能"
        
        self.view.addSubview(self.tableView)
        
        /*
         添加该功能时 需要让后台给账号添加DD的配置信息及房间信息
         */
        
        // 获取全局token
        DDServiceAPI.diandouAccessTokenRequest()
        
        // 获取房间信息
        DDServiceAPI.diandouCustomer()
    }
    
}

extension PropertyListVC: UITableViewDelegate, UITableViewDataSource {
    
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
        debugPrint("选择", self.dataList[indexPath.row])
        
        let name = self.dataList[indexPath.row]
        
        switch name {
        case "物业报修":
            DDServiceAPI.repair { urlStr in
                if urlStr == nil || urlStr == "" {
                    debugPrint("没有取到物业链接")
                } else {
                    if let urlStr = urlStr {
                        self.gotoDDServiceVC(urlStr: urlStr, isService: true)
                    }
                }
            }
            break
        case "投诉建议":
            DDServiceAPI.complaint(callback: { (urlStr) in
                if urlStr == nil || urlStr == "" {
                    debugPrint("暂无该功能权限")
                } else {
                    self.gotoDDServiceVC(urlStr: urlStr!, isService: true)
                }
            })
            break
        case "物业缴费":
            DDServiceAPI.pay(callback: { (urlStr) in
                DispatchQueue.main.async {
                    if urlStr == nil || urlStr == "" {
                        debugPrint("暂无该功能权限")
                    } else {
                        self.gotoDDServiceVC(urlStr: urlStr!, isService: false)
                    }
                }
            })
            break
        case "小区活动":
            DDServiceAPI.activity(callback: { (urlStr) in
                DispatchQueue.main.async {
                    if urlStr == nil || urlStr == "" {
                        debugPrint("暂无该功能权限")
                        return
                    }
                    self.gotoDDServiceVC(urlStr: urlStr!, isService: false)
                }
            })
            break
        case "小区动态":
            DDServiceAPI.dynamic(callback: { (urlStr) in
                DispatchQueue.main.async {
                    if urlStr == nil || urlStr == "" {
                        debugPrint("暂无该功能权限")
                        return
                    }
                    self.gotoDDServiceVC(urlStr: urlStr!, isService: false)
                }
            })
            break
        case "投票表决":
            DDServiceAPI.vote(callback: { (urlStr) in
                DispatchQueue.main.async {
                    if urlStr == nil || urlStr == "" {
                        debugPrint("暂无该功能权限")
                        return
                    }
                    self.gotoDDServiceVC(urlStr: urlStr!, isService: false)
                }
            })
            break
        case "问卷调查":
            DDServiceAPI.questionnaire(callback: { (urlStr) in
                DispatchQueue.main.async {
                    if urlStr == nil || urlStr == "" {
                        debugPrint("暂无该功能权限")
                        return
                    }
                    self.gotoDDServiceVC(urlStr: urlStr!, isService: false)
                }
            })
            break
        default:
            break
        }
        
    }
}


extension PropertyListVC {
        
    // 跳转到物业页面
    private func gotoDDServiceVC(urlStr: String, isService: Bool) -> Void {
        debugPrint("物业的链接::: ", urlStr)
        
        let serviceVC = DDServiceVC()
        serviceVC.urlStr = urlStr
         serviceVC.isService = isService // 默认没有服务记录按钮
        serviceVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(serviceVC, animated: true)
    }
}
