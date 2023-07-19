//
//  NewNodeDeviceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/28.
//

import UIKit
import SnapKit
import GemvaryCommonSDK

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
    
    /// 节点设备列表
    private var dataList: [Device] = [Device]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    /// 房间名字
    var room_name: String? = String()
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let room_name = self.room_name, room_name != "" {
            self.title = room_name
            self.dataList = Device.query(room_name: room_name)
        } else {
            self.title = "所有设备"
            self.dataList = Device.queryAll() // 查询所有设备
        }
        
        if self.dataList.count == 0 {
            ProgressHUD.showText("当前设备个数为0")
        }
    }    
}


extension NewNodeDeviceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let device = self.dataList[indexPath.row]
        if let dev_name = device.dev_name, let room_name = device.room_name {
            cell.textLabel?.text = "\(room_name) \(dev_name)"
        } else {
            cell.textLabel?.text = "未知设备???"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = self.dataList[indexPath.row]
        
        let newDeviceContentVC = NewDeviceContentVC()
        newDeviceContentVC.hidesBottomBarWhenPushed = true
        newDeviceContentVC.device = device // 设备信息赋值
        self.navigationController?.pushViewController(newDeviceContentVC, animated: true)
    }
}
