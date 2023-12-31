//
//  NewProductListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/14.
//

import UIKit
import SnapKit
import GemvaryToolSDK

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
        
        self.dataList = DeviceClass.query(gatewayType: GatewayType.zigbee)
        //swiftDebug("列表数据内容", ModelEncoder.encoder(toDictionaryArray: self.dataList) as Any)
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
    
    private var brandLabel: UILabel = {
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
            if let dev_brand = self.deviceClass.dev_brand {
                self.brandLabel.text = "品牌:\(dev_brand)"
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.typeLabel)
        self.contentView.addSubview(self.gatewayTypeLabel)
        self.contentView.addSubview(self.brandLabel)
        
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
        self.brandLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.gatewayTypeLabel.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
