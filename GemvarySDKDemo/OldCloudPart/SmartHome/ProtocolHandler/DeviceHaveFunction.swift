//
//  DeviceHaveFunction.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK
import GemvarySmartHomeSDK

class DeviceHaveFunctionHandler: NSObject {

    static func handleData(msg: MsgReceive, info: [String: Any]) -> Void {
        
        guard msg.result == MsgResult.success else {
            swiftDebug("处理 device_have_function 数据 失败")
            return
        }
        swiftDebug("开始处理 device_have_function 数据")
        switch msg.command {
        case Command.query_multi:
            
            guard let res = try? ModelDecoder.decode(DeviceHaveFunctionQueryMultiRecv.self, param: info) else {
                swiftDebug("DeviceHaveFunctionQueryMultiRecv 转换Model失败")
                return
            }
            //swiftDebug("解析出来的数据: ", res)
            if let func_attr = res.func_attr, let function_part = res.function_part {
                
                if func_attr.count == 1,
                   let func_attr = res.func_attr,
                   let funcAttr = func_attr.first,
                   let functions = funcAttr.functions,
                   let dev_class_type = funcAttr.dev_class_type,
                   dev_class_type == DevClassType.wired_alarm && function_part == FunctionPart.conds {
                    
                    for function in functions {
                        //function.function_part
                        var functionTemp = function
                        // 功能属性
                        functionTemp.function_part = function_part
                        // 设备类型
                        functionTemp.dev_class_type = dev_class_type
                        // 更新
                        Function.update(function: functionTemp)
                    }
                } else {
                    // 删除
                    Function.delete(functionPart: function_part)
                    //swiftDebug("准备插入的参数数据:: ", function_part, func_attr)
                    // 插入到数据库
                    Function.insert(functionPart: function_part, funcAttrs: func_attr)
                }
            }
            break
        default:
            swiftDebug("device_have_function 其他命令")
            break
        }
    }
    
}

/// 设备功能属性 查询
class DeviceHaveFunctionQueryMultiRecv: NSObject, Codable {
    /// 设备类型集合
    var classTypes: [String]?
    /// 命令 query_multi
    var command: String?
    /// 设备类型
    var dev_class_type: String?
    /// 客户端ID
    var from_account: String?
    /// 手机/平板
    var from_role: String?
    /// 设备功能属性列表
    var func_attr: [FuncAttr]?
    /// all: 查询所有功能属性 linkage: 查询支持做联动控制动作的属性 conds: 查询支持做联动条件的功能属性  param: 查询有参数需要显示的属性
    var function_part: String?
    /// 消息类型 device_have_function
    var msg_type: String?
    ///
    var pro_ver: String?
    /// 操作返回结果
    var result: String?
}

/// 设备功能属性
class FuncAttr: NSObject, Codable {
    /// 设备类型
    var dev_class_type: String?
    /// 功能属性信息
    var functions: [Function]?
}

class DeviceHaveFunctionQueryHandler: NSObject {
    /// 发送数据
    static func send(classTypes: [String]) -> Void {
        /// 要查询的功能功能
        let functionPartList = [FunctionPart.conds, FunctionPart.linkage, FunctionPart.param, ]
        // 判断当前账号是否为空
        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
            swiftDebug("当前用户信息为空")
            return
        }
        for function_part in functionPartList {
            // 设备功能属性查询 发送数据
            let sendData = DeviceHaveFunctionQueryMultiSend(from_account: account, function_part: function_part, classTypes: classTypes)
            
            guard let sendStr = ModelEncoder.encoder(toString: sendData) else {
                swiftDebug("转换字符串数据失败")
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                SmartHomeManager.sendMsgDataToDevice(msg: sendStr)
            }
        }
        
    }
}

/// 查询设备功能属性
class DeviceHaveFunctionQueryMultiSend: NSObject, Codable {
    /// 消息命令
    var msg_type: String? = MsgType.device_have_function
    /// 命令
    var command: String? = Command.query_multi
    /// 客户端
    var from_role: String? = FromRole.phone
    /// 账户
    var from_account: String?
    /// 功能属性
    var function_part: String?
    /// 类型
    var classTypes: [String]?
    
    /// 初始化方法
    init(from_account: String, function_part: String, classTypes: [String]) {
        self.from_account = from_account
        self.function_part = function_part
        self.classTypes = classTypes
    }
}
