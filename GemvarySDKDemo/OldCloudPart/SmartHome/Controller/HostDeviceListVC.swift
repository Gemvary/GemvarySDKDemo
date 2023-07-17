//
//  HostDeviceListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/8/31.
//

import UIKit
import GemvarySmartHomeSDK // 智能家居sdk
import GemvaryNetworkSDK
import GemvaryToolSDK
import GemvaryCommonSDK
import SnapKit

/// 智能家居主机设备列表
class HostDeviceListVC: UIViewController {

    private let cellID = "HostDeviceListCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()

    private var deviceList: [HostDevice] = [HostDevice]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "主机设备列表"
        
        self.setupSubViews()
        
        self.userDeviceListRequest()
    }

}

extension HostDeviceListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = "主机设备"
        let device = self.deviceList[indexPath.row]
        if let devCode = device.devcode, let online = device.online {
            cell.textLabel?.text = "\(devCode) (\(online ? "在线" : "离线"))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let device = self.deviceList[indexPath.row]
//        if let devCode = device.devcode {
//
//        }
        
        SmartHomeBind.bindDeviceCode(device: device)
    }
}

extension HostDeviceListVC {
    /// 获取主机列表
    private func userDeviceListRequest() -> Void {
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account, account != "" else {
            debugPrint("当前账号信息为空")
            return
        }
                
        JHCloudWorkAPI.userDeviceList(account: account) { object in
            debugPrint("", object as Any)
            
            guard (object != nil) else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            
            if let object = object as? Error {
                swiftDebug("获取与用户绑定的设备列表 报错: \(object.localizedDescription)")
                ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
                return
            }
            
            guard let res = try? ModelDecoder.decode(UserDeviceListRes.self, param: object as! [String : Any]) else {
                swiftDebug("GetDevicesRes 转换Model失败")
                return
            }
            
            swiftDebug("请求设备数组的数组: ", res as Any)

            switch res.code {
            case CloudResCode.c000000: // 成功
                if let data = res.data {
                    self.deviceList = data
                }
                break
            case CloudResCode.c100004: // token失效
                FetchApiToken.requestUserLogin { (result) in
                    self.userDeviceListRequest()
                }
                break
            default: // 错误
                swiftDebug("服务器端请求设备列表错误", res)
                break
            }
            
        }
    }
    
    
    
    
}

extension HostDeviceListVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

struct UserDeviceListRes: Codable {
    var code: String?
    var data: [HostDevice]?
    var message: String?
}


/// 网络节点设备
struct HostDevice: Codable {
    /// 账户
    var account: String?
    /// 绑定时间
    var bindDate: String?
    /// 设备类型
    var bindType: String?
    /// 设备码
    var devcode: String?
    /// 设备ID
    var deviceid: Int?
    /// 设备名字
    var devname: String?
    /// ID
    var id: Int?
    /// 是否在线
    var online: Bool?
    /// 平台(设备环境)
    var plat: String?
    /// 子域名
    var subdomain: String?
    /// 是否为当前绑定设备
    var useflag: Bool?
}
