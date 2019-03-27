//
//  YTStatusToolBar.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/19.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

class YTStatusToolBar: UIView {
    /// 转发
    @IBOutlet weak var btn_retweeted: UIButton!
    /// 评论
    @IBOutlet weak var btn_common: UIButton!
    /// 赞
    @IBOutlet weak var btn_like: UIButton!
    
    
    var viewModel:YTStatusViewModel? {
        didSet {
            btn_retweeted.setTitle("\(String(describing: viewModel?.retweetStr ?? ""))", for: .normal)
            btn_common.setTitle("\(String(describing: viewModel?.commentStr ?? ""))", for: .normal)
            btn_like.setTitle("\(String(describing: viewModel?.attributeStr ?? ""))", for: .normal)
        }
    }
    
    
    
    
    
    
    
}
