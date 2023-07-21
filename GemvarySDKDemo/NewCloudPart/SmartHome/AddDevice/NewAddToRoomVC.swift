//
//  NewAddToRoomVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/20.
//

import UIKit
import SnapKit
import GemvaryToolSDK
import GemvarySmartHomeSDK

/// 添加到房间
class NewAddToRoomVC: UIViewController {

    private let cellID: String = "NewAddToRoomCell"
    private let footerID: String = "NewAddToRoomFooterView"
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewAddToRoomCell.self, forCellReuseIdentifier: self.cellID)
        tableView.register(NewAddToRoomFooterView.self, forHeaderFooterViewReuseIdentifier: self.footerID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    /// 设备列表
    var dataList: [Device] = [Device]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    /// 设备类型
    var deviceClass: DeviceClass = DeviceClass() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var hostDevice: Device = Device()
    var currentDevice: Device = Device() // 默认选中第一个设备
                    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加设备到房间"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        /// 设备数据
        let jsonData = "{\"gateway_type\":\"zigbee\",\"host_mac\":\"259173ce40164413\",\"dev_net_addr\":\"f3fe\",\"room_name\":\"默认\",\"dev_addr\":\"ccccccfffe18188a\",\"alloc_room\":1,\"brand\":\"gemvary.mlk\",\"dev_key\":1,\"new_dev_id\":0,\"riu_id\":3,\"dev_name\":\"烟雾传感器1\",\"dev_state\":\"{\\\"status\\\":\\\"on\\\",\\\"value\\\":1}\",\"dev_uptype\":0,\"dev_class_type\":\"smoke\"}"
        
        guard let jsonDict = JSONTool.translationJsonToDic(from: jsonData) else {
            swiftDebug("解析数据为空")
            return
        }
        
        guard let deviceModel = try? ModelDecoder.decode(Device.self, param: jsonDict) else {
            swiftDebug("解析数据失败")
            return
        }
        swiftDebug("解析数据内容", deviceModel)
        self.dataList = [deviceModel]
    }
    
}

extension NewAddToRoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewAddToRoomCell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! NewAddToRoomCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerID) as! NewAddToRoomFooterView
        // 点击按钮
        footerView.addButtonBlock = {
            self.addDeviceToRoom()
        }
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension NewAddToRoomVC {
    
    private func addDeviceToRoom() -> Void {
        
        guard let gid = self.hostDevice.gid, let host_mac = self.hostDevice.host_mac else {
            swiftDebug("host_mac为空")
            return
        }
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            return
        }
        guard let riu_id = self.deviceClass.riu_id,
              let dev_class_type = self.deviceClass.dev_class_type,
              let dev_brand = self.deviceClass.dev_brand,
              let gateway_type = self.deviceClass.gateway_type else {
            return
        }
        
        // 发送数据请求
        let sendData: [String: Any] = [
            "gid":gid, // 主机gid
            "product_id":"9c179ba94e5e42acaa57b82ffc78afea",
            "group_id":"DA93F72E-B90B-4E93-9860-2CA03DC5500F",
            "msg_type":"device_manager",
            "from_role": FromRole.phone,
            "from_account": account,
            "riu_id":riu_id,
            "dev_class_type":dev_class_type,
            "dev_addr":"ccccccfffe18188a",
            "dev_net_addr":"f3fe",
            "dev_uptype":0,
            "dev_key":1,
            "brand_logo":"http://gemvary.51vip.biz:3333/product-imgs/product/9c179ba94e5e42acaa57b82ffc78afea/38851c618e0528d75dc285e109f53c9c.jpg",
            "brand": dev_brand,
            "dev_state": "", //"\{\\\"status\\\":\\\"on\\\",\\\"value\\\":1}\",
            "dev_additional":"",
            "channel_id":0,
            "online":1,
            "duration":1,
            "host_mac": host_mac,
            "command": Command.add,
            "room_name":"默认",
            "dev_name":"烟雾传感器1",
            "gateway_type":gateway_type,
            "active":1
        ]
                                
        guard let sendJson = JSONTool.translationObjToJson(from: sendData) else {
            swiftDebug("转换字符串失败")
            return
        }
        swiftDebug("发送智能家居数据:: ", sendData)
        // 发送智能家居数据
        SmartHomeHandler.sendData(msg: sendJson) { object, error in
            swiftDebug("返回数据内容信息", object as Any, error as Any)
            // 返回到设备首页面
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    
}


class NewAddToRoomFooterView: UITableViewHeaderFooterView {
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("添加", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(buttonAction(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    var addButtonBlock:(() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.addButton)
        self.addButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().offset(10)
            make.horizontalEdges.equalToSuperview().offset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction(_ button: UIButton) -> Void {
        if self.addButtonBlock != nil {
            self.addButtonBlock!()
        }
    }
            
}


class NewAddToRoomCell: UITableViewCell {
    
    private var line1View: UIView = {
        let view = UIView()
        return view
    }()
    private var line2View: UIView = {
        let view = UIView()
        return view
    }()
    private var line3View: UIView = {
        let view = UIView()
        return view
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "设备基本信息"
        return label
    }()
    private var gatewayLabel: UILabel = {
        let label = UILabel()
        label.text = "网关设备信息"
        return label
    }()
    private var roomLabel: UIView = {
        let label = UILabel()
        label.text = "所属房间"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.line1View)
        self.contentView.addSubview(self.line2View)
        self.contentView.addSubview(self.line3View)
        self.line1View.addSubview(self.nameLabel)
        self.line2View.addSubview(self.gatewayLabel)
        self.line3View.addSubview(self.roomLabel)
        
        self.line1View.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(1/3)
        }
        self.line2View.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.line1View.snp.bottom)
            make.height.equalToSuperview().multipliedBy(1/3)
        }
        self.line3View.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self.line2View.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(1/3)
        }
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.gatewayLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.roomLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
