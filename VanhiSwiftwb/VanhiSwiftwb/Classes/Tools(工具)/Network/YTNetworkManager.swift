//
//  YTNetworkManager.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/15.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
import Alamofire

enum NetworkMethod {
    case GET
    case POST
}

class YTNetworkManager: AFHTTPSessionManager {
    
    // MARK: - 属性
    /// 用户账号模型
    lazy var userAccount = YTUserAccount()
    /// 是否登录
    var userLogin:Bool {
        return userAccount.access_token != nil
    }
    
    
    
    /// 单例
    /// 静态区，常量，闭包
    static let shared: YTNetworkManager = {
        let instance = YTNetworkManager()
        instance.responseSerializer.acceptableContentTypes = ["application/json", "text/plain", "text/javascript", "text/json", "text/html"]
        return instance
    }()
    
    /// 拼接token 的网络请求方法
    ///
    /// - Parameters:
    ///   - method: GET
    ///   - URLString: URLString
    ///   - parameters: 参数
    ///   - completion: 完成回掉
    func tokenRequest(method:NetworkMethod = .GET, URLString:String, parameters:[String:Any]?, name:String?=nil, data:Data?=nil, completion:@escaping (_ json:Any?,_ isSuccess:Bool)->()) {
        
        guard let token = userAccount.access_token else {
            completion(nil,false)
            // 发送通知，提示用户登录
            print("没有 token! 需要登录")
            NotificationCenter.default.post(name: NSNotification.Name.init(WBUserShouldLoginNotification), object: nil, userInfo: nil)
            completion(nil,false)
            return
        }
        
        // 1> 判断 参数字典是否存在，如果为 nil，应该新建一个字典
        var parameters = parameters
        if parameters == nil {
            parameters = [String:Any]()
        }
        
        // 2> 设置参数字典，代码在此处字典一定有值
        parameters!["access_token"] = token as AnyObject
        
        // 3> 判断 name 和 data
        if let name = name,
            let data=data {
            upload(URLString: URLString, parameters: parameters, name: name, data: data, completion: completion)
        } else {
            request(method: method, URLString: URLString, parameters: parameters, completion: completion)
        }
        
        
//        request(method: method, URLString: URLString, parameters: parameters) { (json, isSuccess) in
//            completion(json,isSuccess)
//        }
    }
    
    // MARK: - 封装 AFN 方法
    /// 上传文件必须是 POST 方法，GET 只能获取数据
    /// 封装 AFN 的上传文件方法
    ///
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter name:       接收上传数据的服务器字段(name - 要咨询公司的后台) `pic`
    /// - parameter data:       要上传的二进制数据
    /// - parameter completion: 完成回调
    func upload(URLString:String,parameters:[String:Any]?,name:String,data:Data,completion:@escaping (_ json:Any?,_ isSuccess:Bool)->()) {
        
        post(URLString, parameters: parameters, constructingBodyWith: { (forData) in
            // 创建 formData
            /**
             1. data: 要上传的二进制数据
             2. name: 服务器接收数据的字段名
             3. fileName: 保存在服务器的文件名，大多数服务器，现在可以乱写
             很多服务器，上传图片完成后，会生成缩略图，中图，大图...
             4. mimeType: 告诉服务器上传文件的类型，如果不想告诉，可以使用 application/octet-stream
             image/png image/jpg image/gif
             */
            forData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            
        }, progress: nil, success: { (_, json) in
            completion(json,true)
            
        }) { (task, error) in
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                // 发送通知，提示用户再次登录(本方法不知道被谁调用，谁接收到通知，谁处理！)
                NotificationCenter.default.post(
                    name: NSNotification.Name(rawValue: WBUserShouldLoginNotification),
                    object: "bad token")
                completion(nil,false)
            }
        }
    }
    
    
    ///
    /// 封装 GET/POST 请求
    ///
    /// - Parameters:
    ///   - method: 请求类型
    ///   - URLString: URLString
    ///   - parameters: 参数字典
    ///   - completion: 完成回掉
    func request(method:NetworkMethod = .GET, URLString:String, parameters:[String:Any]?,completion:@escaping (_ json:Any?,_ isSuccess:Bool)->()) {
        
        let success = { (task:URLSessionDataTask,json:Any?)->() in
            completion(json,true)
        }
        
        let failure = { (task:URLSessionDataTask?,error:Error)->() in
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                NotificationCenter.default.post(name: NSNotification.Name.init(WBUserShouldLoginNotification), object: "obj", userInfo: nil)
                print("token过期了")
            }
            completion(nil,false)
        }
    
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
