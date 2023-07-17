//
//  RoomContentVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/17.
//

import UIKit
import SnapKit

/// 房间内容页面
class RoomContentVC: UIViewController {

    private let cellID = "RoomContentCell"
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
        collectionView.register(RoomContentCell.self, forCellWithReuseIdentifier: self.cellID)
        return collectionView
    }()
    
    
    var room: Room = Room() {
        didSet {
           // 查询房间设备
            if let room_name = self.room.room_name {
                self.deviceList = Device.query(room_name: room_name)
            }
        }
    }
    
    private var deviceList: [Device] = [Device]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let room_name = self.room.room_name {
            self.title = room_name
        } else {
            self.title = "房间内容"
        }
        
        self.setupSubViews()
    }
    
}

extension RoomContentVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.deviceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RoomContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! RoomContentCell
        //cell.backgroundColor = UIColor.orange
        cell.device = self.deviceList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let device = self.deviceList[indexPath.row]
                
        if let naviVC = self.navigationController {
            // 跳转到节点设备主页
            SmartHomeHandler.gotoNodeDeviceVC(naviVC: naviVC, device: device)
        }
    }
    
}

extension RoomContentVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


class RoomContentCell: UICollectionViewCell {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.orange
        return imageView
    }()
        
    private var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var device: Device = Device() {
        didSet {
            if let dev_name = self.device.dev_name {
                self.titleLabel.text = dev_name
            } else {
                self.titleLabel.text = "子设备"
            }
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
