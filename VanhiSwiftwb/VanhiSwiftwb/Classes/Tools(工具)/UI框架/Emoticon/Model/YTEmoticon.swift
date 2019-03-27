//
//  YTEmoticon.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/22.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import MJExtension

class YTEmoticon: NSObject {
    
    /// 表情类型
    @objc var type = false
    
    /// 表情字符串，发送给服务器的
    @objc var chs:String?
    /// 表情图片名
    @objc var png:String?
    
    /// emoji 的十六进制编码 转换成 表情字符串
    @objc var code:String? {
        didSet {
            guard let code = code else {
                return
            }
            let scanner = Scanner(string: code)
            
            var result:UInt32 = 0
            scanner.scanHexInt32(&result)
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    
    /// 表情模型所在的目录
    @objc var directory: String?
    
    /// 表情使用次数
    var times: Int = 0
    
    /// emoji 的字符串
    var emoji: String?
    
    /// `图片`表情对应的图像
    @objc var image:UIImage? {
        if type {
            return nil
        }
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundel = Bundle(path: path)
        else {
            return nil
        }
        
        return UIImage(named: "\(directory)/\(png)", in: bundel, compatibleWith: nil)
    }
    
    /// 将当前的图像转换成图片的属性文本
    func imageText(font:UIFont) -> NSAttributedString {
        // 1. 判断图像是否存在
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        // 2. 创建文本附件
        let attachment = YTEmoticonAttachment()
        // 记录属性文本文字
        attachment.chs = chs
        
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        // 3. 返回图片属性文本
        let attrStrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        // 设置字体属性
        attrStrM.addAttributes([NSAttributedStringKey.font:font], range: NSRange(location: 0, length: 1))
        
        return attrStrM
    }
}
