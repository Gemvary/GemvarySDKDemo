//
//  NewNodeDeviceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/28.
//

import UIKit
import SnapKit

/// 新云端节点设备
class NewNodeDeviceVC: UIViewController {
    
    private let cellID = "NewNodeDeviceCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var devices: [Device] = [Device]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "节点子设备列表"
                
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 查询所有设备
        self.devices = Device.queryAll()
    }
    

}


extension NewNodeDeviceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let device = self.devices[indexPath.row]
        if let dev_name = device.dev_name, let room_name = device.room_name {
            cell.textLabel?.text = "\(room_name) \(dev_name)"
        } else {
            cell.textLabel?.text = "节点设备"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = self.devices[indexPath.row]
        
        let newDeviceContentVC = NewDeviceContentVC()
        newDeviceContentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newDeviceContentVC, animated: true)
    }
}
