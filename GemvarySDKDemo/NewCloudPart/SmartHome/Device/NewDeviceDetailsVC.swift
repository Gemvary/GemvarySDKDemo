//
//  NewDeviceDetailsVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/15.
//

import UIKit
import SnapKit
import GemvarySmartHomeSDK
import GemvaryToolSDK

/// 设备详情页
class NewDeviceDetailsVC: UIViewController {

    private let cellID: String = "DeviceDetailsCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    /// 详情页功能
    var dataList: [String] = [
        "修改设备名字",
        "删除设备",
    ]
    
    /// 当前设备信息
    var device: Device = Device() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设备详情"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension NewDeviceDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.dataList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let text = self.dataList[indexPath.row]
        
        switch text {
        case "修改设备名字":
            self.popChangeNameAlert()
            break
        case "删除设备":
            self.popDeleteDeviceAlert()
            break
        default:
            break
        }
        
    }
}

extension NewDeviceDetailsVC {
            
    /// 更新设备名字弹窗
    private func popChangeNameAlert() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "是否更新设备名字", preferredStyle: UIAlertController.Style.alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入设备名字"
        }
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            guard let textFields = alertVC.textFields, let first = textFields.first, let text = first.text else {
                swiftDebug("输入框内容为空")
                return
            }
            
            if text == "" {
                swiftDebug("房间名字内容为空")
                return
            }
            self.updateDevice(dev_name: text)
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel))
        self.present(alertVC, animated: true)
    }
    
    /// 删除设备弹窗
    private func popDeleteDeviceAlert() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "是否删除设备", preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            self.deleteDevice()
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel))
        self.present(alertVC, animated: true)
    }
    
    /// 删除设备
    private func deleteDevice() -> Void {
        // 获取当前账号
        guard let accountInfo = AccountInfo.queryNow(), let account  = accountInfo.account else {
            swiftDebug("账号信息为空")
            return
        }
        
        let sendData = [
            "msg_type" : "device_manager",
            "command" : "delete",
            "room_name" : self.device.room_name,
            "from_role" : "phone",
            "from_account" : account,
            "dev_name" : self.device.dev_name
        ]
        
        guard let sendJson = JSONTool.translationObjToJson(from: sendData) else {
            swiftDebug("转换字符串失败")
            return
        }
        
        // 发送智能家居数据
        SmartHomeHandler.sendData(msg: sendJson) { object, error in
            swiftDebug("返回数据内容信息", object as Any, error as Any)
        }
    }
    
    /// 更新设备
    private func updateDevice(dev_name: String) -> Void {
        guard let accountInfo = AccountInfo.queryNow(), let account  = accountInfo.account else {
            swiftDebug("账号信息为空")
            return
        }
        let sendData: [String: Any] = [
            "msg_type": "device_manager",
            "command": "update",
            "from_role": "phone",
            "from_account": account,
            "gid": "gid",
            
            "riu_id":self.device.riu_id as Any,
            "dev_addr":"hostInfo.devcode",
            "dev_net_addr":"hostInfo.ip",
            "host_mac":self.device.host_mac as Any,
            "duration":1,
            "online":1,
            "dev_uptype":self.device.dev_uptype as Any,
            
            "dev_class_type":self.device.dev_class_type as Any,
            "room_name":self.device.room_name as Any,
            "dev_name": dev_name, //self.device.dev_name as Any,
            "dev_key":self.device.dev_key as Any,
        ]
        
        guard let sendJson = JSONTool.translationObjToJson(from: sendData) else {
            swiftDebug("转换字符串失败")
            return
        }
        
        // 发送智能家居数据
        SmartHomeHandler.sendData(msg: sendJson) { object, error in
            swiftDebug("返回数据内容信息", object as Any, error as Any)
        }
        
    }
    
}
