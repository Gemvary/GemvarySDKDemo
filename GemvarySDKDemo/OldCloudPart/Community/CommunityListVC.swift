//
//  CommunityListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import UIKit

/// 社区功能列表
class CommunityListVC: UIViewController {

    let cellID = "CommunityCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [String] = ["钥匙包", "通知", "邀请函", "管家服务"] // "新云对讲"
            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "社区功能"

        self.view.addSubview(self.tableView)
    }

}


extension CommunityListVC: UITableViewDelegate, UITableViewDataSource {
    
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
        let name = self.dataList[indexPath.row]
        switch name {
        case "钥匙包":
            let keyBagListVC = KeyBagListVC()
            keyBagListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(keyBagListVC, animated: true)
            break
        case "通知":
            let noticeListVC = NoticeListVC()
            noticeListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(noticeListVC, animated: true)
            break
        case "邀请函":
            let invitationListVC = InvitationListVC()
            invitationListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(invitationListVC, animated: true)
            break
        case "新云对讲":
            
            break
        case "管家服务":
            let butlerServiceVC = ButlerServiceVC()
            butlerServiceVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(butlerServiceVC, animated: true)
            break
        default:
            break
        }
    }
}
