//
//  InvitationDataVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/25.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK

class InvitationDataVC: UIViewController {
    
    private var addButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("添加", for: UIControl.State.normal)
        return button
    }()
    
    
    
    var invitation: InvitationData = InvitationData() {
        didSet {
            
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "邀请函"
        self.view.backgroundColor = UIColor.white
    }

    
}

extension InvitationDataVC {
    
    /// 添加邀请函请求
    private func phoneInvitationVisitorCardAddRequest() -> Void {
        
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account, account != "" else {
            swiftDebug("当前用户账号为空")
            return
        }
        
        /// 设置邀请函内容
        let visitors = [Visitor(visitorName: "测试1", visitorPhone: account, carNumber: "", faceImg: "", invitationId: 0, id: 0, visitorEndTime: "")]
        
        self.invitation = InvitationData(account: account, authCode: "", createTime: "", dynamicPassword: "", endTime: "", floorNo: "", id: 0, roomno: "", startTime: "", theme: "", unitName: "", unitno: "", updateTime: "", address: "", zoneName: "", zoneCode: "", visitors: visitors)
        
        guard var body = ModelEncoder.encoder(toDictionary: self.invitation) else {
            debugPrint("转换字典失败")
            return
        }
        if body.keys.contains("id") == true {
            body.removeValue(forKey: "id")
        }
        
        PhoneWorkAPI.phoneInvitationVisitorCardAdd(body: body) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            guard let res = try? ModelDecoder.decode(PhoneInvitationVisitorCardAddRes.self, param: object as! [String : Any]) else {
                debugPrint("InvitationCardAddRes 转换Model失败")
                return
            }
            switch res.code {
            case 200:
                debugPrint("添加邀请函成功")
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.phoneInvitationVisitorCardAddRequest()
                }
                break
            default:
                break
            }
        }
    }
    
    private func phoneRandpwdGenRequest() -> Void {
        // 生成6位随机动态密码
        let password = self.genRandomPwdString(number: 6)
        // 上传访客的开门信息 （有效时长 单位为小时）
        PhoneWorkAPI.phoneRandpwdGen(code: password, fromTime: "", roomNo: "", unitNo: "", validTime: 0, floorNo: "") { object in
            
        }
    }
    
    /// 生成随机数字密码
    private func genRandomPwdString(number: NSInteger) -> String {
        
        var password = String()
        for _ in 0..<number {
            password.append(String(format: "%d", arc4random_uniform(10)))
        }
        return password
    }
    
    
}

struct PhoneInvitationVisitorCardAddRes: Codable {
    var code: Int?
    var data: String?
    var message: String?
}

