//
//  NewProductListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/14.
//

import UIKit
import SnapKit

/// 新云端产品类型列表
class NewProductListVC: UIViewController {

    private let cellID: String = "NewProductListCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [DeviceClass] = [DeviceClass]() {
        didSet {
            self.tableView.reloadData()
        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "产品类型"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.dataList = DeviceClass.queryAll()
    }
    
}

extension NewProductListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let deviceClass = self.dataList[indexPath.row]
        if let dev_class_name = deviceClass.dev_class_name {
            cell.textLabel?.text = "\(dev_class_name)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let newAddDeviceVC = NewAddDeviceVC()
        newAddDeviceVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newAddDeviceVC, animated: true)        
    }
}
