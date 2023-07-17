//
//  NewZoneListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/27.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK
import GemvaryCommonSDK
import SnapKit

class NewZoneListVC: UIViewController {

    private let cellID = "NewZoneListCell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewZoneListCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    /// 小区列表
    var zoneList: [Zone] = [Zone]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    /// 账号信息
    var account: String = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 请求小区列表
        self.phoneZoneListRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = NSLocalizedString("新云端请选择小区", comment: "")
        self.setupSubViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewZoneListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.zoneList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewZoneListCell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! NewZoneListCell
        cell.zone = self.zoneList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        swiftDebug("点击cell")
        // 防止多次点击
        
        // 清空小区数据库表
        Zone.deleteAll()
        // 更新选中小区
        Zone.insert(zones: self.zoneList)
        let zone = self.zoneList[indexPath.row]
        if let zoneCode = zone.zoneCode {
            swiftDebug("新云端代码信息", zone)
            // 新云端社区接口小区编码赋值
            ScsPhoneWorkAPI.zoneCode = zoneCode
        }
        Zone.updateSelected(zone: zone)
        // 请求账号信息
        self.phoneAuthRequest(zone: zone)
    }
    
}


extension NewZoneListVC {
    
    /// 请求小区的列表
    private func phoneZoneListRequest() -> Void {
        guard self.account != "" else {
            ProgressHUD.showText("当前账号信息为空")
            return
        }
        // 获取当前用户信息
        ScsPhoneWorkAPI.phoneZoneList(account: self.account) { object in
            guard let object  = object else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            if object is Error, let object = object as? Error {
                swiftDebug("请求小区的列表 报错 ", object.localizedDescription)
                ProgressHUD.showText(object.localizedDescription)
                return
            }
            swiftDebug("请求小区的列表 返回内容 ", object)
            // 解析返回数据内容
            guard let object = object as? [String: Any], let res = try? ModelDecoder.decode(PhoneZoneListRes.self, param: object) else {
                swiftDebug("PhoneLoginRes 转换model失败")
                return
            }
            
            switch res.code {
            case NetResCode.c200:
                if let data = res.data, let zonelist = data.zonelist {
                    self.zoneList = zonelist
                }
                break
            case NetResCode.c552: // 免登录
                NewUserTokenLogin.loginWithToken {
                    self.phoneZoneListRequest()
                }
                break
            default:
                if let message = res.message {
                    ProgressHUD.showText(message)
                }
                break
            }
            
        }
    }
    
    /// 请求账号相关信息
    private func phoneAuthRequest(zone: Zone) -> Void {
        if self.account == "" || self.account.count == 0 {
            guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
                swiftDebug("")
                ProgressHUD.showText(NSLocalizedString("当前账号信息为空", comment: ""))
                return
            }
            self.account = account
        }
        guard let zoneCode = zone.zoneCode else {
            swiftDebug("小区编码为空")
            return
        }
        
        ScsPhoneWorkAPI.phoneAuth(account: self.account, zoneCode: zoneCode) { object in
            guard let object  = object else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            if object is Error, let object = object as? Error {
                swiftDebug("请求账号相关信息 报错 ", object.localizedDescription)
                ProgressHUD.showText(object.localizedDescription)
                return
            }
            swiftDebug("请求账号相关信息 ", object)
            guard let object = object as? [String: Any], let res = try? ModelDecoder.decode(PhoneAuthRes.self, param: object) else {
                swiftDebug("PhoneLoginRes 转换model失败")
                return
            }
            switch res.code {
            case NetResCode.c200:
                guard let data = res.data else {
                    swiftDebug("返回数据内容的data为空")
                    return
                }
                // 用户信息设置默认
                AccountInfo.setupAllDefault()
                // 请求所有门口机室内机信息
                SipDataHandler.requestAllInOutdoorDev()
                // 请求获取蓝牙开锁的门口机列表
                SipDataHandler.requestPhoneOutdoorList()
                // 获取房间信息
                SipDataHandler.fetchRoomInfoList()
                
                // 获取登录状态 及信息 保存到数据库
                self.insertOrUpdateUserInfo(data: data)
                
                // 获取智能家居Token
                
                // 请求该小区用户的房间列表
                self.phoneOwnerRoomListRequest()
                
                break
            case NetResCode.c552: // 免登录
                NewUserTokenLogin.loginWithToken {
                    self.phoneAuthRequest(zone: zone)
                }
                break
            default:
                break
            }
        }
    }
    
    /// 获取住户的房间信息
    private func phoneOwnerRoomListRequest() -> Void {
        ScsPhoneWorkAPI.phoneOwnerRoomList { object in
            guard let object  = object else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            if object is Error, let object = object as? Error {
                swiftDebug("获取住户的房间信息 报错 ", object.localizedDescription)
                ProgressHUD.showText(object.localizedDescription)
                return
            }
            swiftDebug("获取住户的房间信息 ", object)
            guard let object = object as? [String: Any], let res = try? ModelDecoder.decode(PhoneOwnerRoomListRes.self, param: object) else {
                swiftDebug("PhoneLoginRes 转换model失败")
                return
            }
            
            switch res.code {
            case NetResCode.c200:
                if let data = res.data {
                    if data.count > 1 {
                        // 房间个数 跳转到房间列表
                        let ownerRoomListVC = NewOwnerRoomListVC()
                        ownerRoomListVC.ownerRooms = data
                        self.navigationController?.pushViewController(ownerRoomListVC, animated: true)
                        return
                    }
                    // 只有一个房间 或0个房间时 直接跳转到主页面
                    let mainTabbarVC = NewMianHomeVC()
                    if let keyWindow = UIApplication.shared.keyWindow {
                        keyWindow.rootViewController = mainTabbarVC
                    }
                    
                    guard let ownerRoom = data.first else {
                        swiftDebug("房间数据为空")
                        return
                    }
                    // 房间数据库更新
                    OwnerRoom.updateSelected(ownerRoom: ownerRoom)
                    // 刷新token
//                    UserTokenLogin.loginWithToken {
//                        // 点都刷新房间信息
//                        self.phoneOwnerRoomListRequest()
//                    }
                }
                break
            case NetResCode.c552:
                break
            default:
                break
            }
        }
    }
    
}

extension NewZoneListVC {
    /// 插入或更新用户数据
    private func insertOrUpdateUserInfo(data: PhoneAuthData) -> Void {
        swiftDebug("更新当前账号信息")
        // 用户信息
        guard var accountInfo = AccountInfo.query(account: self.account) else {
            // 数据库表中没有该信息 需要创建插入
            var accountInfo = AccountInfo()
            accountInfo.account = self.account
            accountInfo.ablecloudToken = data.ablecloudToken
            //accountInfo.ablecloudUid = data.ablecloudUid
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
            //accountInfo.domain = ""
            //accountInfo.dndStatus = 0
            //accountInfo.missedCallStatus = 0
            // 插入到数据库
            AccountInfo.insert(accountInfo: accountInfo)
            return
        }
        
        accountInfo.ablecloudToken = data.ablecloudToken
        //accountInfo.ablecloudUid = data.ablecloudUid
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
        //accountInfo.domain = ""
        //accountInfo.dndStatus = 0
        //accountInfo.missedCallStatus = 0
        // 数据库表中存在该信息 需要更新
        AccountInfo.update(accountInfo: accountInfo)
    }
    
}

extension NewZoneListVC {
    /// 设置子控件
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

/// 小区列表的cell
class NewZoneListCell: UITableViewCell {
    /// 小区地址
    private var zoneAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    /// 小区名字
    private var zoneNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    /// 传入zone值
    var zone: Zone = Zone() {
        didSet {
            self.zoneAddressLabel.text = zone.zoneAddress
            self.zoneNameLabel.text = zone.zoneName
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 设置子控件
        self.setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension NewZoneListCell {
    /// 设置子控件
    private func setupSubViews() -> Void {
        self.contentView.addSubview(self.zoneAddressLabel)
        self.contentView.addSubview(self.zoneNameLabel)
        
        self.zoneAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.zoneNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.zoneAddressLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 5), // 顶部
            NSLayoutConstraint(item: self.zoneAddressLabel, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 15), // 左边
            NSLayoutConstraint(item: self.zoneAddressLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.zoneNameLabel, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0), // 底部
            NSLayoutConstraint(item: self.zoneAddressLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.zoneNameLabel, attribute: NSLayoutConstraint.Attribute.height, multiplier: 3/2, constant: 0), // 高度
        ])
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.zoneNameLabel, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 15), // 左边
            NSLayoutConstraint(item: self.zoneNameLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -5.0), // 底部
            
        ])
    }
}


//struct PhoneZoneListRes: Codable {
//    /// 状态码
//    var code: Int?
//    /// 消息
//    var message: String?
//    /// 数据内容
//    var data: PhoneZoneListData?
//}

//struct PhoneZoneListData: Codable {
//    /// able密码
//    var ablepwd: String?
//    /// 小区列表
//    var zonelist: [Zone]?
//}

/// 账号相关信息
//struct PhoneAuthRes: Codable {
//    var code: Int?
//    var data: PhoneAuthData?
//    var message: String?
//}

/// 账号相关信息内容
//struct PhoneAuthData: Codable {
//    /// AbleCloud Token
//    var ablecloudToken: String?
//    /// 判断云对讲的类型 2021.06.23新增
//    var cloudIntercomType: Int?
//    /// 是否为主账号
//    var isPrimary: Int?
//    /// 后台服务器地址编号
//    var serverId: String?
//    /// SIP账号
//    var sipId: String?
//    /// SIP密码
//    var sipPassword: String?
//    /// SIP服务器地址
//    var sipServer: String?
//    /// 手机免密码登录校验码
//    var tokenauth: String?
//    /// 手机免密码登录识别号
//    var tokencode: String?
//    /// 云之讯账号token
//    var ucsToken: String?
//    /// 判断登录用户是业主还是管理员 (0:业主 1:管理员) 2021.03.23新增
//    var userDesc: Int?
//    /// 用户ID
//    var userId: Int?
//    /// 免打扰状态
//    var userStatus: Int?
//}

//struct PhoneOwnerRoomListRes: Codable {
//    var code: Int?
//    var data: [OwnerRoom]?
//    var message: String?
//}

