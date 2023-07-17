//
//  SmartHomeSetupVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import UIKit
import SnapKit

/// 智能家居设置功能页面
class SmartHomeSetupVC: UIViewController {

    private let cellID = "SmartHomeSetupCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
        
    private let dataList: [String] = ["网络主机列表", "局域网设备列表", "节点设备类型", "场景列表", "联动列表"]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "智能家居设置"
        
        self.setupSubViews()
    }
    
}

extension SmartHomeSetupVC: UITableViewDelegate, UITableViewDataSource {
    
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
        case "网络主机列表":
            let hostDeviceListVC = HostDeviceListVC()
            self.navigationController?.pushViewController(hostDeviceListVC, animated: true)
            break
        case "局域网设备列表":
            let lanDeviceListVC = LanDeviceListVC()
            self.navigationController?.pushViewController(lanDeviceListVC, animated: true)
            break
        case "节点设备类型":
            let deviceClassInfoListVC = DeviceClassInfoListVC()
            self.navigationController?.pushViewController(deviceClassInfoListVC, animated: true)
            break
        case "场景列表":
            let sceneListVC = SceneListVC()
            self.navigationController?.pushViewController(sceneListVC, animated: true)
            break
        case "联动列表":
            let smartLinkageListVC = SmartLinkageListVC()
            self.navigationController?.pushViewController(smartLinkageListVC, animated: true)
            break
        default:
            break
        }
    }
}

extension SmartHomeSetupVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
