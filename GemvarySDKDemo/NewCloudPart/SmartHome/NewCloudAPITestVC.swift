//
//  NewCloudAPITestVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/20.
//

import UIKit
import GemvaryToolSDK
import GemvaryCommonSDK
import GemvarySmartHomeSDK
import SnapKit

class NewCloudAPITestVC: UIViewController {

    private let cellID = "NewCloudAPITestCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()

    private let dataList: [[String]] = [
        [
            "获取验证码",
            "获取用户相关的项目列表",
            "网关代理请求",
            "根据空间ID发送数据",
            "根据GID获取产品信息",
            "请求新云端Weex版本信息",
            "下载新云端weex的zip包",
            "海贝斯设备猫眼信息",
            "批量删除(清空)消息记录",
            "坚朗之家 请求ipa包的版本",
            "天气请求接口",
            "获取用户相关房间列表",
            "查询已分享的设备列表",
            "根据设备参数获取产品信息",
        ], //"常用请求 Request",
        [
            "添加空间",
            "修改空间",
            "删除空间",
            "获取空间列表",
            "获取可用空间列表",
            "获取空间状态",
            "出租空间",
            "收回空间",
            "转让空间",
            "分享设备给其他用户",
            "接受其他人分享的设备",
            "获取当前空间的设备分享给了哪些用户",
            "查询其他人分享的设备列表",
            "查询当前设备分享记录",
            "取消分享给某个用户",
            "获取指定空间的房东或租户",
            "获取用户相关组织下空间的所有房东或租户",
            "获取指定组织下的空间房东或租户",
            "空间退租",
            "获取指定组织下的空间列表",
            "获取其他用户可用的空间列表",
            "添加用户到指定空间的组织以及授权",
            "修改空间用户名称及权限",
            "从指定空间的组织移除用户与取消授权",
        ], //"空间 Space",
        [
            "添加组织",
            "添加组织及成员",
            "更新组织信息",
            "删除组织",
            "获取组织列表",
            "批量添加组织成员",
            "删除组织成员",
            "获取组织成员列表",
            "添加组织角色及权限",
            "更新组织角色及权限",
            "删除组织角色及权限",
            "获取组织角色列表",
            "获取成员角色列表",
            "授予成员角色",
            "获取组织角色相关的树形数据",
            "获取组织角色树形数据",
            "获取当前组织下的设备分享给了那些用户",
            "获取用户相关组织下的设备分享给了那些用户",
        ], //"组织 OrgUnit",
        [
            "添加联系人",
            "批量添加联系人",
            "更新联系人信息",
            "删除联系人",
            "获取联系人列表",
            "根据关键字搜索联系人",
        ], //"联系人 Contacts",
        [
            "修改用户信息",
            "上传用户头像",
            "获取个人信息",
            "停用账号",
            "查询用户",
            "查询分享设备列表",
            "用户取消注册",
        ], //"用户 User",
        [
            "上传意见反馈图片",
            "提交意见反馈",
            "查询用户提交的所有意见反馈"
        ], //"意见反馈 Feedback",
        [
            "获取标签列表",
            "新增标签",
            "删除标签",
        ], //"通讯录 AddressBook",
        [
            "获取相应的所有遥控器品牌",
            "从超级碗(Spot)删除⼀一个遥控器",
            "获取支持的遥控器种类",
        ], //"超级碗 LifeSmart",
        [
            "获取推送消息列表",
            "获取未读消息列表",
            "获取推送信息详情",
            "获取未读消息条数",
            "获取紧急报警消息列表",
            "获取紧急报警消息列表",
        ], //"报警推送 SmartPush",
        [
            "获取产品分类列表",
            "根据父分类ID获取产品列表"
        ], //"产品类型 ProductCategory",
    ]
        
    private let groupList: [String] = [
        "常用请求 Request",
        "空间 Space",
        "组织 OrgUnit",
        "联系人 Contacts",
        "用户 User",
        "意见反馈 Feedback",
        "通讯录 AddressBook",
        "超级碗 LifeSmart",
        "报警推送 SmartPush",
        "产品类型 ProductCategory",
    ]
    /// 通讯录标签列表
    private var addressBookTagList: [String] = [String]()
    /// 君和weex版本号
    private var gemvaryWeexVersion: String = String()
    /// 坚朗weex版本号
    private var kinlongWeexVersion: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新云端接口"
        self.setupSubViews()
    }
        
}

extension NewCloudAPITestVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        let text = self.dataList[indexPath.section][indexPath.row]
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groupList[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = self.groupList[indexPath.section]
        let text = self.dataList[indexPath.section][indexPath.row]
        
        switch group {
        case "常用请求 Request":
            break
        case "空间 Space":
            break
        case "组织 OrgUnit":
            break
        case "联系人 Contacts":
            break
        case "用户 User":
            break
        case "意见反馈 Feedback":
            break
        case "通讯录 AddressBook":
            break
        case "超级碗 LifeSmart":
            break
        case "报警推送 SmartPush":
            break
        case "产品类型 ProductCategory":
            break
        default:
            break
        }
        
        switch text {
        /// "常用请求 Request"
        case "获取验证码":
            self.smsSendVerifyCode()
            break
        case "获取用户相关的项目列表":
            self.projectUserList()
            break
        case "网关代理请求":
            self.iotGatewayProxyData()
            break
        case "根据空间ID发送数据":
            self.iotGatewayProxySpaceId()
            break
        case "根据GID获取产品信息":
            self.iotProductInfo()
            break
        case "请求新云端Weex版本信息":
            self.weexGemvaryVersion()
            break
        case "下载新云端weex的zip包":
            self.weexGemvaryZip()
            break
        case "海贝斯设备猫眼信息":
            self.amazonGetObjByDevId()
            break
        case "批量删除(清空)消息记录":
            self.amazonDeleteBatch()
            break
        case "坚朗之家 请求ipa包的版本":
            self.kinlongIOSVersion()
            break
        case "天气请求接口":
            self.iotWeatherV2()
            break
        case "获取用户相关房间列表":
            self.projectUserRooms()
            break
        case "查询已分享的设备列表":
            self.iotSpaceIdSharedDeviceList()
            break
        case "根据设备参数获取产品信息":
            self.iotProductInfoList()
            break
            
        /// "空间 Space"
        case "添加空间":
            self.iotSpaceAdd()
            break
        case "修改空间":
            self.iotSpaceUpdate()
            break
        case "删除空间":
            self.iotSpaceDelete()
            break
        case "获取空间列表":
            self.iotSpaceList()
            break
        case "获取可用空间列表":
            self.iotSpaceUsableList()
            break
        case "获取空间状态":
            self.iotSpaceListStat()
            break
        case "出租空间":
            self.iotSpaceLease()
            break
        case "收回空间":
            self.iotSpaceTakeBack()
            break
        case "转让空间":
            self.iotSpaceTransfer()
            break
        case "分享设备给其他用户":
            self.iotSpaceSharingDevice()
            break
        case "接受其他人分享的设备":
            self.iotSpaceSharingDeviceApproval()
            break
        case "获取当前空间的设备分享给了哪些用户":
            self.iotSpaceSharingDeviceUserList()
            break
        case "查询其他人分享的设备列表":
            self.iotSpaceSharingDeviceList()
            break
        case "查询当前设备分享记录":
            self.iotSpaceSharingDeviceGidList()
            break
        case "取消分享给某个用户":
            self.iotSpaceSharingDeviceCancel()
            break
        case "获取指定空间的房东或租户":
            self.iotSpaceRentList()
            break
        case "获取用户相关组织下空间的所有房东或租户":
            self.iotOrgUnitRentList()
            break
        case "获取指定组织下的空间房东或租户":
            self.iotOrgUnitRentListOrgId()
            break
        case "空间退租":
            self.iotSpaceLeaseCancel()
            break
        case "获取指定组织下的空间列表":
            self.iotOrgUnitSpaceList()
            break
        case "获取其他用户可用的空间列表":
            self.iotSpaceOtherUsableList()
            break
        case "添加用户到指定空间的组织以及授权":
            self.iotSpaceAddUser()
            break
        case "修改空间用户名称及权限":
            self.iotSpaceRemoveUser()
            break
        case "从指定空间的组织移除用户与取消授权":
            self.iotSpaceRemoveUser()
            break
            
        /// "组织 OrgUnit"
        case "添加组织":
            self.iotOrgUnitAdd()
            break
        case "添加组织及成员":
            self.iotOrgUnitAddAndStaffs()
            break
        case "更新组织信息":
            self.iotOrgUnitUpdate()
            break
        case "删除组织":
            self.iotOrgUnitDelete()
            break
        case "获取组织列表":
            self.iotOrgUnitList()
            break
        case "批量添加组织成员":
            self.iotOrgUnitStaffBatchAdd()
            break
        case "删除组织成员":
            self.iotOrgUnitStaffDelete()
            break
        case "获取组织成员列表":
            self.iotOrgUnitIdStaffList()
            break
        case "添加组织角色及权限":
            self.iotOrgUnitRoleAdd()
            break
        case "更新组织角色及权限":
            self.iotOrgUnitRoleUpdate()
            break
        case "删除组织角色及权限":
            self.iotOrgUnitRoleDelete()
            break
        case "获取组织角色列表":
            self.iotOrgUnitOrgIdRoleList()
            break
        case "获取成员角色列表":
            self.iotOrgUnitStaffRoleList()
            break
        case "授予成员角色":
            self.iotOrgUnitStaffGrantRole()
            break
        case "获取组织角色相关的树形数据":
            self.iotOrgUnitOrgIdRoletree()
            break
        case "获取组织角色树形数据":
            self.iotOrgUnitOrgIdRoleRoleIdTree()
            break
        case "获取当前组织下的设备分享给了那些用户":
            self.iotOrgUnitOrgIdSharingDeviceUserList()
            break
        case "获取用户相关组织下的设备分享给了那些用户":
            self.iotOrgUnitSharingDeviceUserList()
            break
                                    
        /// "联系人 Contacts"
        case "添加联系人":
            self.iotContactsAdd()
            break
        case "批量添加联系人":
            self.iotContactsBatchAdd()
            break
        case "更新联系人信息":
            self.iotContactsUpdate()
            break
        case "删除联系人":
            self.iotContactsDelete()
            break
        case "获取联系人列表":
            self.iotContactsList()
            break
        case "根据关键字搜索联系人":
            self.iotContactsSearch()
            break
            
        /// "用户 User"
        case "修改用户信息":
            self.userUpdate()
            break
        case "上传用户头像":
            self.userUploadAvatar()
            break
        case "获取个人信息":
            self.userInfo()
            break
        case "停用账号":
            self.userDisable()
            break
        case "查询用户":
            self.userSearch()
            break
        case "查询分享设备列表":
            self.userShareDeviceList()
            break
        case "用户取消注册":
            self.userDeletionRegistration()
            break
                        
        /// "意见反馈 Feedback"
        case "上传意见反馈图片":
            self.feedbackIotUploadImg()
            break
        case "提交意见反馈":
            self.feedbackIot()
            break
        case "查询用户提交的所有意见反馈":
            self.feedbackMyList()
            break
                                        
        /// "通讯录 AddressBook"
        case "获取标签列表":
            self.iotAddressBookTagList()
            break
        case "新增标签":
            self.iotAddressBookTagAdd()
            break
        case "删除标签":
            self.iotAddressBookTagDelete()
            break
                                    
        /// "超级碗 LifeSmart"
        case "获取相应的所有遥控器品牌":
            self.queryBrandsList()
            break
        case "从超级碗(Spot)删除⼀一个遥控器":
            self.deleteRemote()
            break
        case "获取支持的遥控器种类":
            self.queryCategoryList()
            break
                        
        /// "报警推送 SmartPush"
        case "获取推送消息列表":
            self.toList()
            break
        case "获取未读消息列表":
            self.toUnreadList()
            break
        case "获取推送信息详情":
            self.readUnreadMessage()
            break
        case "获取未读消息条数":
            self.countUnread()
            break
        case "获取紧急报警消息列表":
            self.toUrgentList()
            break
//        case "获取紧急报警消息列表11":
//            self.toUrgentListWithPage()
//            break
                                    
        /// "产品类型 ProductCategory"
        case "获取产品分类列表":
            self.iotProductCategoryList()
            break
        case "根据父分类ID获取产品列表":
            self.iotProductCategoryParentIdProduct()
            break
            
            
        default:
            break
        }
        
    }
}

//MARK: 常用请求
/// 调用测试接口 Request
extension NewCloudAPITestVC {
    /// 获取验证码
    private func smsSendVerifyCode() -> Void {
        RequestHandler.smsSendVerifyCode(phone: "", type: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取用户相关的项目列表
    private func projectUserList() -> Void {
        RequestHandler.projectUserList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 网关代理请求
    private func iotGatewayProxyData() -> Void {
        RequestHandler.iotGatewayProxy(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 根据空间ID发送数据
    private func iotGatewayProxySpaceId() -> Void {
        RequestHandler.iotGatewayProxy(spaceId: "", data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 根据GID获取产品信息
    private func iotProductInfo() -> Void {
        RequestHandler.iotProductInfo(gid: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 请求新云端Weex版本信息
    private func weexGemvaryVersion() -> Void {
        RequestHandler.weexGemvaryVersion { success in
            swiftDebug("成功", success as Any)
            if let success = success {
                self.gemvaryWeexVersion = success
            }
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 下载新云端weex的zip包
    private func weexGemvaryZip() -> Void {
        guard self.gemvaryWeexVersion != "" else {
            ProgressHUD.showText("版本号为空")
            return
        }
        RequestHandler.weexGemvaryZip(version: self.gemvaryWeexVersion) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 海贝斯设备猫眼信息
    private func amazonGetObjByDevId() -> Void {
        RequestHandler.amazonGetObjByDevId(deviceId: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 批量删除(清空)消息记录
    private func amazonDeleteBatch() -> Void {
        RequestHandler.amazonDeleteBatch(deviceIds: [""]) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 坚朗之家 请求ipa包的版本
    private func kinlongIOSVersion() -> Void {
        RequestHandler.kinlongIOSVersion { success in
            swiftDebug("成功", success as Any)
            if let success = success {
                self.kinlongWeexVersion = success
            }
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 天气请求接口
    private func iotWeatherV2() -> Void {
        RequestHandler.iotWeatherV2(province: "广东", city: "深圳") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as  Any)
        }
    }
    
    /// 获取用户相关房间列表
    private func projectUserRooms() -> Void {
        RequestHandler.projectUserRooms(zoneCode: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 查询已分享的设备列表
    private func iotSpaceIdSharedDeviceList() -> Void {
        RequestHandler.iotSpaceIdSharedDeviceList(spaceId: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 根据设备参数获取产品信息
    private func iotProductInfoList() -> Void {
        RequestHandler.iotProductInfoList(brand: "", classType: "", gatewayType: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }        
}

//MARK: 联系人
/// 联系人
extension NewCloudAPITestVC {
    
    /// 添加联系人
    private func iotContactsAdd() -> Void {
        ContactsHandler.iotContactsAdd(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 批量添加联系人
    private func iotContactsBatchAdd() -> Void {
        ContactsHandler.iotContactsBatchAdd(name: "", phone: "", description: "", group: "", tags: [""]) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 更新联系人信息
    private func iotContactsUpdate() -> Void {
        ContactsHandler.iotContactsUpdate(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 删除联系人
    private func iotContactsDelete() -> Void {
        ContactsHandler.iotContactsDelete(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取联系人列表
    private func iotContactsList() -> Void {
        ContactsHandler.iotContactsList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 根据关键字搜索联系人
    private func iotContactsSearch() -> Void {
        ContactsHandler.iotContactsSearch(keyword: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }    
}

// MARK: 反馈
/// 反馈
extension NewCloudAPITestVC {
    
    /// 上传意见反馈图片
    private func feedbackIotUploadImg() -> Void {
        FeedbackHandler.feedbackIotUploadImg(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 提交意见反馈
    private func feedbackIot() -> Void {
        FeedbackHandler.feedbackIot(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 查询用户提交的所有意见反馈
    private func feedbackMyList() -> Void {
        FeedbackHandler.feedbackMyList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
}

//MARK: 空间
/// 空间
extension NewCloudAPITestVC {
        
    /// 添加空间
    private func iotSpaceAdd() -> Void {
        /*
         name*    string         空间名称
         address    string         空间位置
         zoneCode    string         小区代码
         orgId*    integer         组织ID
         attr    string         空间属性
         description    string         描述
         alias    string         空间别名
         propertyId    string         房屋ID
         propertyName    string         房屋名称
         unitNo    string         单元号
         floorNo    string         楼层号
         roomNo    string         房号
         */
        SpaceHandler.iotSpaceAdd(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 修改空间
    private func iotSpaceUpdate() -> Void {
        /*
         id*    string         空间ID
         name*    string         空间名称
         address    string         空间位置
         zoneCode    string         小区代码
         orgId    integer         组织ID
         attr    string         空间属性
         description    string         描述
         alias    string         空间别名
         oldPropertyId    string         旧房屋ID
         propertyId    string         新房屋ID
         propertyName    string         房屋名称
         unitNo    string         单元号
         floorNo    string         楼层号
         roomNo    string         房号
         */
        SpaceHandler.iotSpaceUpdate(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 删除空间
    private func iotSpaceDelete() -> Void {
        SpaceHandler.iotSpaceDelete(spaceId: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取空间列表
    private func iotSpaceList() -> Void {
        SpaceHandler.iotSpaceList { success in
            swiftDebug("成功", success as Any)
            // 获取空间列表
            guard let success = success, let spaceList: [[String: Any]] = JSONTool.translationJsonToArray(from: success) as? [[String: Any]] else {
                swiftDebug("转换数组数据失败")
                return
            }
            /*
             [{\"unitNo\":null,\"status\":0,\"defaultSpace\":false,\"roomNo\":null,\"owner\":\"\",\"zoneCode\":\"ABCD\",\"alias\":\"\",\"tOrgId\":null,\"name\":\"ghh\",\"zoneName\":\"测试\",\"id\":\"1663d61d648540d6ba94afd336e0567e\",\"attr\":\"住宅\",\"propertyId\":null,\"floorNo\":null,\"lessee\":null,\"orgName\":null,\"propertyName\":null,\"orgId\":0,\"address\":\"{}\",\"description\":\"rff\"}]
             */
                        
            let alertVC = UIAlertController(title: "提示", message: "显示空间列表数据，点击选择空间", preferredStyle: UIAlertController.Style.actionSheet)
            for space in spaceList {
                guard let name: String = space["name"] as? String else {
                    return
                }
                alertVC.addAction(UIAlertAction(title: "空间:\(name)", style: UIAlertAction.Style.default, handler: { action in
                    swiftDebug("点击空间信息: ", space)
                    // 设置当前空间
                    // 数据库设置当前空间
                    guard let spaceModel = try? ModelDecoder.decode(Space.self, param: space) else {
                        swiftDebug("设置当前空间信息 解析空间数据失败")
                        return
                    }
                    // 更新当前账号数据
                    guard var accountInfo = AccountInfo.queryNow() else {
                        swiftDebug("当前账号信息为空")
                        return
                    }
                    // 空间ID赋值
                    accountInfo.spaceID = spaceModel.id
                    // 智能家居主机设备码设置为空
                    accountInfo.smartDevCode = nil
                    // 更新账号信息
                    AccountInfo.update(accountInfo: accountInfo)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        // 连接当前空间
                        WebSocketHandler.connectCurrentSpace()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.0) {
                            // 发送智能家居初始化数据
                            self.sendInitData()
                        }                                                                                                               
                    }
                    
                }))
            }
            alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
                
            }))
            self.present(alertVC, animated: true, completion: nil)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取可用空间列表
    private func iotSpaceUsableList() -> Void {
        SpaceHandler.iotSpaceUsableList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取空间状态
    private func iotSpaceListStat() -> Void {
        SpaceHandler.iotSpaceListStat { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 出租空间
    private func iotSpaceLease() -> Void {
        /*
         spaceId    string         空间ID
         account    string         承租人帐号
         userName    string         承租人名称
         */
        SpaceHandler.iotSpaceLease(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 收回空间
    private func iotSpaceTakeBack() -> Void {
        /* 字典内容
         "spaceId": "string"        空间ID
         */
        SpaceHandler.iotSpaceTakeBack(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 转让空间
    private func iotSpaceTransfer() -> Void {
        /* 字典内容
         spaceId    string         空间ID
         account    string         转入目标帐号
         */
        SpaceHandler.iotSpaceTransfer(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 分享设备给其他用户
    private func iotSpaceSharingDevice() -> Void {
        SpaceHandler.iotSpaceSharingDevice(spaceId: "", toUserId: "", nickname: "", gid: "", hwid: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 接受其他人分享的设备
    private func iotSpaceSharingDeviceApproval() -> Void {
        SpaceHandler.iotSpaceSharingDeviceApproval(shareId: 0, deviceStatus: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取当前空间的设备分享给了哪些用户
    private func iotSpaceSharingDeviceUserList() -> Void {
        SpaceHandler.iotSpaceSharingDeviceUserList(spaceId: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 查询其他人分享的设备列表
    private func iotSpaceSharingDeviceList() -> Void {
        SpaceHandler.iotSpaceSharingDeviceList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 查询当前设备分享记录
    private func iotSpaceSharingDeviceGidList() -> Void {
        SpaceHandler.iotSpaceSharingDeviceGidList(gid: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 取消分享给某个用户
    private func iotSpaceSharingDeviceCancel() -> Void {
        SpaceHandler.iotSpaceSharingDeviceCancel(shareId: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取指定空间的房东或租户
    private func iotSpaceRentList() -> Void {
        SpaceHandler.iotSpaceRentList(spaceId: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取用户相关组织下空间的所有房东或租户
    private func iotOrgUnitRentList() -> Void {
        SpaceHandler.iotOrgUnitRentList() { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取指定组织下的空间房东或租户
    private func iotOrgUnitRentListOrgId() -> Void {
        SpaceHandler.iotOrgUnitRentList(orgId: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 空间退租
    private func iotSpaceLeaseCancel() -> Void {
        SpaceHandler.iotSpaceLeaseCancel(spaceId: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取指定组织下的空间列表
    private func iotOrgUnitSpaceList() -> Void {
        SpaceHandler.iotOrgUnitSpaceList(orgId: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取其他用户可用的空间列表
    private func iotSpaceOtherUsableList() -> Void {
        SpaceHandler.iotSpaceOtherUsableList(account: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 添加用户到指定空间的组织以及授权
    private func iotSpaceAddUser() -> Void {
        /*
         spaceId    string         空间ID
         account    string         用户帐号
         name    string         用户名称
         perm    integer         权限,0-普通,1-管理员
         */
        SpaceHandler.iotSpaceAddUser(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
        
    /// 修改空间用户名称及权限
    private func iotSpaceModifyUser() -> Void {
        /*
         spaceId    string         空间ID
         account    string         用户帐号
         name    string         用户名称
         perm    integer         权限,0-普通,1-管理员
         */
        SpaceHandler.iotSpaceRemoveUser(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 从指定空间的组织移除用户与取消授权
    private func iotSpaceRemoveUser() -> Void {
        /*
         spaceId    string         空间ID
         account    string         用户帐号
         */
        SpaceHandler.iotSpaceRemoveUser(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
}

//MARK: 组织结构
/// 组织结构
extension NewCloudAPITestVC {
    
    /// 添加组织
    private func iotOrgUnitAdd() -> Void {
        /*
         name    string         组织名称
         description    string         描述
         */
        OrgUnitHandler.iotOrgUnitAdd(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 添加组织及成员
    private func iotOrgUnitAddAndStaffs() -> Void {
        /*
         {
         name    string         组织名称
         description    string         描述
         staffs    [         成员列表
         {
         name    string         名称
         account    string         手机帐号
         }
         ]
         }
         */
        OrgUnitHandler.iotOrgUnitAddAndStaffs(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 更新组织信息
    private func iotOrgUnitUpdate() -> Void {
        /*
         {
         id    integer($int64)         记录ID
         name    string         组织名称
         description    string         描述
         }
         */
        OrgUnitHandler.iotOrgUnitUpdate(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 删除组织
    private func iotOrgUnitDelete() -> Void {
        OrgUnitHandler.iotOrgUnitDelete(id: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取组织列表
    private func iotOrgUnitList() -> Void {
        OrgUnitHandler.iotOrgUnitList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 批量添加组织成员
    private func iotOrgUnitStaffBatchAdd() -> Void {
        /*
         {
         orgId    integer($int64)         组织ID
         staffs    [         成员列表
         {
         name    string         名称
         account    string         手机帐号
         }]
         }
         */
        OrgUnitHandler.iotOrgUnitStaffBatchAdd(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 删除组织成员
    private func iotOrgUnitStaffDelete() -> Void {
        OrgUnitHandler.iotOrgUnitStaffDelete(id: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取组织成员列表
    private func iotOrgUnitIdStaffList() -> Void {
        OrgUnitHandler.iotOrgUnitIdStaffList(id: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 添加组织角色及权限
    private func iotOrgUnitRoleAdd() -> Void {
        /*
         {
         orgId    integer($int64)         组织ID
         name    string         角色名称
         description    string         角色描述
         permissions    [         权限列表
         {
         name    string         名称
         type    string         资源类型
         objId    string         对象ID
         operation    string         动作
         }]
         }
         */
        OrgUnitHandler.iotOrgUnitRoleAdd(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 更新组织角色及权限
    private func iotOrgUnitRoleUpdate() -> Void {
        /*
         {
         orgId    integer($int64)         组织ID
         id    integer($int64)         角色ID
         name    string         角色名称
         description    string         角色描述
         permissions    [         权限列表
         {
         name    string         名称
         type    string         资源类型
         objId    string         对象ID
         operation    string         动作
         }]
         }
         */
        OrgUnitHandler.iotOrgUnitRoleUpdate(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 删除组织角色及权限
    private func iotOrgUnitRoleDelete() -> Void {
        /*
         {
         orgId    integer($int64)         组织ID
         roleId    integer($int64)         角色ID
         }
         */
        OrgUnitHandler.iotOrgUnitRoleDelete(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取组织角色列表
    private func iotOrgUnitOrgIdRoleList() -> Void {
        OrgUnitHandler.iotOrgUnitOrgIdRoleList(orgId: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取成员角色列表
    private func iotOrgUnitStaffRoleList() -> Void {
        OrgUnitHandler.iotOrgUnitStaffRoleList(orgId: 0, account: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 授予成员角色
    private func iotOrgUnitStaffGrantRole() -> Void {
        /*
         {
         orgId    integer($int64)         组织ID
         account    string         帐号
         roleIds    [         角色ID列表
         integer($int64)]
         }
         */
        OrgUnitHandler.iotOrgUnitStaffGrantRole(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取组织角色相关的树形数据
    private func iotOrgUnitOrgIdRoletree() -> Void {
        OrgUnitHandler.iotOrgUnitOrgIdRoletree(orgId: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取组织角色树形数据
    private func iotOrgUnitOrgIdRoleRoleIdTree() -> Void {
        OrgUnitHandler.iotOrgUnitOrgIdRoleRoleIdTree(orgId: 0, roleId: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取当前组织下的设备分享给了那些用户
    private func iotOrgUnitOrgIdSharingDeviceUserList() -> Void {
        OrgUnitHandler.iotOrgUnitOrgIdSharingDeviceUserList(orgId: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取用户相关组织下的设备分享给了那些用户
    private func iotOrgUnitSharingDeviceUserList() -> Void {
        OrgUnitHandler.iotOrgUnitSharingDeviceUserList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
}

//MARK: 通讯录
extension NewCloudAPITestVC {
    
    /// 获取标签列表
    private func iotAddressBookTagList() -> Void {
        AddressBookHandler.iotAddressBookTagList { success in
            swiftDebug("成功", success as Any)
            guard let success = success, let array: [String] = JSONTool.translationJsonToArray(from: success) as? [String] else {
                swiftDebug("转换数组数据失败")
                return
            }
            self.addressBookTagList = array
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 新增标签
    private func iotAddressBookTagAdd() -> Void {
        
        let alertVC = UIAlertController(title: "提示", message: "增加标签", preferredStyle: UIAlertController.Style.alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入新增标签内容"
        }
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            guard let textFields = alertVC.textFields, let textFiled = textFields.first, let text = textFiled.text, text != "" else {
                swiftDebug("获取账号和验证码失败")
                return
            }
            
            AddressBookHandler.iotAddressBookTagAdd(tag: text) { success in
                swiftDebug("成功", success as Any)
            } failedCallback: { failed in
                swiftDebug("失败", failed as Any)
            }
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 删除标签
    private func iotAddressBookTagDelete() -> Void {
        
        guard self.addressBookTagList.count != 0, let text = self.addressBookTagList.first else {
            ProgressHUD.showText("标签列表个数为空，或请请求获取标签列表")
            return
        }
                
        AddressBookHandler.iotAddressBookTagDelete(tag: text) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
}

//MARK: 超级碗
extension NewCloudAPITestVC {
    
    /// 获取相应的所有遥控器品牌
    private func queryBrandsList() -> Void {
        LifeSmartNetHandler.queryBrandsList(userid: "", usertoken: "", paramsDict: ["": ""]) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 从超级碗(Spot)删除⼀一个遥控器
    private func deleteRemote() -> Void {
        LifeSmartNetHandler.deleteRemote(userid: "", usertoken: "", paramsDict: ["": ""]) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取支持的遥控器种类
    private func queryCategoryList() -> Void {
        LifeSmartNetHandler.queryCategoryList(userid: "", usertoken: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }        
}

//MARK: 产品类型
extension NewCloudAPITestVC {
    
    /// 获取产品分类列表
    private func iotProductCategoryList() -> Void {
        ProductCategoryHandler.iotProductCategoryList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 根据父分类ID获取产品列表
    private func iotProductCategoryParentIdProduct() -> Void {
        ProductCategoryHandler.iotProductCategoryParentIdProduct(parentId: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
            
}

//MARK: 报警推送
extension NewCloudAPITestVC {
    
    /// 获取推送消息列表
    private func toList() -> Void {
        SmartPushWorkHandler.toList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取未读消息列表
    private func toUnreadList() -> Void {
        SmartPushWorkHandler.toUnreadList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取推送信息详情
    private func readUnreadMessage() -> Void {
        SmartPushWorkHandler.readUnreadMessage(message_type: 0, message_id: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取未读消息条数
    private func countUnread() -> Void {
        SmartPushWorkHandler.countUnread { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取紧急报警消息列表
    private func toUrgentList() -> Void {
        SmartPushWorkHandler.toUrgentList { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败",failed as Any)
        }
    }
    
    /// 获取紧急报警消息列表
    private func toUrgentListWithPage() -> Void {
        SmartPushWorkHandler.toUrgentListWithPage(pageNumber: 0, pageSize: 0) { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
}

//MARK: 用户
extension NewCloudAPITestVC {
    
    /// 修改用户信息
    private func userUpdate() -> Void {
        UserHandler.userUpdate(nickname: "", photo: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 上传用户头像
    private func userUploadAvatar() -> Void {
        /*
         {
         data    string($byte)         Base64的头像数据
         }
         */
        UserHandler.userUploadAvatar(data: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 获取个人信息
    private func userInfo() -> Void {
        UserHandler.userInfo { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 停用账号
    private func userDisable() -> Void {
        UserHandler.userDisable { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
    
    /// 查询用户
    private func userSearch() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "查询用户", preferredStyle: UIAlertController.Style.alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入账号内容"
        }
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            guard let textFields = alertVC.textFields, let textField = textFields.first, let text = textField.text, text != "" else {
                ProgressHUD.showText("请输入账号")
                return
            }
            
            UserHandler.userSearch(account: text) { success in
                swiftDebug("成功", success as Any)
            } failedCallback: { failed in
                swiftDebug("失败", failed as Any)
            }
        }))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    /// 查询分享设备列表
    private func userShareDeviceList() -> Void {
        let alertVC = UIAlertController(title: "提示", message: "查询用户", preferredStyle: UIAlertController.Style.alert)
        alertVC.addTextField { textField in
            textField.placeholder = "请输入账号"
        }
        alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { action in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { action in
            guard let textFields = alertVC.textFields, let textField = textFields.first, let text = textField.text, text != "" else {
                ProgressHUD.showText("请输入账号信息")
                return
            }
            
            UserHandler.userShareDeviceList(account: text) { success in
                swiftDebug("成功", success as Any)
            } failedCallback: { failed in
                swiftDebug("失败", failed as Any)
            }
        }))
        self.present(alertVC, animated: true, completion: nil)
        
    }
        
    /// 用户取消注册
    private func userDeletionRegistration() -> Void {
        UserHandler.userDeletionRegistration(verifyCode: "") { success in
            swiftDebug("成功", success as Any)
        } failedCallback: { failed in
            swiftDebug("失败", failed as Any)
        }
    }
        
}

extension NewCloudAPITestVC {
    
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
            "msg_type" : "room_manager",
            "command" : "query",
            "from_role" : "phone",
            "from_account" : account,
            "room_name" : ""
        ]
        
        let scene_control_manager_query_all = [
            "msg_type" : "scene_control_manager",
            "command" : "query_all",
            "from_role" : "phone",
            "from_account" : account,
        ]
        
        let device_class_info_query = [
            "msg_type": "device_class_info",
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
                swiftDebug("查询设备的功能属性 成功", success as Any)
                
//                if let success = success, let jsonDic = JSONTool.translationJsonToDic(from: success) {
//                    ProtocolHandler.jsonStrData(jsonDic: jsonDic)
//                }
            } failedCallback: { (failed) in
                swiftDebug("查询设备的功能属性 失败", failed as Any)
            }
        }
        // 订阅数据
        //self.reviceMessageData()
    }
    
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
