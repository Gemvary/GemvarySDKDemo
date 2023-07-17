//
//  CloudCallVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/9/15.
//

import UIKit
import GemvaryNetworkSDK
import GemvaryToolSDK
//import GemvaryZGCloudCallSDK
import GemvaryCommonSDK

/// 新云对讲枚举值
enum CloudCallType {
    /// 云对讲 被动呼入 (主机呼叫手机 弹出通知)
    case callin
    /// 云对讲 主动呼叫(手机呼叫主机 主动呼出)
    case callout
}

class CloudCallVC: UIViewController {
    
}

/// 云对讲功能页面
//class CloudCallVC: UIViewController {
//    /// 顶部
//    private var headerImageView: UIImageView = {
//        let imageView = UIImageView()
//        //imageView.backgroundColor = UIColor.brown
//        imageView.image = UIImage(named: "icon")
//        imageView.contentMode = .scaleToFill
//        return imageView
//    }()
//    /// 预览画面(视频对讲时出现)
//    private var previewImageView: UIImageView = {
//        let imageView = UIImageView()
//        //imageView.backgroundColor = UIColor.yellow
//        imageView.image = UIImage(named: "icon")
//        //imageView.contentMode = .scaleToFill
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//    /// 状态label
//    private var stateLabel: UILabel = {
//        let label = UILabel()
//        label.text = "通话中";
//        label.textColor = UIColor.white
//        return label
//    }()
//    /// 显示名字滚动图
//    private var marqueeView: MarqueeView = {
//        let view = MarqueeView()
//        //view.backgroundColor = UIColor.orange
//        //view.isHidden = true
//        view.fontOfMarqueeLabel = 17.0
//        view.textColor = UIColor.white
//        return view
//    }()
//    /// 底部按钮页面 栈view
//    private var buttonListView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = NSLayoutConstraint.Axis.horizontal
//        stackView.distribution = UIStackView.Distribution.equalSpacing
//        //stackView.distribution = UIStackView.Distribution.fillEqually
//        stackView.spacing = UIStackView.spacingUseDefault
//        stackView.alignment = UIStackView.Alignment.center
//        //stackView.alignment = UIStackView.Alignment.fill
//        //stackView.spacing = 0
//        stackView.contentMode = UIView.ContentMode.scaleToFill
//        stackView.semanticContentAttribute = .unspecified
//        return stackView
//    }()
//    /// 麦克风静音按钮
//    private lazy var microButton: CloudCallButton = {
//        let button = CloudCallButton()
//        //button.imageView?.contentMode = .scaleAspectFit
//        button.setBackgroundImage(UIImage(named: "button_mute_off"), for: UIControl.State.selected)
//        button.setBackgroundImage(UIImage(named: "button_mute_on"), for: UIControl.State.normal)
//        button.addTarget(self, action: #selector(microButtonAction(button:)), for: UIControl.Event.touchUpInside)
//        return button
//    }()
//    /// 接通按钮
//    private lazy var answerButton: CloudCallButton = {
//        let button = CloudCallButton()
//        //button.imageView?.contentMode = .scaleAspectFit
//        button.setBackgroundImage(UIImage(named: "answer_keys"), for: UIControl.State.normal)
//        button.addTarget(self, action: #selector(answerButtonAction(button:)), for: UIControl.Event.touchUpInside)
//        return button
//    }()
//    /// 开锁按钮
//    private lazy var unlockButton: CloudCallButton = {
//        let button = CloudCallButton()
//        //button.imageView?.contentMode = .scaleAspectFit
//        button.setBackgroundImage(UIImage(named: "unlocking"), for: UIControl.State.normal)
//        button.addTarget(self, action: #selector(unlockButtonAction(button:)), for: UIControl.Event.touchUpInside)
//        return button
//    }()
//    /// 挂断按钮
//    private lazy var hangupButton: CloudCallButton = {
//        let button = CloudCallButton()
//        //button.imageView?.contentMode = .scaleAspectFit
//        button.setBackgroundImage(UIImage(named: "hang_up_key"), for: UIControl.State.normal)
//        button.addTarget(self, action: #selector(hangupButtonAction(button:)), for: UIControl.Event.touchUpInside)
//        return button
//    }()
//    /// 扬声器按钮
//    private lazy var speakerButton: CloudCallButton = {
//        let button = CloudCallButton()
//        //button.imageView?.contentMode = .scaleAspectFit
//        button.setBackgroundImage(UIImage(named: "button_HF_off"), for: UIControl.State.normal)
//        button.setBackgroundImage(UIImage(named: "button_HF_on"), for: UIControl.State.selected)
//        button.addTarget(self, action: #selector(speakerButtonAction(button:)), for: UIControl.Event.touchUpInside)
//        return button
//    }()
//    /// 宽度的约束
//    private var buttonsWidthCon: NSLayoutConstraint = NSLayoutConstraint()
//
//
//    /// 数据
//    var data: [String: Any] = [String: Any]() {
//        didSet {
//            if let callData = try? ModelDecoder.decode(ZegoCallInfo.self, param: self.data)  {
//                // 呼叫数据赋值
//                self.callData = callData
//            }
//        }
//    }
//    /// 呼叫的信息数据
//    private var callData: ZegoCallInfo = ZegoCallInfo() {
//        didSet {
//            // 呼叫引擎赋值
//            ZegoEngineTool.share.callData = self.callData
//            // 地址赋值
//            if let device = self.callData.data, let devName = device.devName {
//                if self.callType == CloudCallType.callin {
//                    self.marqueeView.textArr = [devName]
//                }
//                // 设备类型为管理机时 隐藏开锁按钮
//                if let devType = device.devType, devType == CloudCallDevType.manager || devType == 99 {
//                    swiftDebug("管理机时 隐藏开锁按钮")
//                    self.unlockButton.isHidden = true
//                }
//            }
//        }
//    }
//    /// 呼叫的目标
//    var to: String = String() {
//        didSet {
//            if self.callType == CloudCallType.callout {
//                self.marqueeView.textArr = [self.to]
//            }
//        }
//    }
//    /// 呼叫的来源
//    var from: String = String()
//    /// 云对讲呼叫的类型(默认呼入)
//    var callType: CloudCallType = CloudCallType.callin
//    /// 是否有人接听 默认 没有
//    var isAnswer: Bool = false
//
//
//    /// 页面即将出现
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // 设置铃声
//        UCSSoundEffect.instance().play()
//
//    }
//
//    /// 页面已经出现
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//    }
//
//    /// 页面已经加载
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.view.backgroundColor = UIColor.black
//        // 引擎工具类设置代理
//        ZegoEngineTool.share.delegate = self
//
//        // 设置子控件
//        self.setupSubViews()
//
//        // 所有按钮不可点击
//        self.microButton.isEnabled = false
//        self.answerButton.isEnabled = false
//        self.unlockButton.isEnabled = false
//        self.hangupButton.isEnabled = false
//        self.speakerButton.isEnabled = false
//        // 默认麦克风 扬声器 关闭
//        ZegoEngineTool.share.closeMicrophone()
//        ZegoEngineTool.share.closeSpeaker()
//
//
//        // 隐藏子控件
//        /*
//         没有呼通时 麦克风 开锁 扬声器 隐藏
//         */
//        self.microButton.isHidden = true
//        self.unlockButton.isHidden = true
//        self.speakerButton.isHidden = true
//        if self.callType == CloudCallType.callout {
//            swiftDebug("手机呼叫主机")
//            // 隐藏接听按钮
//            self.answerButton.isHidden = true
//            self.updateSubViews(width: 50)
//        }
//
//        // 监听是否进入前台
//        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
//
//        // 加载页面
//        guard let accountInfo = AccountInfo.queryNow(), let account = accountInfo.account else { //
//            swiftDebug("获取当前账号信息")
//            return
//        }
//
//        // 判断呼叫类型
//        if self.callType == CloudCallType.callin {
//            // 主机呼叫手机 呼入
//            if self.to == account {
//                // 初始化方法 主机主动呼叫手机
//                self.stateLabel.text = "来电"
//                self.initZGCloud()
//            }
//        } else {
//            // 手机主动呼叫主机 呼出
//            if self.from == account {
//                // 手机主动呼叫主机 from手机号
//                self.stateLabel.text = "呼叫"
//                self.loginRoomFromZG()
//            }
//        }
//
//
//        // 5s没有拉取到有效流就退出房间
//        // 25s没有人接听就自动挂断
//        // 500ms来电超时处理
//
//        // 创建通知
//        NotificationCenter.default.addObserver(self, selector: #selector(cloudCallResultFailed(_:)), name: NSNotification.Name(rawValue: "CloudCallResultFailed"), object: nil)
//
//        // 延时操作
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 25.0) {
//            // 判断当前状态
//            if self.isAnswer == false {
//                // 没人接听 按挂断处理
//                ZegoEngineTool.share.hangup()
//            }
//        }
//    }
//
//    /// 页面即将消失
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//    }
//
//    /// 页面已经消失
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        // 停止播放
//        ZegoEngineTool.share.stopPlayAndPublish()
//        // 退出房间
//        ZegoEngineTool.share.logoutRoom()
//        // 铃声停止
//        UCSSoundEffect.instance().remove()
//    }
//
//    /// 云对讲呼叫失败返回
//    @objc func cloudCallResultFailed(_ noti: Notification) -> Void {
//        swiftDebug("用户信息:: ", noti.userInfo as Any)
//
//        if let userInfo: [String: Any] = noti.userInfo as? [String: Any], let result: Int = userInfo["result"] as? Int {
//            switch result {
//            case 0:
//                ProgressHUD.showText("呼叫失败，设备正常")
//                swiftDebug("设备正常")
//                break
//            case 1:
//                ProgressHUD.showText("呼叫失败，设备不存在")
//                swiftDebug("呼叫失败，设备不存在")
//                break
//            case 2:
//                ProgressHUD.showText("呼叫失败，设备不在线")
//                swiftDebug("呼叫失败，设备不在线")
//                break
//            case 3:
//                ProgressHUD.showText("呼叫失败，设备正忙")
//                swiftDebug("呼叫失败，设备正忙")
//                break
//            default:
//                break
//            }
//        }
//        // 挂断
//        //ZegoEngineTool.share.hangup()
//        // 停止播放
//        //ZegoEngineTool.share.stopPlayAndPublish()
//        // 退出房间
//        ZegoEngineTool.share.logoutRoom()
//        // 铃声取消
//        UCSSoundEffect.instance().remove()
//        // 页面消失
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    deinit {
//        // 移除通知方法
//        NotificationCenter.default.removeObserver(self)
//        // 息屏
//        UIDevice.current.isProximityMonitoringEnabled = false
//        UIApplication.shared.isIdleTimerDisabled = false
//    }
//
//    //MARK: 初始化云对讲
//    /// 初始化云对讲(门口机呼叫手机)
//    private func initZGCloud() -> Void {
//        swiftDebug("开始呼叫手机端信息:: ")
//        // 设置云对讲
//        ZegoEngineTool.share.setVideoAndAudio(remoteView: self.previewImageView)
//        // 登录房间 from==主机地址  to==当前手机号
//        ZegoEngineTool.share.loginRoom(roomID: self.from, userID: self.to, loginType: 0)
//
//        if let device = self.callData.data, let devName = device.devName {
//            // 保存到数据库
//            //DBOperation.insertNotAnswerCallrecords(with: devName)
//        }
//
//        // 2s后 开锁按钮显示
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
//
//            if let device = self.callData.data, let devType = device.devType, devType == CloudCallDevType.manager || devType == 99 {
//                // 设备类型为管理机时 隐藏开锁按钮
//                self.unlockButton.isHidden = true
//            } else {
//                self.unlockButton.isHidden = false
//            }
//
//        }
//    }
//
//
//    /// 登录初始化云对讲(呼叫门口机)
//    private func loginRoomFromZG() -> Void {
//        // 设置云对讲
//        ZegoEngineTool.share.setVideoAndAudio(remoteView: self.previewImageView)
//        // 登录房间 from==当前手机号
//        ZegoEngineTool.share.loginRoom(roomID: self.from, userID: self.from, loginType: 0)
//        // 已呼叫
//        //DBOperation.insertOutCallrecords(with: self.to)
//
//        // 呼叫主机 发送请求
//        self.newPhoneCallRequest()
//    }
//
//
//    //MARK: 通知方法
//    /// 应用进入前台
//    @objc func willEnterForeground(_ noti: Notification) -> Void {
//        swiftDebug("应用进入前台")
//        //
//    }
//
//    /// 退出房间
//    private func logoutRoom() -> Void {
//        // 停止推流
//        ZegoEngineTool.share.stopPlayAndPublish()
//        ZegoEngineTool.share.logoutRoom()
//    }
//}
//
//extension CloudCallVC {
//    /// 麦克风静音按钮 动作方法
//    @objc func microButtonAction(button: UIButton) -> Void {
//        swiftDebug("麦克风 静音 动作方法")
//        // 按钮状态选择
//        self.microButton.isSelected = !self.microButton.isSelected
//
//        if self.microButton.isSelected == true {
//            ZegoEngineTool.share.openMicrophone()
//        } else {
//            ZegoEngineTool.share.closeMicrophone()
//        }
//    }
//
//    /// 接通按钮 动作方法
//    @objc func answerButtonAction(button: UIButton) -> Void {
//        swiftDebug("接通按钮动作方法")
//
//        ZegoEngineTool.share.answer()
//    }
//
//    /// 开锁按钮 动作方法
//    @objc func unlockButtonAction(button: UIButton) -> Void {
//        swiftDebug("开锁按钮 动作方法")
//
//        ProgressHUD.showText("发送开锁信息")
//        ZegoEngineTool.share.unlock()
//        // 发送服务器开锁请求
//        self.unlockRequest()
//    }
//
//    /// 挂断按钮 动作方法
//    @objc func hangupButtonAction(button: UIButton) -> Void {
//        swiftDebug("挂断按钮 动作方法")
//
//        ZegoEngineTool.share.hangup()
//        // 铃声取消
//        UCSSoundEffect.instance().remove()
//        // 页面消失
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    /// 扬声器外音按钮 动作方法
//    @objc func speakerButtonAction(button: UIButton) -> Void {
//        swiftDebug("扬声器外音按钮 动作方法")
//        self.speakerButton.isSelected = !self.speakerButton.isSelected
//
//        if self.speakerButton.isSelected == true {
//            ZegoEngineTool.share.openSpeaker()
//        } else {
//            ZegoEngineTool.share.closeSpeaker()
//        }
//    }
//}
//
//extension CloudCallVC {
//
//    /// 发送开锁命令给服务器
//    private func unlockRequest() -> Void {
//        // 解析数据
//        guard let device = self.callData.data, let zoneId = device.zoneId else {
//            swiftDebug("")
//            return
//        }
//        var devcode = ""
//
//        if self.callType == CloudCallType.callin {
//            // 主机呼叫手机
//            devcode = self.from
//        } else {
//            // 手机呼叫主机
//            devcode = self.to
//        }
//
//        // 兼容旧门口机开锁
//        // 开锁方式 2:来电开锁 1: 旧钥匙包开锁 15:钥匙包开锁(兼容后)
//        PhoneWorkAPI.phoneMsgForward(zoneCode: zoneId, devcode: devcode, msgType: 2) { object in
//            guard let object = object else {
//                swiftDebug("网络请求错误")
//                DispatchQueue.main.async {
//                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
//                    swiftDebug("网络请求错误")
//                }
//                return
//            }
//            // 判断返回数据是否错误
//            if object is Error {
//                if let obj = object as? Error {
//                    let description = obj.localizedDescription
//                    DispatchQueue.main.async {
//                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
//                        swiftDebug("请求错误", description)
//                    }
//                    swiftDebug("请求账开门信息 报错: \(description)")
//                    return
//                }
//            }
//            swiftDebug("新门口机开锁", object as Any)
//            // 解析返回数据内容 转model
//            guard let res = try? ModelDecoder.decode(PhoneMsgForwardRes.self, param: object as! [String : Any]) else {
//                swiftDebug("PhoneGetAllOutdoorRes 转换Model失败")
//                return
//            }
//            // 判断返回数据状态码
//            switch res.code {
//            case NetResCode.c200: // 成功
//                ProgressHUD.showText(NSLocalizedString("发送成功", comment: ""))
//                swiftDebug("发送开锁信息成功")
//                break
//            case NetResCode.c552: // 免登录
//                UserTokenLogin.loginWithToken { (result) in
//                    //self.sendOpenDoorInfo(index: index)
//                }
//                break
//            default:
//                ProgressHUD.showText(NSLocalizedString("失败", comment: ""))
//                swiftDebug("发送开锁信息失败 \(res.message!)")
//                break
//            }
//
//        }
//        // 延时0.1s
//        Thread.sleep(forTimeInterval: 0.1)
//        // 旧门口机开锁
//        PhoneWorkAPI.phoneMsgForward(zoneCode: zoneId, devcode: devcode) { object in
//            guard let object = object else {
//                swiftDebug("网络请求错误")
//                DispatchQueue.main.async {
//                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
//                    swiftDebug("网络请求错误")
//                }
//                return
//            }
//            // 判断返回数据是否错误
//            if object is Error {
//                if let obj = object as? Error {
//                    let description = obj.localizedDescription
//                    DispatchQueue.main.async {
//                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
//                        swiftDebug("请求错误:: ", description)
//                    }
//                    swiftDebug("请求开门信息 报错: \(description)")
//                    return
//                }
//            }
//            swiftDebug("旧门口机开锁", object as Any)
//            // 解析返回数据内容 转model
//            guard let res = try? ModelDecoder.decode(PhoneMsgForwardRes.self, param: object as! [String : Any]) else {
//                swiftDebug("PhoneGetAllOutdoorRes 转换Model失败")
//                return
//            }
//            // 判断返回数据状态码
//            switch res.code {
//            case NetResCode.c200: // 成功
//                ProgressHUD.showText(NSLocalizedString("发送成功", comment: ""))
//                swiftDebug("发送开锁信息成功")
//                break
//            case NetResCode.c552: // 免登录
//                UserTokenLogin.loginWithToken { (result) in
//                    //self.sendOpenDoorInfo(index: index)
//                }
//                break
//            default:
//                ProgressHUD.showText(NSLocalizedString("失败", comment: ""))
//                swiftDebug("发送开锁信息失败 \(res.message!)")
//                break
//            }
//        }
//    }
//
//    /// 发送请求呼叫
//    private func newPhoneCallRequest() -> Void {
//        // 转换为字典
//        guard var dataDict = ModelEncoder.encoder(toDictionary: self.callData) else {
//            swiftDebug("转换字典失败")
//            return
//        }
//        swiftDebug("当前云对讲呼叫的内容: ", dataDict)
//        // 判断是否含有字段result
//        if dataDict.keys.contains("result") {
//            dataDict.removeValue(forKey: "result")
//        }
//
//        // 发送请求给服务器
//        PhoneWorkAPI.newPhoneCall(data: dataDict) { object in
//
//            guard let object = object else {
//                swiftDebug("网络请求错误")
//                DispatchQueue.main.async {
//                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
//                    swiftDebug("网络请求错误")
//                }
//                return
//            }
//            // 判断返回数据是否错误
//            if object is Error {
//                if let obj = object as? Error {
//                    let description = obj.localizedDescription
//                    DispatchQueue.main.async {
//                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
//                        swiftDebug("请求错误: ", description)
//                    }
//                    swiftDebug("发送呼叫请求 报错: \(description)")
//                    return
//                }
//            }
//
//            swiftDebug("新云对讲呼叫的参数内容", object as Any)
//            // 判断是否成功
//        }
//
//    }
//
//    /// 设备呼叫手机 登录房间后发送返回数据
//    private func phoneCallResponseRequest(data: [String: Any]) -> Void {
//        swiftDebug("发送请求返回的数据内容 ", data)
//        PhoneWorkAPI.phoneCallResponse(data: data) { object in
//            guard let object = object else {
//                swiftDebug("网络请求错误")
//                DispatchQueue.main.async {
//                    ProgressHUD.showText(NSLocalizedString("网络请求错误", comment: ""))
//                }
//                return
//            }
//            // 判断返回数据是否错误
//            if object is Error {
//                if let obj = object as? Error {
//                    let description = obj.localizedDescription
//                    DispatchQueue.main.async {
//                        ProgressHUD.showText(NSLocalizedString(description, comment: ""))
//                    }
//                    swiftDebug("发送呼叫请求 报错: \(description)")
//                    return
//                }
//            }
//
//            swiftDebug("设备呼叫手机发送反应数据的参数内容", object as Any)
//        }
//    }
//
//}
//
////MARK: 实现代理方法内容
//extension CloudCallVC: ZegoEngineToolDelegate {
//
//    func onRoomOnlineUserCount(_ count: Int32) {
//
////        if count == 1 && self.callType == CloudCallType.callin {
////            swiftDebug("手机主动接听失败")
////            ProgressHUD.showText("主机已不在线")
////            // 退出房间
////            ZegoEngineTool.share.logoutRoom()
////            return
////        }
//
//    }
//
//    /// 信令返回数据
//    func onIMRecvCustomCommand(_ command: String) {
//        swiftDebug("返回数据信息内容")
//
//    }
//
//    /// 推流失败
//    func onPublisherStateUpdateFailed() {
//        ProgressHUD.showText("云对讲通话故障")
//        // 退出房间
//        ZegoEngineTool.share.logoutRoom()
//
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    /// 拉流失败
//    func onPlayerStateUpdateFailed() {
//        ProgressHUD.showText("云对讲通话故障")
//        // 退出房间
//        ZegoEngineTool.share.logoutRoom()
//
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    /// 呼叫状态回调
//    func callStatus(_ status: String, message: String) {
//        swiftDebug("呼叫状态上传代理数据:: ", status, message)
//
//        switch status {
//        case ZegoCommand.error: // 错误信息
//            swiftDebug("呼叫状态上传数据信息")
//            // 铃声取消
//            UCSSoundEffect.instance().remove()
//
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
//                // 页面消失
//                self.dismiss(animated: true, completion: nil)
//            }
//            break
//        case ZegoCommand.call_timeout, // 呼叫超时
//         ZegoCommand.hangup: // 挂断
//            self.stateLabel.text = "已挂断"
//            // 铃声取消
//            UCSSoundEffect.instance().remove()
//
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
//                // 页面消失
//                self.dismiss(animated: true, completion: nil)
//            }
//
//            break
//        case ZegoCommand.logout: // 退出房间
//            swiftDebug("退出房间了")
//            // 铃声取消
//            UCSSoundEffect.instance().remove()
//
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
//                // 页面消失
//                self.dismiss(animated: true, completion: nil)
//            }
//            break
//        case ZegoCommand.login: // 登录房间
//            // 所有按钮可以点击
//            self.microButton.isEnabled = true
//            self.answerButton.isEnabled = true
//            self.unlockButton.isEnabled = true
//            self.hangupButton.isEnabled = true
//            self.speakerButton.isEnabled = true
//
//            // 判断是否是主机呼叫
//            if self.callType == CloudCallType.callin {
//                // 返回应该信息
//                guard let from = self.callData.from, let to = self.callData.to else {
//                    swiftDebug("呼叫信息内容赋值")
//                    return
//                }
//                // from和to字段值互换
//                self.callData.from = to
//                self.callData.to = from
//                self.callData.callObject = 0
//                // 转换为字典
//                guard var dataDict = ModelEncoder.encoder(toDictionary: self.callData) else {
//                    swiftDebug("转换字典失败")
//                    return
//                }
//                if dataDict.keys.contains("result") == false {
//                    dataDict["result"] = 0
//                }
//                swiftDebug("云对讲返回服务器内容数据:: ", dataDict)
//                self.phoneCallResponseRequest(data: dataDict)
//            }
//            if self.callType == CloudCallType.callout {
//                // 主动呼叫主机 进入房间开始推流
//                ZegoEngineTool.share.startPublishing()
//            }
//
//            break
//        case ZegoCommand.refused:
//            self.stateLabel.text = "对方拒接"
//            // 铃声取消
//            UCSSoundEffect.instance().remove()
//
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
//                // 页面消失
//                self.dismiss(animated: true, completion: nil)
//            }
//            break
//        case ZegoCommand.calling: // 发起呼叫 服务器
//            break
//        case ZegoCommand.monitoring: // 发起监视
//            break
//        case ZegoCommand.answer: // 接听
//            // 铃声取消
//            UCSSoundEffect.instance().remove()
//            // 已经接听
//            self.isAnswer = true
//            self.stateLabel.text = "通话中"
//            // 插入接通的数据库
//            //DBOperation.insertAnswerCallrecords()
//
//            self.updateSubViews(width: 250.0)
//
//            self.answerButton.isHidden = true
//            self.microButton.isHidden = false
//            swiftDebug("设备呼叫的信息:: ", self.callData)
//            if let device = self.callData.data, let devType = device.devType, devType == CloudCallDevType.manager || devType == 99 {
//                swiftDebug("当前设备类型为管理机")
//                // 设备类型为管理机时 隐藏开锁按钮
//                self.unlockButton.isHidden = true
//            } else {
//                self.unlockButton.isHidden = false
//            }
//            self.speakerButton.isHidden = false
//            // 麦克风按钮选中状态
//            self.microButton.isSelected = true
//            self.speakerButton.isSelected = true
//            // 接通后 打开麦克风 扬声器
//            ZegoEngineTool.share.openSpeaker()
//            ZegoEngineTool.share.openMicrophone()
//            swiftDebug("呼叫 正在通话中")
//
//            break
//        case ZegoCommand.unlock: // 开锁
//            swiftDebug("开锁成功 数据上报")
//            break
//        default:
//            swiftDebug("返回其他的状态信息 错误")
//            // 铃声取消
//            UCSSoundEffect.instance().remove()
//
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
//                // 页面消失
//                self.dismiss(animated: true, completion: nil)
//            }
//            break
//        }
//    }
//}
//
//
//extension CloudCallVC {
//    /// 设置子控件
//    private func setupSubViews() -> Void {
//        self.view.addSubview(self.headerImageView)
//        self.view.addSubview(self.stateLabel)
//        self.view.addSubview(self.marqueeView)
//        self.view.addSubview(self.previewImageView)
//        self.view.addSubview(self.buttonListView)
//
//        self.headerImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.stateLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.marqueeView.translatesAutoresizingMaskIntoConstraints = false
//        self.previewImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.buttonListView.translatesAutoresizingMaskIntoConstraints = false
//
//
//        self.buttonListView.addArrangedSubview(self.microButton)
//        self.buttonListView.addArrangedSubview(self.answerButton)
//        self.buttonListView.addArrangedSubview(self.unlockButton)
//        self.buttonListView.addArrangedSubview(self.hangupButton)
//        self.buttonListView.addArrangedSubview(self.speakerButton)
//
//        // 顶部
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: self.headerImageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0), // 水平居中
//            NSLayoutConstraint(item: self.headerImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 100.0), // 宽度
//            NSLayoutConstraint(item: self.headerImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 100.0), // 高度
//            NSLayoutConstraint(item: self.headerImageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 80.0), // 顶部
//        ])
//        // 状态
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: self.stateLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0), // 水平居中
//            NSLayoutConstraint(item: self.stateLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 188.0), // 顶部
//            NSLayoutConstraint(item: self.stateLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 30.0), // 高度
//        ])
//        // 字符串滚动
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: self.marqueeView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0), // 水平居中
//            NSLayoutConstraint(item: self.marqueeView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 40.0), // 高度
//            NSLayoutConstraint(item: self.marqueeView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 120.0), // 宽度
//            NSLayoutConstraint(item: self.marqueeView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.stateLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0), // 顶部
//        ])
//        // 预览
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: self.previewImageView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0), // 左边
//            NSLayoutConstraint(item: self.previewImageView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0), // 右边
//            NSLayoutConstraint(item: self.previewImageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonListView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: -8.0), // 底部
//            NSLayoutConstraint(item: self.previewImageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.marqueeView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 8.0), // 顶部
//        ])
//        self.buttonsWidthCon = NSLayoutConstraint(item: self.buttonListView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 250.0) // 宽度
//        // 设置标签
//        self.buttonsWidthCon.identifier = "buttonsWidthCon"
//        // 按钮列表
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: self.buttonListView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -60.0), // 底部
//            NSLayoutConstraint(item: self.buttonListView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0), // 水平居中
//            NSLayoutConstraint(item: self.buttonListView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 50.0),// 高度
//            self.buttonsWidthCon, // 宽度
//        ])
//    }
//
//    /// 更新stackview的约束
//    private func updateSubViews(width: CGFloat) -> Void {
////        NSLayoutConstraint.deactivate(
////            [NSLayoutConstraint(item: self.buttonListView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: old)
////        ])
////        NSLayoutConstraint.activate([
////            NSLayoutConstraint(item: self.buttonListView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: new)
////        ])
//        // 更新约束
//        //self.buttonListView.updateConstraints()
//        //self.buttonListView.needsUpdateConstraints()
//
////        let associatedConstraints = self.buttonListView.constraints.filter {
////            $0.identifier == "buttonsWidthCon"
////        }
////        NSLayoutConstraint.deactivate(associatedConstraints)
////        self.buttonListView.removeConstraint(associatedConstraints.first!)
////
////        self.buttonsWidthCon = NSLayoutConstraint(item: self.buttonListView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: width)// 高度
////        // 设置标签
////        self.buttonsWidthCon.identifier = "buttonsWidthCon"
////        self.buttonsWidthCon.isActive = true
//////        NSLayoutConstraint.activate([
//////            self.buttonsWidthCon
//////        ])
////
////        self.buttonListView.addConstraint(self.buttonsWidthCon)
////
////        self.buttonListView.layoutIfNeeded()
//
//
//        self.buttonsWidthCon.constant = width
//    }
//}

/// 云对讲按钮
class CloudCallButton: UIButton {
 
//    override public var intrinsicContentSize: CGSize {
//        get {
//            //...
//            return CGSize(width: 50.0, height: 50.0)
//        }
//    }
    
    /// 防止变形设置按钮
    override public var intrinsicContentSize: CGSize {
        //...
        return CGSize(width: 50.0, height: 50.0)
    }
    
}

/// 主机的类型
struct CloudCallDevType {
    /// 未知设备
    static let unknown = -1
    /// 管理机
    static let manager = 1
    /// 围墙机
    static let wall = 2
    /// 单元机
    static let unit = 3
    /// 门口机
    static let outdoor = 4
    /// 模拟门口机
    static let outdoor_simu = 5
    
    /// 普通固定机
    static let only_fixed = 10
    /// 双网口固定机
    static let router_fixed = 11
    /// 模拟室内机
    static let indoor_simu = 12
    /// 兴天下室内机
    static let indoor_xtx_linux = 13
    /// 数字室内机
    static let indoor_digit = 14
    
    /// 君和移动机
    static let gemvary_mobile = 20
    /// 华为移动机
    static let huawei_mobile = 21
    /// 苹果移动机
    static let apple_mobile = 22
    
    /// 数字小门口机
    static let digit = 30
    /// 手机
    static let mobile = 40
}
