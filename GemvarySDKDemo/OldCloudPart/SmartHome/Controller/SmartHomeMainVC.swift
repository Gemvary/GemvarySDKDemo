//
//  SmartHomeMainVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/8/31.
//

import UIKit
import SnapKit

class SmartHomeMainVC: UIViewController {

    private let cellID = "SmartHomeCell"
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
    
    /// 节点设备列表
    private var deviceList: [Device] = [Device]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "智能家居"
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "房间", style: UIBarButtonItem.Style.plain, target: self, action: #selector(leftBarButtonItemAction(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarButtonItemAction(_:)))
        
        
        self.setupSubViews()
        
        swiftDebug("所有节点设备列表:: ", Device.queryAll())
        
        //self.deviceList = Device.queryAll()
        // 查询常用设备
        self.deviceList = Device.query(shortcutFlag: "1")
    }
    
    @objc func leftBarButtonItemAction(_ button: UIBarButtonItem) -> Void {
        let roomListVC = RoomListVC()
        roomListVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(roomListVC, animated: true)
    }
        
    @objc func rightBarButtonItemAction(_ button: UIBarButtonItem) -> Void {
        
        let smartHomeSetupVC = SmartHomeSetupVC()
        smartHomeSetupVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(smartHomeSetupVC, animated: true)
    }
        
}

extension SmartHomeMainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
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


extension SmartHomeMainVC {
    /// 设置子控件
    private func setupSubViews() -> Void {
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
