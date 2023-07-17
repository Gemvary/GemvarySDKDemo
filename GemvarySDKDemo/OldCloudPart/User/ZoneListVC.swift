//
//  ZoneListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK

class ZoneListVC: UIViewController {

    private let cellID = "ZoneListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    /// 小区列表
    var zoneList: [Zone] = [Zone]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    /// 当前账号
    var account: String = String()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //if self.account == "" {
            self.phoneZoneListRequest()
        //}
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "小区列表"
        
        self.view.addSubview(self.tableView)
    }
    
}

extension ZoneListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.zoneList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        let zone = self.zoneList[indexPath.row]
        if let zoneAddress = zone.zoneAddress, let zoneName = zone.zoneName {
            cell.textLabel?.text = "\(zoneAddress) \(zoneName)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        Zone.deleteAll()
        Zone.insert(zones: self.zoneList)
        Zone.updateSelected(zone: self.zoneList[indexPath.row])
        
        if let zoneCode = self.zoneList[indexPath.row].zoneCode {
            UserTokenLogin.zoneCode = zoneCode
        }
        
        // 获取账号的小区信息
        self.phoneAuthRequest(zone: self.zoneList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension ZoneListVC {
    
    private func phoneZoneListRequest() -> Void {
        
        PhoneWorkAPI.phoneZoneList(account: self.account) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            
            guard let res = try? ModelDecoder.decode(PhoneZoneListRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneZoneListRes 转换Model失败")
                return
            }
            debugPrint("当前小区信息内容: ", object as Any)
            switch res.code {
            case 200:
                if let data = res.data, let zonelist = data.zonelist {
                    self.zoneList = zonelist
                }
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.phoneZoneListRequest()
                }
                break
            default:
                break
            }
        }
    }
    
    
    private func phoneAuthRequest(zone: Zone) -> Void {
        
        if self.account == "" || self.account.count == 0 {
            guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
                debugPrint("")
                return
            }
            self.account = account
        }
        
        guard let zoneCode = zone.zoneCode else {
            debugPrint("小区编码为空")
            return
        }
        // 请求账号信息
        PhoneWorkAPI.phoneAuth(account: self.account, zoneCode: zoneCode) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            
            debugPrint("请求账号信息", object)
            guard let res = try? ModelDecoder.decode(PhoneAuthRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneAuthRes 转换Model失败")
                return
            }
            switch res.code {
            case 200:
                guard let data = res.data else {
                    debugPrint("data为空")
                    return
                }
                AccountInfo.setupAllDefault()
                
                // 保存到数据库
                self.insertOrUpdateUserInfo(data: data)
                
                UserTokenLogin.tokenauth = data.tokenauth!
                UserTokenLogin.tokencode = data.tokencode!
                
                // 请求房间列表
                self.phoneOwnerRoomListRequest()
                
                break
            case 400:
                debugPrint("失败")
                break
            case 552:
                debugPrint("免登录")
                UserTokenLogin.loginWithToken { result in
                    self.phoneAuthRequest(zone: zone)
                }
                break
            case 554:
                debugPrint("账户已过期")
                break
            default:
                break
            }
            
        }
    }
    
    /// 获取住户房间信息
    private func phoneOwnerRoomListRequest() -> Void {
        
        PhoneWorkAPI.phoneOwnerRoomList { object in
            
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            debugPrint("", object)
            
            guard let res = try? ModelDecoder.decode(PhoneOwnerRoomListRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneOwnerRoomListRes 转换Model失败")
                return
            }
            
            switch res.code {
            case 200:
                guard let data = res.data else {
                    return
                }
                OwnerRoom.insert(ownerRooms: data)
                
                if data.count == 0 || data.count == 1 {
                                      
                    if let ownerRoom = data.first {
                        OwnerRoom.updateSelected(ownerRoom: ownerRoom)
                    }
                    
                    let mainTabbarVC = MainTabbarVC()
                    if let keyWindow = UIApplication.shared.keyWindow {
                        keyWindow.rootViewController = mainTabbarVC
                    }
                    
                } else {
                    let ownerRoomListVC = OwnerRoomListVC()
                    ownerRoomListVC.dataList = data
                    self.navigationController?.pushViewController(ownerRoomListVC, animated: true)
                }
                                
                break
            default:
                break
            }
            
        }
        
    }
    
    
    private func insertOrUpdateUserInfo(data: PhoneAuthData) -> Void {
        
        guard var accountInfo = AccountInfo.query(account: self.account) else {
            var accountInfo = AccountInfo()
            accountInfo.account = self.account
            accountInfo.ablecloudToken = data.ablecloudToken
            accountInfo.ablecloudUid = data.ablecloudUid
            accountInfo.isPrimary = data.isPrimary
            accountInfo.serverId = data.serverId
            accountInfo.sipId = data.sipId
            accountInfo.sipPassword = data.sipPassword
            accountInfo.sipServer = data.sipServer
            accountInfo.tokenauth = data.tokenauth
            accountInfo.tokencode = data.tokencode
            accountInfo.ucsToken = data.ucsToken
            accountInfo.userId = data.userId
            accountInfo.userStatus = data.userStatus
            accountInfo.selected = true
            accountInfo.userDesc = data.userDesc // 判断登录用户是业主还是管理员
            accountInfo.cloudIntercomType = data.cloudIntercomType // 判断云对讲的类型
            // 插入到数据库
            AccountInfo.insert(accountInfo: accountInfo)
            return
        }
        
        accountInfo.ablecloudToken = data.ablecloudToken
        accountInfo.ablecloudUid = data.ablecloudUid
        accountInfo.isPrimary = data.isPrimary
        accountInfo.serverId = data.serverId
        accountInfo.sipId = data.sipId
        accountInfo.sipPassword = data.sipPassword
        accountInfo.sipServer = data.sipServer
        accountInfo.tokenauth = data.tokenauth
        accountInfo.tokencode = data.tokencode
        accountInfo.ucsToken = data.ucsToken
        accountInfo.userId = data.userId
        accountInfo.userStatus = data.userStatus
        accountInfo.selected = true
        accountInfo.userDesc = data.userDesc // 判断登录用户是业主还是管理员
        accountInfo.cloudIntercomType = data.cloudIntercomType // 判断云对讲的类型
        // 数据库表中存在该信息 需要更新
        AccountInfo.update(accountInfo: accountInfo)
    }
    
    
}


struct PhoneZoneListRes: Codable {
    var message: String?
    var data: PhoneZoneListData?
    var code: Int?
}

struct PhoneZoneListData: Codable {
    var ablepwd: String?
    var zonelist: [Zone]?
}

struct PhoneOwnerRoomListRes: Codable {
    var code: Int?
    var data: [OwnerRoom]?
    var message: String?
}

struct PhoneAuthRes: Codable {
    var code: Int?
    var data: PhoneAuthData?
    var message: String?
}

struct PhoneAuthData: Codable {
    var ablecloudToken: String?
    var ablecloudUid: Int?
    var isPrimary: Int?
    var serverId: String?
    var sipId: String?
    var sipPassword: String?
    var sipServer: String?
    var tokenauth: String?
    var tokencode: String?
    var ucsToken: String?
    var userId: Int?
    var userStatus: Int?
    var userDesc: Int?
    var cloudIntercomType: Int?
}
