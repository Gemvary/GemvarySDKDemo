//
//  SmartLinkageManager.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK
import GemvarySmartHomeSDK

class SmartLinkageManagerHandler: NSObject {

    static func handleData(msg: MsgReceive, info: [String: Any]) -> Void {
        
        guard msg.result == MsgResult.success else {
            swiftDebug("处理 smart_linkage_manager 数据 失败")
            return
        }
        
        switch msg.command {
        case Command.add: // 添加
            guard let res = try? ModelDecoder.decode(SmartLinkageManagerAddRecv.self, param: info) else {
                swiftDebug("SmartLinkageManagerAddRecv 转换Model失败")
                return
            }
            res.insertSmartLinkage()
            guard let jsonStr = JSONTool.translationObjToJson(from: info) else {
                return
            }
            break
        case Command.delete: // 删除
            guard let res = try? ModelDecoder.decode(SmartLinkageManagerDeleteRecv.self, param: info) else {
                swiftDebug("SmartLinkageManagerDeleteRecv 转换Model失败")
                return
            }
            res.deleteSmartLinkages()
            //swiftDebug("删除联动", res)
            break
        case Command.start: // 激活
            guard let res = try? ModelDecoder.decode(SmartLinkageManagerStartRecv.self, param: info) else {
                swiftDebug("SmartLinkageManagerStartRecv 转换Model失败")
                return
            }
            res.startSmartLinkages()
            //swiftDebug("激活联动:", res)
            break
        case Command.stop: // 失效
            guard let res = try? ModelDecoder.decode(SmartLinkageManagerStopRecv.self, param: info) else {
                swiftDebug("SmartLinkageManagerStopRecv 转换Model失败")
                return
            }
            res.stopSmartLinkages()
            //swiftDebug("激活联动:", res)
            break
        case Command.modify: // 修改
            guard let res = try? ModelDecoder.decode(SmartLinkageManagerModifyRecv.self, param: info) else {
                swiftDebug("SmartLinkageManagerModifyRecv 转换Model失败")
                return
            }
            res.updateSmartLinkages()
            //swiftDebug("联动更改", res)
            break
        case Command.query: // 查询
            guard let res = try? ModelDecoder.decode(SmartLinkageManagerQueryRecv.self, param: info) else {
                swiftDebug("SmartLinkageManagerQueryRecv 转换Model失败")
                return
            }
            // 插入数据库
            if (res.smart_linkages != nil) {
                SmartLinkage.deleteAll()
                // linkage_id = -1时
                SmartLinkage.insert(smartLinkages: res.smart_linkages!)
            }
            //swiftDebug("联动查询", res)
            break
        default: // 其他命令
            break
        }
    }
    
}

/// 联动管理 添加
class SmartLinkageManagerAddRecv: NSObject, Codable {
    /// 消息类型 smart_linkage_manager
    var msg_type: String?
    /// 命令 add
    var command: String?
    /// 平板/手机
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 联动名称
    var linkage_name: String?
    /// 状态 1.激活 0.禁用
    var state: Int?
    /// 触发时间
    var retrigger_time: Int?
    /// 满足条件
    var conditions: String?
    /// 联动触发执行动作列表
    //var dev_conds: [DevCond]?
    /// 联动执行条件列表
    //var exe_actions: [ExeAction]?
    /// 操作返回结果
    var result: String?
    
    /// 插入联动
    func insertSmartLinkage() -> Void {
        let smartLinkage = SmartLinkage()
        smartLinkage.linkage_name = self.linkage_name
        smartLinkage.state = self.state
        smartLinkage.conditions = self.conditions
        smartLinkage.content = ""
        smartLinkage.retrigger_time = self.retrigger_time
        smartLinkage.linkage_id = 0
        SmartLinkage.insert(smartLinkage: smartLinkage)
    }
}

/// 联动管理 删除
class SmartLinkageManagerDeleteRecv: NSObject, Codable {
    /// 消息类型 smart_linkage_manager
    var msg_type: String?
    /// 命令 delete
    var command: String?
    /// 平板/手机
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 联动ID
    var linkage_id: Int?
    /// 操作返回结果
    var result: String?
    
    /// 删除联动
    func deleteSmartLinkages() -> Void {
        // 删除
        guard let linkage_id = self.linkage_id, let smartLinkage = SmartLinkage.query(linkageID: linkage_id) else {
            return
        }
        SmartLinkage.delete(smartLinkage: smartLinkage)
    }
}

/// 联动管理 激活
class SmartLinkageManagerStartRecv: NSObject, Codable {
    /// 消息类型 smart_linkage_manager
    var msg_type: String?
    /// 命令 start
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 联动ID
    var linkage_id: Int?
    /// 操作返回结果
    var result: String?
    
    /// 激活联动数据
    func startSmartLinkages() -> Void {
        // 查询数据库中的联动
        guard let linkage_id = self.linkage_id, var smartLinkage = SmartLinkage.query(linkageID: linkage_id) else {
            return
        }
        smartLinkage.state = 1
        // 更新
        SmartLinkage.update(smartLinkage: smartLinkage)
    }
}

/// 联动管理 失效
class SmartLinkageManagerStopRecv: NSObject, Codable {
    /// 消息类型 smart_linkage_manager
    var msg_type: String?
    /// 命令 stop
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 联动ID
    var linkage_id: Int?
    /// 操作返回结果
    var result: String?
    
    /// 禁用联动数据
    func stopSmartLinkages() -> Void {
        // 查询数据库中的联动
        guard let linkage_id = self.linkage_id, var smartLinkage = SmartLinkage.query(linkageID: linkage_id) else {
            return
        }
        smartLinkage.state = 0
        // 更新
        SmartLinkage.update(smartLinkage: smartLinkage)
    }
}

/// 联动管理 更改 smart_linkage_manager modify
class SmartLinkageManagerModifyRecv: NSObject, Codable {
    /// 消息类型 smart_linkage_manager
    var msg_type: String?
    /// 命令 modify
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 联动ID
    var linkage_id: Int?
    /// 联动名字
    var linkage_name: String?
    /// 状态 0.禁用 1.激活
    var state: Int?
    /// 触发时间
    var retrigger_time: Int?
    /// 满足条件
    var conditions: String?
    /// 联动触发执行动作列表
    //var dev_conds: [DevCond]?
    /// 联动执行条件列表
    //var exe_actions: [ExeAction]?
    /// 操作返回结果
    var result: String?
    
    /// 更新联动数据
    func updateSmartLinkages() -> Void {
        // 查询数据库中的联动
        guard let linkage_id = self.linkage_id, var smartLinkage: SmartLinkage = SmartLinkage.query(linkageID: linkage_id) else {
            return
        }
        
        smartLinkage.linkage_name = self.linkage_name
        smartLinkage.state = self.state
        smartLinkage.conditions = self.conditions
        smartLinkage.retrigger_time = self.retrigger_time
        // 更新
        SmartLinkage.update(smartLinkage: smartLinkage)
    }
}

/// 联动管理 查询
class SmartLinkageManagerQueryRecv: NSObject, Codable {
    /// 联动管理
    var msg_type: String?
    /// 命令 查询
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端唯一ID
    var from_account: String?
    /// 联动ID linkage_id==-1:查询所有 linkage_id > 0:查询该联动的详细(动作和条件)
    var linkage_id: Int?
    /// 联动数组
    var smart_linkages: [SmartLinkage]?
    /// 操作返回结果
    var result: String?
}


//MARK: 发送数据的协议内容
/// 新增联动管理
struct SmartLinkageManagerAddSend: Codable {
    var msg_type: String? = MsgType.smart_linkage_manager
    var command: String? = Command.add
    var from_role: String? = FromRole.phone
    var from_account: String?
    var linkage_name: String?
    /// 联动规则的激活与失效，默认0为激活
    var state: Int?
    /// 规则触发间隔
    var retrigger_time: Int?
    /// || 只满足一个条件或者所有都满足（&&）
    var conditions: String?
    var dev_conds: [DevCondsAdd]?
    var exe_actions: [ExeActionsAdd]?
}

/// 新增场景条件
struct DevCondsAdd: Codable {
    /// 1某设备属性参数，2 场景触发 ，3撤布防 ，4时间，5当前地区，6当前天气
    var type: Int?
    var conds: String?
    /// 设备dev_id 或场景ID
    var obj_id: Int?
    var room_name: String?
    var dev_name: String?
    /// 如果类型是场景就会有该字段
    var scene_name: String?
    /// 如果是撤布防模式就有该字段
    var security_mode: String?
    var func_cmd: String?
    /// 附加参数列表，可参数属性属性参数说明，根据实际不通设备有所不同
    var func_value: String?
    var value: Int?
    var year: Int?
    var month: Int?
    var date: Int?
    var week: Int?
    var time: Int?
    var area: String?
    var param_type: Int?
}

/// 新增场景动作
struct ExeActionsAdd: Codable {
    /// 1 single, 2 scene，3 alarm,4 撤布防，5 联动规则的激活/失效,6 等待，8执行确认
    var type: Int?
    var seq: Int?
    /// 设备dev_id 或场景ID
    var obj_id: Int?
    var room_name: String?
    var dev_name: String?
    var scene_name: String?
    var func_cmd: String?
    var func_value: String?
    var value: Int?
    var content: String?
    var alarm_type: Int?
    var alarm_level: Int?
    var valid: Int?
    var inter_time: Int?
    var param_type: Int?
}


/// 删除联动
struct SmartLinkageManagerDeleteSend: Codable {
    var msg_type: String? = MsgType.smart_linkage_manager
    var command: String? = Command.delete
    var from_role: String? = FromRole.phone
    var from_account: String?
    var linkage_id: Int?
}
