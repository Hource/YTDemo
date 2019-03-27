//
//  YTUserAccount.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/16.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import SwiftyJSON

private let filePath:NSString = "useraccount.json"

class YTUserAccount: NSObject {
    
    //MARK: - 属性
    /// 访问令牌
    var access_token:String?
    /// 用户代号
    var uid:String?
    /// access_token生命周期
    var expires_in:TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expiresDate:Date?
    /// 头像
    var avatar_large:String?
    /// 全名
    var screen_name:String?
    
    
    
    
    /// 重写构造方法
    override init() {
        super.init()
        
        guard let filePath = filePath.cz_appendTempDir(),
            let data = NSData(contentsOfFile: filePath) ,
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: [])
        else {
            return
        }
        let json = JSON.init(dict)
        initialData(json: json)
        
        // 判断token是否过期
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期")
            access_token = nil
            uid = nil
            _ = try? FileManager.default.removeItem(atPath: filePath)
        }
        
    }
    
    
    /// 给模型赋值
    ///
    /// - Parameter json: JSON
    func initialData(json:JSON) {
        // 给模型赋值
        access_token = json["access_token"].string
        expires_in = json["expires_in"].doubleValue
        uid = json["uid"].string
        screen_name = json["screen_name"].string
        avatar_large = json["avatar_large"].string
    }
    
    ///
    /// 保存模型数据到沙盒中
    ///
    /// - Parameter json: JSON
    func saveAccount(json:JSON) {
        
        var dict = json.dictionaryObject
//        dict?.removeValue(forKey: "expires_in")
        guard let dict1 = dict,
            let data = try? JSONSerialization.data(withJSONObject: dict1, options: []),
            let filePath = filePath.cz_appendTempDir()
            
        else {
            return
        }
        // 写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
    }
}
