//
//  YTWelcomeView.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/18.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import SDWebImage

class YTWelcomeView: UIView {
    //MARK: - 属性
    @IBOutlet weak private var imageV_icon: UIImageView!
    /// 名字
    @IBOutlet weak private var label_name: UILabel!
    /// 头像底部约束
    @IBOutlet weak private var constraint_bottom: NSLayoutConstraint!
    
    
    /// XIB创建视图
    ///
    /// - Returns: 返回对象
    class func welcomeView() -> YTWelcomeView {
        let welComeView = UINib.init(nibName: "YTWelcomeView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! YTWelcomeView
        return welComeView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let urlStr = YTNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlStr)
        else {
            return
        }
        
        imageV_icon.layer.cornerRadius = 42.5
        imageV_icon.layer.masksToBounds = true
        imageV_icon .sd_setImage(with: url, completed: nil)
        label_name.text = YTNetworkManager.shared.userAccount.screen_name ?? ""
    }
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = UIColor.blue
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
        constraint_bottom.constant = 450
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.layoutIfNeeded()
        }) { (isSuccess) in
            self.removeFromSuperview()
        }
    }
}
