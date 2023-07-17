//
//  NewLanDeviceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/13.
//

import UIKit
import SnapKit
import GemvarySmartHomeSDK
import GemvaryToolSDK

/// 局域网设备列表
class NewLanDeviceVC: UIViewController {

    private let cellID = "NewLanDeviceCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var lanDevices: [LanDevice] = [LanDevice]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新云端局域网设备列表"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        SmartHomeLan.shared.startScanLanDevice()
        
        
        SmartHomeLan.shared.currentLanDeviceListCallBack { devices in
            swiftDebug("局域网设备信息: ", devices)
            
            guard let lanDevices = try? ModelDecoder.decode(LanDevice.self, array: devices) else {
                swiftDebug("转换失败")
                return
            }
            self.lanDevices = lanDevices
        }
        
    }


}

extension NewLanDeviceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lanDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let device = self.lanDevices[indexPath.row]
        if
            //let displayname = device.displayname,
            let server_ip = device.server_ip, let xmpp_username = device.xmpp_username {
            cell.textLabel?.text = "ID:\(xmpp_username)  IP:\(server_ip)"
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 绑定局域网设备
        
    }
    
}

/**
 ["xmpp_username": 75969bf90cc37c87, "server_port": 8101, "server_ip": 192.168.1.113, "result": success, "flag": gem45Protocol, "command": query, "dev_class_type": gateway.rk3126, "version": Business-6.0.202305251109_V3, "gateway_name": 主机, "gateway_mode": , "msg_type": search, "from_role": phone, "plat": jhcloud_v3, "port": 51591, "zigbee_guid": 04CF8CDF3C8F5E64, "displayname": *gemvary*, "from_account": 75969bf90cc37c87, "data_length": 7, "ip": 192.168.1.104]
 
 */

/// 局域网设备
struct LanDevice: Codable {
//    /// 局域网内设备的IP
//    var server_ip: String? = ""
//    /// 客户端
//    var from_role: String? = ""
//    /// 端口 8101
//    var server_port: Int = 0
//    /// 消息类型
//    var msg_type: String? = ""
//    /// 标识符 gem45Protocol
//    var flag: String? = ""
//    /// 用户
//    var from_account: String? = ""
//    /// 设备mac
//    var xmpp_username: String? = ""
//    /// 消息命令
//    var command: String? = ""
//    /// gemvary
//    var displayname: String? = ""
//    /// 设备名字
//    var gateway_name: String? = ""
//    /// 主机类型
//    var gateway_mode: String? = ""
//    /// 长度
//    var data_length: Int = 0
//    /// 结果
//    var result: String? = ""
//    /// n3,n5主机会用到
//    var dev_state: String? = ""
    
    /// 局域网内设备的IP
    var server_ip: String? = ""
    /// 客户端
    var from_role: String? = ""
    /// 端口 8101
    var server_port: Int? = 0
    /// 消息类型
    var msg_type: String? = ""
    /// 标识符 gem45Protocol
    var flag: String? = ""
    /// 用户
    var from_account: String? = ""
    /// 设备mac
    var xmpp_username: String? = ""
    /// 消息命令
    var command: String? = ""
    /// gemvary
    var displayname: String? = ""
    /// 设备名字
    var gateway_name: String? = ""
    /// 主机类型
    var gateway_mode: String? = ""
    /// 长度
    var data_length: Int? = 0
    /// 结果
    var result: String? = ""
    /// 平台
    var plat: String? = DevicePlat.hostlan
    /// n3,n5主机会用到
    var dev_state: String? = ""
}
