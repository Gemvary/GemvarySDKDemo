//
//  OwnerRoomListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/25.
//

import UIKit
import SnapKit

class OwnerRoomListVC: UIViewController {

    private let cellID = "OwnerRoomListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    var dataList: [OwnerRoom] = [OwnerRoom]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "房间列表"
        
        self.setupSubViews()
    }
    
}

extension OwnerRoomListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.dataList[indexPath.row].roomno
        
        let ownerRoom = self.dataList[indexPath.row]
        var floorNo = ""
        if let floorNoTemp = ownerRoom.floorNo {
            floorNo = floorNoTemp
        }
        
        cell.textLabel?.text = "\(ownerRoom.unitName!) \(floorNo)  \(ownerRoom.roomno!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ownerRoom = self.dataList[indexPath.row]
        OwnerRoom.updateSelected(ownerRoom: ownerRoom)
        
        let mainTabbarVC = MainTabbarVC()
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.rootViewController = mainTabbarVC
        }        
    }
}

extension OwnerRoomListVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
