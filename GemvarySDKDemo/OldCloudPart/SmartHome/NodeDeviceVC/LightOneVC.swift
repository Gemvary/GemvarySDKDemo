//
//  LightOneVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/17.
//

import UIKit

/// 单键开关控制器
class LightOneVC: NodeDeviceVC {

    private lazy var stateButton: UIButton = {
        let button = UIButton()
        button.setTitle("关闭", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(stateButtonAction(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
        
    override var device: Device {
        didSet {
                                
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.funcList = ["开"]
                
    }
    
    
    @objc func stateButtonAction(_ button: UIButton) -> Void {
        
    }
    
    
}
