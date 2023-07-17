//
//  RoomListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/17.
//

import UIKit
import SnapKit

/// 房间列表
class RoomListVC: UIViewController {

    private let cellID = "RoomListCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var roomList: [Room] = [Room]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "房间列表"
        
        self.setupSubViews()
        
        self.roomList = Room.queryAll()
    }
    
}

extension RoomListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.roomList[indexPath.row].room_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let roomContentVC = RoomContentVC()
        roomContentVC.room = self.roomList[indexPath.row]
        self.navigationController?.pushViewController(roomContentVC, animated: true)
    }
}


extension RoomListVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
