//
//  InvitationListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/25.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK
import SnapKit

class InvitationListVC: UIViewController {

    private let cellID = "InvitationListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    private var dataList: [InvitationData] = [InvitationData]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "邀请函"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(onRightBarButtonItem(_:)))
        
        self.setupSubView()
        
        self.phoneGetInvitationListRequest()
    }
    
    @objc func onRightBarButtonItem(_ button: UIBarButtonItem) -> Void {
        let invitationDataVC = InvitationDataVC()
        //invitationDataVC.addMode = true
        self.navigationController?.pushViewController(invitationDataVC, animated: true)
    }
    
    
}

extension InvitationListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let invitation = self.dataList[indexPath.row]
        if let theme = invitation.theme {
            cell.textLabel?.text = theme
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invitation = self.dataList[indexPath.row]
        if let id = invitation.id {
            self.phoneGetInvitationDetailRequest(id: id)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "删除") { (action, indexPath) in
            tableView.setEditing(false, animated: true)
            // 获取邀请函当前的内容
            let invitation = self.dataList[indexPath.row]
            debugPrint("点击删除按钮", invitation)
            // 邀请函删除
            if let id = invitation.id {
                self.phoneInvitationVisitorCardDelReqeust(id: id)
            }
        }
        return [deleteAction]
    }
    
}

extension InvitationListVC {
    /// 邀请函列表
    private func phoneGetInvitationListRequest() -> Void {
        
        PhoneWorkAPI.phoneGetInvitationList { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            guard let res = try? ModelDecoder.decode(PhoneGetInvitationListRes.self, param: object as! [String : Any]) else {
                debugPrint("InvitationCardAddRes 转换Model失败")
                return
            }
            switch res.code {
            case 200:
                if let data = res.data {
                    self.dataList = data
                }
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.phoneGetInvitationListRequest()
                }
            default:
                break
            }
        }
    }
    
    /// 邀请函详情
    private func phoneGetInvitationDetailRequest(id: Int) -> Void {
        PhoneWorkAPI.phoneGetInvitationDetail(id: id) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            guard let res = try? ModelDecoder.decode(PhoneGetInvitationDetailRes.self, param: object as! [String : Any]) else {
                debugPrint("InvitationCardAddRes 转换Model失败")
                return
            }
            
            switch res.code {
            case 200:
                if let data = res.data {
                    let invitationDataVC = InvitationDataVC()
                    invitationDataVC.invitation = data
                    self.navigationController?.pushViewController(invitationDataVC, animated: true)
                }
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.phoneGetInvitationDetailRequest(id: id)
                }
                break
            default:
                break
            }
            
        }
    }
    
    /// 邀请函删除
    private func phoneInvitationVisitorCardDelReqeust(id: Int) -> Void {
        PhoneWorkAPI.phoneInvitationVisitorCardDel(id: id) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            guard let res = try? ModelDecoder.decode(PhoneInvitationVisiotrCardDelRes.self, param: object as! [String : Any]) else {
                debugPrint("PhoneInvitationVisiotrCardDelRes 转换Model失败")
                return
            }
            switch res.code {
            case 200:
                debugPrint("删除成功 刷新邀请函列表")
                self.phoneGetInvitationListRequest()
                break
            case 400:
                debugPrint("删除失败")
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.phoneInvitationVisitorCardDelReqeust(id: id)
                }
                break
            default:
                break
            }
        }
    }
    
}


extension InvitationListVC {
     
    private func setupSubView() -> Void {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


struct PhoneGetInvitationListRes: Codable {
    var code: Int?
    var data: [InvitationData]?
    var message: String?
}

struct InvitationData: Codable {
    var account: String?
    var authCode: String?
    var createTime: String?
    var dynamicPassword: String?
    var endTime: String?
    var floorNo: String?
    var id: Int?
    var roomno: String?
    var startTime: String?
    var theme: String?
    var unitName: String?
    var unitno: String?
    var updateTime: String?
    var address: String?
    var zoneName: String?
    var zoneCode: String?
    var visitors: [Visitor]?
}

struct Visitor: Codable {
    var visitorName: String?
    var visitorPhone: String?
    var carNumber: String?
    var faceImg: String?
    var invitationId: Int?
    var id: Int?
    var visitorEndTime: String?
}

struct PhoneGetInvitationDetailRes: Codable {
    var code: Int?
    var data: InvitationData?
    var message: String?
}

struct PhoneInvitationVisiotrCardDelRes: Codable {
    var code: Int?
    var data: String?
    var message: String?
}
