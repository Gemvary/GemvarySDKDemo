//
//  NewHostDeviceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/13.
//

import UIKit
import SnapKit
import GemvaryNetworkSDK
import GemvaryToolSDK
import GemvaryCommonSDK

/// 新云端主机列表
class NewHostDeviceVC: UIViewController {

    private let cellID = "NewHostDeviceCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()

    private var bindDeviceList: [BindDevice] = [BindDevice]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新云端主机设备列表"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.getNetDeviceList()
    }

}

extension NewHostDeviceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bindDeviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let device = self.bindDeviceList[indexPath.row]
        if
            //let displayname = device.displayname,
            let gateway_name = device.gateway_name,
            let xmpp_username = device.xmpp_username {
            cell.textLabel?.text = "\(gateway_name) \(xmpp_username)"
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// 点击绑定网络设备
    }
    
}

extension NewHostDeviceVC {
    
    /// 获取网络设备列表
    private func getNetDeviceList(_ callBack: (([BindDevice]) -> Void)? = nil ) -> Void {
        // 账号为当前账号
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("账号为空")
            ProgressHUD.showText(NSLocalizedString("账号为空", comment: ""))
            callBack?([BindDevice]())
            return
        }
        swiftDebug("当前的账号~.~: ", account)
        // 请求设备网络设备的数据
        SmartWorkAPI.userDeviceList(account: account) { (object) in
            guard (object != nil) else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                callBack?([BindDevice]())
                return
            }
            
            if let object = object as? Error {
                swiftDebug("获取与用户绑定的设备列表 报错: \(object.localizedDescription)")
                ProgressHUD.showText(NSLocalizedString(object.localizedDescription, comment: ""))
                callBack?([BindDevice]())
                return
            }
            
            guard let object: [String: Any] = object as? [String: Any], let res = try? ModelDecoder.decode(GetDevicesRes.self, param: object) else {
                swiftDebug("GetDevicesRes 转换Model失败")
                return
            }
            swiftDebug("请求设备数组的数组: ", res as Any)
            switch res.code {
            case CloudResCode.c000000: // 成功
                // 返回设备数据数组
                if let data = res.data, data.count != 0 {
                    var bindDeviceList: [BindDevice] = [BindDevice]()
                    for netDevice in data {
                        // 组装数据
                        var bindDevice: BindDevice = BindDevice()
                        bindDevice.account = netDevice.account
                        bindDevice.bindDate = netDevice.bindDate
                        bindDevice.bindType = netDevice.bindType // 绑定类型
                        bindDevice.devcode = netDevice.devcode
                        bindDevice.deviceid = netDevice.deviceid
                        bindDevice.id = netDevice.id
                        bindDevice.subdomain = netDevice.subdomain
                        bindDevice.xmpp_username = netDevice.devcode
                        bindDevice.gateway_name = netDevice.devname // 设备名
                        bindDevice.plat = netDevice.plat
                        bindDevice.online = netDevice.online
                        bindDevice.useflag = netDevice.useflag
                        // 添加到数组
                        bindDeviceList.append(bindDevice)
                    }
                    // 当前设备列表赋值
                    self.bindDeviceList = bindDeviceList
                    callBack?(bindDeviceList)
                } else {
                    callBack?([BindDevice]())
                }
                break
            case CloudResCode.c100004: // token失效
                NewUserTokenLogin.loginWithToken {
                    self.getNetDeviceList(callBack)
                }
                break
            default: // 错误
                swiftDebug("服务器端请求设备列表错误", res)
                break
            }
        }
    }
    
}

/// 设备绑定的model信息
public struct BindDevice: Codable {
    /// 账户
    var account: String?
    /// 绑定时间
    var bindDate: String?
    /// 绑定类型
    var bindType: String?
    /// 设备码
    var devcode: String?
    /// 设备ID
    var deviceid: Int? = 0
    /// ID
    var id: Int? = 0
    /// 服务IP
    var server_ip: String?
    /// 子域名
    var subdomain: String?
    /// 用户标签
    //var useflag: String?
    /// 名字
    var xmpp_username: String?
    /// 网关名字 局域网设备
    var gateway_name: String?
    /// 网关类型 局域网设备 Host为主控 gateway为从设备
    var gateway_mode: String?
    /// 平台用来区分设备环境
    var plat: String?
    /// 是否在线
    var online: Bool? = true // 默认在线(局域网扫描到的默认在线)
    /// 是否为当前绑定设备
    var useflag: Bool?
    ///
    var dev_state: String? = ""
    ///
    var flag: String?
    
}

/// 请求后台绑定设备类型返回数据
struct GetDevicesRes: Codable {
    // 返回状态码
    var code: String?
    // 返回数据内容
    var data: [GetDevicesData]?
    // 返回状态信息
    var message: String?
}

/// 后台获取到的设备信息
public struct GetDevicesData: Codable {
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
