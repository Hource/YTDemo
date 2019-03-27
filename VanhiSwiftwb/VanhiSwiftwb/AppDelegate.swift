//
//  AppDelegate.swift
//  VanhiSwiftwb
//
//  Created by yt on 2018/7/6.
//  Copyright © 2018年 yt. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 加载服务器信息
        loadAppInfo()
        
        // 设置App额外信息
        setupAddition()
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        
        let vc = YTMainViewController()
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
        
        return true
    }
}



// MARK: - 加载App额外信息
extension AppDelegate {
    private func setupAddition() {
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        // 取得授权
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
                print("授权" + (success ? "成功" : "失败"))
            }
        } else {
            let notifySetting = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifySetting)
        }
    }
}

// MARK: - 加载服务器信息
extension AppDelegate {
    private func loadAppInfo() {
        DispatchQueue.global().async {
            // 从服务器获取信息
            guard let url = Bundle.main.url(forResource: "main.json", withExtension: nil),
                let data = NSData(contentsOf: url)
                else {
                    return
            }
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (path as NSString).appendingPathComponent("main.json")
            data.write(toFile: jsonPath, atomically: true)
            print("应用程序加载完毕:  \(jsonPath)")
        }
    }
}







