//
//  General.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2022/4/27.
//

import UIKit

/// 新旧通用代码或功能

/// 免登录返回数据内容
struct PhoneTokenLoginRes: Codable {
    /// 返回状态码
    var code: Int?
    /// 返回数据
    var data: PhoneTokenLoginData?
    /// 返回状态消息
    var message: String?
}

/// 免登录返回数据内容
struct PhoneTokenLoginData: Codable {
    /// 0-均可呼叫，1-落地呼叫免打扰，2-APP免打扰，3-均免打扰
    var userStatus: Int?
    
}

/// 智能家居接受数据解析
//struct MsgReceive: Codable {
//    /// 消息类型
//    var msg_type: String?
//    /// 命令
//    var command: String?
//    /// 结果
//    var result: String?
//}

/// 智能家居消息返回result的状态
//struct MsgResult {
//    /// 数据错误
//    static let data_error = "data_error"
//    /// 成功
//    static let success = "success"
//    /// 失败
//    static let failed = "failed"
//    /// 相同设备
//    static let same = "same"
//}

/// 请求门口机/室内机的数据
//struct AllInOutdoorDevRes: Codable {
//    /// 状态码
//    var code: Int?
//    /// 返回数据
//    var data: [InOutdoorDev]?
//    /// 状态消息
//    var message: String?
//}


/// 网络请求返回状态码
struct NetResCode: Codable {
    /// 成功 200
    static let c200 = 200
    /// 失败 400
    static let c400 = 400
    /// 未认证(签名错误) 401
    static let c401 = 401
    /// 接口不存在 404
    static let c404 = 404
    /// 服务器内部错误 500
    static let c500 = 500
    /// Web页面未登录 551
    static let c551 = 551
    /// 手机未登录 552
    static let c552 = 552
    /// 免登录验证失败返回码 553
    static let c553 = 553
    /// 账户已过期 554
    static let c554 = 554
    /// 人脸录入 图片不适合 570 badface
    static let c570 = 570
}

/// 旧智能家居主机绑定类型
//struct BindType {
//    /// 主账号
//    static let main = "main"
//    /// 子账号
//    static let sub = "sub"
//}
