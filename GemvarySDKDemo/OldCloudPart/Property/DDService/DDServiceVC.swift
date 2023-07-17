//
//  DDServiceVC.swift
//  GemvarySDKDemo
//
//  Created by Gemvary Apple on 2021/6/24.
//

import UIKit
import WebKit
import WebViewJavascriptBridge

/// 物业信息页面
class DDServiceVC: UIViewController {

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect.zero)
        
        webView.uiDelegate = self
        
        
        return webView
    }()
    private lazy var bridge: WebViewJavascriptBridge = {
        let bridge = WebViewJavascriptBridge(self.webView)
        return bridge!
    }()
    private var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        view.trackTintColor = UIColor.gray
        view.isHidden = true
        return  view
    }()
    
    
    var urlStr: String = String() {
        didSet {
            guard let url = URL(string: self.urlStr) else {
                debugPrint("获取Web连接为空")
                self.navigationController?.popViewController(animated: true)
                return
            }
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval(15.0))
            self.webView.load(request)
        }
    }
    /// 是否有服务记录选项
    var isService: Bool = false {
        didSet {
            if self.isService == true {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("服务记录", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBarButtonAction(_:)))
            }
        }
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubViews()
        
        self.bridge.registerHandler("iOSH5PayFeeFeiYongChaJiao") { data, responseCallback in
            // 支付
            debugPrint("调用支付方法")
        }
        
        self.bridge.registerHandler("registerHandler") { data, responseCallback in
            // 打电话
            debugPrint("调用打电话方法")
        }
        
        self.bridge.registerHandler("webIosShare") { data, responseCallback in
            // 分享
            debugPrint("调用分享方法")
        }
    }
    
    
    /// 右边导航栏方法
    @objc private func rightBarButtonAction(_ button: UIBarButtonItem) -> Void {
        DDServiceAPI.service(callback: { (urlStr) in
            DispatchQueue.main.async {
                guard urlStr != nil else {
                    debugPrint("请开通该功能模块")
                    return
                }
                let diandouVC = DDServiceVC()
                diandouVC.urlStr = urlStr!
                diandouVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(diandouVC, animated: true)
            }
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.alpha = 1
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if self.webView.estimatedProgress >= Double(1) {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finished) in
                    self.progressView.setProgress(0, animated: false)
                })
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        self.webView.uiDelegate = nil
        self.webView.navigationDelegate = nil
        
        self.bridge.setWebViewDelegate(nil)
        
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let dateFrom = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
            debugPrint("wkwebview清除缓存")
        }
    }
    
}

extension DDServiceVC {
    
    /// 支付信息数据
    
}

extension DDServiceVC: WKUIDelegate {
    
}

extension DDServiceVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            return
        }
        
        let url_str = url.absoluteString
        
        if url_str.contains("weixin://wap/pay") {
            UIApplication.shared.open(url)
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}

extension DDServiceVC {
    
    private func setupSubViews() -> Void {
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.webView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.webView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.webView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.webView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.progressView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.progressView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.progressView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 5),
            NSLayoutConstraint(item: self.progressView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: UIApplication.shared.statusBarFrame.height+44),
        ])
    }
    
}
