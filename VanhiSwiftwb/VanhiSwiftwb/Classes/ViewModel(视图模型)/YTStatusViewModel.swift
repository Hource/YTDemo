//
//  YTStatusViewModel.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/18.
//  Copyright © 2019年 YT. All rights reserved.
//

import Foundation


/// 单条微博视图模型
class YTStatusViewModel {
    /// 微博模型
    var status:YTStatus
    /// 会员等级
    var memberIcon:UIImage?
    /// 认证类型 -1没有认证，认证用户，2，3，5:企业认证：220：达人
    var vipIcon:UIImage?
    /// 转发数
    var retweetStr:String?
    /// 评论数
    var commentStr:String?
    /// 点赞数
    var attributeStr:String?
    /// 配图Size
    var pictureViewSize = CGSize()
    
    /// 如果是被转发微博，原创微博一定没有图
    var picURLs:[YTStatusPictureModel]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 微博正文的属性文本
    var statusAttrText: NSAttributedString?
    /// 转发文字的属性文本
    var retweetedAttrText:NSAttributedString?
    /// 记录行高
    var rowHeight:CGFloat = 0
    
    
    
    
    init(model:YTStatus) {
        self.status = model
        
        // 会员等级
        if let user = model.user {
            if user.mbrank > 0 && user.mbrank < 7 {
                let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
                memberIcon = UIImage.init(named: imageName)
            }
        }
        
        // 认证图标
        model.user?.verified ?? false ? (vipIcon = UIImage.init(named: "avatar_vip")) : (vipIcon = UIImage.init(named: "avatar_enterprise_vip"))
        
        retweetStr = countString(count: model.reposts_count, defaultstr: "转发")
        commentStr = countString(count: model.comments_count, defaultstr: "评论")
        attributeStr = countString(count: model.attitudes_count, defaultstr: "点赞")
        
        // 配图尺寸
        pictureViewSize = calculatorPictureViewSize(count: picURLs?.count ?? 0)
        
        // ---- 设置微博文本 ---
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        // 微博正文的属性文本
        statusAttrText = YTEmoticonManager.shared.emoticonString(string: model.text ?? "", font: originalFont)
        
        // 设置被转发微博的属性文本
        let rText = "@" + (status.retweeted_status?.user?.screen_name ?? "")
            + ":"
        let attrStr = rText + (status.retweeted_status?.text ?? "")
        retweetedAttrText = YTEmoticonManager.shared.emoticonString(string: attrStr, font: retweetedFont)
        
        // 更新行高
        updateRowHeight()
    }
    
    /// 更新单张视图尺寸
    ///
    /// - Parameter image: UIImage
    func updateSigleImageSize(image:UIImage) {
        var size = image.size
        
        // 图片过宽处理
        let maxWidth:CGFloat = 300
        let minWidth:CGFloat = 40
        if size.width > maxWidth {
            size.width = maxWidth
            size.height = size.width * image.size.height / image.size.width
        }
        // 图片过宽窄处理
        if size.width < minWidth {
            size.width = minWidth
            size.height = size.width * image.size.height/image.size.width
        }
        
        size.height += WBOutterMargin
        pictureViewSize = size
        // 更新行高
        updateRowHeight()
    }
}

// MARK: - 计算
extension YTStatusViewModel {
    
    /// 更新行高
    func updateRowHeight() {
        var height:CGFloat = 0
        let margin:CGFloat = 12
        let iconHeight:CGFloat = 34
        let toolbarHeight:CGFloat = 35
        
        let viewSize = CGSize(width: UIScreen.cz_screenWidth() - 2*margin, height: CGFloat(MAXFLOAT))
        
        // 1.计算顶部高度
        height = 2*margin + iconHeight + margin
        // 2.正文高度
        if let text = statusAttrText {
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        // 3.判断是否转发微博
        if status.retweeted_status != nil {
            height += 2*margin
            // 转发文本的高度 - 一定用 retweetedText，拼接了 @用户名:微博文字
            if let text = retweetedAttrText {
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        // 4.配图视图
        height += pictureViewSize.height
        height += margin
        // 5.底部工具栏
        height += toolbarHeight
        
        rowHeight = height
    }
    
    
    /// 计算配图尺寸
    ///
    /// - Parameter count: 图片个数
    /// - Returns: 返回尺寸
    private func calculatorPictureViewSize(count:Int) -> CGSize {
        if count == 0 {
            return CGSize()
        }
        
        let row = (count - 1)/3 + 1
        // 根据行数算高度
        var height = WBOutterMargin
        height += CGFloat(row) * WBItemWidth
        height += CGFloat(row - 1) * WBInnerMargin
        
        return CGSize(width: WBPictureViewWidth, height: height)
    }
    
    
    /// 计算 转发，点赞，评论
    ///
    /// - Parameters:
    ///   - count: 数量
    ///   - defaultstr: 默认字符串
    /// - Returns: 返回字符串
    private func countString(count:Int,defaultstr:String) -> String {
        if count == 0 {
            return defaultstr
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.02 万f", Double(count) / 10000)
    }
}

