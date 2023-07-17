//
//  ButlerServiceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/15.
//

import UIKit
import AVFoundation
import GemvaryNetworkSDK
import MJRefresh
import GemvaryToolSDK
//import GemvaryZGCloudCallSDK
import GemvaryCommonSDK
import SnapKit

class ButlerServiceVC: UIViewController {
    /// cell重用标识符
    private let kCallListTVCCEll = "kCallListTVCCEll"

    /// 创建tableview
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain) // grouped
        // 设置代理
        tableView.delegate = self
        tableView.dataSource = self
        // 注册cell
        tableView.register(UINib.init(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: self.kCallListTVCCEll)
        // 分割线
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        // 清空多余的cell
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        // 动态cell高度
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    private var refreshFinishedCount: Int = 0
    /// 管理机数组
    private var manageList = [PhoneCallManageList]() {
        didSet {
            self.tableView.reloadData() // 刷新列表
        }
    }
    /// 管家数组
    private var butlerList = [PhoneCallButlerData]() {
        didSet {
            self.tableView.reloadData() // 刷新列表
        }
    }
    
    /// 页面即将出现
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 请求数据
        self.requestManagerList()
        self.requestHousekeeperInfoList()
    }
    
    /// 页面已经出现
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /// 页面已经加载
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("管家服务", comment: "")
        // 添加tableView
        // 设置子控件
        self.setupSubViews()
        // 刷新
        self.initMJRefresh()
    }
    
    /// 设置子控件
    private func setupSubViews() -> Void {
        
        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    deinit {
        swiftDebug("\(NSStringFromClass(self.classForCoder)) __dealloc__")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    /// 请求管理机
    private func requestManagerList() {
        
        // 获取室内机/门口机的信息列表
        PhoneWorkAPI.phoneCall() { (obj) in
            // 判断返回数据是否为空
            guard let obj = obj else {
                swiftDebug("网络请求错误")
                self.endRefreshing()
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            // 判断返回数据是否错误
            if obj is Error {
                if let obj = obj as? Error {
                    self.endRefreshing()
                    ProgressHUD.showText(NSLocalizedString(obj.localizedDescription, comment: ""))
                    swiftDebug("请求呼叫信息列表 报错: \(obj.localizedDescription)")
                    return
                }
            }
            swiftDebug("呼叫信息列表: ", obj)
            // 解析返回数据内容 转model
            guard let res = try? ModelDecoder.decode(PhoneCallRes.self, param: obj as! [String : Any]) else {
                swiftDebug("PhoneCallRes 转换Model失败")
                return
            }
            swiftDebug("转换后的model内容::: ", res)
            // 判断返回数据状态码
            switch res.code {
            case NetResCode.c200: // 成功
                self.endRefreshing()
                // 判断返回数据的data是否为空 管理机设备列表是否为空
                if let data = res.data, let manageList = data.manageList {
                    self.manageList = manageList
                }
                self.tableView.mj_header?.endRefreshing {
                    // 结束刷新
                }
                break
            case NetResCode.c400: // 失败
                self.endRefreshing()
                ProgressHUD.showText(NSLocalizedString(res.message!, comment: ""))
                swiftDebug("请求呼叫信息列表: \(res.message!)")
                break
            case NetResCode.c552: // 免登录
                UserTokenLogin.loginWithToken { (result) in
                    self.requestManagerList()
                }
                break
            default:
                
                break
            }
        }
    }
    
    
    /// 请求君和管家
    private func requestHousekeeperInfoList() {
        // 当前账户信息
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
                
        // 获取管家信息列表
        PhoneWorkAPI.phoneCallButler() { (obj) in
            // 判断返回数据是否为空
            guard let obj = obj else {
                swiftDebug("网络请求错误")
                self.endRefreshing()
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            // 判断返回数据是否错误
            if obj is Error {
                if let obj = obj as? Error {
                    self.endRefreshing()
                    ProgressHUD.showText(NSLocalizedString(obj.localizedDescription, comment: ""))
                    swiftDebug("请求管家信息列表 报错: \(obj.localizedDescription)")
                    return
                }
            }
            swiftDebug("请求君和管家数据内容", obj)
            // 解析返回数据内容 转model
            guard let res = try? ModelDecoder.decode(PhoneCallButlerRes.self, param: obj as! [String : Any]) else {
                swiftDebug("PhoneCallButlerRes 转换Model失败")
                return
            }
            swiftDebug("请求君和管家的数据", res)
            // 判断返回数据状态码
            switch res.code {
            case NetResCode.c200: // 成功
                self.endRefreshing()
                if var data = res.data {
                    data.removeAll(where: { (model) -> Bool in
                        if model.account == account {
                            // 遍历信息 如果管家账号等于自己账号 则删除该管家信息
                            return true
                        } else {
                            return false
                        }
                    })
                    /// 管家列表赋值
                    self.butlerList = data
                }
                break
            case NetResCode.c400: // 失败
                self.endRefreshing()
                ProgressHUD.showText(NSLocalizedString(res.message!, comment: ""))
                swiftDebug("请求管家信息列表: \(res.message!)")
                break
            case NetResCode.c552: // 免登录
                UserTokenLogin.loginWithToken { (result) in
                    self.requestHousekeeperInfoList()
                }
                break
            default:
                break
            }
        }
    }
    
    func initMJRefresh() {
        let header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            #if IS_NEUTRAL_NOSH
            self?.refreshFinishedCount = 1
            self?.requestManagerList()
            #else
            self?.refreshFinishedCount = 2
            self?.requestManagerList()
            #endif
        })
        
        header.isAutomaticallyChangeAlpha = true
        header.lastUpdatedTimeLabel?.isHidden = true
        
        header.setTitle(NSLocalizedString("下拉可以刷新", comment: ""), for: MJRefreshState.idle)
        header.setTitle(NSLocalizedString("松开立即刷新", comment: ""), for: MJRefreshState.pulling)
        header.setTitle(NSLocalizedString("正在刷新数据中...", comment: ""), for: MJRefreshState.refreshing)
        
        self.tableView.mj_header = header
    }
    
    
    // MARK: - private methods
    private func getManagerName(manageInfo: PhoneCallManageList) -> String {
        var toName = String()
        
        if let alias = manageInfo.alias,  alias != "" {
            toName = NSLocalizedString("管理机", comment: "") + alias
        }else{
            toName = NSLocalizedString("管理机", comment: "")
        }
        return toName
    }
    
    /// 设置MJRefresh刷新状态为闲置状态
    private func endRefreshing() {
        refreshFinishedCount -= 1
        if refreshFinishedCount == 0 {
            DispatchQueue.main.async {
                self.tableView.mj_header?.state = .idle
            }
        }
    }
    
    /// 呼叫管理机
    private func callManager(indexPath: IndexPath) {
        let micAuth = GlobalTools.checkPermissionsForMic()
        if micAuth == false {
            swiftDebug("呼叫管理机 麦克风权限没有")
            return
        }
        
        let cameraAuth = GlobalTools.checkPermissionsForCamera()
        if cameraAuth == false {
            swiftDebug("呼叫管理机 相机权限没有")
            return
        }
        
        let managerInfo = self.manageList[indexPath.row]
        let toName = getManagerName(manageInfo: managerInfo)
        
        if let accountInfo = AccountInfo.queryNow(),
           let cloudIntercomType = accountInfo.cloudIntercomType, cloudIntercomType == 1,
           managerInfo.devCode != "" && managerInfo.devCode != "jhrt0405" {
            swiftDebug("当前是新云对讲 呼叫")
            // 保存到数据库
            //DBOperation.insertOutCallrecords(with: toName)
            // 开始云对讲呼叫
            self.loginRoomFromZG(deviceInfo: managerInfo)
            return
        }
        
        guard let sipAddr = managerInfo.sipAddr, sipAddr != "" else {
            ProgressHUD.showText(NSLocalizedString("管理机暂时无法呼叫", comment: ""))
            return
        }
        
        swiftDebug("当前的内容: ", sipAddr, toName)

        //DBOperation.insertOutCallrecords(with: toName)
        
        //MainPhoneView.instance().dial(UCSCallType.videoCall, andCallid: sipAddr, andUserdata: toName, type: "manager")
    }
    
    
    /// 呼叫君和管家
    private func callHouseKeeper(indexPath: IndexPath) {
//        let micAuth = GlobalTools.checkPermissionsForMic()
//        if micAuth == false {
//            swiftDebug("呼叫管家 没有麦克风权限")
//            return
//        }
//
//        let cameraAuth = GlobalTools.checkPermissionsForCamera()
//        if cameraAuth == false {
//            swiftDebug("呼叫管家 没有相机权限")
//            return
//        }
//
//        let houseKeeperInfo = butlerList[indexPath.row]
//        //
//        guard let name = houseKeeperInfo.userName, let ucsUserId = houseKeeperInfo.ucsUserId else {
//            swiftDebug("判断数据是否为空")
//            return
//        }
//
//        var toName: String = String()
//
//        if let unitList = butlerList[indexPath.row].unitList, unitList.count > 0 {
//            // 管家 此处小区号不为空
//            toName = NSLocalizedString("管家", comment: "") + " \(String(describing: name))"
//        } else {
//            toName = NSLocalizedString("管理处", comment: "") + " \(String(describing: name))"
//        }
//        DBOperation.insertOutCallrecords(with: toName)
////        if let accountInfo = AccountInfo.queryNow(), let cloudIntercomType = accountInfo.cloudIntercomType, cloudIntercomType == 1 {
////            swiftDebug("当前是新云对讲 呼叫")
////            ProgressHUD.showText("不能呼叫管家")
////            return
////        }
//
//        MainPhoneView.instance().dial(UCSCallType.videoCall, andCallid: ucsUserId, andUserdata: toName, type: "butler")
    }
    
    /// 开始新云对讲唤起
    private func loginRoomFromZG(deviceInfo: PhoneCallManageList) -> Void {
        
        // 查询当前账号信息
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("获取用户信息为空")
            return
        }
        // 获取当前小区信息
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            swiftDebug("当前小区信息为空")
            return
        }
        // 获取当前房间信息
        guard let ownerRoom = OwnerRoom.queryNow() else {
            swiftDebug("当前房间的信息为空")
            return
        }
        var unitno = ""
        var roomno = ""
        var floorNo = ""
        if let unitnoTemp = ownerRoom.unitno {
            unitno = unitnoTemp
        }
        if let roomnoTemp = ownerRoom.roomno {
            roomno = roomnoTemp
        }
        if let floorNoTemp = ownerRoom.floorNo {
            floorNo = floorNoTemp
        }
        // 获取当前门口机的设备码
        guard let devCode = deviceInfo.devCode else {
            swiftDebug("当前设备码为空")
            return
        }
        swiftDebug("当前设备的信息:: ", deviceInfo)
        let cloudCallVC = CloudCallVC()
//        cloudCallVC.from = account //"15706772030"
//        cloudCallVC.to = devCode  //"54105036851858120a8e"
//        // 主动呼出
//        cloudCallVC.callType = CloudCallType.callout
        
        
        // 组织数据
//        let cloudDevice = ZegoCallDeviceData(devName: account, devType: 99, zoneId: zoneCode, unitNo: unitno, floorNo: floorNo, roomNo: roomno)
//        let cloudData = ZegoCallInfo(type: "Call", cmd: "calling", from: account, to: devCode, callObject: 0, data: cloudDevice, result: nil)
        // 转换成字典
//        guard let dataDict = ModelEncoder.encoder(toDictionary: cloudData) else {
//            swiftDebug("转换为字典失败")
//            return
//        }
        // 移除result字段
        //dataDict.removeValue(forKey: "result")
        // 赋值
//        cloudCallVC.data = dataDict
        // 弹出新云对讲页面
        self.present(cloudCallVC, animated: true, completion: nil)
    }
}

// MARK: 实现TableView的代理方法
/// 实现tableView的代理方法
extension ButlerServiceVC: UITableViewDelegate, UITableViewDataSource {
    /// section个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    /// cell个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.manageList.count
        case 1:
            return self.butlerList.count
        default:
            return 0
        }
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "管理机"
//        case 1:
//            return "管家"
//        default:
//            return ""
//        }
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40.0
//    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }
    
    /// 生成cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ButlerServiceCell = tableView.dequeueReusableCell(withIdentifier: kCallListTVCCEll, for: indexPath) as! ButlerServiceCell
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0://管理机
            cell.nickLabel.text = self.manageList[indexPath.row].alias
            cell.typeLabel.text = NSLocalizedString("管理机", comment: "")
            cell.messageButton.isHidden = true
            cell.onButtonExeCb { [unowned self] (eventType) in
                if case BLerEventType.call = eventType {
                    swiftDebug("呼叫管理机")
                    self.callManager(indexPath: indexPath)
                }
            }
            break
        case 1://君和管家
            cell.nickLabel.text = (self.butlerList[indexPath.row].userName) ?? ""
            if let unitList = self.butlerList[indexPath.row].unitList, unitList.count > 0 {
                // 管家 此处小区号不为空
                var unitName: String?
                for unitInfo in unitList {
                    let unitNameTemp: String = unitInfo.unitName!
                    if (unitName != nil) {
                        unitName?.append(" \n\(unitNameTemp)")
                    } else {
                        unitName = unitNameTemp
                    }
                }
                cell.typeLabel.text = NSLocalizedString(unitName!, comment: "")
            } else {
                cell.typeLabel.text = NSLocalizedString("管理处", comment: "")
            }
            cell.messageButton.isHidden = true
            cell.onButtonExeCb { [unowned self] (eventType) in
                if case BLerEventType.call = eventType {
                    swiftDebug("呼叫君和管家")
                    self.callHouseKeeper(indexPath: indexPath)
                }
            }
            break
        default:
            break
        }
        
        return cell
    }
    
    /// cell 动态高度
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

/// 管家服务cell
class ButlerServiceCell: UITableViewCell {
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        return imageView
    }()
    var nickLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(netHex: 0x457AA9)
        return label
    }()
    var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(netHex: 0x6F7179)
        label.font = UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "manager_meassge"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(onMessageButtonAction(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    lazy var callButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "answer_keys"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(onCallButtonAction(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    typealias OnButton = (BLerEventType) -> Void
    // 创建闭包
    var onButton: OnButton?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onButtonExeCb(onButton: @escaping OnButton) {
        self.onButton = onButton
    }
    
    /// 消息按钮动作方法
    @objc func onMessageButtonAction(_ button: UIButton) -> Void {
        if let onButton = onButton {
            onButton(.message)
        }
    }
    
    /// 呼叫按钮动作方法
    @objc func onCallButtonAction(_ button: UIButton) -> Void {
        if let onButton = onButton {
            onButton(.call)
        }
    }
    
}

extension ButlerServiceCell {
    
    private func setupSubviews() -> Void {
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.nickLabel)
        self.contentView.addSubview(self.typeLabel)
        self.contentView.addSubview(self.callButton)
        self.contentView.addSubview(self.messageButton)
        
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.nickLabel.translatesAutoresizingMaskIntoConstraints = false
        self.typeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.callButton.translatesAutoresizingMaskIntoConstraints = false
        self.messageButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 图标imageview
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 15.0), // 顶部
            NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 8.0), // 左边
            NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 40.0), // 宽
            NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 40.0), // 高
        ])
        // 昵称label
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.nickLabel, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.iconImageView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 8.0), // 左边
            NSLayoutConstraint(item: self.nickLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 10.0), // 顶部
            NSLayoutConstraint(item: self.nickLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 21.0), // 高度
        ])
        // 类型label
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.typeLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.nickLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 10.0), // 顶部
            NSLayoutConstraint(item: self.typeLabel, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.iconImageView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 8.0), // 左边
            NSLayoutConstraint(item: self.typeLabel, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.callButton, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: -5.0), // 右边
            NSLayoutConstraint(item: self.typeLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -10.0), // 底部
        ])
        // 呼叫按钮
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.callButton, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 15.0), // 顶部
            NSLayoutConstraint(item: self.callButton, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: -8.0), // 右边
            NSLayoutConstraint(item: self.callButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 40.0), // 宽度
            NSLayoutConstraint(item: self.callButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 40.0), // 高度
        ])
        // 消息按钮
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.messageButton, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 15.0), // 顶部
            NSLayoutConstraint(item: self.messageButton, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.callButton, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: -8.0), // 右边
            NSLayoutConstraint(item: self.messageButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 40.0), // 宽度
            NSLayoutConstraint(item: self.messageButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 40.0), // 高度
        ])
    }
}



/// 消息类型
enum BLerEventType {
    /// 消息
    case message
    /// 呼叫
    case call
}

/// 获取室内机/门口机的信息列表 返回内容
struct PhoneCallRes: Codable {
    /// 状态码
    var code: Int?
    /// 信息数据
    var data: PhoneCallData?
    /// 状态信息
    var message: String?
}

/// 室内机/门口机 返回数据
struct PhoneCallData: Codable {
    /// 门口机列表
    var manageList: [PhoneCallManageList]?
    /// 室内机列表
    var roomList: [PhoneCallRoomList]?
}

/// 门口机数据
struct PhoneCallManageList: Codable {
    /// 别名
    var alias: String?
    /// 设备码
    var devCode: String?
    /// 设备类型
    var devType: Int?
    /// 房间编号
    var roomno: String?
    /// 云对讲地址
    var sipAddr: String?
    /// 单元编号
    var unitno: String?
    /// 楼层号
    var floorNo: String?
}

/// 室内机数据
struct PhoneCallRoomList: Codable {
    /// 门口机列表
    var indoorList: [PhoneCallIndoorList]?
    /// 房间号
    var roomno: String?
    /// 单元名字
    var unitname: String?
    /// 单元号
    var unitno: String?
    /// 楼层号
    var floorNo: String?
}

/// 室内机信息
struct PhoneCallIndoorList: Codable {
    /// 别名
    var alias: String?
    /// 设备码
    var devCode: String?
    /// 设备类型
    var devType: Int?
    /// 房间编号
    var roomno: String?
    /// 云对讲地址
    var sipAddr: String?
    /// 单元编号
    var unitno: String?
}

/// 管家服务数据
struct PhoneCallButlerRes: Codable {
    /// 状态码
    var code: Int?
    /// 状态数据
    var data: [PhoneCallButlerData]?
    /// 状态消息
    var message: String?
}

/// 管家信息
struct PhoneCallButlerData: Codable {
    /// 账号
    var account: String?
    /// ID
    var id: Int?
    /// sip地址
    var sipAddr: String?
    /// ucs用户ID
    var ucsUserId: String?
    /// 单元列表
    var unitList: [PhoneCallButlerUnit]?
    /// 用户名字
    var userName: String?
}

// 小区信息
struct PhoneCallButlerUnit: Codable {
    /// 单元号
    var unitno: String?
    /// 单元名字
    var unitName: String?
}
