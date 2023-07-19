//
//  NewAddDeviceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/14.
//

import UIKit
import SnapKit
import GemvarySmartHomeSDK
import GemvaryCommonSDK
import GemvaryToolSDK

/// 新云端添加设备
class NewAddDeviceVC: UIViewController {

    private let cellID: String = "NewAddDeviceCell"
    private let headerID: String = "NewAddDeviceHeaderView"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.register(NewAddDeviceHeaderView.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [String] = [
        "添加Zigbee节点设备",
        "添加Wi-Fi网关设备",
    ]
    /// 设备类型
    var deviceClass: DeviceClass = DeviceClass()
    /// 默认主机设备（当前默认第一个主机设备为hostdevice）
    private var hostDevice: Device = Device() {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加设备"

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        /// 查询当前主机
        let hostDevices = Device.queryGateway()
        swiftDebug("查询到的主机设备::: ", hostDevices)
        if hostDevices.count <= 0 {
            ProgressHUD.showText("主机设备个数为0")
        }
        if let first = hostDevices.first {
            self.hostDevice = first
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(newDeviceManagerUpHandler(noti:)), name: NSNotification.Name.new_device_manager, object: nil)
        
    }
        
    /// 新设备上报通知处理
    @objc func newDeviceManagerUpHandler(noti: Notification) -> Void {
        ///
        if let userinfo = noti.userInfo {
           swiftDebug("", userinfo)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerID) as! NewAddDeviceHeaderView
        headerView.deviceClass = self.deviceClass
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.dataList[indexPath.row]
        switch title {
        case "添加Zigbee节点设备":
            // 发送配网数据
            self.sendSearchDevice(command: true)
            // 配网60s后停止配网
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 60.00) {
                self.sendSearchDevice(command: false)
            }
            break
        case "添加Wi-Fi网关设备":
            break
        default:
            break
        }
    }
}

extension NewAddDeviceVC {
    
    /// 是否开始配网
    private func sendSearchDevice(command: Bool) -> Void {
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("是否开始配网,账号为空")
            return
        }
        
        guard let gateway_type = self.deviceClass.gateway_type else {
            swiftDebug("网关类型为空")
            return
        }
        /// 设备入网信息
        var riu_id = 3
        switch gateway_type {
        case GatewayType.wifi_Module:
            riu_id = 1
            break
        case GatewayType.zigbee:
            riu_id = 3
            break
        case GatewayType.rs485_module:
            riu_id = 5
            break
        case "RF_Module": // 红外模块
            riu_id = 9
            break
        default:
            break
        }
        
        let devSn = ""
        guard let dev_class_type = self.deviceClass.dev_class_type else {
            swiftDebug("设备类型信息 dev_class_type为空")
            return
        }
        guard let dev_brand = self.deviceClass.dev_brand else {
            swiftDebug("设备类型信息 brand为空")
            return
        }
        guard let host_mac = self.hostDevice.host_mac else {
            swiftDebug("host_mac为空")
            return
        }
        guard let dev_uptype = self.deviceClass.dev_uptype else {
            swiftDebug("dev_uptype为空")
            return
        }
        let sendData: [String: Any] = [
            "host_mac": host_mac,
            "msg_type" : MsgType.device_join_control,
            "command" : command ? Command.allow : Command.stop,
            "from_role" : FromRole.phone,
            "from_account" : account,
            "dev_class_type": dev_class_type,
            "gateway_type":gateway_type,
            "dev_sn": devSn,
            "riu_id" : riu_id,
            "brand": dev_brand,
            "dev_uptype": dev_uptype,
        ] as! [String: Any]
        
        guard let sendJson = JSONTool.translationObjToJson(from: sendData) else {
            swiftDebug("转换字符串失败")
            return
        }
        swiftDebug("发送智能家居数据:: ", sendData)
        // 发送智能家居数据
        SmartHomeHandler.sendData(msg: sendJson) { object, error in
            swiftDebug("返回数据内容信息", object as Any, error as Any)
        }
        
        /**
         {\"host_mac\":\"f870879a57de996d\",\"msg_type\":\"device_join_control\",\"command\":\"allow\",\"from_role\":\"phone\",\"from_account\":\"15989760200\",\"dev_class_type\":\"gem_cube\",\"gateway_type\":\"zigbee\",\"dev_sn\":\"\",\"riu_id\":3,\"brand\":\"gemvary.m9\",\"dev_uptype\":83}
         */
        // new_device_manager
        // 新设备上报,跳转到添加设备页面
        
    }
    
    /// 添加主机设备
    private func addHostDevice() -> Void {
        
    }
    
    
    /// 添加设备到空间
    private func addDeviceToSpace() -> Void {
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return
        }
        guard let gid = self.hostDevice.gid else {
            return
        }
        guard let groupId = self.hostDevice.group_id else {
            return
        }
        
        
        var sendJSON = [
            "gid": gid,
            "product_id": "product_id",
            "group_id": groupId,
            "msg_type" : MsgType.device_manager,
            "from_role" : FromRole.phone,
            "from_account" : account,
            "riu_id" :  "self.currentDevice.riu_id",
            "dev_class_type" : "self.currentDevice.dev_class_type", // 当前信息的类型
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
    
    /**
     
     /// 更新设备
     msg_type: "device_manager",
     command: "update",
     
     required init?(coder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }
     from_role: "phone",
     from_account: self.getAccount(),
     gid: gid,
     
     riu_id:newDevice.riu_id,
     dev_addr:newDevice.dev_addr,
     dev_net_addr:newDevice.dev_net_addr,
     host_mac:newDevice.host_mac,
     duration:1,
     online:1,
     dev_uptype:newDevice.dev_uptype,
     
     dev_class_type:oldDevice.dev_class_type,
     room_name:oldDevice.room_name,
     dev_name:oldDevice.dev_name,
     dev_key:oldDevice.dev_key,
     
     */
    
    /**
        
     /// 检查设备是否存在
     msg_type: "device_manager",
     command: "dev_check",
     from_role: "phone",
     from_account: self.getAccount(),
     gid: gid,
     dev_addr:dev_addr,
     dev_class_type:dev_class_type,
     riu_id:riu_id,
     host_mac:host_mac
     
     */
    
    
}

/// HeaderView
class NewAddDeviceHeaderView: UITableViewHeaderFooterView {
    
    private var describeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    /// 显示第一个主机    
    var deviceClass: DeviceClass = DeviceClass() {
        didSet {
            if let dev_describe = self.deviceClass.dev_describe {
                self.describeLabel.text = dev_describe
            }
        }
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.describeLabel)
        self.describeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
