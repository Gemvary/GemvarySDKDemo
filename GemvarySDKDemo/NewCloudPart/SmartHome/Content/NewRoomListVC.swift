//
//  NewRoomListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/18.
//

import UIKit
import SnapKit

/// 新云端 房间列表
class NewRoomListVC: UIViewController {

    private let cellID: String = "NewRoomListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [Room] = [Room]() {
        didSet {
            self.tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "房间列表"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        self.dataList = Room.queryAll()
    }
    
}


extension NewRoomListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let room = self.dataList[indexPath.row]
        if let room_name = room.room_name {
            cell.textLabel?.text = "\(room_name)"
        } else {
            cell.textLabel?.text = "房间名字不存在"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let room = self.dataList[indexPath.row]
        
        let newNodeDeviceVC = NewNodeDeviceVC()
        newNodeDeviceVC.room_name = room.room_name
        self.navigationController?.pushViewController(newNodeDeviceVC, animated: true)        
    }
    
}
