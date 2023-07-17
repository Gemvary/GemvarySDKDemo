//
//  DeviceClassInfoListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import UIKit
import SnapKit

/// 设备类型
class DeviceClassInfoListVC: UIViewController {
    
    private let cellID = "DeviceClassInfoListCell"
    /// 集合view
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/3.0, height: UIScreen.main.bounds.width/3.0) //320.0/3
        // 设置最小间距
        flowLayout.minimumLineSpacing = 0
        // 设置中间间距
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
        collectionView.register(SmartHomeSetupCell.self, forCellWithReuseIdentifier: self.cellID)
        return collectionView
    }()
        
    private var deviceClassList: [DeviceClass] = [DeviceClass]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设备类型信息"
        
        self.setupSubViews()
        
        self.deviceClassList = DeviceClass.queryAll()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "选择", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarButtonItemAction(_:)))
    }
    
    
    /// 弹出选择框
    @objc func rightBarButtonItemAction(_ button: UIBarButtonItem) -> Void {
        let alertVC = UIAlertController(title: "提示", message: "过滤不同类型", preferredStyle: UIAlertController.Style.actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "全部", style: UIAlertAction.Style.default, handler: { action in
            self.deviceClassList = DeviceClass.queryAll()
        }))
        
        alertVC.addAction(UIAlertAction(title: "绿米", style: UIAlertAction.Style.default, handler: { action in
            self.deviceClassList = DeviceClass.query(gatewayType: GatewayType.zigbee)
        }))
        
        alertVC.addAction(UIAlertAction(title: "顺舟", style: UIAlertAction.Style.default, handler: { action in
            self.deviceClassList = DeviceClass.query(gatewayType: GatewayType.shunzhou_zigbee)
        }))
        
        alertVC.addAction(UIAlertAction(title: "网络", style: UIAlertAction.Style.default, handler: { action in
            self.deviceClassList = DeviceClass.query(gatewayType: GatewayType.wifi_Module)
        }))
        
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
        
}

extension DeviceClassInfoListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.deviceClassList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SmartHomeSetupCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! SmartHomeSetupCell
        //cell.backgroundColor = UIColor.orange
        cell.deviceClass = self.deviceClassList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let addDeviceTipsVC = AddDeviceTipsVC()
        addDeviceTipsVC.deviceClass = self.deviceClassList[indexPath.row]
        self.navigationController?.pushViewController(addDeviceTipsVC, animated: true)
    }
    
}


extension DeviceClassInfoListVC {
    
    /// 设置子控件
    private func setupSubViews() -> Void {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


class SmartHomeSetupCell: UICollectionViewCell {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.orange
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    var deviceClass: DeviceClass = DeviceClass() {
        didSet {
            self.titleLabel.text = self.deviceClass.dev_class_name
            //self.contentLabel.text = self.deviceClass.brand
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubViews() -> Void {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.imageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: self.imageView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: self.imageView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: -5),
            NSLayoutConstraint(item: self.imageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.titleLabel, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0),
        ])
    }
    
}

/// 网关类型
class GatewayType: NSObject {
    /// 绿米zigbee
    static let zigbee = "zigbee"
    /// 顺舟
    static let shunzhou_zigbee = "shunzhou_zigbee"
    /// 网络类型
    static let wifi_Module = "wifi_Module"
    ///  君和485
    static let rs485_module = "rs485_module"
    /// xhy
    static let xhy_zigbee = "xhy_zigbee"
    /// 家云
    static let jiay_zigbee = "jiay_zigbee"
}

