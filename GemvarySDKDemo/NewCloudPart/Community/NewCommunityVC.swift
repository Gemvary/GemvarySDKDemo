//
//  NewCommunityVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/19.
//

import UIKit
import SnapKit

class NewCommunityVC: UIViewController {

    private let cellID: String = "NewCommunityCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private let dataList: [String] = ["钥匙包", "管家服务", "邀请函", "退出登录"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "社区"
        
        self.setupSubViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewCommunityVC: UITableViewDelegate, UITableViewDataSource {
    
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
            let keyBagListVC = NewKeyBagListVC()
            keyBagListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(keyBagListVC, animated: true)
            break
        case "管家服务":
            let butlerServiceVC = NewButlerServiceVC()
            butlerServiceVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(butlerServiceVC, animated: true)
            break
        case "邀请函":
            let invitationListVC = NewInvitationListVC()
            invitationListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(invitationListVC, animated: true)
            break
        case "退出登录": // 跳转到登录页面
            self.gotoLoginVC()
            break
        default:
            break
        }
    }
}

extension NewCommunityVC {
    
    
    private func gotoLoginVC() -> Void {
        if let keyWindow = UIApplication.shared.keyWindow {
            // 清空token相关数据信息
            if var accountInfo = AccountInfo.queryNow() {
                accountInfo.access_token = nil
                accountInfo.tokenauth = nil
                AccountInfo.update(accountInfo: accountInfo)
            }
            keyWindow.rootViewController = UINavigationController(rootViewController: NewLoginAuthVC())
        }
    }
    
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
