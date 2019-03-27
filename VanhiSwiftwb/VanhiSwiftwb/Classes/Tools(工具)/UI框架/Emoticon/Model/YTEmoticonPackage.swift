//
//  YTEmoticonPackage.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/22.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import MJExtension

class YTEmoticonPackage: NSObject {
    
    /// 表情包的分组名
    @objc var groupName:String?
    /// 背景图片名称
    @objc var bgImageName: String?
    
    /// 表情包目录，从目录下加载info.plist
    @objc var directory:String? {
        didSet {
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath),
                let models = YTEmoticon.mj_objectArray(withKeyValuesArray: array) as? [YTEmoticon]
            else {
                return
            }
            for m in models {
                m.directory = directory
            }
            emotions += models
        }
    }
    
    /// 懒加载的表情模型的空数组
    /// 使用懒加载可以避免后续的解包
    @objc lazy var emotions = [YTEmoticon]()
    
    /// 表情页面数量
    var numberOfPages:Int {
        return (emotions.count - 1) / 20 + 1
    }
    
    /// 从懒加载的表情包中，按照 page 截取最多 20 个表情模型的数组
    /// 例如有 26 个表情
    /// page == 0，返回 0~19 个模型
    /// page == 1，返回 20~25 个模型
    func emoticon(page:Int) -> [YTEmoticon] {
        
        // 每页的数量
        let count = 20
        let location = page*count
        var length = count
        
        // 判断数组是否越界
        if location + length > emotions.count {
            length = emotions.count - location
        }
        let range = NSRange(location: location, length: length)
        
        // 截取数组的子数组
        let subArray = (emotions as NSArray).subarray(with: range) as! [YTEmoticon]
        
        return subArray
    }
    
    
}
