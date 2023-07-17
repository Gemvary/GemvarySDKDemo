//
//  KeyBagListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/24.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK
import SnapKit

class KeyBagListVC: UIViewController {

    private let cellID = "KeyBagListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [PhoneGetAllOutdoorData] = [PhoneGetAllOutdoorData]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.phoneGetAllOutdoorRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "钥匙包"
        
        self.setupSubViews()
    }
}

extension KeyBagListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let data = self.dataList[indexPath.row]
        if let note = data.note {
            cell.textLabel?.text = note
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let keyBag = self.dataList[indexPath.row]
        
        if keyBag.status != 1  {
            debugPrint("设备离线")
            return
        }
        
    }
}

extension KeyBagListVC {
    /// 获取钥匙包列表
    private func phoneGetAllOutdoorRequest() -> Void {
        
        PhoneWorkAPI.phoneGetAllOutdoor { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            
            guard let res = try? ModelDecoder.decode(PhoneGetAllOutdoorRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneGetAllOutdoorRes 转换Model失败")
                return
            }
            debugPrint("钥匙包信息内容:: ", object as Any)
            switch res.code {
            case 200:
                if let data = res.data {
                    self.dataList = data
                }
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.phoneGetAllOutdoorRequest()
                }
                break
            default:
                break
            }
        }
    }
    
    /// 开锁
    private func phoneMsgForwardRequest(devCode: String) -> Void {
        
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            debugPrint("")
            return
        }
        
        // 兼容旧钥匙包开锁方式 1:旧钥匙包 15:兼容旧钥匙包
        PhoneWorkAPI.phoneMsgForward(zoneCode: zoneCode, devcode: devCode, msgType: 15) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            
            guard let res = try? ModelDecoder.decode(PhoneMsgForwardRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneMsgForwardRes 转换Model失败")
                return
            }
            debugPrint("钥匙包信息内容:: ", object as Any)
            switch res.code {
            case 200:
                debugPrint("发送开锁信息成功")
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.phoneMsgForwardRequest(devCode: devCode)
                }
                break
            default:
                break
            }
        }
        
        PhoneWorkAPI.phoneMsgForward(zoneCode: zoneCode, devcode: devCode) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            
            guard let res = try? ModelDecoder.decode(PhoneMsgForwardRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneMsgForwardRes 转换Model失败")
                return
            }
            debugPrint("钥匙包信息内容:: ", object as Any)
            switch res.code {
            case 200:
                debugPrint("发送开锁信息成功")
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.phoneMsgForwardRequest(devCode: devCode)
                }
                break
            default:
                break
            }
        }
    }
    
    
}

extension KeyBagListVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

struct PhoneGetAllOutdoorRes: Codable {
    var code: Int?
    var data: [PhoneGetAllOutdoorData]?
    var message: String?
}

struct PhoneGetAllOutdoorData: Codable {
    /// 别名
    var alias: String?
    /// 蓝牙地址
    var bleMac: String?
    var cloudTalkStatus: Int?
    /// 创建时间
    var createTime: String?
    /// 设备码
    var devCode: String?
    /// 设备类型
    var devType: Int?
    /// 网关
    var gateway: String?
    /// 唯一标识
    var id: Int?
    /// 本机IP
    var ipAddr: String?
    /// 设备更新时间
    var lastUpdated: String?
    /// 设备型号
    var model: String?
    /// 对应的中文/英文名称
    var note: String?
    /// 房间号
    var roomno: String?
    var simuable: Bool?
    /// sip账号
    var sipAddr: String?
    /// 单元号
    var unitno: String?
    var daStatus: Int?
    var doNotDisturbStatus: Int?
    var extra: String?
    var floorNo: String?
    var gid: String?
    var hwid: String?
    var inOutType: Int?
    var isMainLift: Int?
    var legacy: Int?
    var macAddr: String?
    var pushServerStatus: String?
    var regStatus: Int?
    var serverAddr: String?
    /// 设备在线离线状态
    var status: Int?
    var zoneCode: String?
}


struct PhoneMsgForwardRes: Codable {
    var code: Int?
    var message: String?
}
