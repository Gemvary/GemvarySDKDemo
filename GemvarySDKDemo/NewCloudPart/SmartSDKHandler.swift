//
//  SmartSDKHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/26.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvaryNetworkSDK
import GemvarySmartHomeSDK

/// 智能家居SDK的处理
class SmartSDKHandler: NSObject {

    /// 设置SDK
    static func setup() -> Void {
        // 服务器为测试环境
        #if DEBUG
        NewCloudNetParam.userMode = NetWorkUserMode.test
        //NewCloudNetParam.userMode = NetWorkUserMode.release
        #else
        NewCloudNetParam.debug = false
        // 服务器为正式环境
        NewCloudNetParam.userMode = NetWorkUserMode.release
        #endif
        WebSocketParam.wsDomain = NewCloudNetParam.domain

        swiftDebug("当前网络请求域名: ", NewCloudNetParam.domain)
    }

    /// 设置token
    static func setupAccessToken(access_token: String) -> Void {
        // 设置请求header
        NewCloudNetParam.access_token = access_token
    }
            
    
    //MARK: 数字机配网
    /// 数字机配网
    static func sendWifi(ssid: String, password: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        // 开始配网
        AccessPointTool.share.sendUDP(ssid: ssid, password: password)
        // 配网返回结果
        AccessPointTool.share.apConfig { (result) in
            swiftDebug("是否配网成功", result)
            if result == true {
                // 配网成功
                successCallback?("\(result)")
            } else {
                // 配网失败
                failedCallback?("\(result)")
            }
        }
    }
    
    /// 停止数字机配网
    static func stopSendWifi() -> Void {
        // 停止
        AccessPointTool.share.stop()
    }
    
    
}
