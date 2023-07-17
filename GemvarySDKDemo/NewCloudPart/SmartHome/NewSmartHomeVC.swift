//
//  NewSmartHomeVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/19.
//

import UIKit
import SnapKit

class NewSmartHomeVC: UIViewController {

    private let cellID: String = "NewSmartHomeCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "智能家居"
        
        
        // 连接当前空间
        //WebSocketHandler.connectCurrentSpace()
        
        
        // 设置右边按钮添加设备
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(onRightBarButtonItem))

        self.setupSubViews()
    }
    
    private let dataList: [String] = [
        "空间列表",
        //"网络主机列表",
        //"局域网设备列表",
        "节点设备列表",
        "场景列表",
        "联动列表",
    ]
}

extension NewSmartHomeVC: UITableViewDelegate, UITableViewDataSource {
    
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
        case "空间列表":
            let newSpaceListVC = NewSpaceListVC()
            newSpaceListVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(newSpaceListVC, animated: true)
            break
        case "网络主机列表":
            let newHostDeviceVC = NewHostDeviceVC()
            newHostDeviceVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(newHostDeviceVC, animated: true)
            break
        case "局域网设备列表":
            let newLanDeviceVC = NewLanDeviceVC()
            newLanDeviceVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(newLanDeviceVC, animated: true)
            break
        case "节点设备列表":
            let newNodeDeviceVC = NewNodeDeviceVC()
            newNodeDeviceVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(newNodeDeviceVC, animated: true)
            break
        case "场景列表":
            break
        case "联动列表":
            break
        default:
            break
        }
    }
}

extension NewSmartHomeVC {
    
    /// 跳转到产品列表
    @objc private func onRightBarButtonItem() -> Void {
        let newProductListVC = NewProductListVC()
        newProductListVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newProductListVC, animated: true)
    }
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
