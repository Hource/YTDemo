//
//  YTUser.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/18.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import SwiftyJSON

class YTUser: NSObject {
    
    var id:Int64 = 0
    /// 用户昵称
    var screen_name:String?
    /// 用户头像
    var profile_image_url:String?
    /// 认证类型 -1没有认证，认证用户，2，3，5:企业认证：220：达人
    var verified:Bool = false
    /// 会员等级 0-6
    var mbrank:Int = 0
    
    func setupJsonToModel(json:JSON) -> YTUser {
        let user = YTUser()
        user.id = json["id"].int64Value
        user.screen_name = json["screen_name"].string
        user.profile_image_url = json["profile_image_url"].string
        user.verified = json["verified"].boolValue
        user.mbrank = json["mbrank"].intValue
        
        return user
    }
}
