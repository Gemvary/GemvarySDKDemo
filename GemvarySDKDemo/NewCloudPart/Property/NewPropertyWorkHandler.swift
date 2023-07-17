//
//  NewPropertyWorkHandler.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/20.
//

import UIKit
import GemvaryCommonSDK
import GemvaryNetworkSDK
import GemvaryToolSDK

class NewPropertyWorkHandler: NSObject {
    /// 创建单例
    static var share: NewPropertyWorkHandler = NewPropertyWorkHandler()
    /// 物业平台的 token
    private var accessToken: String = String()
    ///  物业基本域名
    private var serverUrl = "http://wy.cqylwy.cn"
    /// 物业平台名字(默认点都物业)
    var propertyPlat: PropertyPlat = PropertyPlat.diandou
    /// 客户信息
    private var customerData: DianDouCustomerData = DianDouCustomerData()
    /// 是否配置DD 信息工程
    private var getProject: Bool = false
    
    /// API名字
    private struct ApiName {
        /// 移动端 H5 对接 第三方系统中通过房间查询房间下对应应用
        static let wxOrApp_index = "/wxOrApp/index.do"
        /// 第三方系统中需要提交报事
        static let CrApp_index = "/CrApp/index.do"
        /// 服务记录
        static let serviceIndex = "/cr/app/service/serviceIndex.do"
    }
    
    /// 点都 APP 类型
    private struct TypeForH5 {
        /// Android系统
        static let Android = "Android"
        /// iOS系统
        static let ios = "ios"
    }
    
    /// DD物业 功能标示
    private struct ModuleType {
        /// 小区活动
        static let w1 = "1"
        /// 投票表决
        static let w2 = "2"
        /// 问卷调查
        static let w3 = "3"
        /// 公告通知
        static let w4 = "4"
        /// 小区动态
        static let w5 = "5"
        
        /// 投诉举报
        static let c1 = "1"
        /// 报事报修
        static let c2 = "2"
        /// 费用查缴
        static let c3 = "3"
    }
    
    /// JD物业
    private struct JDWYPathName {
        /// 社区活动
        static let activity_hot = "/home/activity/hot"
        ///  社区消息(动态)
        static let community = "/home/msg/community"
        /// 报事报修
        static let form_erp = "/service/from/ERP"
        /// 投诉建议
        static let form_com = "/service/form/COM"
        /// 查费缴费
        static let bill_0 = "/user/bill/0"
        /// 快递查询
        static let express2_0 = "/service/express2/0"
    }
    
    /** JD物业相关功能  */
    /// JD物业 社区活动
    func jdwyActivity(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            callback("\(self.serverUrl+"?access_token=\(accessToken)#")\(JDWYPathName.activity_hot)")
        }
    }
    
    /// JD物业社区消息
    func jdwyNews(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            callback("\(self.serverUrl+"?access_token=\(accessToken)#")\(JDWYPathName.community)")
        }
    }
    
    /// JD物业报事报修
    func jdwyRepair(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            callback("\(self.serverUrl+"?access_token=\(accessToken)#")\(JDWYPathName.form_erp)")
        }
    }
    
    /// JD物业投诉建议
    func jdwyComplaint(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            callback("\(self.serverUrl+"?access_token=\(accessToken)#")\(JDWYPathName.form_com)")
        }
    }
    
    /// JD物业查费缴费
    func jdwyPay(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            callback("\(self.serverUrl+"?access_token=\(accessToken)#")\(JDWYPathName.bill_0)")
        }
    }
    
    ///  JD物业 快递查询
    func jdwyExpress(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            callback("\(self.serverUrl+"?access_token=\(accessToken)#")\(JDWYPathName.express2_0)")
        }
    }
    
    /** DD物业相关功能 */
    /// 公告通知
    func diandouAnnouncement(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertWxOrAppParam2Str(accessToken: accessToken, moduleType: ModuleType.w4, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.wxOrApp_index)?\(param)")
        }
    }
    
    /// 小区活动
    func diandouActivity(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertWxOrAppParam2Str(accessToken: accessToken, moduleType: ModuleType.w1, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.wxOrApp_index)?\(param)")
        }
    }
    
    /// 小区动态
    func diandouDynamic(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertWxOrAppParam2Str(accessToken: accessToken, moduleType: ModuleType.w5, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.wxOrApp_index)?\(param)")
        }
    }
    
    /// 投票表决
    func diandouVote(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertWxOrAppParam2Str(accessToken: accessToken, moduleType: ModuleType.w2, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.wxOrApp_index)?\(param)")
        }
    }
    
    /// 问卷调查
    func diandouQuestionnaire(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertWxOrAppParam2Str(accessToken: accessToken, moduleType: ModuleType.w3, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.wxOrApp_index)?\(param)")
        }
    }
    
    /// 报事报修
    func diandouRepair(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertCrAppParam2Str(accessToken: accessToken, moduleType: ModuleType.c2, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.CrApp_index)?\(param)" + "&source=9")
        }
    }
    
    /// 投诉举报
    func diandouComplaint(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertCrAppParam2Str(accessToken: accessToken, moduleType: ModuleType.c1, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.CrApp_index)?\(param)" + "&source=9")
        }
    }
    
    /// 费用查缴
    func diandouPay(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertCrAppParam2Str(accessToken: accessToken, moduleType: ModuleType.c3, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.CrApp_index)?\(param)")
        }
    }
    
    /// 服务记录
    func diandouService(callback: @escaping ((String?) -> Void)) -> Void {
        self.diandouAccessTokenRequest { token in
            guard let accessToken = token, accessToken != "" else {
                callback(nil)
                return
            }
            let param = self.convertCrAppService2Str(accessToken: accessToken, data: self.customerData)
            if param == "" {
                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                 callback(nil)
                return
            }
            callback("\(self.serverUrl + ApiName.serviceIndex)?\(param)")
        }
    }
    
    
    /// 获取第三方系统的Access Token
    func diandouAccessTokenRequest(_ callback: ((String?) -> Void)? = nil) -> Void {
        // 判断当前网络状态
        ScsPhoneWorkAPI.diandouAccessToken { object in
            // 判断返回数据是否为空
            guard let object = object else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                callback?(nil)
                return
            }
            // 判断返回数据是否错误
            if object is Error {
                if let obj = object as? Error {
                    ProgressHUD.showText(NSLocalizedString(obj.localizedDescription, comment: ""))
                    swiftDebug("获取全局accessToken值 失败 报错: \(object)")
                    callback?(nil)
                    return
                }
            }
            
            guard let res = try? ModelDecoder.decode(DianDouAccessTokenRes.self, param: object as! [String : Any]) else {
                callback!(nil)
                return
            }
            
            swiftDebug("获取全局accessToken值", res)
            // 判断返回数据的状态码
            switch res.code {
            case NetResCode.c200: // 成功
                DispatchQueue.main.async {
                    guard let data = res.data else {
                        swiftDebug("请求返回为空")
                        return
                    }
                    if let serverUrl = data.serverUrl {
                        // 物业基地址链接
                        self.serverUrl = serverUrl
                    }
                    if let corporateName = data.corporateName, corporateName == PropertyPlat.jdwj.rawValue {
                        // 我家云平台
                        self.propertyPlat = PropertyPlat.jdwj
                    } else {
                        // 点都平台
                        self.propertyPlat = PropertyPlat.diandou
                    }
                    if let token = data.token {
                        // 物业平台token
                        self.accessToken = token // 全局access token
                        callback?(token)
                    }
                }
                break
            case NetResCode.c400: // 失败
                DispatchQueue.main.async {
                    callback?(nil)
                }
                break
            case NetResCode.c552: // 免登录
                NewUserTokenLogin.loginWithToken {
                    self.diandouAccessTokenRequest(callback)
                }
                break
            default:
                DispatchQueue.main.async {
                    callback?(nil)
                }
                break
            }
        }
    }
    
    /// 根据帐号获取第三方系统信息
    func diandouCustomerRequest() -> Void {
        ScsPhoneWorkAPI.diandouCustomer { object in
            //判断返回数据是否为空
            guard let object = object else {
                swiftDebug("网络请求错误")
                ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
                return
            }
            // 判断返回数据是否错误
            if object is Error {
                if let obj = object as? Error {
                    ProgressHUD.showText(NSLocalizedString(obj.localizedDescription, comment: ""))
                    swiftDebug("根据帐号获取第三方系统信息 失败 报错: \(object)")
                    return
                }
            }
            
            // 解析返回数据内容 转model
            guard let res = try? ModelDecoder.decode(DianDouCustomerRes.self, param: object as! [String : Any]) else {
                return
            }
            
            swiftDebug("第三方系统信息内容:", object)
            // 判断返回数据状态码
            switch res.code {
            case NetResCode.c200: // 成功
                // 判断返回数据data是否为空
                guard let data = res.data, data.count != 0 else {
                    swiftDebug("根据帐号获取第三方系统信息 data为空")
                    return
                }
                
                guard let customerData = data.first else {
                    swiftDebug("获取内容为空")
                    return
                }
                
                if data.count == 1 {
                    swiftDebug("DD 自定义信息 只有一个信息:::", customerData)
                    // DD API的自定义数据赋值
                    self.customerData = customerData
                } else {
                    
                    guard let ownRoom = OwnerRoom.queryNow() else {
                        swiftDebug("当前房间信息为空")
                        self.customerData = customerData
                        return
                    }
                    
                    //swiftDebug("当前的房间信息:", ownRoom)
                    // 过滤符合条件的数组
                    let infoList = data.filter { (info) -> Bool in
                        if ownRoom.floorNo != nil && info.floorNo != nil {
                            // 楼层号不为空
                            return (info.unitNo == ownRoom.unitno) && (ownRoom.roomno == info.pname) && (info.floorNo == ownRoom.floorNo)

                        } else {
                            // 楼层号为空
                            return (info.unitNo == ownRoom.unitno) && (ownRoom.roomno == info.pname)
                        }
                    }
                    
                    //swiftDebug("过滤后的数据信息::: ", infoList)
                    if infoList.count > 0, let info = infoList.first {
                        self.customerData = info
                    } else {
                        self.customerData = customerData
                    }
                    // 已经获取到DD 工程
                    self.getProject = true
                }
                break
            case NetResCode.c400: // 没有配置DD 工程
                // message "cannot get diandou project"
                // 没有获取到DD 工程
                self.getProject = false
                break
            case NetResCode.c552: // 免登录
                NewUserTokenLogin.loginWithToken {
                    self.diandouCustomerRequest()
                }
                break
            default:
                DispatchQueue.main.async {
                    ProgressHUD.showText(NSLocalizedString(res.message!, comment: ""))
                }
                break
            }
        }
    }
        
}

extension NewPropertyWorkHandler {
    
    /*
     http://pwstest.dd2007.cn/pws/cr/app/service/baoxiuIndex.do?
     userId=13632971318&propertyId=H041B005U001F001P001&phone=13632971318&typeForH5=Android&appType=JHRT&colorStyle=%2334ba63
     */
    /// 查询房间下对应的应用参数 转换成字符串
    final func convertWxOrAppParam2Str(accessToken: String, moduleType: String, data: DianDouCustomerData) -> String {
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("")
            return ""
        }
        // 房间标识
        guard let pid = data.pid, pid != "" else {
            swiftDebug("")
            return ""
        }
        // APP 类型
        let typeForH5 = TypeForH5.ios
        // 用户唯一标识
        let userId = account
        // 类型
        let type = "2"
        // 功能名称标识
        //let moduleType = moduleType
        // 组装字符串
        let str = "type=\(type)&userId=\(userId)&pid=\(pid)&typeForH5=\(typeForH5)&moduleType=\(moduleType)&accessToken=\(accessToken)"
        return str
    }
    
    /// 转换成字符串
    final func convertCrAppParam2Str( accessToken: String, moduleType: String, data: DianDouCustomerData) -> String {
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前账号为空")
            return ""
        }
        // 房间标识(根据房间位置接口获取)
        guard let propertyId = data.pid, propertyId != "" else {
            swiftDebug("")
            return ""
        }
        // APP类型
        let typeForH5 = TypeForH5.ios
        // 用户手机号
        let phone = account
        // 用户唯一标识(用户手机号)
        let userId = account
        // 业主端 app 标识
        let appType = AppType.JHRT
        // 功能名称标识
        //let moduleType = moduleType
        // 通过全局接口 获取
        //let accessToken = accessToken
        // 组装字符串
        let str = "userId=\(userId)&propertyId=\(propertyId)&typeForH5=\(typeForH5)&phone=\(phone)&moduleType=\(moduleType)&appType=\(appType)&accessToken=\(accessToken)"
        return str
    }
    
    /// 服务记录  转换成字符串
    final func convertCrAppService2Str(accessToken: String, data: DianDouCustomerData) -> String {
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("Accout为空")
            return ""
        }
        
        // 房间标识
        guard let pid = data.pid, pid != "" else {
            swiftDebug("")
            return ""
        }
        // 用户唯一标识
        let appUserId = account
        // 用户手机号
        let phone = account
        // APP类型
        let typeForH5 = TypeForH5.ios
        // accessToken 通过全局接口获取
        //let accessToken = accessToken
        
        let str = "appUserId=\(appUserId)&pid=\(pid)&typeForH5=\(typeForH5)&phone=\(phone)&accessToken=\(accessToken)"
        return str
    }
    
    /// 业主端 app 标识
    struct AppType {
        /// 君和睿通
        static let JHRT = "JHRT"
    }
    
    /// 根据帐号获取第三方系统信息 返回内容
    struct DianDouCustomerRes: Codable {
        /// 状态码
        var code: Int?
        /// 状态消息
        var message: String?
        /// 数据内容
        var data: [DianDouCustomerData]?
    }
    
    /// 根据帐号获取第三方系统信息 数据
    struct DianDouCustomerData: Codable {
        ///
        var hid: String?
        /// 小区编码
        var zoneCode: String?
        /// 楼栋ID
        var bid: String?
        /// 楼栋名字
        var bname: String?
        /// 单元ID
        //var uid: String?
        /// 单元名字
        var uname: String?
        /// 楼层ID
        var fid: String?
        /// 楼层名字
        var fname: String?
        /// 房间ID
        var pid: String?
        /// 房间名字
        var pname: String?
        /// 用户ID
        var cid: String?
        /// 用户名字
        var cname: String?
        /// 房间号
        var unitNo: String?
        /// 楼层号
        var floorNo: String?
    }
    
    /// 获取第三方系统的Access Token 返回内容
    struct DianDouAccessTokenRes: Codable {
        /// 状态码。
        var code: Int?
        /// 状态消息
        var message: String?
        /// 返回数据
        var data: DianDouAccessTokeData?
    }
    
    /// 获取第三方系统的Access Token 返回数据
    struct DianDouAccessTokeData: Codable {
        /// 服务器地址
        var serverUrl: String?
        /// token值
        var token: String?
        /// 判断是否为我家云平台
        var corporateName: String?
    }
}

/// 物业平台名字
enum PropertyPlat: String {
    /// diandou
    case diandou = "daindou"
    /// JD物业
    case jdwj = "jdwj"
}
