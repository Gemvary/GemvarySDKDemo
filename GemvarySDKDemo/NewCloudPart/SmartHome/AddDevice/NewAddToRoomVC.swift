//
//  NewAddToRoomVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/20.
//

import UIKit
import SnapKit
import GemvaryToolSDK


class NewAddToRoomVC: UIViewController {

    private let cellID: String = "NewAddToRoomCell"
    private let footerID: String = "NewAddToRoomFooterView"
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.register(NewAddToRoomFooterView.self, forHeaderFooterViewReuseIdentifier: self.footerID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    var dataList: [Device] = [Device]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加设备到房间"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    


}

extension NewAddToRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerID) as! NewAddToRoomFooterView
        // 点击按钮
        
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


class NewAddToRoomFooterView: UITableViewHeaderFooterView {
    
    private var addButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("添加", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.backgroundColor = UIColor.gray
        return button
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.addButton)
        self.addButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().offset(10)
            make.horizontalEdges.equalToSuperview().offset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
}
