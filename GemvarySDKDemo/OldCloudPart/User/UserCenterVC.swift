//
//  UserCenterVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/28.
//

import UIKit
import SnapKit

class UserCenterVC: UIViewController {

    private let cellID = "UserCenterCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
        
    private var dataList: [String] = ["小区列表", "退出",] { // "报警信息"
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "用户中心"
        
        self.setupSubViews()
    }
    
}

extension UserCenterVC: UITableViewDelegate, UITableViewDataSource {
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
        debugPrint("cell名字:: ", name)
        
        switch name {
        case "小区列表":
            self.gotoZoneListVC()
            break
        case "退出":
            self.gotoLoginVC()
            break
        default:
            break
        }
    }
}

extension UserCenterVC {
    
    private func gotoZoneListVC() -> Void {
        let zoneListVC = ZoneListVC()
        zoneListVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(zoneListVC, animated: true)
    }
    
    private func gotoLoginVC() -> Void {
        
        UserTokenLogin.repeatLogin(title: "确定要退出帐号?")
    }
    
}

extension UserCenterVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
