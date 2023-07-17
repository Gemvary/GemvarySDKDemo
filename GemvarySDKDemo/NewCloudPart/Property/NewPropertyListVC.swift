//
//  NewPropertyListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/20.
//

import UIKit
import SnapKit

class NewPropertyListVC: UIViewController {

    private let cellID = "NewPropertyListCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private let dataList: [String] = ["物业报修", "投诉建议", "物业缴费", "小区活动", "小区动态", "投票表决", "问卷调查"]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "物业"
        
        self.setupSubViews()
    }
    
}

extension NewPropertyListVC: UITableViewDelegate, UITableViewDataSource {
    
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
        case "物业报修":
            break
        case "投诉建议":
            break
        case "物业缴费":
            break
        case "小区活动":
            break
        case "小区动态":
            break
        case "投票表决":
            break
        case "问卷调查":
            break
        default:
            break
        }
        
        self.gotoPropertyVC()
    }
    
}

extension NewPropertyListVC {
    private func gotoPropertyVC() -> Void {
        let webViewVC = NewPropertyWebViewVC()
        webViewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
}

extension NewPropertyListVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
