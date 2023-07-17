//
//  LifeSmartNetHandler.swift
//  Gem_Home
//
//  Created by Gemvary Apple on 2021/12/27.
//

//import LifeSmartSDK
import GemvaryToolSDK
import GemvarySmartHomeSDK

/// 超级碗接口处理
class LifeSmartNetHandler: NSObject {

    /// 获取相应的所有遥控器品牌
    static func queryBrandsList(userid: String, usertoken: String, paramsDict: [String: String], successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        guard ReachableTool.share.reachable == true else {
            swiftDebug("当前网络不佳")
            failedCallback?("")
            return
        }
        swiftDebug("获取相应的所有遥控器品牌", userid, usertoken, paramsDict)
//        LifeSmartIRAPI.queryBrandsList(userid: userid, usertoken: usertoken, params: paramsDict) { object in
//            //swiftDebug("获取品牌内容: ", object as Any)
//            // 判断返回内容
//            guard let object: [String: Any] = object as? [String : Any] else {
//                swiftDebug("不是字典数据:: ", object as Any)
//                failedCallback!("")
//                return
//            }
//            guard let code = object["code"] as? Int, code == 0 else {
//                swiftDebug("请求结果失败")
//                failedCallback!("")
//                return
//            }
//            
//            guard let message = object["message"] as? [String: Any], let data = message["data"] as? [String: Any] else {
//                swiftDebug("解析数据失败")
//                failedCallback!("")
//                return
//            }
//            //swiftDebug("解析后的数据内容:: ", data)
//            // 获取字典key
//            var valueArray: [[String: Any]] = [[String: Any]]()
//            for key in data.keys {
//                let value = data[key]
//                valueArray.append(["codeCount": value as Any, "name": key])
//            }
//            // 给数组排序
//            valueArray.sort (by:{
//                $1["codeCount"] as! Int > $0["codeCount"] as! Int
//            })
//            // 转换字符串
//            guard let jsonStr = JSONTool.translationObjToJson(from: valueArray as Any) else {
//                swiftDebug("转换字符串失败")
//                failedCallback!("")
//                return
//            }
//            //swiftDebug("转换后的字符串内容:: ", jsonStr)
//            successCallback!(jsonStr)
//        }
    }
    
    /// 从超级碗(Spot)删除⼀一个遥控器
    static func deleteRemote(userid: String, usertoken: String, paramsDict: [String: String], successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        swiftDebug("从超级碗中删除一个遥控器:: ", userid, usertoken, paramsDict)
//        LifeSmartIRAPI.deleteRemote(userid: userid, usertoken: usertoken, params: [String : String]()) { object in
//
//        }
    }
    
    /// 获取支持的遥控器种类
    static func queryCategoryList(userid: String, usertoken: String, successCallback: ((String?) -> Void)? = nil, failedCallback: ((String?) -> Void)? = nil) -> Void {
        swiftDebug("获取支持的遥控器种类")
//        LifeSmartIRAPI.queryCategoryList(userid: userid, usertoken: usertoken) { object in
//            swiftDebug("获取支持的遥控器种类", object as Any)
//        }
    }
    
    
    /// 获取超级碗的注册sign方法
    static func getRepeaterSign(methodprams: String, time: String, userid: String, usertoken: String) -> String {
        swiftDebug("注册参数的方法", methodprams, time, userid, usertoken)
        /*
         ["注册参数的方法", "GetBrands,category:ac", "1640586332", "10001", "10001"]
         */
        // 分割字符串
        let methodpramsArray = methodprams.components(separatedBy: ",")
        guard let methodName = methodpramsArray.first, let methodParam = methodpramsArray.last else {
            swiftDebug("超级碗 方法参数的方法名字/方法参数 获取为空")
            return ""
        }
        let paramDict = methodParam.components(separatedBy: ":")
        guard let key = paramDict.first, let value = paramDict.last else {
            swiftDebug("超级碗 方法参数 key value获取为空")
            return ""
        }
        
        let resultDict = ["": ""] // LifeSmartIRAPI.getParameters(userid: userid, usertoken: usertoken, method: methodName, params: [key: value])
        swiftDebug("注册方法内容", resultDict as Any)
        guard let resultStr = JSONTool.translationObjToJson(from: resultDict as Any) else {
            swiftDebug("注册方法的数据 转换字符串失败")
            return ""
        }
        return resultStr
    }
}
