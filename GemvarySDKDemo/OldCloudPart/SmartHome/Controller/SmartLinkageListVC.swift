//
//  SmartLinkageListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import UIKit
import GemvarySmartHomeSDK
import SnapKit

class SmartLinkageListVC: UIViewController {

    private let cellID = "SmartLinkageListCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SmartLinkageListCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var smartLinkageList: [SmartLinkage] = [SmartLinkage]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "联动列表"
        
        self.setupSubViews()
        
        //self.smartLinkageList = SmartLinkage.que
        // 查询所有联动
        
    }
    

}

extension SmartLinkageListVC {
    
    /// 查询所有的联动
    private func querySmartLinkageRequest() -> Void {
        
        
        
        
        
    }
}


extension SmartLinkageListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.smartLinkageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SmartLinkageListCell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! SmartLinkageListCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension SmartLinkageListVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

class SmartLinkageListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubViews() -> Void {
        
    }
    
}


struct SmartLinkageManagerQuerySend: Codable {
    var msg_type: String? = MsgType.smart_linkage_manager
    var command: String? = Command.query
    var from_role: String? = FromRole.phone
    var from_account: String = "phone"
    var linkage_id: Int? = -1
}
