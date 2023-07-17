//
//  LoginVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/23.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK
import SnapKit

class LoginVC: UIViewController {
    
    private let cellID = "LoginVC"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var dataList: [String] = ["获取注册验证码", "自主注册账号", "获取登录验证码", "登录账号", "Token登录"]
    /// 注册验证码
    private var verifycodeReg: String = String()
    /// 登录验证码
    private var verifycodeLog: String = String()
    /// 测试账号
    private var account: String = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "用户登录"
        
        self.setupSubViews()
        
        // 设置测试账号
        self.account = "" // "18547070797"
    }
        
}

extension LoginVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let name = self.dataList[indexPath.row]
        switch name {
        case "获取注册验证码":
            self.getVerificationCodeRequest(account: self.account)
            break
        case "自主注册账号":
            // 弹出输入验证码的对话框
            let alertVC = UIAlertController(title: "提示", message: "注册账号", preferredStyle: UIAlertController.Style.alert)
            alertVC.addTextField { textField in
                textField.placeholder = "输入短信验证码"
                textField.keyboardType = .numberPad
            }
            alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            }))
            alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
                if let textFields = alertVC.textFields, let textFiled = textFields.first, let verifycode = textFiled.text {
                    if verifycode != "" {
                        self.userRegisteredRequest(account: self.account, verifycode: verifycode)
                    } else {
                        debugPrint("请输入验证码")
                    }
                }
            }))
            self.present(alertVC, animated: true, completion: nil)
            break
        case "获取登录验证码":
            
            self.phoneSmsCodeRequest(account: self.account)
            break
        case "登录账号":
            debugPrint("开始登录账号")
            // 弹出输入验证码的接口
            let alertVC = UIAlertController(title: "提示", message: "登录账号", preferredStyle: UIAlertController.Style.alert)
            alertVC.addTextField { textField in
                textField.placeholder = "输入短信验证码"
                textField.keyboardType = .numberPad
            }
            alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            }))
            alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
                if let textFields = alertVC.textFields, let textFiled = textFields.first, let verifycode = textFiled.text {
                    if verifycode != "" {
                        self.phoneLoginRequest(account: self.account, verifycode: verifycode)
                    } else {
                        debugPrint("请输入验证码")
                    }
                }
            }))
            self.present(alertVC, animated: true, completion: nil)
            break
        case "Token登录":
            //self.accountRegisterRequest()
            //self.accountRequest()
            // 客户使用SDK登录
            self.appUserLoginRequest()
            break
        default:
            break
        }
    }
    
}

/// 网络请求
extension LoginVC {
    
    /// SDK登录获取Token(客户使用)
    private func appUserLoginRequest() -> Void {
        debugPrint("token登录")
        // 设置初始化
        //CloudWorkAPI.initCloudAPI(appId: "55deabd864df42afa4a779811f0a668c", key: "568f5ac2a827d161a12e1a052e5b6cc7")
        //CloudWorkAPI.appId = "55deabd864df42afa4a779811f0a668c"
        //CloudWorkAPI.key = "568f5ac2a827d161a12e1a052e5b6cc7"
        // 18547070797
        CloudWorkAPI.appUserLogin(account: "", zone: "8600") { object in
            debugPrint("SDK初始化登录", object as Any)
            
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            
            guard let res = try? ModelDecoder.decode(AppUserLoginRes.self, param: object as! [String : Any]) else {
                debugPrint("AppUserLoginRes 转换Model失败")
                return
            }
            debugPrint("返回内容:  ", res)
            
            // token赋值
            switch res.code {
            case 200: // 登录成功
                if let data = res.data {
                    
                    UserTokenLogin.zoneCode = data.zoneCode!
                    UserTokenLogin.tokenauth = data.tokenauth!
                    UserTokenLogin.tokencode = data.tokencode!
                    
                    // 跳转到小区页面
                    let zoneListVC = ZoneListVC()
                    zoneListVC.account = "" //"18547070797"
                    //zoneListVC.zoneList = zonelist
                    self.navigationController?.pushViewController(zoneListVC, animated: true)
                }
                break
            default:
                break
            }
        }
    }
    
    /// 刷新数据库token
    private func insertOrUpdateUserInfo(data: AppUserLoginData) -> Void {
        
        guard var accountInfo = AccountInfo.query(account: self.account) else {
            var accountInfo = AccountInfo()
            accountInfo.account = self.account
            accountInfo.ablecloudToken = data.ablecloudToken
            accountInfo.ablecloudUid = data.ablecloudUid
            accountInfo.isPrimary = data.isPrimary
            accountInfo.tokenauth = data.tokenauth
            accountInfo.tokencode = data.tokencode
            accountInfo.ucsToken = data.ucsToken
            accountInfo.userId = data.userId
            accountInfo.userStatus = data.userStatus
            accountInfo.selected = true
            // 插入到数据库
            AccountInfo.insert(accountInfo: accountInfo)
                                        
            return
        }
        
        accountInfo.ablecloudToken = data.ablecloudToken
        accountInfo.ablecloudUid = data.ablecloudUid
        accountInfo.isPrimary = data.isPrimary
        accountInfo.tokenauth = data.tokenauth // 请求token
        accountInfo.tokencode = data.tokencode
        accountInfo.ucsToken = data.ucsToken
        accountInfo.userId = data.userId
        accountInfo.userStatus = data.userStatus
        accountInfo.selected = true
        // 数据库表中存在该信息 需要更新
        AccountInfo.update(accountInfo: accountInfo)
        
    }
        
    
    /// 查询账号信息
    private func accountRequest() -> Void {
        CloudWorkAPI.account(accout: "13590307053") { object in
            debugPrint("查询账号信息: ", object as Any)
        }
    }
    
    
    /// 注册账号
    private func accountRegisterRequest() -> Void {
        CloudWorkAPI.accountRegister(account: "13590307053") { object in
            debugPrint("测试接口内容:: ", object as Any)
        }
    }
        
    /// 登录接口
    private func phoneLoginRequest(account: String, verifycode: String) -> Void {
        PhoneWorkAPI.phoneLogin(account: account, verifycode: verifycode) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            guard let res = try? ModelDecoder.decode(PhoneLoginRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneLoginRes 转换Model失败")
                return
            }
            debugPrint("登录接口请求: ", object as Any)

            switch res.code {
            case 200:
                if let data = res.data, let zonelist = data.zonelist {
                    let zoneListVC = ZoneListVC()
                    zoneListVC.account = account
                    zoneListVC.zoneList = zonelist
                    self.navigationController?.pushViewController(zoneListVC, animated: true)
                }
                break
            default:
                break
            }            
        }
    }
    
    /// 获取验证码接口
    private func phoneSmsCodeRequest(account: String) -> Void {
        PhoneWorkAPI.phoneSmsCode(account: account) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            
            if object is Error {
                debugPrint("内容错误")
                return
            }
            guard let res = try? ModelDecoder.decode(PhoneSmscodeRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneSmscodeRes 转换Model失败")
                return
            }
            debugPrint("获取验证码请求: ", object as Any)
            switch res.code {
            case 200:
                debugPrint("获取登录验证码成功")
                break
            case 400:
                debugPrint("获取登录验证码失败")
                break
            default:
                debugPrint("获取登录验证码 其他错误")
                break
            }
        }
    }
        
    /// 自主注册 验证码
    private func getVerificationCodeRequest(account: String) -> Void {
        PhoneWorkAPI.getVerificationCode(account: account) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            
            if object is Error {
                debugPrint("内容错误")
                return
            }
            guard let res = try? ModelDecoder.decode(GetVerificationCodeRes.self, param: object as! [String : Any]) else {
                debugPrint("GetVerificationCodeRes 转换Model失败")
                return
            }
            debugPrint("自主注册验证码: ", object as Any)
            switch res.code {
            case 200: // 验证码 短信获取
                debugPrint("获取验证码 成功")
                break
            case 400:
                debugPrint("获取验证码 失败")
                break
            default:
                break
            }
        }
    }
    
    /// 自主注册账号
    private func userRegisteredRequest(account: String, verifycode: String) -> Void {
        PhoneWorkAPI.userRegistered(account: account, verifycode: verifycode) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            
            guard let res = try? ModelDecoder.decode(UserRegisteredRes.self, param: object as! [String : Any]) else {
                debugPrint("UserRegisteredRes 转换Model失败")
                return
            }
            debugPrint("自主注册账号: ", object as Any)
            switch res.code {
            case 200:
                debugPrint("注册账号 成功")
                break
            case 400:
                debugPrint("注册账号 失败")
                break
            default:
                debugPrint("注册账号 其他情况")
                break
            }
        }
    }
    
}



extension LoginVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


/// 登录成功返回
struct PhoneLoginRes: Codable {
    /// 返回码
    var code: Int?
    /// 返回数据
    var data: PhoneLoginData?
    /// 操作结果信息
    var message: String?
}

/// 登录成功的数据
struct PhoneLoginData: Codable {
    /// 智能家居
    var ablepwd: String?
    /// 比邻客
    var belinker: String?
    /// 小区列表
    var zonelist: [Zone]?
}

struct PhoneSmscodeRes: Codable {
    var code: Int?
    var message: String?
}

struct UserRegisteredRes: Codable {
    var code: Int?
    var message: String?
}

struct GetVerificationCodeRes: Codable {
    var code: Int?
    var message: String?
}


struct AppUserLoginRes: Codable {
    var code: Int?
    var data: AppUserLoginData?
    var message: String?
}

struct AppUserLoginData: Codable {
    var ablecloudToken: String?
    var ablecloudUid: Int? // String?
    var isPrimary: Int?
    var tokenauth: String?
    var tokencode: String? //Int?
    var ucsToken: String?
    var userId: Int?
    var userStatus: Int?
    var zoneCode: String?
}
