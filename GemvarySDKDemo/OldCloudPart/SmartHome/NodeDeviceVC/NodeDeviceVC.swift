//
//  NodeDeviceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/17.
//

import UIKit
import SnapKit

/// 节点设备的基类
class NodeDeviceVC: UIViewController {

    private let cellID = "NodeDeviceCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    /// 功能列表
    var funcList: [String] = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    /// 设备属性
    var device: Device = Device()        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSubViews()
    }
    
}

extension NodeDeviceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.funcList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.funcList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension NodeDeviceVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
