//
//  YTNavigationController.swift
//  VanhiSwiftwb
//
//  Created by yt on 2018/7/6.
//  Copyright © 2018年 YT. All rights reserved.
//

import UIKit

class YTNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if let vc = viewController as? YTBaseViewController {
                var title = "返回"
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, fontSize: 15, target: self, action: #selector(popToParent), isBack: true)
            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    /// 返回上一个控制器
    @objc private func popToParent() {
        popViewController(animated: true)
    }

}


















