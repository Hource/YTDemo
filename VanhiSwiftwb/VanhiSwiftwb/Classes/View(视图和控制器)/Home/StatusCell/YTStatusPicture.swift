//
//  YTStatusPicture.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/19.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

class YTStatusPicture: UIView {
    /// 配图的高度约束
    @IBOutlet weak var constraint_height: NSLayoutConstraint!
    
    // 处理图片View的尺寸
    var viewModel:YTStatusViewModel? {
        didSet {
            urls = viewModel?.picURLs
            calcViewSize()
        }
    }
    
    // 处理图片显示
    private var urls:[YTStatusPictureModel]? {
        didSet {
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                let iv = subviews[index] as! UIImageView
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                iv.yt_setImage(urlString: url.thumbnail_pic, placeholdImage: nil)
                iv.isHidden = false
                index += 1
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
}


extension YTStatusPicture {
    
    /// 根据视图模型配图大小，调整显示
    private func calcViewSize() {
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBOutterMargin, width: viewSize.width, height: viewSize.height - WBOutterMargin)
            
        } else {
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBOutterMargin, width: WBItemWidth, height: WBItemWidth)
        }
        constraint_height.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    /// 设置UI
    private func setupUI() {
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: WBOutterMargin, width: WBItemWidth, height: WBItemWidth)
        
        for i in 0..<count*count {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            let xOffset = col * (WBItemWidth + WBInnerMargin)
            let yOffset = row * (WBItemWidth + WBInnerMargin)
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(iv)
        }
    }
}
