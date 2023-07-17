//
//  AddDeviceConnectVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/10/11.
//

import UIKit

/// 添加设备进行配网
class AddDeviceConnectVC: UIViewController {

    
    private var configButton: UIButton = {
        let button = UIButton()
        button.setTitle("配网", for: UIControl.State.normal)
        return button
    }()
    
    
    
    var deviceClass: DeviceClass = DeviceClass() {
        didSet {
            swiftDebug("设备类型信息:: ", self.deviceClass)
        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设备配网"
        
        self.view.backgroundColor = UIColor.white
        self.setupSubViews()
    }
    
}


extension AddDeviceConnectVC {
    
    /// 发送数据
    private func sendData() -> Void {
        
    }
    
    
}

extension AddDeviceConnectVC {
    
    private func setupSubViews() -> Void {
        
    }
    
}
