//
//  SceneControlManager.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK
import GemvarySmartHomeSDK
import Foundation

class SceneControlManagerHandler: NSObject {

    static func handleData(msg: MsgReceive, info: [String: Any]) -> Void {
        
        guard msg.result == MsgResult.success else {
            swiftDebug("处理 scene_control_manager 数据 失败")
            return
        }
        
        switch msg.command {
        case Command.add: // 添加
            // 解析数据会崩溃
            //let res = try! ModelDecoder.decode(SceneControlManagerAdd.self, param: info)
            //swiftDebug("场景管理 添加:", res)
            // 删除场景
            //res.insertScene()
            break
        case Command.delete: // 删除
            guard let res = try? ModelDecoder.decode(SceneControlManagerDeleteRecv.self, param: info) else {
                swiftDebug("SceneControlManagerDeleteRecv 转换Model失败")
                return
            }
            swiftDebug("场景管理 删除:", res)
            // 删除场景
            res.deleteScene()
            
            break
        case Command.modify: // 更新
            guard let res = try? ModelDecoder.decode(SceneControlManagerModifyRecv.self, param: info) else {
                swiftDebug("SceneControlManagerModifyRecv 转换Model失败")
                return
            }
            res.updateScene()
            
            break
        case Command.query_all: // 场景查询 所有
            
            guard let res = try? ModelDecoder.decode(SceneControlManagerQueryAllRecv.self, param: info) else {
                swiftDebug("SceneControlManagerQueryAllRecv 转换Model失败")
                return
            }
            //swiftDebug("场景管理 查询所有:", res)
            if res.scenes != nil {
                // 删除旧数据
                Scene.deleteAll()
                // 插入数据
                Scene.insert(scenes: res.scenes!)
            }
//            guard let jsonStr = JSONTool.translationObjToJson(from: info) else {
//                return
//            }
            
            break
            
        case Command.query: // 场景 查询
            //let res = try! ModelDecoder.decode(SceneControlManagerQuery.self, param: info)
            
            //swiftDebug("设备场景 管理查询:", res)
//            guard let jsonStr = JSONTool.translationObjToJson(from: info) else {
//                return
//            }
            
            break
        case Command.photo:
            // 场景命令是快照 插入到数据库
            guard let res = try? ModelDecoder.decode(SceneControlManagerPhotoRecv.self, param: info) else {
                swiftDebug("SceneControlManagerPhotoRecv 转换Model失败")
                return
            }
            // 判断当前账号是否为空
            guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
                swiftDebug("当前用户信息为空")
                return
            }
            swiftDebug("场景管理 快照:", res)
            let sendData = SceneControlManagerQueryAllSend(from_account: account, room_name: "", scene_id: -1)
            guard let sendStr = ModelEncoder.encoder(toString: sendData) else {
                return
            }
            // 发送消息
            SmartHomeManager.sendMsgDataToDevice(msg: sendStr) { (result, error) in
                swiftDebug("场景查询所有 发送数据返回的内容:", result as Any, error as Any)
                // 更新设备显示
            }
            
            // 删除场景
            //res.insertScene()
            break
        case Command.start: // 启动执行
            
            guard let jsonStr = JSONTool.translationObjToJson(from: info) else {
                return
            }
            
            guard let res = try? ModelDecoder.decode(SceneControlManagerStartRecv.self, param: info) else {
                swiftDebug("执行场景 转换model失败")
                return
            }
            
            res.update()
            break
        default:
            break
        }
    }
    
}

/// 场景控制管理 删除
class SceneControlManagerDeleteRecv: NSObject, Codable {
    /// 命令 delete
    var command: String?
    /// 客户端ID
    var from_account: String?
    /// 手机/平板
    var from_role: String?
    /// 消息类型 scene_control_manager
    var msg_type: String?
    /// 版本
    var pro_ver: String?
    /// 操作返回结果
    var result: String?
    /// 场景ID
    var scene_id: Int?
    
    /// 删除 场景
    func deleteScene() -> Void {
        // 查询场景
        guard let scene_id = self.scene_id, let scene = Scene.query(sceneID: scene_id) else {
            return
        }
        // 删除场景
        Scene.delete(scene: scene)
    }
}

/// 场景控制管理  修改
class SceneControlManagerModifyRecv: NSObject, Codable {
    /// 消息类型 scene_control_manager
    var msg_type: String?
    /// 命令 modify
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 房间名称
    var room_name: String?
    /// 场景ID
    var scene_id: Int?
    /// 图标
    var icon: String?
    /// 场景类型
    var scene_type: Int?
    /// modify
    var func_cmd: String?
    /// 客户端ID
    var from_account: String?
    /// 场景名称
    var scene_name: String?
    /// 动作
    //var actions: [Action]?
    /// 操作返回结果
    var result: String?
    
    /// 更新场景
    func updateScene() -> Void {
        // 查询场景
        guard let scene_id = self.scene_id, var scene: Scene = Scene.query(sceneID: scene_id) else {
            return
        }
        scene.icon = self.icon
        scene.type = self.scene_type
        scene.scene_name = self.scene_name
        scene.room_name = self.room_name
        Scene.update(scene: scene)
    }
    
}

/// 场景控制管理 查询所有    query_all/query
class SceneControlManagerQueryAllRecv: NSObject, Codable {
    /// 消息类型 场景管理
    var msg_type: String?
    /// 命令 查询
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 房间名字
    var room_name: String?
    /// 场景ID
    var scene_id: Int?
    /// 返回结果
    var result: String?
    /// 场景数组
    var scenes: [Scene]?
}

/// 场景控制管理 快照
class SceneControlManagerPhotoRecv: NSObject, Codable {
    /// 消息类型 scene_control_manager
    var msg_type: String?
    /// 命令 photo
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 房间名字
    var room_name: String?
    /// 场景名字
    var scene_name: String?
    /// 场景ID
    var scene_id: Int?
    /// 场景类型
    var scene_type: Int?
    /// 场景图片
    var icon: String?
    /// 操作返回结果
    var result: String?
    
    /// 插入到数据库
    func insertScene() -> Void {
        let scene = Scene()
        scene.scene_id = self.scene_id
        scene.icon = self.icon
        scene.type = self.scene_type
        scene.scene_name = self.scene_name
        scene.room_name = self.room_name
        scene.executing = 0
        scene.state = 0
        Scene.insert(scene: scene)
    }
}




/// 场景控制管理 启动
class SceneControlManagerStartRecv: NSObject, Codable {
    /// 命令
    var command: String?
    /// 账号
    var from_account: String?
    /// 客户端
    var from_role: String?
    /// 消息类型
    var msg_type: String?
    /// 协议版本
    var pro_ver: String?
    /// 返回操作结果
    var result: String?
    /// 场景ID
    var scene_id: Int?
    
    /// 更新场景
    func update() -> Void {
        if self.result == MsgResult.success {
            guard let scene_id = self.scene_id, var scene = Scene.query(sceneID: scene_id) else {
                return
            }
            scene.executing = 1
            Scene.update(scene: scene)
            //swiftDebug("当前的场景内容:", scene)
            
//            guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else {
//                swiftDebug("当前用户信息为空")
//                return
//            }
//
//            // 查询该房间内数据
//            let query = SceneControlManagerQuerySend(room_name: scene.room_name!, from_account: account)
//            guard let sendData = ModelEncoder.encoder(toString: query) else {
//                return
//            }
//            //swiftDebug("发送的数据", sendData)
//            // 发送数据
//            SmartHomeManager.sendMsgDataToDevice(msg: sendData) { (result, error) in
//            }
        }
    }
}

//MARK: 场景发送数据命令
/// 查询场景发送数据
class SceneControlManagerQueryAllSend: NSObject, Codable {
    /// 消息类型
    var msg_type: String? = MsgType.scene_control_manager
    /// 命令
    var command: String? = Command.query_all
    /// 客户端 手机
    var from_role: String? = FromRole.phone
    /// 房间名字
    var room_name: String?
    /// 账号
    var from_account: String?
    /// 场景ID
    var scene_id: Int?
    
    init(from_account: String?, room_name: String?, scene_id: Int?) {
        self.from_account = from_account
        self.room_name = room_name
        self.scene_id = scene_id
    }
}

/// 场景执行
class SceneControlManagerStartSend: NSObject, Codable {
    
    var msg_type: String? = MsgType.scene_control_manager
    var command: String? = Command.start
    var from_role: String? = FromRole.phone
    var from_account: String?
    var room_name: String?
    var scene_id: Int?
    
    init(from_account: String?, room_name: String?, scene_id: Int?) {
        self.from_account = from_account
        self.room_name = room_name
        self.scene_id = scene_id
    }
}

/// 查询某场景的所有动作
class SceneControlManagerQuerySend: NSObject, Codable {
    var msg_type: String = MsgType.scene_control_manager
    var command: String? = Command.query
    var from_role: String? = FromRole.phone
    var from_account: String?
    var scene_id: Int?
    
    init(from_account: String?, scene_id: Int?) {
        self.from_account = from_account
        self.scene_id = scene_id
    }
}

/// 场景快照配置
class SceneControlManagerPhotoSend: NSObject, Codable {
    var msg_type: String? = MsgType.scene_control_manager
    var command: String = Command.photo
    var from_role: String = FromRole.phone
    var from_account: String?
    var room_name: String?
    var scene_name: String?
    var scene_type: Int?
    var icon: String?
    
    init(from_account: String, room_name: String, scene_name: String, scene_type: Int, icon: String) {
        self.from_account = from_account
        self.room_name = room_name
        self.scene_name = scene_name
        self.scene_type = scene_type
        self.icon = icon
    }
}

/// 新增场景
class SceneControlManagerAddSend: NSObject, Codable {
    var msg_type: String = MsgType.scene_control_manager
    var command: String = Command.add
    var from_role: String = FromRole.phone
    var room_name: String?
    var scene_id: Int?
    var icon: String?
    ///0 全局场景，1房间场景
    var scene_type: Int?
    var func_cmd: String?
    var from_account: String?
    var scene_name: String?
    var actions: [SceneActions]?
    
    var comm_type: Int?
}


class SceneActions: NSObject, Codable {
    var type: Int?
    var conditions: String?
    var obj_id: Int? = 0
    var security_mode: String?
    var room_name: String?
    var dev_name: String?
    var func_value: String?
    var func_cmd: String?
    var value: Int?
    var valid: Int?
    var seq: Int?
    var inter_time: Int?
    var param_type: Int?
}
