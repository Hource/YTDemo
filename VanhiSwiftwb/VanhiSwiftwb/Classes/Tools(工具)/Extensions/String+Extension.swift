//
//  String+Extension.swift
//  练习正则表达式
//
//  Created by pro on 2019/3/22.
//  Copyright © 2019年 易涛. All rights reserved.
//

import Foundation

extension String {
    
    /// 从当前字符串中，提前链接和文本
    func yt_href() -> (link:String,text:String)? {
        let pattren = "<a href=\"(.*?)\".*?\">(.*?)</a>"
        
        guard let regx = try? NSRegularExpression(pattern: pattren, options: []),
        let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
        else {
            return nil
        }
        
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link,text)
    }
}

