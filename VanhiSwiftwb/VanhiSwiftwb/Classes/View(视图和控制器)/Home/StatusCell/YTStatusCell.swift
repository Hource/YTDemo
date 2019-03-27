//
//  YTStatusCell.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/18.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

@objc protocol YTStatusCellDelegate: NSObjectProtocol {
    /// 网址被点击代理
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - urlString: urlString
    @objc optional func statusCellDidClickUrl(cell:YTStatusCell,urlString:String)
}


class YTStatusCell: UITableViewCell {
    //MARK:- 属性
    /// 代理属性
    weak var delegate:YTStatusCellDelegate?
    /// 头像
    @IBOutlet weak var imageV_icon: UIImageView!
    /// 姓名
    @IBOutlet weak var label_name: UILabel!
    /// 会员图标
    @IBOutlet weak var imageV_memberIcon: UIImageView!
    /// 时间
    @IBOutlet weak var label_time: UILabel!
    /// 微博来源
    @IBOutlet weak var label_sourceTime: UILabel!
    /// 认证图标
    @IBOutlet weak var imageV_vipIcon: UIImageView!
    /// 微博正文
    @IBOutlet weak var label_status: FFLabel!
    /// toolBar
    @IBOutlet weak var toolbar: YTStatusToolBar!
    /// 配图视图
    @IBOutlet weak var view_picture: YTStatusPicture!
    /// 被转发微博文字
    @IBOutlet weak var label_retweetedText: FFLabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label_status.delegate = self
        label_retweetedText?.delegate = self
    }
    
    //MARK: - 赋值
    var viewModel:YTStatusViewModel? {
        didSet {
            // 微博文本
            label_status?.attributedText = viewModel?.statusAttrText
            // 被转发微博文字
            label_retweetedText?.attributedText = viewModel?.retweetedAttrText
            
            label_name.text = viewModel?.status.user?.screen_name
            imageV_memberIcon.image = viewModel?.memberIcon
            imageV_vipIcon.image = viewModel?.vipIcon
            imageV_icon.yt_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholdImage: UIImage.init(named: "avatar_default_big"),isavator: true)
            label_sourceTime.text = viewModel?.status.source
            
            // toobar
            toolbar.viewModel = viewModel
            
            // 配图
            view_picture.viewModel = viewModel
        }
    }
    
    
}


// MARK: - cell上匹配文本点击 代理
extension YTStatusCell:FFLabelDelegate {
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        delegate?.statusCellDidClickUrl?(cell: self, urlString: text)
    }
}





