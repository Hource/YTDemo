//
//  YTComposetTypeView.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/21.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import pop


class YTComposetTypeView: UIView {
    //MARK: - 属性
    /// UIScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    /// 滚动内容视图
    @IBOutlet weak var view_scrollViewContent: UIView!
    /// 内容宽度约束
    @IBOutlet weak var constraint_contentWidth: NSLayoutConstraint!
    /// X按钮centerX约束
    @IBOutlet weak var constraint_btnX_centerX: NSLayoutConstraint!
    /// <-按钮centerX约束
    @IBOutlet weak var constraint_btnBack_centerX: NSLayoutConstraint!
    /// <-按钮
    @IBOutlet weak var btn_back: UIButton!
    
    /// 闭包回掉
    var completion:((_ clsName:String?)->())?
    
    
    
    /// 按钮数据数组
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName":"YTComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
    
    
    
    /// 创建撰写界面XIB视图
    ///
    /// - Returns: 返回XIB视图
    class func composetTypeView() -> YTComposetTypeView {
        let composeView = UINib.init(nibName: "YTComposetTypeView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! YTComposetTypeView
        composeView.frame = UIScreen.main.bounds
        
        composeView.setupUI()
        
        return composeView
    }
    
    /// 显示当前视图
    func show(completion: @escaping (_ clsName:String?)->()) {
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        vc.view.addSubview(self)
        showCurrentView()
        
        self.completion = completion
    }
    
    //MARK: - 监听方法
    @objc private func clickButton(button:YTComposeTypeButton) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = view_scrollViewContent.subviews[page]
        
        for (i,btn) in v.subviews.enumerated() {
            // 按钮缩放
            let scaleAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = (btn == button) ? 1.6 : 0.4
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.5
            btn.pop_add(scaleAnim, forKey: nil)
            
            // 渐变动画->动画组:直接添加就行
            let alphaAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            btn.pop_add(alphaAnim, forKey: nil)
            
            // 动画监听
            if i == 0 {
                alphaAnim.completionBlock = {_,_ in
                    self.completion?(button.clsName)
                }
            }
        }
    }
    
    /// 点击更多
    @objc private func clickMore() {
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        btn_back.isHidden = false
        let margin = scrollView.bounds.width / 6
        constraint_btnX_centerX.constant += margin
        constraint_btnBack_centerX.constant -= margin
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    /// 滚动到上一个视图
    @IBAction func scrollViewBackView(_ sender: Any) {
        scrollView.setContentOffset(CGPoint(), animated: true)
        btn_back.isHidden = true
        constraint_btnX_centerX.constant = 0
        constraint_btnBack_centerX.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
            self.btn_back.alpha = 0
        }) { (_) in
            self.btn_back.alpha = 1
            self.btn_back.isHidden = true
        }
    }
    
    /// 关闭按钮 事件
    ///
    /// - Parameter sender: 按钮
    @IBAction func closeAction(_ sender: Any) {
        hiddenButton()
    }
}

// MARK: - 设置动画
private extension YTComposetTypeView {
    /// 隐藏当前视图的按钮
    func hiddenButton() {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = view_scrollViewContent.subviews[page]
        
        for (i,btn) in v.subviews.enumerated().reversed() {
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.yt_centerY
            anim.toValue = btn.yt_centerY + 500
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            btn.pop_add(anim, forKey: nil)
            
            if i==0 {
                anim.completionBlock = {_,_ in
                    self.hideCurrentView()
                }
            }
        }
    }
    
    /// 隐藏当前视图
    func hideCurrentView() {
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        
        anim.completionBlock = {_,_ in
            self.reloadInputViews()
        }
    }
    
    /// 设置当前视图动画显示
    func showCurrentView()  {
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 1.5
        // 添加视图
        pop_add(anim, forKey: nil)
        
        showButtons()
    }
    
    /// 弹力显示所有的按钮
    func showButtons() {
        let v = view_scrollViewContent.subviews[0]
        for (index,btn) in v.subviews.enumerated() {
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.yt_centerY + 500
            anim.toValue = btn.yt_centerY
            anim.springBounciness = 8
            anim.springSpeed = 8
            
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(exactly: index)! * 0.025
            btn.pop_add(anim, forKey: nil)
        }
    }
}

// MARK: - 设置控件
private extension YTComposetTypeView {
    /// 设置UI
    func setupUI() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        let rect = scrollView.bounds
        let width = rect.width
        constraint_contentWidth.constant = scrollView.bounds.width * 2
        
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i)*width, dy: 0))
            v.backgroundColor = UIColor.clear
            addButtons(v: v, idx: i*6)
            view_scrollViewContent.addSubview(v)
        }
    }
    
    func addButtons(v:UIView,idx:Int) {
        let count = 6
        
        // 添加视图
        for i in idx..<(idx + count) {
            if i >= buttonsInfo.count {
                break
            }
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"],
                let title = dict["title"]
                else {
                    continue
            }
            
            let btn = YTComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            v.addSubview(btn)
            
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.clsName = dict["clsName"]
                btn.addTarget(self, action: #selector(clickButton(button:)), for: .touchUpInside)
            }
            
        }
        
        // 布局
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3*btnSize.width) / 4
        
        for (i,btn) in v.subviews.enumerated() {
            let y:CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
        
    }
}




