//
//  NewOwnerRoomListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/27.
//

import UIKit

class NewOwnerRoomListVC: UIViewController {

    
    private let cellID = "OwnerRoomListCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewOwnerRoomListCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    /// 房间列表
    var ownerRooms: [OwnerRoom] = [OwnerRoom]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择房间"
        self.setupSubViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewOwnerRoomListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ownerRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewOwnerRoomListCell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! NewOwnerRoomListCell
        cell.ownerRoom = self.ownerRooms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 选中当前房间
        let ownerRoom = self.ownerRooms[indexPath.row]
        // 设置选中房间数据
        OwnerRoom.updateSelected(ownerRoom: ownerRoom)
        swiftDebug("查询当前所有房间: ", OwnerRoom.queryAll())
        // 刷新token
//        UserTokenLogin.loginWithToken {
//            // 刷新token
//            swiftDebug("刷新重新登录token")
//            // 刷新点都获取房间信息
//        }
        
        // 跳转到主页面
        let mainTabbarVC = MainTabbarVC()
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.rootViewController = mainTabbarVC
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
}


extension NewOwnerRoomListVC {
    /// 设置子控件
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0),
        ])
    }
}

/// 用户房间列表的cell
class NewOwnerRoomListCell: UITableViewCell {
    /// 房间信息
    var ownerRoom: OwnerRoom = OwnerRoom() {
        didSet {
            
            var floorNo = ""
            if let floorNoTemp = self.ownerRoom.floorNo {
                floorNo = floorNoTemp
            }
            guard let unitName = self.ownerRoom.unitName, let roomno = self.ownerRoom.roomno else {
                swiftDebug("房间信息为空")
                return
            }
            self.textLabel?.text = "\(unitName) \(floorNo) \(roomno)"
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

