//
//  WebSocketHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2020/12/28.
//  Copyright © 2020 gemvary. All rights reserved.
//

import GemvarySmartHomeSDK
import GemvaryToolSDK
import GemvaryCommonSDK

/// websocket处理
class WebSocketHandler: NSObject {

    static func setupWebSocket() -> Void {
        // 连接前先断开
        WebSocketTool.share.disconnect()
        
        guard let accountInfo = AccountInfo.queryNow(), let access_token = accountInfo.access_token else {
            swiftDebug("当前空间ID为空")
            return
        }
        
        if let spaceID = accountInfo.spaceID, spaceID != "" {
            // 有空间ID时 连接空间
            WebSocketTool.share.connectSocket(spaceID: spaceID, access_token: access_token) { result, error in
                swiftDebug("连接成功")
                // 处理接收到的数据
                WebSocketTool.share.receiveData { (jsonDic) in
                    guard let jsonDic = jsonDic else {
                        swiftDebug("接收到的数据为空")
                        return
                    }
                    swiftDebug("SDK上报的数据内容::: ", jsonDic)
                    // 处理数据
                    ProtocolHandler.jsonStrData(jsonDic: jsonDic)
                    // 数据转换为字符串
//                    guard let jsonStr = JSONTool.translationObjToJson(from: jsonDic) else {
//                        swiftDebug("WebSocket转换为字符串为空")
//                        return
//                    }
                    // 订阅数据
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeexNotiName.subscription), object: nil, userInfo: ["data": jsonStr])
                }
            }
            
            // 处理接收到的数据
            WebSocketTool.share.receiveData { (jsonDic) in
                guard let jsonDic = jsonDic else {
                    swiftDebug("接收到的数据为空")
                    return
                }
                swiftDebug("SDK上报的数据内容::: ", jsonDic)
                // 处理数据
                ProtocolHandler.jsonStrData(jsonDic: jsonDic)
                // 数据转换为字符串
//                guard let jsonStr = JSONTool.translationObjToJson(from: jsonDic) else {
//                    swiftDebug("WebSocket转换为字符串为空")
//                    return
//                }
                // 订阅数据
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeexNotiName.subscription), object: nil, userInfo: ["data": jsonStr])
            }
            
        } else if let smartDevCode = accountInfo.smartDevCode, smartDevCode != "" {
            // 空间ID设置为空
            //SocketRocketTool.share.spaceID = ""
            // 初始化订阅数据
            WebSocketTool.share.connectSocket(devCode: smartDevCode, access_token: access_token) { result, error in
                swiftDebug("新云端主机 WEBSOCKET连接")
                // 处理接收到的数据
                WebSocketTool.share.receiveData { (jsonDic) in
                    guard let jsonDic = jsonDic else {
                        swiftDebug("接收到的数据为空")
                        return
                    }
                    swiftDebug("SDK上报的数据内容::: ", jsonDic)
                    // 处理数据
                    ProtocolHandler.jsonStrData(jsonDic: jsonDic)
                    // 数据转换为字符串
//                    guard let jsonStr = JSONTool.translationObjToJson(from: jsonDic) else {
//                        swiftDebug("WebSocket转换为字符串为空")
//                        return
//                    }
                    // 订阅数据
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeexNotiName.subscription), object: nil, userInfo: ["data": jsonStr])
                }
            }
            
            // 处理接收到的数据
            WebSocketTool.share.receiveData { (jsonDic) in
                guard let jsonDic = jsonDic else {
                    swiftDebug("接收到的数据为空")
                    return
                }
                swiftDebug("SDK上报的数据内容::: ", jsonDic)
                // 处理数据
                ProtocolHandler.jsonStrData(jsonDic: jsonDic)
                // 数据转换为字符串
//                guard let jsonStr = JSONTool.translationObjToJson(from: jsonDic) else {
//                    swiftDebug("WebSocket转换为字符串为空")
//                    return
//                }
                // 订阅数据
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeexNotiName.subscription), object: nil, userInfo: ["data": jsonStr])
            }
        }
    }
    
    ///  订阅当前空间的数据
    static func connectCurrentSpace() -> Void {
                
        SmartHomeHandler.subscribeSpace { error in
            swiftDebug("订阅数据成功")
            ProgressHUD.showText("订阅数据成功")
            SmartHomeHandler.reviceData { jsonStr in
                guard let jsonStr = jsonStr else {
                    swiftDebug("接收到的数据为空")
                    return
                }
                guard let jsonDic = JSONTool.translationJsonToDic(from: jsonStr) else {
                    swiftDebug("字符串转字典失败")
                    return
                }
                swiftDebug("SDK上报的数据内容::: ", jsonDic)
                // 处理数据
                ProtocolHandler.jsonStrData(jsonDic: jsonDic)
                // 订阅数据
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WeexNotiName.subscription), object: nil, userInfo: ["data": jsonStr])
            }
            
//            SmartHomeHandler.subscribeSpace { error in
//                swiftDebug("订阅空间成功")
//                SmartHomeHandler.reviceData { (jsonStr) in
//                    guard let jsonStr = jsonStr else {
//                        swiftDebug("接收到的数据为空")
//                        return
//                    }
//                    guard let jsonDic = JSONTool.translationJsonToDic(from: jsonStr) else {
//                        swiftDebug("字符串转字典失败")
//                        return
//                    }
//                    swiftDebug("SDK上报的数据内容::: ", jsonDic)
//                    // 处理数据
//                    ProtocolHandler.jsonStrData(jsonDic: jsonDic)
//                }
//            }
            
            SmartHomeHandler.reviceData { (jsonStr) in
                guard let jsonStr = jsonStr else {
                    swiftDebug("接收到的数据为空")
                    return
                }
                guard let jsonDic = JSONTool.translationJsonToDic(from: jsonStr) else {
                    swiftDebug("字符串转字典失败")
                    return
                }
                swiftDebug("SDK上报的数据内容::: ", jsonDic)
                // 处理数据
                ProtocolHandler.jsonStrData(jsonDic: jsonDic)
            }
            
        }
    }
                
}
