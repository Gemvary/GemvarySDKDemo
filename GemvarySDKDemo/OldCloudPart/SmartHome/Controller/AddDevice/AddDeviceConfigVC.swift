//
//  AddDeviceConfigVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/10/11.
//

import UIKit
import SnapKit

/// 添加设备到房间页面
class AddDeviceConfigVC: UIViewController {

    private let cellID = "AddDeviceConfigCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加到房间"
        
        self.setupSubViews()
    }
    
}

extension AddDeviceConfigVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


extension AddDeviceConfigVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
