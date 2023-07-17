//
//  DDServiceAPI.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/24.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK

/// DD物业服务功能API
class DDServiceAPI: NSObject {
    
    /// 基本URL
    private static var baseURL = "http://wy.cqylwy.cn"
    /// 获取全局accessToken值
    private static var accessToken = ""
    /// 客户信息
    private static var customerData: DianDouCustomerData = DianDouCustomerData()
    /// 是否配置DD 信息工程
    private static var getProject: Bool = false
    
    /// API名字
    private struct ApiName {
        /// 移动端 H5 对接 第三方系统中通过房间查询房间下对应应用
        static let wxOrApp_index = "/wxOrApp/index.do"
        /// 第三方系统中需要提交报事
        static let CrApp_index = "/CrApp/index.do"
        /// 服务记录
        static let serviceIndex = "/cr/app/service/serviceIndex.do"
    }
    /// APP 类型
    private struct TypeForH5 {
        /// Android系统
        static let Android = "Android"
        /// iOS系统
        static let ios = "ios"
    }
    
    /// 功能标示
    struct ModuleType {
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
    
    //MARK: 获取全局
    /// 获取全局accessToken值
    static func diandouAccessTokenRequest(_ callback: ((String?) -> Void)? = nil) -> Void {
       
        // 获取第三方系统的Access Token
        PhoneWorkAPI.diandouAccessToken { (object) in
            // 判断返回数据是否为空
            guard let object = object else {
                debugPrint("网络请求错误")
                callback?(nil)
                return
            }
            // 判断返回数据是否错误
            if object is Error {
                if object is Error {
                    debugPrint("获取全局accessToken值 失败 报错: \(object)")
                    callback?(nil)
                    return
                }
            }
            debugPrint("获取全局accessToken值", object)
            // 解析返回数据内容 转model
            
            if let data = try? ModelDecoder.decode(DiandouAccessTokenRes.self, param: object as! [String : Any]), data.code == 400 {
                debugPrint("数据返回结果:: ", data)
                callback?(nil)
                return
            }
            
            guard let res = try? ModelDecoder.decode(DianDouAccessTokenRes.self, param: object as! [String : Any]) else {
                callback!(nil)
                return
            }
            
            debugPrint("获取全局accessToken值", res)
            // 判断返回数据的状态码
            switch res.code {
            case 200: // 成功
                DispatchQueue.main.async {
                    if res.data?.serverUrl != nil {
                        self.baseURL = res.data!.serverUrl! // 基地址链接
                    }
                    if res.data?.token != nil {
                        self.accessToken = res.data!.token! // 全局access token
                        callback?(self.accessToken)
                    }
                }
                break
            case 400: // 失败
                DispatchQueue.main.async {
                    //ProgressHUD.showText(NSLocalizedString(res.message!, comment: ""))
                    callback?(nil)
                }
                break
            case 552: // 免登录
                UserTokenLogin.loginWithToken { (result) in
                    self.diandouAccessTokenRequest()
                }
                DispatchQueue.main.async {
                    callback?(nil)
                }
                break
            default:
                DispatchQueue.main.async {
                    //ProgressHUD.showText(NSLocalizedString(res.message!, comment: ""))
                    callback?(nil)
                }
                break
            }
        }
    }
    
    /// 根据帐号获取第三方系统信息
    static func diandouCustomer() -> Void {
        // 请求 根据帐号获取第三方系统信息
        PhoneWorkAPI.diandouCustomer { (object) in
            //判断返回数据是否为空
            guard let object = object else {
                debugPrint("网络请求错误")
                return
            }
            // 判断返回数据是否错误
            if object is Error {
                if object is Error {
                    debugPrint("根据帐号获取第三方系统信息 失败 报错: \(object)")
                    return
                }
            }
            
            // 解析返回数据内容 转model
            guard let res = try? ModelDecoder.decode(DianDouCustomerRes.self, param: object as! [String : Any]) else {
                return
            }
            
            debugPrint("第三方系统信息内容:", object)
            // 判断返回数据状态码
            switch res.code {
            case 200: // 成功
                // 判断返回数据data是否为空
                guard res.data != nil && res.data!.count != 0 else {
                    debugPrint("根据帐号获取第三方系统信息 data为空")
                    return
                }
                
                if res.data!.count == 1 {
                    debugPrint("DD 自定义信息 只有一个信息:::", res.data!.first!)
                    // DD API的自定义数据赋值
                    DDServiceAPI.customerData = res.data!.first!
                } else {
                    
                    //debugPrint("获取到的数据列表内容: ", res.data!)
                    guard let ownRoom = OwnerRoom.queryNow() else {
                        debugPrint("当前房间信息为空")
                        DDServiceAPI.customerData = res.data!.first!
                        return
                    }
                    
                    //debugPrint("当前的房间信息:", ownRoom)
                    // 过滤符合条件的数组
                    let infoList = res.data!.filter { (info) -> Bool in
                        if ownRoom.floorNo != nil && info.floorNo != nil {
                            // 楼层号不为空
                            return (info.unitNo == ownRoom.unitno) && (ownRoom.roomno == info.pname) && (info.floorNo == ownRoom.floorNo)

                        } else {
                            // 楼层号为空
                            return (info.unitNo == ownRoom.unitno) && (ownRoom.roomno == info.pname)
                        }
                    }
                    
                    //debugPrint("过滤后的数据信息::: ", infoList)
                    if infoList.count > 0 {
                        DDServiceAPI.customerData = infoList.first!
                    } else {
                        DDServiceAPI.customerData = res.data!.first!
                    }
                    //debugPrint("DD 自定义信息 当前选中的信息:::", DianDouWorkApi.customerData)
                    // 已经获取到DD 工程
                    self.getProject = true
                }
                break
            case 400: // 没有配置DD 工程
                // message "cannot get diandou project"
                // 没有获取到DD 工程
                self.getProject = false
                break
            case 552: // 免登录
                UserTokenLogin.loginWithToken { (result) in
                    DDServiceAPI.diandouCustomer()
                }
                break
            default:
                debugPrint("")
                break
            }
        }
    }
    
    
    //MARK: 公告通知
    /// 公告通知
    static func announcement(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest {(token) in
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.wxOrApp_index
            // 公告通知
            let param = WxOrAppParam(moduleType: ModuleType.w4)
            
            if WxOrAppParam.convert2Str(param: param) == "" {
                debugPrint("参数为空 请重新加载请求")
                callback(nil)
                return
            }
            
            callback("\(domain)?\(WxOrAppParam.convert2Str(param: param))")
        }
    }
    
    //MARK: 小区活动
    /// 小区活动
    static func activity(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest { (token) in
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.wxOrApp_index
            // 小区活动
            let param = WxOrAppParam(moduleType: ModuleType.w1)

            if WxOrAppParam.convert2Str(param: param) == "" {
                debugPrint("参数为空 请重新加载请求")
                callback(nil)
                return
            }
            
            callback("\(domain)?\(WxOrAppParam.convert2Str(param: param))")
        }
        
        
    }
    
    //MARK: 小区动态
    /// 小区动态
    static func dynamic(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest { token in
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.wxOrApp_index
            // 小区动态
            let param = WxOrAppParam(moduleType: ModuleType.w5)

            if WxOrAppParam.convert2Str(param: param) == "" {
                debugPrint("参数为空 请重新加载请求")
                callback(nil)
                return
            }
            
            callback("\(domain)?\(WxOrAppParam.convert2Str(param: param))")
        }
        
    }
    
    //MARK: 投票表决
    /// 投票表决
    static func vote(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest { token in
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.wxOrApp_index
            // 投票表决
            let param = WxOrAppParam(moduleType: ModuleType.w2)
            
            if WxOrAppParam.convert2Str(param: param) == "" {
                debugPrint("参数为空 请重新加载请求")
                callback(nil)
                return
            }
            callback( "\(domain)?\(WxOrAppParam.convert2Str(param: param))")
        }
    }
    
    //MARK: 问卷调查
    /// 问卷调查
    static func questionnaire(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest { token in
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.wxOrApp_index
            // 问卷调查
            let param = WxOrAppParam(moduleType: ModuleType.w3)

            if WxOrAppParam.convert2Str(param: param) == "" {
                debugPrint("参数为空 请重新加载请求")
                callback(nil)
                return
            }
            
            callback("\(domain)?\(WxOrAppParam.convert2Str(param: param))")
        }
    }
    
    //MARK: 报事报修
    /// 报事报修
    static func repair(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest { token in
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.CrApp_index
            // 报事报修
            let param = CrAppParam(moduleType: ModuleType.c2)

            if CrAppParam.convert2Str(param: param) == "" {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                callback(nil)
                return
            }
            
            callback("\(domain)?\(CrAppParam.convert2Str(param: param))" + "&source=9")
        }
        
        
    }
    
    //MARK: 投诉举报
    /// 投诉举报
    static func complaint(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest { token in
            //debugPrint("获取token的闭包 token", token as Any)
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.CrApp_index
            // 投诉举报
            let param = CrAppParam(moduleType: ModuleType.c1)

            if CrAppParam.convert2Str(param: param) == "" {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                callback(nil)
                return
            }
            
            callback("\(domain)?\(CrAppParam.convert2Str(param: param))" + "&source=9")
        }
    }
    
    //MARK: 费用查缴
    /// 费用查缴
    static func pay(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest { token in
            //debugPrint("费用查缴 token:", token)
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.CrApp_index
            // 费用查缴
            let param = CrAppParam(moduleType: ModuleType.c3)

            if CrAppParam.convert2Str(param: param) == "" {
                debugPrint("参数为空 请重新加载请求")
                callback(nil)
                return
            }
            
            callback("\(domain)?\(CrAppParam.convert2Str(param: param))")
        }
        
    }
    
    //MARK: 服务记录
    /// 服务记录
    static func service(callback: @escaping ((String?) -> Void)) -> Void {
        // 获取token
        DDServiceAPI.diandouAccessTokenRequest { token in
            if token == nil || token == "" {
                callback(nil)
                return
            }
            let domain = self.baseURL + ApiName.serviceIndex
            // 费用查缴
            let param = CrAppService()
            
            if CrAppService.convert2Str(param: param) == "" {
                debugPrint("参数为空 请重新加载请求")
                callback(nil)
                return
            }
            callback("\(domain)?\(CrAppService.convert2Str(param: param))")
        }
    }
    
    
    /// 查询房间下对应的应用参数
    struct WxOrAppParam: Codable {
        /// 类型
        var type: String? = "2"
        /// 用户唯一标识
        var userId: String? //= DianDouWorkApi.customerData.uid
        /// 房间标识
        var pid: String? = DDServiceAPI.customerData.pid
        /// APP 类型
        var typeForH5: String? = TypeForH5.ios
        /// 功能名称标识
        var moduleType: String?
        /// accessToken
        var accessToken: String? = DDServiceAPI.accessToken
        
        /// 初始化方法
        init(moduleType: String) {
            self.moduleType = moduleType
            guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
                return
            }
            self.userId = account
        }
        
        /*
         http://pwstest.dd2007.cn/pws/cr/app/service/baoxiuIndex.do?
         userId=13632971318&propertyId=H041B005U001F001P001&phone=13632971318&typeForH5=Android&appType=JHRT&colorStyle=%2334ba63
         */
        /// 转换成字符串
        static func convert2Str(param: WxOrAppParam) -> String {
//            if param.userId == "" || param.pid == "" || param.accessToken == "" {
//                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
//                return ""
//            }
            
            guard param.accessToken != nil && param.accessToken != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
            guard param.userId != nil && param.userId != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
            guard param.pid != nil && param.pid != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
            let str = "type=\(param.type!)&userId=\(param.userId!)&pid=\(param.pid!)&typeForH5=\(param.typeForH5!)&moduleType=\(param.moduleType!)&accessToken=\(param.accessToken!)"
            return str
        }
        
        
    }
    
    /// 参数
    struct CrAppParam: Codable {
        /// 用户唯一标识(用户手机号)
        var userId: String? //= DianDouWorkApi.customerData.uid
        /// 房间标识(根据房间位置接口获取)
        var propertyId: String? = DDServiceAPI.customerData.pid
        /// APP类型
        var typeForH5: String? = TypeForH5.ios
        /// 用户手机号
        var phone: String? = AccountInfo.queryNow()?.account
        /// 功能名称标识
        var moduleType: String?
        /// 业主端 app 标识
        var appType: String? = AppType.JHRT
        /// 通过全局接口 获取
        var accessToken: String? = DDServiceAPI.accessToken
        
        /// 初始化方法
        init(moduleType: String) {
            self.moduleType = moduleType
            
            guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
                return
            }
            self.userId = account
            
        }
        
        /// 转换成字符串
        static func convert2Str(param: CrAppParam) -> String {
            
            guard param.accessToken != nil && param.accessToken != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
//            if param.userId == ""   || param.propertyId == "" || param.accessToken == "" {
//                ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
//                return ""
//            }
            
            guard param.userId != nil && param.userId != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
            guard param.propertyId != nil && param.propertyId != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
            let str = "userId=\(param.userId!)&propertyId=\(param.propertyId!)&typeForH5=\(param.typeForH5!)&phone=\(param.phone!)&moduleType=\(param.moduleType!)&appType=\(param.appType!)&accessToken=\(param.accessToken!)"
            
            return str
        }
    }
    
    /// 服务记录
    struct CrAppService: Codable {
        /// 用户唯一标识
        var appUserId: String? //= DianDouWorkApi.customerData.uid
        /// 房间标识
        var pid: String? = DDServiceAPI.customerData.pid
        /// APP类型
        var typeForH5: String? = TypeForH5.ios
        /// 用户手机号
        var phone: String? = AccountInfo.queryNow()?.account
        /// accessToken 通过全局接口获取
        var accessToken: String? = DDServiceAPI.accessToken
        
        /// 转换成字符串
        static func convert2Str(param: CrAppService) -> String {
            // 重新赋值参数
            var param = param
            
            guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
                return ""
            }
            // 参数赋值
            param.appUserId = account
            
            guard param.accessToken != nil && param.accessToken != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
            guard param.appUserId != nil && param.appUserId != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
            guard param.pid != nil && param.pid != "" else {
                //ProgressHUD.showText(NSLocalizedString("参数为空,重新加载", comment: ""))
                return ""
            }
            
            let str = "appUserId=\(param.appUserId!)&pid=\(param.pid!)&typeForH5=\(param.typeForH5!)&phone=\(param.phone!)&accessToken=\(param.accessToken!)"
            return str
        }
        
    }
    
    
    /// 业主端 app 标识
    struct AppType {
        /// 君和睿通
        static let JHRT = "JHRT"
    }
    
    //MARK: DD API返回数据
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
}


struct DiandouAccessTokenRes: Codable {
    /// 状态码
    var code: Int?
    /// 返回状态消息
    var message: String?
}
