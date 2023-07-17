//
//  NoticeListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/25.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK
import SnapKit

class NoticeListVC: UIViewController {

    private let cellID = "NoticeListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    private var nowPage: Int = 0
    private var pageSize: Int = 20
    private var dataList: [Notice] = [Notice]() {
        didSet {
            self.tableView.reloadData()
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "通知"
        self.setupSubView()
        
        self.pubNoticeListRequest()
    }
    
}

extension NoticeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        
        let notice = self.dataList[indexPath.row]
        if let title = notice.title, let pushtime = notice.pushtime {
            cell.textLabel?.text = "\(title)   \(pushtime)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let noticeDetailVC = NoticeDetailVC()
        noticeDetailVC.notice = self.dataList[indexPath.row]
        self.navigationController?.pushViewController(noticeDetailVC, animated: true)        
    }
}

extension NoticeListVC {
    
    private func pubNoticeListRequest() -> Void {
        guard let zone = Zone.queryNow(), let zoneCode = zone.zoneCode else {
            debugPrint("")
            return
        }
        
        PubWorkAPI.pubNoticeList(zoneCode: zoneCode, page: self.nowPage, size: self.pageSize) { object in
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            if object is Error {
                debugPrint("内容错误")
                return
            }
            debugPrint("通知信息:: ", object as Any)
            guard let res = try? ModelDecoder.decode(PubNoticeListRes.self, param: object as! [String : Any]) else {
                debugPrint("PubNoticeListRes 转换数据失败")
                return
            }
            switch res.code {
            case 200:
                if let data = res.data, let data_data = data.data {
                    if self.nowPage == 0 {
                        self.dataList = data_data
                    } else {
                        self.dataList.append(contentsOf: data_data)
                    }
                    if data_data.count < self.pageSize  {
                        // 没有更多数据
                        //self.loadMoreView.noMoreData()
                    } else {
                        self.nowPage = self.nowPage + 1
                    }
                }
                break
            case 552:
                UserTokenLogin.loginWithToken { result in
                    self.pubNoticeListRequest()
                }
                break
            default:
                break
            }
            
        }
    }
    
}

extension NoticeListVC {
    
    private func setupSubView() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

struct PubNoticeListRes: Codable {
    var code: Int?
    var data: PubNoticeListData?
    var message: String?
}

struct PubNoticeListData: Codable {
    var data: [Notice]?
    var pageCount: Int?
}
