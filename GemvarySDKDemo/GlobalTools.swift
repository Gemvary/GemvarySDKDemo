//
//  GlobalTools.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/15.
//

import UIKit
import AVFoundation

class GlobalTools: NSObject {
    
    // MARK: 检查麦克风授权
    /// 检查麦克风授权
    @objc class func checkPermissionsForMic() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch authStatus {
        case .notDetermined:
            // 未选择
            return true
        case .authorized:
            // 已授权
            return true
        case .restricted:
            // 不能修改权限
            GlobalTools.showAlertView(message: NSLocalizedString("不能完成麦克风授权,可能开启了访问限制,暂时无法使用云对讲.", comment: ""))
            return false
        case .denied:
            // 显示拒绝
            GlobalTools.showAlertView(message: NSLocalizedString("您已拒绝我们访问麦克风,暂时无法使用云对讲.", comment: ""))
            return false
        default:
            return false
        }
    }
    
    
    // MARK: 检查相机授权
    @objc class func checkPermissionsForCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            // 未选择
            return true
        case .authorized:
            // 已授权
            return true
        case .restricted:
            // 不能修改权限
            GlobalTools.showAlertView(message: NSLocalizedString("不能完成相机授权,可能开启了访问限制,暂时无法使用云对讲.", comment: ""))
            return false
        case .denied:
            // 显示拒绝
            GlobalTools.showAlertView(message: NSLocalizedString("您已拒绝我们访问相机,暂时无法使用云对讲.", comment: ""))
            return false
        default:
            return false
        }
    }
    
    // MARK: (检查麦克风授权/检查相机授权)弹出提示框
    class func showAlertView(message: String) {
        //
        let alertController = UIAlertController(title: NSLocalizedString("提示", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: 获取版本
    /// 获取App的信息
    public func getAppInfo() -> [String : Any] {
        return Bundle.main.infoDictionary!
    }
    
    
    /// 获取App的名称
    ///
    /// - Returns: App的名称
    public func getAppName() -> String {
        let info = getAppInfo()
        var displayName = info["CFBundleDisplayName"] as? String
        if displayName == nil {
            displayName = info["CFBundleName"] as? String
        }
        return displayName ?? ""
    }
    
    
    /// 获取App的 ShortVersion
    ///
    /// - Returns: ShortVersion版本
    public func getAppShortVersionString() -> String {
        let info = getAppInfo()
        let shortVersionString = info["CFBundleShortVersionString"] as? String
        return shortVersionString ?? ""
    }
    
    
    /// 获取App的BundleVersion
    ///
    /// - Returns: BundleVersion版本
    public func getAppBundleVersion() -> String {
        let info = getAppInfo()
        let bundleVersion = info["CFBundleVersion"] as? String
        return bundleVersion ?? ""
    }
    
    
    //MARK: 从沙盒路径下删除数据库文件
    /// 从沙盒路径下删除数据库文件
    static func deleteFile(fileName: String) -> Void {
        // 定位到用户文档
        let manager = FileManager.default
                
        let path: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/\(fileName)")
        
        if manager.fileExists(atPath: path) {
            swiftDebug("文件已存在 即将删除: ", fileName)
            // 删除
            try! manager.removeItem(atPath: path)
        } else {
            swiftDebug("文件不存在 无法删除")
        }
    }
    
    //MARK: 获取当前语言环境
    /// 获取当前语言环境
    @objc static func getCurrentLanguage() -> String {
        let preferredLang = Bundle.main.preferredLocalizations.first! as String
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            return "en"//英文
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            return "cn"//中文
        default:
            return "en"
        }
    }
}
