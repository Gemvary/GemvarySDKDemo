//
//  NewKeyBagListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/20.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK
import SnapKit

class NewKeyBagListVC: UIViewController {
    
    private let cellID = "NewKeyBagListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
        
    private var dataList: [PhoneGetAllOutdoorData] = [PhoneGetAllOutdoorData]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "钥匙包"
        self.setupSubViews()
        self.phoneGetAllOutdoorRequest()
    }
    
}

extension NewKeyBagListVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
    }
}

extension NewKeyBagListVC {
     
    private func phoneGetAllOutdoorRequest() -> Void {
        ScsPhoneWorkAPI.phoneGetAllOutdoor { object in
            swiftDebug("钥匙包请求设备列表:: ", object as Any)
            guard let object = object else {
                return
            }
            if object is Error {
                return
            }
            guard let object: [String: Any] = object as? [String: Any], let res = try? ModelDecoder.decode(PhoneGetAllOutdoorRes.self, param: object) else {
                swiftDebug("PhoneGetAllOutdoorRes 转换Model失败")
                return
            }

            switch res.code {
            case NetResCode.c200: // 成功
                if let data = res.data {
                    self.dataList = data
                }
                break
            case NetResCode.c552: // 免登录
                NewUserTokenLogin.loginWithToken {
                    self.phoneGetAllOutdoorRequest()
                }
                break
            default:
                swiftDebug("请求钥匙包列表 失败 \(res.message!)")
                break
            }
        }
    }
    
    private func phoneMsgForward(devCode: String) -> Void {
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            return
        }
        
        ScsPhoneWorkAPI.phoneMsgForward(zoneCode: zoneCode, devcode: devCode) { object in
            guard let object = object else {
                return
            }
            if object is Error {
                return
            }
            
        }
        
        ScsPhoneWorkAPI.phoneMsgForward(zoneCode: zoneCode, devcode: devCode, msgType: 15) { object in
            guard let object = object else {
                return
            }
            if object is Error {
                return
            }
            
        }
        
    }
        
}

extension NewKeyBagListVC {
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
