//
//  AddDeviceTipsVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/10/11.
//

import UIKit

/// 添加设备提示
class AddDeviceTipsVC: UIViewController {

    /// 提示
    private var tipsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    /// 跳转按钮
    private var gotoButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setTitle("添加", for: UIControl.State.normal)
        button.backgroundColor = UIColor.brown
        button.addTarget(self, action: #selector(gotoButtonAction(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
            
    
    /// 设备类型
    var deviceClass: DeviceClass = DeviceClass() {
        didSet {
            if let dev_describe = self.deviceClass.dev_describe {
                self.tipsLabel.text = dev_describe
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加提示"
        self.view.backgroundColor = UIColor.white
        self.setupSubViews()
    }
    
    
    @objc func gotoButtonAction(_ button: UIButton) -> Void {
        let addDeviceConnectVC = AddDeviceConnectVC()
        addDeviceConnectVC.deviceClass = self.deviceClass
        self.navigationController?.pushViewController(addDeviceConnectVC, animated: true)
    }
    
}

extension AddDeviceTipsVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tipsLabel)
        self.view.addSubview(self.gotoButton)
        
        self.tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.gotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.tipsLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.tipsLabel, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: self.tipsLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.gotoButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.gotoButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.5, constant: 0),
            NSLayoutConstraint(item: self.gotoButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.4, constant: 0),
            NSLayoutConstraint(item: self.gotoButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.2, constant: 0),
        ])
    }
    
}
