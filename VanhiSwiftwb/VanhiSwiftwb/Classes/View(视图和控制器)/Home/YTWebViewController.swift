//
//  YTWebViewController.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/25.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

class YTWebViewController: YTBaseViewController {

    private lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    var urlString: String? {
        didSet {
            guard let urlString = urlString,
                let url = URL(string: urlString)
            else {
                return
            }
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func setupTableView() {
        navItem.title = "网页"
        
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.backgroundColor = UIColor.white
        webView.scrollView.contentInset.top = navigationBar.yt_height
    }

}
