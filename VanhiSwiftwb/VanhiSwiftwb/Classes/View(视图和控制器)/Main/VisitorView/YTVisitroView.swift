//
//  YTVisitroView.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/14.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import SnapKit

class YTVisitroView: UIView {
    // MARK: - 私有属性
    /// 图像视图
    private lazy var iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"));
    /// 遮罩视图
    lazy var maskImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"));
    /// 小房子
    private lazy var houseIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"));
    /// 提示标签
    private lazy var tipLabel:UILabel = UILabel.cz_label(withText: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜", fontSize: 14, color: UIColor.darkGray)
    /// 注册按钮
    lazy var registerButton:UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    /// 登录按钮
    lazy var loginButton:UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.black, backgroundImageName: "common_button_white_disable")
    
    /// MARK: - 设置访客视图信息
    ///
    /// - Parameter dict: [imageName/message]
    /// 如果是首页 imageName = ""
    var visitorInfo:[String:String]? {
        didSet {
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"]
                else {
                    return
            }
            tipLabel.text = message
            if imageName == "" {
                startAnimation()
                return
            }
            iconView.image = UIImage(named: imageName)
            houseIconView.isHidden = true
            maskImageView.isHidden = true
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 首页旋转动画
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = Double.pi*2
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        anim.isRemovedOnCompletion = false
        iconView.layer.add(anim, forKey: nil)
    }
}

// MARK: - 设置界面
extension YTVisitroView {
    func setupUI() {
        backgroundColor = UIColor.cz_color(withHex: 0xededed)
        // 1.
        addSubview(iconView)
        addSubview(maskImageView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 2.取消autoresize
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 3.添加约束
        setupAutoLayout()
    }
    
    /// 添加约束
    private func setupAutoLayout() {
        // 圆圈视图
        iconView.snp.makeConstraints { (mark) in
            mark.centerX.equalToSuperview()
            mark.centerY.equalToSuperview().offset(-60)
        }
        // 小房子
        houseIconView.snp.makeConstraints { (mark) in
            mark.center.equalTo(iconView)
        }
        // 提示Label
        tipLabel.snp.makeConstraints { (mark) in
            mark.centerX.equalTo(iconView)
            mark.top.equalTo(iconView.snp.bottom).offset(20)
            mark.width.equalTo(236)
        }
        // 注册
        registerButton.snp.makeConstraints { (mark) in
            mark.left.equalTo(tipLabel)
            mark.top.equalTo(tipLabel.snp.bottom).offset(20)
            mark.width.equalTo((100))
        }
        // 登录
        loginButton.snp.makeConstraints { (mark) in
            mark.right.equalTo(tipLabel)
            mark.top.equalTo(registerButton)
            mark.width.equalTo((100))
        }
        // 遮罩
        maskImageView.snp.makeConstraints { (mark) in
            mark.top.left.right.equalTo(self).offset(0)
            mark.bottom.equalTo(registerButton.snp.bottom)
        }
    }
}


