//
//  YTMainViewController.swift
//  VanhiSwiftwb
//
//  Created by yt on 2018/7/6.
//  Copyright © 2018年 YT. All rights reserved.
//

import UIKit
import SVProgressHUD


class YTMainViewController: UITabBarController {
    // MARK: - 私有控件
    /// 撰写按钮
    private lazy var composeButton: UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    /// 定时器
    private var timer:Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置子控制器
        setupChildViewControllers()
        // 设置tabbar大按钮
        setupComposeButton()
        // 设置定时器
        setupTimer()
        // 设置新特性
        setupNewFeature()
        
        delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
    }
    
    /// tabbar中间大按钮被点击 事件
    @objc private func composeButtonDidClicked() {
        let composeView = YTComposetTypeView.composetTypeView()
        composeView.show { [weak composeView] (clsName) in
            guard let clsName = clsName,
                let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? UIViewController.Type
                else {
                    composeView?.removeFromSuperview()
                    return
            }
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: {
                composeView?.removeFromSuperview()
            })
        }
    }
    
    /// 用户登录
    @objc private func userLogin(noti:Notification) {
        if noti.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录已超时，需要重新登录")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let oaVc = YTOAuthViewController()
            let navi = UINavigationController(rootViewController: oaVc)
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    /// 代码控制横竖屏，当前控制器和子控制器会遵守这个方法
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // 释放定时器
    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - tabbar代理
extension YTMainViewController:UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        let index = (childViewControllers as NSArray).index(of: viewController)
        if selectedIndex == 0 && selectedIndex == index {
            let nav = childViewControllers[0] as! UINavigationController
            let vc = nav.childViewControllers[0] as! YTHomeViewController
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                vc.loadData()
                
                vc.tabBarItem.badgeValue = nil
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
        
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 定时器的相关方法
extension YTMainViewController {
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if !YTNetworkManager.shared.userLogin {
            return
        }
        // 获取微博未读数
        YTNetworkManager.shared.unreadCount { (count) in
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

// MARK: - 新特性
extension YTMainViewController {
    /// 设置新特性
    private func setupNewFeature() {
        if !YTNetworkManager.shared.userLogin {
            return
        }
        let preView = isNewVersion ? YTNewfeatureView.newFeatureView() : YTWelcomeView.welcomeView()
        preView.frame = view.bounds
        view.addSubview(preView)
    }
    
    // 计算型属性，可以在extension 中书写
    private var isNewVersion:Bool {
        let current = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let sandboxVersion = UserDefaults.standard.object(forKey: "twilltVersion") as? String ?? ""
        UserDefaults.standard.set(current, forKey: "twilltVersion")
        UserDefaults.standard.synchronize()
        
        return current != sandboxVersion
    }
}

// MARK: - 子控制器设置
extension YTMainViewController {
    /// 设置撰写按钮
    private func setupComposeButton() {
        tabBar.addSubview(composeButton)
        let count = CGFloat(childViewControllers.count)
        let width = tabBar.bounds.width / count
        // 正数向内缩进，负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2*width, dy: 0)
        composeButton.addTarget(self, action: #selector(composeButtonDidClicked), for: UIControlEvents.touchUpInside)
    }
    
    /// 设置所有子控制器
    private func setupChildViewControllers() {
        // 从沙盒中取数据
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (path as NSString).appendingPathComponent("main.json")
        var data = NSData(contentsOfFile: jsonPath)
        if data == nil {
            // 从本地工程中取数据
            path = Bundle.main.path(forResource: "main.json", ofType: nil)!
            data = NSData(contentsOfFile: path)
        }
        
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: Any]]
        else {
            return
        }
        
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    
    /// 通过字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典
    /// - Returns: 子控制器
    private func controller(dict:[String:Any]) -> UIViewController {
        // 解析字典
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let visitorInfo = dict["visitorInfo"] as? [String:String],
            let cls = NSClassFromString(Bundle.main.nameSpace + "." + clsName) as? YTBaseViewController.Type
            else {
            return UIViewController()
        }
        
        // 创建视图控制器
        let vc = cls.init()
        vc.title = title
        vc.visitorInfoDictionary = visitorInfo
    vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12)], for: .normal)
    vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .normal)
    vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: .selected)
        
        vc.tabBarItem.image = UIImage(named:imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName+"_selected")?.withRenderingMode(.alwaysOriginal)
        
        let nav = YTNavigationController.init(rootViewController: vc)
        return nav
    }
}










    
    


