//
//  YTBaseViewController.swift
//  VanhiSwiftwb
//
//  Created by yt on 2018/7/6.
//  Copyright © 2018年 YT. All rights reserved.
//

import UIKit


class YTBaseViewController: UIViewController {
    // MARK: - 公有属性
    /// 自定义导航条
    lazy var navigationBar = YTNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    /// 自定义导航条目
    lazy var navItem = UINavigationItem()
    /// tableView
    var tableView:UITableView?
    /// 刷新控件
    var refreshControl:YTRefreshControl?
    /// 是否上拉刷新
    var isPullup = false
    /// 访客视图信息
    var visitorInfoDictionary:[String:String]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        YTNetworkManager.shared.userLogin ? loadData() : ()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name.init(WBUserLoginSuccessNotification), object: nil)
    }
    
    /// 重写标题属性
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    /// 加载数据
    @objc func loadData() {
        refreshControl?.endRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 设置UI
extension YTBaseViewController {
    /// 设置UI
   private func setupUI() {
        // 取消自动缩进
        automaticallyAdjustsScrollViewInsets = false
        setupNavi()
        YTNetworkManager.shared.userLogin ? setupTableView() : setupVisitorView()
    
    }
    
    /// 设置访客视图
    private func setupVisitorView() {
        let visitorView = YTVisitroView(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        // 设置访客信息
        visitorView.visitorInfo = visitorInfoDictionary
        
        // 访客视图添加监听方法
        visitorView.registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        visitorView.loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        // 注册登录
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", target: self, action: #selector(registerAction))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", target: self, action: #selector(loginAction))
    }
    
    /// 设置tableView
    @objc func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        let height:CGFloat
        Int((UIScreen.cz_screenHeight()/UIScreen.cz_screenWidth()) * 100) == 216 ? (height = 24) : (height = 44);
        
        tableView?.contentInset = UIEdgeInsetsMake(height, 0, 0, 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset 
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 刷新控件
        refreshControl = YTRefreshControl()
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置导航条
    private func setupNavi() {
        // 添加导航条
        view.addSubview(navigationBar)
        // 将item 设置给bar
        navigationBar.items = [navItem]
        // 设置navBar 的渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xf6f6f6)
        // 设置navBar的字体颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.darkGray]
        navigationBar.tintColor = UIColor.orange
    }
}

// MARK: - 监听方法 （登录，注册，登录成功）
extension YTBaseViewController {
    /// 登录成功通知
    @objc private func loginSuccess(noti:Notification) {
        // view = nil 时会重新调 loadView方法
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        view = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 注册
    @objc private func registerAction() {
        print("注册")
    }
    
    /// 登录
    @objc private func loginAction() {
        NotificationCenter.default.post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil, userInfo: nil)
    }
}

// MARK: - 实现tableView的代理
extension YTBaseViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.1
    }
    
    /// 在显示最后一行时，做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        // 行数
        let count = tableView.numberOfRows(inSection: section)
        if row == (count - 1) && !isPullup && section == indexPath.section {
            print("上拉刷新")
            isPullup = true
            loadData()
        }
    }
}





