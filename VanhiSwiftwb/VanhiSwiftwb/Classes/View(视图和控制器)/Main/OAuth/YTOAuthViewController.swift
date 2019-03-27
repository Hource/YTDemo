//
//  YTOAuthViewController.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/16.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import SVProgressHUD


class YTOAuthViewController: UIViewController {
    
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        webView.scrollView.isScrollEnabled = false
        title = "登录新浪微博"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载授权页面
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBAppReduri)"
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        webView.delegate = self
        webView.loadRequest(request)
        
        
        // 返回
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(back))
        
        // 自动填充
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    
    /// 自动填充实现
    @objc private func autoFill() {
        let js = "document.getElementById('userId').value = '13686447824';" + "document.getElementById('passwd').value = 'q1111111';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    /// 返回上一级
    @objc private func back() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UIWebViewDelegate代理
extension YTOAuthViewController:UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 不包含百度地址，允许请求
        if request.url?.absoluteString.hasPrefix(WBAppReduri) == false {
            return true
        }
        // 取消授权，不允许请求
        if request.url?.query?.hasPrefix("code=") == false {
            back()
            return false
        }
        // 获取授权码
        guard let codeStr = request.url?.absoluteString as NSString? else {
            back()
            return false
        }
        let range = codeStr.range(of: "code=")
        let code = codeStr.substring(from: range.location+range.length)
        
        // 获取accessToken
        YTNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            if isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name.init(WBUserLoginSuccessNotification), object: nil, userInfo: nil)
                self.back()
            } else {
                SVProgressHUD.showInfo(withStatus: "网络异常")
            }
        }
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}


