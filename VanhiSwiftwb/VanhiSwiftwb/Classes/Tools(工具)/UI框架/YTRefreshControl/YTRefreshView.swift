//
//  YTRefreshView.swift
//  CustomRefresh
//
//  Created by pro on 2019/3/20.
//  Copyright © 2019年 易涛. All rights reserved.
//

import UIKit

class YTRefreshView: UIView {
    /// 菊花
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    /// 指示图片
    @IBOutlet weak var imageV_icon: UIImageView?
    /// 提示文字
    @IBOutlet weak var label_tipText: UILabel?
    /// 父视图高度
    var paramentHeight:CGFloat = 0
    
    
    
    /// 刷新状态
    var refreshState:YTRefreshStatus = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                label_tipText?.text = "继续使劲拉..."
                imageV_icon?.isHidden = false
                indicator?.stopAnimating()
                UIView.animate(withDuration: 0.25) {
                    self.imageV_icon?.transform = CGAffineTransform.identity
                }
            case .Pulling:
                label_tipText?.text = "放手就刷新"
                UIView.animate(withDuration: 0.25) {
                    self.imageV_icon?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi+0.001))
                }
            case .WillRefresh:
                label_tipText?.text = "正在刷新中..."
                imageV_icon?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }
    
    
    class func refreshView() ->YTRefreshView {
        return UINib.init(nibName: "YTMeiTuRefreshView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! YTRefreshView
    }
    
    
    
}
