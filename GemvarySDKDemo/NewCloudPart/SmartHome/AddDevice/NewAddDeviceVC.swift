//
//  NewAddDeviceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/14.
//

import UIKit
import SnapKit

/// 新云端添加设备
class NewAddDeviceVC: UIViewController {

    private let cellID: String = "NewAddDeviceCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    var dataList: [String] = [
        "添加Zigbee节点设备",
        "添加Wi-Fi网关设备",
    ]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加设备"

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
}

extension NewAddDeviceVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let title = self.dataList[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.dataList[indexPath.row]
        switch title {
        case "添加Zigbee节点设备":
            // 发送配网数据
            
            break
        case "添加Wi-Fi网关设备":
            break
        default:
            break
        }
    }
}

extension NewAddDeviceVC {
    
    private func sendSearchDevice() -> Void {
        
        let sendData = [
            "gid": "self.device.gid",
            "host_mac": "self.device.host_mac",
            "msg_type": "device_join_control",
            // allow:开始入网 stop:停止入网
            "command": "command", // ? "allow" : "stop",
            "from_role": "phone",
            "from_account": "self.getAccount()",
            "dev_name": "self.device.dev_name",
            "room_name": "self.device.room_name",
            "dev_class_type": "self.device.dev_class_type",
            "gateway_type": "self.productInfo.gatewayType",
            "dev_sn": "devSn",
            "riu_id": "riu_id",
            "brand": "self.device.brand",
            "dev_uptype":"self.productInfo.upType",
        ]
    }
    
    /// 添加主机设备
    private func addHostDevice() -> Void {
        
    }
    
    
    /// 添加设备到空间
    private func addDeviceToSpace() -> Void {
        
        var sendJSON = [
            "gid": "gid",
            "product_id": "product_id",
            "group_id": "self.groupId",
            "msg_type" : "device_manager",
            "from_role" : "phone",
            "from_account" : "self.getAccount()",
            "riu_id" :  "self.currentDevice.riu_id",
            "dev_class_type" : "self.currentDevice.dev_class_type",
            "dev_addr" : "self.currentDevice.dev_addr",
            "dev_net_addr" : "self.currentDevice.dev_net_addr",
            "dev_uptype" : "self.currentDevice.dev_uptype",
            "dev_key" : "self.currentDevice.dev_key",
            "brand_logo" : "self.deviceIcon",
            "brand" : "self.currentDevice.brand",
            "dev_state" : "dev_state",
            "dev_additional" : "dev_additional",
            "channel_id": 0,
            "online": "online",
            "duration": "duration",
            "host_mac": "host_mac",
        ] as [String : Any]
                        
    }
    
    /// 注册设备
    private func massProdAddDevice() -> Void {
        // 注册设备
        MassProdHandler.iotMassProdAddDevice(spaceId: "", devAddr: "", manufacturerId: "", productId: "", riu_id: 0) { success in
            
        } failedCallback: { failed in
            
        }
        
        
    }
    
    
}
