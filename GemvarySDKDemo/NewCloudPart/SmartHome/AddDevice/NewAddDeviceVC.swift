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
        "添加Wi-Fi网关设备", // 扫描局域网添加主机
    ]
    /// 设备类型
    var deviceClass: DeviceClass = DeviceClass()
    /// 默认主机设备（当前默认第一个主机设备为hostdevice）
    private var hostDevice: Device = Device()
    
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
        // 默认选择第一个主机
        if let first = hostDevices.first {
            self.hostDevice = first
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(newDeviceManagerUpHandler(noti:)), name: NSNotification.Name.new_device_manager, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(deviceJoinControlHandler(noti:)), name: NSNotification.Name.device_join_control, object: nil)

    }
        
    /// 新设备上报通知处理
    @objc func newDeviceManagerUpHandler(noti: Notification) -> Void {
        ///
        if let userinfo = noti.userInfo {
           swiftDebug("解析数据", userinfo)
            
            guard let dataJson: String = userinfo["data"] as? String else {
                swiftDebug("解析数据失败")
                return
            }
            guard let dataDict = JSONTool.translationJsonToDic(from: dataJson) else {
                swiftDebug("解析数据失败")
                return
            }
            
            guard let recv = try? ModelDecoder.decode(NewDeviceManagerRecv.self, param: dataDict) else {
                swiftDebug("NewDeviceManagerRecv 转换Model失败")
                return
            }
            
            
            /**
             {"msg_type":"new_device_manager","command":"up","from_role":"business","from_account":"84107890870c182608cf",
                //"devices":[{"alloc_room":0,"new_dev_id":0,"dev_addr":"_wQBAITz65whWQAAAAAAAA","riu_id":1,"gateway_type":"wifi_Module","dev_class_type":"lifesmart_repeater",
                //"dev_net_addr":"{\"userid\":\"7707463\",\"usertoken\":\"4Is3Xzd9pyfVJ4JuuO9zag\",\"agt\":\"_wQBAITz65whWQAAAAAAAA\",\"me\":\"0011\"}","dev_uptype":100,
                //"brand":"LifeSmart","host_mac":"84107890870c182608cf","dev_key":1,"dev_state":"{\"status\":\"off\"}"}]}
             */
            
            // 跳转到添加到房间页面
            
//            let newAddToRoomVC = NewAddToRoomVC()
            
//            self.navigationController?.pushViewController(newAddToRoomVC, animated: true)
            
            /*
             {\"msg_type\":\"new_device_manager\",\"command\":\"up\",\"from_role\":\"business\",\"from_account\":\"259173ce40164413\",\"dev_fw_version\":\"{\\\"dev_fw_version\\\":\\\"15\\\"}\",\"devices\":[{\"alloc_room\":0,\"new_dev_id\":0,\"dev_addr\":\"847127fffedb1e3e\",\"riu_id\":3,\"gateway_type\":\"zigbee\",\"dev_class_type\":\"gem_cube\",\"dev_net_addr\":\"c8c1\",\"dev_uptype\":83,\"brand\":\"gemvary.m9\",\"host_mac\":\"259173ce40164413\",\"dev_key\":1,\"dev_state\":\"{\\\"status\\\":\\\"on\\\",\\\"sub_devices\\\":[{\\\"dev_class_type\\\":\\\"light_three\\\",\\\"channel\\\":7,\\\"alloc\\\":0,\\\"id\\\":1},{\\\"dev_class_type\\\":\\\"scene_m9_panel6\\\",\\\"channel\\\":63,\\\"alloc\\\":0,\\\"id\\\":2}]}\"}]}
             */
            
        }
    }
    
    /// 设备添加返回
    @objc func deviceJoinControlHandler(noti: Notification) -> Void {
        
        // 停止入网
        self.sendSearchDevice(command: false)
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
            let newAddToRoomVC = NewAddToRoomVC()
            newAddToRoomVC.deviceClass = self.deviceClass
            //newAddToRoomVC.dataList = []
            self.navigationController?.pushViewController(newAddToRoomVC, animated: true)
            
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
        /**
         {\"host_mac\":\"259173ce40164413\",\"msg_type\":\"device_join_control\",\"command\":\"allow\",\"from_role\":\"phone\",\"from_account\":\"15989760200\",\"dev_class_type\":\"smoke\",\"gateway_type\":\"zigbee\",\"dev_sn\":\"\",\"riu_id\":3,\"brand\":\"gemvary.mlk\",\"dev_uptype\":0}"]
         
         ["command": "stop", "riu_id": 3, "dev_sn": "", "gateway_type": "zigbee", "dev_uptype": 0, "brand": "gemvary.bnd", "host_mac": "259173ce40164413", "msg_type": "device_join_control", "from_role": "phone", "from_account": "15989760200", "dev_class_type": "smoke"]
         
         */
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
    private func massProdAddDevice(devAddr: String) -> Void {
        
        guard let accountInfo = AccountInfo.queryNow(), let spaceID = accountInfo.spaceID else {
            swiftDebug("当前空间ID为空")
            return
        }
        
        guard let productId = self.deviceClass.id else {
            swiftDebug("")
            return
        }
        
        
        // 注册设备
        MassProdHandler.iotMassProdAddDevice(spaceId: spaceID, devAddr: devAddr, manufacturerId: "GEMVARY", productId: "\(productId)", riu_id: 0) { success in
                swiftDebug("设备注册成功")
        } failedCallback: { failed in
            swiftDebug("设备注册失败")
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
    
    /// 设备检查
    private func devCheck() -> Void {
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return
        }
        guard let gid = self.hostDevice.gid else {
            return
        }
        guard let groupId = self.hostDevice.group_id else {
            return
        }
        
        var sendData = [
            "msg_type": "device_manager",
            "command": "dev_check",
            "from_role": "phone",
            "from_account": account,
            "gid": gid,
            "dev_addr":"dev_addr",
            "dev_class_type":"dev_class_type",
            "riu_id":"riu_id",
            "host_mac":"host_mac"
        ]
        
        guard let sendJson = JSONTool.translationObjToJson(from: sendData) else {
            swiftDebug("转换字符串失败")
            return
        }
        swiftDebug("发送智能家居数据:: ", sendData)
        // 发送智能家居数据
        SmartHomeHandler.sendData(msg: sendJson) { object, error in
            swiftDebug("返回数据内容信息", object as Any, error as Any)
        }
                     
    }
        
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


/// 新设备类型信息上报
struct NewDeviceManagerRecv: Codable {
    /// 消息类型
    var msg_type: String?
    /// 命令
    var command: String?
    /// 角色
    var from_role: String?
    /// 账号
    var from_account: String?
    /// 设备信息
    var devices: [Device]? //[NewDevice]?
}

/// 新设备信息内容
struct NewDevice: Codable {
    /// 是否已经添加
    var alloc_room: Int?
    /// 新设备ID
    var new_dev_id: Int?
    /// 设备地址
    var dev_addr: String?
    /// 网关类型
    var riu_id: Int?
    /// 设备类型
    var dev_class_type: String?
    /// 网络设备地址
    var dev_net_addr: String?
    /// 设备私有类型
    var dev_uptype: Int?
    /// 品牌
    var brand: String?
    /// 设备key
    var dev_key: Int?
    /// 设备状态
    var dev_state: String?
    /// 房间
    var room_name: String?
    /// 设备名字
    var dev_name: String?
    
    var host_mac: String?
    /// 临时保存数据
    var from_account: String?
    
    
    /// 更新设备信息
    func update() -> Void {
        guard let dev_addr = self.dev_addr else {
            swiftDebug("新设备上报 更新 当前设备的地址为空")
            return
        }
        if let room_name = self.room_name, let dev_name = self.dev_name, var device = Device.query(devName: dev_name, roomName: room_name) {
            // 通过设备名 房间名 查询设备并更新
            device.riu_id = self.riu_id
            device.dev_net_addr = self.dev_net_addr
            device.dev_uptype = self.dev_uptype
            device.brand = self.brand
            device.dev_state = self.dev_state
            device.duration = 1
            device.online = 1 // 设置当前设备状态为在线
            if let host_mac = self.host_mac, host_mac != "" { // 2022/05/20修改适配
                device.host_mac = host_mac
            } else {
                device.host_mac = self.from_account
            }
            Device.update(device: device)
        } else {
            // 查询同一地址的设备
            let devices = Device.query(dev_addr: dev_addr)
            swiftDebug("设备上报的数据内容赋值: ", devices)
            // 更新同一地址的所有设备
            for device in devices {
                var device = device
                //device.dev_id = self.new_dev_id
                device.riu_id = self.riu_id
                device.dev_net_addr = self.dev_net_addr
                device.dev_uptype = self.dev_uptype
                device.brand = self.brand
                device.dev_state = self.dev_state
                device.duration = 1
                device.online = 1 // 设置当前设备状态为在线
                //device.dev_key = self.dev_key
                if let host_mac = self.host_mac, host_mac != "" { // 2022/05/20修改适配
                    device.host_mac = host_mac
                } else {
                    device.host_mac = self.from_account
                }
                Device.update(device: device)
            }
        }
        
    }
}
