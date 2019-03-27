//
//  YTStatus.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/15.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import SwiftyJSON

class YTStatus: NSObject {
    
    var id:Int64 = 0
    /// 微博信息内容
    var text:String?
    /// 转发数
    var reposts_count:Int = 0
    /// 评论数
    var comments_count:Int = 0
    /// 点赞数
    var attitudes_count:Int = 0
    /// 转发微博
    var retweeted_status:YTStatus?
    /// 微博创建时间
    var created_at:String?
    /// 来源
    var source:String? {
        didSet {
            source = "来自于" + (source?.yt_href()?.text ?? "")
        }
    }
    
    
    /// 微博用户
    var user:YTUser?
    /// 微博配图模型
    lazy var pic_urls:[YTStatusPictureModel]? = [YTStatusPictureModel]()
    
    
    func setupJsonToModel(json:JSON) -> YTStatus {
        let status = YTStatus()
        status.id = json["id"].int64Value
        status.text = json["text"].string
        status.reposts_count = json["reposts_count"].intValue
        status.comments_count = json["comments_count"].intValue
        status.attitudes_count = json["attitudes_count"].intValue
        status.created_at = json["created_at"].string
        status.source = json["source"].string
        
        
        // 用户模型
        let json_user = JSON.init(json["user"])
        status.user = YTUser().setupJsonToModel(json: json_user)
        
        // 转发微博数据处理
        let dict = json["retweeted_status"].dictionaryObject
        if let dict = dict {
            status.retweeted_status = setupRetweetedJsonToModel(dict: dict)
        }
        
        // 配图模型
        guard let array_pictures = json["pic_urls"].arrayObject as? [[String:AnyObject]] else {
            return status
        }
        for dict in array_pictures {
            let pictureModel = YTStatusPictureModel()
            pictureModel.thumbnail_pic = dict["thumbnail_pic"] as? String
            status.pic_urls?.append(pictureModel)
        }
        
        return status
    }
    
    
    private func setupRetweetedJsonToModel(dict:[String:Any]) -> YTStatus {
        let json = JSON.init(dict)
        let status = setupJsonToModel(json: json)
        return status
    }
}
