//
//  CZEmoticonManager.swift
//  004-表情包数据
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import MJExtension


/// 表情管理器
class YTEmoticonManager {
    
    // 为了便于表情的复用，建立一个单例，只加载一次表情数据
    /// 表情管理器的单例
    static let shared = YTEmoticonManager()
    
    /// 构造函数，如果在 init 之前增加 private 修饰符，可以要求调用者必须通过 shared 访问对象
    /// OC 要重写 allocWithZone 方法
    private init() {
        loadPackages()
    }
    
    /// 表情包的懒加载数组 - 第一个数组是最近表情，加载之后，表情数组为空
    lazy var packages = [YTEmoticonPackage]()
    
    /// 表情素材的 bundle
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil)
        return Bundle(path: path!)!
    }()
    
    
    
    
}


// MARK: - 表情字符串处理
extension YTEmoticonManager {
    
    /// 将给定的字符串转换成属性文本
    ///
    /// 关键点：要按照匹配结果倒序替换属性文本！
    ///
    /// - parameter string: 完整的字符串
    ///
    /// - returns: 属性文本
    func emoticonString(string:String,font:UIFont) -> NSAttributedString {
        // AttributedString 是不可变的
        let attrString = NSMutableAttributedString(string: string)
        
        // 1. 建立正则表达式，过滤所有的表情文字
        // [] () 都是正则表达式的关键字，如果要参与匹配，需要转义
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        // 2. 匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        // 3. 遍历所有匹配结果
        for m in matches.reversed() {
            
            let r = m.range(at: 0)
            
            let subStr = (attrString.string as NSString).substring(with: r)
            
            // 1> 使用 subStr 查找对应的表情符号
            if let em = YTEmoticonManager.shared.findEmoticon(string: subStr) {
                
                // 2> 使用表情符号中的属性文本，替换原有的属性文本的内容
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
            }
        }
        
        // 4. *** 统一设置一遍字符串的属性，除了需要设置字体，还需要设置`颜色`！
        attrString.addAttributes([NSAttributedString.Key.font: font,
                                  NSAttributedString.Key.foregroundColor: UIColor.darkGray],
                                 range: NSRange(location: 0, length: attrString.length))
        
        return attrString
    }
    

    /// 根据 string 在所有的表情符号中查找对应的表情模型对象
    ///
    /// - 如果找到，返回表情模型
    /// - 否则，返回 nil
    func findEmoticon(string:String) -> YTEmoticon? {
        for p in packages {
            
            let result = p.emotions.filter { (em) -> Bool in
                return em.chs == string
            }
            if result.count == 1 {
                return result.first
            }
        }
        return nil
    }
}


// MARK: - 表情包数据处理
extension YTEmoticonManager {
    
    /// 读取emoticons.plist
    func loadPackages() {
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
        let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
        let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
        let models = YTEmoticonPackage.mj_objectArray(withKeyValuesArray: array) as? [YTEmoticonPackage]
        else {
            return
        }
        packages += models
    }
}






