//
//  NewLoginAuthVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/19.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryCommonSDK
import GemvaryToolSDK
import SnapKit

class NewLoginAuthVC: UIViewController {

    private let cellID: String = "NewLoginAuthCell"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private let dataList: [String] = ["登录验证码", "登录账号", "注册验证码", "注册账号", "一键登录"]
        
    /// 用户信息
    private var accountInfo: AccountInfo = AccountInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新云端登录"
        
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

extension NewLoginAuthVC {
    
    /// 登录验证码获取
    private func loginAuthCodeFetch() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "登录验证码获取", preferredStyle: UIAlertController.Style.alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入账号"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 登录账号
    private func loginAccountAction() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "新云端账号登录", preferredStyle: UIAlertController.Style.alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入手机号"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alertVC.addTextField { textField in
            textField.placeholder = "请输入验证码"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            // 登录操作
            guard let textFields = alertVC.textFields, let accountTextFiled = textFields.first, let authTextFiled = textFields.last, let account = accountTextFiled.text, let authCode = authTextFiled.text else {
                swiftDebug("获取账号和验证码失败")
                return
            }
            
            // 验证码登录
            let verifyCodeLogin = VerificationCodeLogin(account: account, verifyCode: authCode)
            // 获取字典类型
            guard let body = ModelEncoder.encoder(toDictionary: verifyCodeLogin) else {
                swiftDebug("model转换字典失败")
                return
            }
            self.accountInfo.account = account
            // 登录请求
            self.authLoginRequest(body: body, loginType: LoginType.verify_code)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 注册验证码
    private func registerAuthCodeFetch() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "注册验证码", preferredStyle: UIAlertController.Style.alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入账号"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 注册账号
    private func registerAccountAction() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "注册新云端账号", preferredStyle: UIAlertController.Style.alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入账号"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alertVC.addTextField { textField in
            textField.placeholder = "请输入验证码"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 一键登录
    private func oneKeyLoginAction() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "是否一键登录", preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}


extension NewLoginAuthVC {
    
    /// 登录的请求
    private func authLoginRequest(body: [String: Any], loginType: String) -> Void {
        // 登录请求
        RequestAPI.authLogin(body: body) { (status, object) in
            swiftDebug("登录 返回内容: ", status as Any, JSONTool.translationObjToJson(from: object as Any) as Any)
            switch status {
            case StatusCode.c200: // 成功
                ProgressHUD.showText("登录成功")
                guard object != nil, let res = try? ModelDecoder.decode(AuthLoginData.self, param: object as! [String : Any]) else {
                    swiftDebug("解析数据失败")
                    return
                }
                // 所有设置为默认
                AccountInfo.setupAllDefault()
                // 判断是否是一键登录 解析获取当前的手机号

                guard let access_token = res.access_token else {
                    swiftDebug("token为空")
                    return
                }
                // 解析token
                let access_token_jwt = JWTDecode.decode(jwtToken: access_token)
                // 解析jwt
                guard let jwtDict = try? ModelDecoder.decode(JWTAccessTokenDecode.self, param: access_token_jwt) else {
                    swiftDebug("解析失败")
                    return
                }
                // 获取当前电话号
                self.accountInfo.account = jwtDict.preferred_username

                swiftDebug("查询当前账号信息:: ", self.accountInfo as Any)

                if var accountInfo = AccountInfo.query(accountInfo: self.accountInfo) {
                    // 保存用户数据
                    accountInfo.access_token = res.access_token
                    accountInfo.expires_in = res.expires_in
                    accountInfo.refresh_token = res.refresh_token
                    accountInfo.refresh_expires_in = res.refresh_expires_in
                    accountInfo.token_type = res.token_type
                    accountInfo.selected = true
                    // 更新账户信息保存到数据库
                    AccountInfo.update(accountInfo: accountInfo)
                } else {
                    // 保存用户数据
                    self.accountInfo.access_token = res.access_token
                    self.accountInfo.expires_in = res.expires_in
                    self.accountInfo.refresh_token = res.refresh_token
                    self.accountInfo.refresh_expires_in = res.refresh_expires_in
                    self.accountInfo.token_type = res.token_type
                    self.accountInfo.selected = true
                    // 创建账户信息保存到数据库
                    AccountInfo.insert(accountInfo: self.accountInfo)
                }

                swiftDebug("查询当前账号信息222:: ", self.accountInfo as Any)

                
                // token赋值
                if let access_token = res.access_token {
                    // 新云端token赋值
                    NewCloudNetParam.access_token = access_token
                }
                
                // 跳转到小区列表页面
                let zoneListVC = NewZoneListVC()
                if let account = self.accountInfo.account {
                    zoneListVC.account = account
                }
                
                if loginType == LoginType.local_phone {
                    // 一键登录
//                    JVERIFICATIONService.dismissLoginController(animated: false) {
//                        if let naviVC = self.navigationController {
//                            naviVC.pushViewController(zoneListVC, animated: true)
//                        }
//                    }
                    return
                }
                // 账号密码登录
                if let naviVC = self.navigationController {
                    // 跳转到小区列表
                    naviVC.pushViewController(zoneListVC, animated: true)
                }
                break
            case StatusCode.c400: // 请求错误
                ProgressHUD.showText("登录失败")
                break
            case StatusCode.c401: // 未鉴权认证
//                UserTokenLogin.loginWithToken {
//                }
                break
            default:
                ProgressHUD.showText("登录失败")
                break
            }
        }
    }
    
}

extension NewLoginAuthVC: UITableViewDelegate, UITableViewDataSource {
    
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
        switch indexPath.row {
        case 0: // 登录验证码
            self.loginAuthCodeFetch()
            break
        case 1: // 登录账号
            self.loginAccountAction()
            break
        case 2: // 注册验证码
            self.registerAuthCodeFetch()
            break
        case 3: // 注册账号
            self.registerAccountAction()
            break
        case 4: // 一键登录
            self.oneKeyLoginAction()
            break
            // 授权登录
        default:
            break
        }
    }
    
}


extension NewLoginAuthVC {
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

/// 登录返回的数据内容
struct AuthLoginData: Codable {
    /// 认证token
    var access_token: String?
    ///
    var expires_in: Int?
    /// 刷新Token
    var refresh_token: String?
    /// 刷新认证token
    var refresh_expires_in: Int?
    /// token类型
    var token_type: String?
}

struct JWTAccessTokenDecode: Codable {
    var preferred_username: String?
}

/// 登录类型
struct LoginType {
    /// 验证码登录
    static let verify_code = "verify_code"
    /// 本地一键登录
    static let local_phone = "local_phone"
    /// 账号密码登录
    static let password = "password"
}

/// 验证码登录
struct VerificationCodeLogin: Codable {
    /// 登录类型
    var type: String? = LoginType.verify_code
    /// 手机号码
    var account: String?
    /// 短信验证码
    var verifyCode: String?
    
    /// 初始化方法
    init(account: String, verifyCode: String) {
        self.account = account
        self.verifyCode = verifyCode
    }
}
