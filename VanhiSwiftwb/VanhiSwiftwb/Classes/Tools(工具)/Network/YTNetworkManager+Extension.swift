//
//  YTNetworkManager+Extension.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/15.
//  Copyright © 2019年 YT. All rights reserved.
//

import Foundation
import SwiftyJSON


// MARK: - 微博数据接口
extension YTNetworkManager {
    /// 加载微博数据字典数组
    ///
    /// - Parameter completion: 完成回掉
    func statusList(since_id:Int64 = 0,max_id:Int64 = 0, completion:@escaping (_ list:[[String:AnyObject]]?,_ isSuccess:Bool)->()) {
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["since_id":"\(since_id)","max_id":"\(max_id > 0 ? max_id-1 : 0)"]
        
        tokenRequest(URLString: url, parameters: params) { (json, isSuccess) in
            let result = (json as AnyObject)["statuses"] as?[[String:AnyObject]]
            completion(result,isSuccess)
            
        }
    }
    
    /// 未读数接口
    func unreadCount(completion: @escaping (_ count:Int)->()) {
        guard let uid = userAccount.uid else {
            return
        }
        let url = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid":uid]
        
        tokenRequest(URLString: url, parameters: params) { (json, isSuccess) in
            guard let json = json as? [String:Any]
                else {
                    return completion(0)
            }
            let json1 = JSON.init(json)
            let count = json1["status"].intValue
            completion(count)
        }
    }
}

// MARK: - 发布微博接口
extension YTNetworkManager {
    func postStatus(text:String, image:UIImage? ,completion:@escaping (_ result:[String:AnyObject]?,_ isSuccess:Bool)->()) {
        
        // 1. url
        let urlString:String?
        
        // 根据是否有图像，选择不同的接口地址
        if image == nil {
            urlString = "https://api.weibo.com/2/statuses/update.json"
        } else {
            urlString = "https://upload.api.weibo.com/2/statuses/update.json"
        }
        
        // 2. 参数字典
        let params = ["status": text]
        
        // 3. 如果图像不为空，需要设置 name 和 data
        var name: String?
        var data: Data?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion([:],true)
        }
        
        // 接口权限申请没有通过，没法使用
//        tokenRequest(method: .POST, URLString: urlString!, parameters: params, name: name, data: data) { (json, isSuccess) in
//            completion(json as? [String:AnyObject],isSuccess)
//        }
    }
}

// MARK: - 用户信息接口
extension YTNetworkManager {
    private func loadUserInfo(completion:@escaping (_ json:JSON,_ isSuccess:Bool)->()) {
        guard let access_token = userAccount.access_token,
            let uid = userAccount.uid
        else {
            return
        }
        let url = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token":access_token,"uid":uid] as [String:Any]
        
        tokenRequest(URLString: url, parameters: params) { (json, isSuccess) in
            guard let json = json
                else {
                    completion(JSON.null,false)
                    return
            }
            let json1 = JSON.init(json)
            completion(json1,isSuccess)
        }
    }
}

// MARK: - 获取token接口
extension YTNetworkManager {
    func loadAccessToken(code:String,completion:@escaping (_ isSuccess:Bool)->()) {
        let url = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":WBAppKey,
                      "client_secret":WBAppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":WBAppReduri
                      ]
        request(method: .POST, URLString: url, parameters: params) { (json, isSuccess) in
            // 处理数据
            guard let json = json
                else {
                    return
            }
            let json1 = JSON.init(json)
            self.userAccount.initialData(json: json1)
            
            self.loadUserInfo(completion: { (json_userInfo, isSuccess) in
                self.userAccount.screen_name = json_userInfo["screen_name"].string
                self.userAccount.avatar_large = json_userInfo["avatar_large"].string
                // 保存模型
                guard let updateJson = try? json1.merged(with: json_userInfo)
                    else {
                        return
                }
                self.userAccount.saveAccount(json: updateJson)
                completion(isSuccess)
            })
            
        }
    }
}



