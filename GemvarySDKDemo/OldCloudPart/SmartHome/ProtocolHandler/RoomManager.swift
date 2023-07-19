//
//  RoomManager.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/16.
//

import GemvaryToolSDK
import GemvarySmartHomeSDK

class RoomManagerHandler: NSObject {
    
    static func handleData(msg: MsgReceive, info: [String: Any]) -> Void {
        
        if msg.result != MsgResult.success  {
            // 消息错误处理
            swiftDebug("处理 room_manager 数据 失败")
            return
        }
        
        switch msg.command {
        case Command.add:
            guard let res = try? ModelDecoder.decode(RoomManagerAddRecv.self, param: info) else {
                swiftDebug("RoomManagerAddRecv 转换Model失败")
                return
            }
            // 插入房间数据
            res.insertRoom()
            break
        case Command.delete:
            guard let res = try? ModelDecoder.decode(RoomManagerDeleteRecv.self, param: info) else {
                swiftDebug("RoomManagerDeleteRecv 转换Model失败")
                return
            }
            // 删除房间数据
            res.deleteRoom()
            break
        case Command.modify:
            guard let res = try? ModelDecoder.decode(RoomManagerModifyRecv.self, param: info) else {
                swiftDebug("RoomManagerModifyRecv 转换Model失败")
                return
            }
            res.updateRoom()
            break
        case Command.query:
            // 清空数据库
            guard let res = try? ModelDecoder.decode(RoomManagerQueryRecv.self, param: info) else {
                swiftDebug("RoomManagerQueryRecv 转换Model失败")
                return
            }
            swiftDebug("房间管理 查询返回的信息:", res)
            if (res.rooms != nil) {
                Room.deleteAll()
                Room.insert(rooms: res.rooms!)
            }
            break
        default: // 其他命令
            break
        }
    }

}

/// 房间管理
class RoomManagerAddRecv: NSObject, Codable {
    /// 消息类型 room_manager
    var msg_type: String?
    /// 手机/平板
    var from_role: String?
    /// 命令 add
    var command: String?
    /// 客户端ID
    var from_account: String?
    /// 房间名称
    var room_name: String?
    /// 图片路径
    var room_backgroup: String?
    /// 房间类型
    var room_class_type: Int?
    /// 操作结果返回
    var result: String?
    
    /// 插入到数据库
    func insertRoom() -> Void {
        var room = Room()        
        room.room_name = self.room_name
        room.room_backgroup = self.room_backgroup
        room.room_class_type = self.room_class_type
        
        // 插入到数据库
        Room.insert(room: room)
    }
}

/// 房间管理 删除
class RoomManagerDeleteRecv: NSObject, Codable {
    /// 房间管理 room_manager
    var msg_type: String?
    /// 删除 delete
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 房间名称
    var room_name: String?
    /// 操作返回结果
    var result: String?
    
    /// 删除房间
    func deleteRoom() -> Void {
        if let room_name = self.room_name {
            // 删除房间
            Room.delete(roomName: room_name)
        }
    }
}

/// 房间管理 更改
class RoomManagerModifyRecv: NSObject, Codable {
    /// 房间管理 room_manager
    var msg_type: String?
    /// 修改 modify
    var command: String?
    /// 手机/平板
    var from_role: String?
    /// 客户端ID
    var from_account: String?
    /// 旧房间名字
    var old_room_name: String?
    /// 房间名字
    var room_name: String?
    /// 图片路径
    var room_backgroup: String?
    /// 房间类型
    var room_class_type: Int?
    /// 操作返回结果
    var result: String?
    
    /// 更新房间
    func updateRoom() -> Void {
        // 查询该房间
        guard let old_room_name = self.old_room_name, var room: Room = Room.query(roomName: old_room_name) else {
            return
        }
        room.room_name = self.room_name
        room.room_backgroup = self.room_backgroup
        room.room_class_type = self.room_class_type
        // 更新房间
        Room.update(room: room)
    }
}

/// 房间管理 查询
class RoomManagerQueryRecv: NSObject, Codable {
    /// 消息类型 房间管理
    var msg_type: String?
    /// 命令 查询
    var command: String?
    /// 手机
    var from_role: String?
    /// 客户端唯一ID
    var from_account: String?
    /// 房间列表
    var rooms: [Room]?
    /// 操作返回结果
    var result: String?
}
