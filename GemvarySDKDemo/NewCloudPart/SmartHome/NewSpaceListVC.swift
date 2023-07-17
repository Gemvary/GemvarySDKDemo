//
//  NewSpaceListVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2023/7/13.
//

import UIKit
import SnapKit
import GemvaryToolSDK

/// 新空间列表
class NewSpaceListVC: UIViewController {
    
    private let cellID = "NewSpaceListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
            
    private var spaceList: [Space] = [Space]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "空间列表"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 请求空间列表
        self.iotSpaceList()
    }
    
}

extension NewSpaceListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spaceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let space = self.spaceList[indexPath.row]
        if let name = space.name {
            cell.textLabel?.text = "\(name)"
        } else {
            cell.textLabel?.text = "空间名字为空"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let space = self.spaceList[indexPath.row]
        
        
        let alertVC = UIAlertController(title: "提示", message: "是否选择该空间", preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            self.selectSpace(space: space)
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        self.present(alertVC, animated: true)
    }
}
          

extension NewSpaceListVC {
    
    /// 选择空间
    private func selectSpace(space: Space) -> Void {
        swiftDebug("点击空间信息: ", space)
        // 设置当前空间
        // 更新当前账号数据
        guard var accountInfo = AccountInfo.queryNow() else {
            swiftDebug("当前账号信息为空")
            return
        }
        // 空间ID赋值
        accountInfo.spaceID = space.id
        // 智能家居主机设备码设置为空
        accountInfo.smartDevCode = nil
        // 更新账号信息
        AccountInfo.update(accountInfo: accountInfo)
        // 空间名字
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            // 连接当前空间
            WebSocketHandler.connectCurrentSpace()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
                // 发送智能家居初始化数据
                self.sendInitData()
            }
        }
    }
    
    
    /// 获取空间列表
    private func iotSpaceList() -> Void {
        SpaceHandler.iotSpaceList { success in
            swiftDebug("成功", success as Any)
            // 获取空间列表
            guard let success = success, let spaceList: [[String: Any]] = JSONTool.translationJsonToArray(from: success) as? [[String: Any]] else {
                swiftDebug("解析数组数据失败")
                return
            }
            
            
            guard let dataList = try? ModelDecoder.decode(Space.self, array: spaceList) else {
                swiftDebug("转换数据失败")
                return
            }
            
            self.spaceList = dataList
                        
            /*
             [{\"unitNo\":null,\"status\":0,\"defaultSpace\":false,\"roomNo\":null,\"owner\":\"\",\"zoneCode\":\"ABCD\",\"alias\":\"\",\"tOrgId\":null,\"name\":\"ghh\",\"zoneName\":\"测试\",\"id\":\"1663d61d648540d6ba94afd336e0567e\",\"attr\":\"住宅\",\"propertyId\":null,\"floorNo\":null,\"lessee\":null,\"orgName\":null,\"propertyName\":null,\"orgId\":0,\"address\":\"{}\",\"description\":\"rff\"}]
             */
            
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 发送智能家居初始化数据
    private func sendInitData() -> Void {
        
        guard let accountInfo = AccountInfo.queryNow(), let account  = accountInfo.account, account != "" else {
            swiftDebug("当前用户账号为空")
            return
        }
        
        let device_manager_query = [
            "msg_type": "device_manager", // 设备管理
            "command": "query",
            "from_role": "phone",
            "from_account": account,
            "room_name": "",
            "dev_name": "",
            "query_all": "yes",
        ]
                
        let room_manager_query = [
            "msg_type" : "room_manager", // 房间管理
            "command" : "query",
            "from_role" : "phone",
            "from_account" : account,
            "room_name" : ""
        ]
        
        let scene_control_manager_query_all = [
            "msg_type" : "scene_control_manager", // 场景
            "command" : "query_all",
            "from_role" : "phone",
            "from_account" : account,
        ]
        
        let device_class_info_query = [
            "msg_type": "device_class_info", // 设备类型
            "command": "query",
            "from_role": "phone",
            "from_account": account,
            "riu_id": 0, // 默认0
        ] as [String : Any]
        
        let sendList = [device_manager_query, room_manager_query, scene_control_manager_query_all, device_class_info_query]
        for data_dict in sendList {
            guard let data_json = JSONTool.translationObjToJson(from: data_dict) else {
                //self.sendDataToMQTT(sendMag: data_json)
                swiftDebug("字典转换字符串失败")
                return
            }
            swiftDebug("准备发送的字符串数据: ", data_json)
            // 当前空间发送智能家居数据(新云端空间发送数据)
            RequestHandler.iotGatewayProxy(data: data_json) { (success) in
                swiftDebug("查询智能家居信息 成功", success as Any)
                
                if let success = success, let jsonDic = JSONTool.translationJsonToDic(from: success) {
                    // 处理返回的数据内容
                    ProtocolHandler.jsonStrData(jsonDic: jsonDic)
                }
            } failedCallback: { (failed) in
                swiftDebug("查询智能家居信息 失败", failed as Any)
            }
        }
        // 订阅数据
        //self.reviceMessageData()
    }
    
}
