//
//  LanDeviceListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import UIKit
import GemvarySmartHomeSDK
import GemvaryToolSDK
import SnapKit

/// 局域网设备列表
class LanDeviceListVC: UIViewController {

    private let cellID = "LanDeviceListCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var deviceList: [LanHostDevice] = [LanHostDevice]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account, account != "" else {
            swiftDebug("当前用户账号为空")
            return
        }
        
        // 开始局域网扫描设备
        SmartHomeManager.lanStartScan(account: account)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "局域网设备列表"
        
        self.setupSubViews()
        
        // 局域网获取局域网内的设备
        SmartHomeManager.lanDevicesScan { devices in
            swiftDebug("局域网设备列表::: ", devices)
            
            guard let deviceList = try? ModelDecoder.decode(LanHostDevice.self, array: devices) else {
                swiftDebug("转换model失败")
                return
            }
            DispatchQueue.main.async {
                self.deviceList.removeAll()
                self.deviceList = deviceList
            }
        }
        
        
    }
    
}

extension LanDeviceListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let device = self.deviceList[indexPath.row]
        cell.textLabel?.text = "\(device.xmpp_username!)   \(device.server_ip!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = self.deviceList[indexPath.row]
        // 绑定局域网设备
        guard let server_ip = device.server_ip, let address = device.xmpp_username else {
            swiftDebug("获取设备地址失败")
            return
        }
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account, account != "" else {
            swiftDebug("当前用户账号为空")
            return
        }
        // 连接当前设备信息内容
        SmartHomeManager.lanConnectMsg(account: account, serverIP: server_ip, deviceID: address) { error in
            swiftDebug("连接设备是否成功", error as Any)
        }
                        
    }
}

extension LanDeviceListVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}


struct LanHostDevice: Codable {
    /// 局域网内设备的IP
    var server_ip: String?
    /// 客户端
    var from_role: String?
    /// 端口 8101
    var server_port: Int = 0
    /// 消息类型
    var msg_type: String?
    /// 标识符 gem45Protocol
    var flag: String?
    /// 用户
    var from_account: String?
    /// 设备mac
    var xmpp_username: String?
    /// 消息命令
    var command: String?
    /// gemvary
    var displayname: String?
    /// 设备名字
    var gateway_name: String?
    /// 主机类型
    var gateway_mode: String?
    /// 长度
    var data_length: Int = 0
    /// 结果
    var result: String?
    /// 平台
    var plat: String? //= DevicePlat.hostlan
}
