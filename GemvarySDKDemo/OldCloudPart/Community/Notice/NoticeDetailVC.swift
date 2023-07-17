//
//  NoticeDetailVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/28.
//

import UIKit
import WebKit
import GemvaryNetworkSDK

class NoticeDetailVC: UIViewController {

    
    private lazy var webView: WKWebView = {
        
        let configuration: WKWebViewConfiguration = WKWebViewConfiguration()
        // WKWebView的偏好配置
        configuration.preferences = WKPreferences()
        configuration.preferences.minimumFontSize = 10
        configuration.preferences.javaScriptEnabled = true
        // 默认是不能通过js自动打开窗口，必须通过用户交互才能打开
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        // 设置网页自适应屏幕宽度
        let jScript = "`var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta)`;"
        let wkUScript = WKUserScript(source: jScript, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        configuration.userContentController = wkUController
        // 创建webview
        let webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.backgroundColor = UIColor.white
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        webView.clipsToBounds = true
        
        return webView
    }()
    
    
    var notice: Notice = Notice() {
        didSet {
            if self.notice.title != nil || self.notice.title != "" {
                self.title = self.notice.title
            } else {
                self.title = NSLocalizedString("物业通知详情", comment: "")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置代理
        self.view.addSubview(self.webView)
        
        if let link = self.notice.link, let url = URL(string: CommunityNetParam.domain + link)  {
            let requset = URLRequest(url: url)
            self.webView.load(requset)
        }                
    }
    

}

extension NoticeDetailVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // https://blog.csdn.net/hosirW/article/details/102514514
        // 创建js字符串
        let js = """
                function imgAutoFit() {
                var imgs = document.getElementsByTagName('img');
                for (var i = 0; i < imgs.length; ++i) {
                var img = imgs[i];
                img.style.maxWidth = '100%';
                img.style.height = 'auto';
                }
                }
                """
        // 注入js到html中
        self.webView.evaluateJavaScript(js) { (object, error) in
            debugPrint("注入JS", object as Any, error as Any)
        }
        // 调用
        self.webView.evaluateJavaScript("imgAutoFit()") { (object, error) in
            debugPrint("调用JS", object as Any, error as Any)
        }
    }
}
