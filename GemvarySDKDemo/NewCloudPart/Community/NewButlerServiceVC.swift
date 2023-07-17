//
//  NewButlerServiceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/20.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK
import SnapKit

class NewButlerServiceVC: UIViewController {

    private let cellID = "NewButlerServiceCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private var manageList = [PhoneCallManageList]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var butlerList = [PhoneCallButlerData]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let groupData: [String] = ["管理机", "管家"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "管家服务"
        
        self.setupSubViews()
        
        self.phoneCallRequest()
        self.phoneCallButlerRequest()
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

extension NewButlerServiceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        switch section {
        case 0:
            number = self.manageList.count
            break
        default:
            number = self.butlerList.count
            break
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groupData[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension NewButlerServiceVC {
    
    ///  室内机/门口挤信息列表
    private func phoneCallRequest() -> Void {
        ScsPhoneWorkAPI.phoneCall { object in
            swiftDebug("呼叫信息列表: ", object as Any)
            // 解析返回数据内容 转model
            guard let object: [String: Any] = object as? [String: Any], let res = try? ModelDecoder.decode(PhoneCallRes.self, param: object) else {
                swiftDebug("PhoneCallRes 转换Model失败")
                return
            }
            swiftDebug("转换后的model内容::: ", res)
            // 判断返回数据状态码
            switch res.code {
            case NetResCode.c200: // 成功
                if let data = res.data, let manageList = data.manageList {
                    self.manageList = manageList
                }
                break
            case NetResCode.c400: // 失败
                break
            case NetResCode.c552: // 免登录
                NewUserTokenLogin.loginWithToken {
                    self.phoneCallRequest()
                }
                break
            default:
                
                break
            }
        }
    }
    
    /// 管家列表
    private func phoneCallButlerRequest() -> Void {
        ScsPhoneWorkAPI.phoneCallButler { object in
            swiftDebug("请求君和管家数据内容", object as Any)
            // 解析返回数据内容 转model
            guard let obejct: [String: Any] = object as? [String: Any], let res = try? ModelDecoder.decode(PhoneCallButlerRes.self, param: obejct) else {
                swiftDebug("PhoneCallButlerRes 转换Model失败")
                return
            }
            swiftDebug("请求君和管家的数据", res)
            // 判断返回数据状态码
            switch res.code {
            case NetResCode.c200: // 成功
                if var data = res.data {
//                    data.removeAll(where: { (model) -> Bool in
//                        if model.account == account {
//                            // 遍历信息 如果管家账号等于自己账号 则删除该管家信息
//                            return true
//                        } else {
//                            return false
//                        }
//                    })
                    /// 管家列表赋值
                    self.butlerList = data
                }
                break
            case NetResCode.c400: // 失败
                break
            case NetResCode.c552: // 免登录
                NewUserTokenLogin.loginWithToken {
                    self.phoneCallButlerRequest()
                }
                break
            default:
                break
            }
        }
    }
    
}

extension NewButlerServiceVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
