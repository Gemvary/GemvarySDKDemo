//
//  NewDeviceContentVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/14.
//

import UIKit

/// 设备内容
class NewDeviceContentVC: UIViewController {

    private let cellID: String = "NewDeviceContentCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
            
    private var dataList: [String] = [
        "设备详情"
    ]
    
    var device: Device = Device() {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设备详情"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


extension NewDeviceContentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let text = self.dataList[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let text = self.dataList[indexPath.row]
        switch text {
        case "设备详情":            
            let newDeviceDetailsVC = NewDeviceDetailsVC()
            newDeviceDetailsVC.device = self.device
            self.navigationController?.pushViewController(newDeviceDetailsVC, animated: true)
            break
        default:
            break
        }
    }
    
    
}
