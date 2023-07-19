//
//  NewProductListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/14.
//

import UIKit
import SnapKit

/// 新云端产品类型列表
class NewProductListVC: UIViewController {

    private let cellID: String = "NewProductListCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewProductCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [DeviceClass] = [DeviceClass]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "产品类型"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.dataList = DeviceClass.queryAll()
    }
    
}

extension NewProductListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewProductCell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! NewProductCell
        let deviceClass = self.dataList[indexPath.row]
        cell.deviceClass = deviceClass
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let deviceClass = self.dataList[indexPath.row]
                
        swiftDebug("设备类型数据: ", deviceClass)
        let newAddDeviceVC = NewAddDeviceVC()
        newAddDeviceVC.hidesBottomBarWhenPushed = true
        newAddDeviceVC.deviceClass = deviceClass
        self.navigationController?.pushViewController(newAddDeviceVC, animated: true)        
    }
}


class NewProductCell: UITableViewCell {
    
        
    /**
     (id: nil, gateway_type: Optional("zigbee"), dev_class_type: Optional("gem_cube"), dev_class_name: Optional("M6组合面板"), dev_class_name_en: nil, dev_class_name_tw: nil, dev_brand: nil, brand_str: nil, dev_describe: Optional("第一个按键连续按下4次，第5次是长按8S，直到灯光闪烁松开(如果上电超过10分钟，需连续操作两次)"), dev_describe_en: nil, dev_describe_tw: nil, dev_uptype: Optional(1), brand: nil, riu_id: nil)
     
     */
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var typeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var gatewayTypeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var describeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var deviceClass: DeviceClass = DeviceClass() {
        didSet {
            if let dev_class_name = self.deviceClass.dev_class_name {
                self.nameLabel.text = "类型名字:\(dev_class_name)"
            }
            if let dev_class_type = self.deviceClass.dev_class_type {
                self.typeLabel.text = "类型:\(dev_class_type)"
            }
            if let gateway_type = self.deviceClass.gateway_type {
                self.gatewayTypeLabel.text = "网关类型:\(gateway_type)"
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.typeLabel)
        self.contentView.addSubview(self.gatewayTypeLabel)
        
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        self.typeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.nameLabel.snp.bottom)
        }
        self.gatewayTypeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.typeLabel.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
