//
//  YTNewfeatureView.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/18.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

class YTNewfeatureView: UIView {
    //MARK: - 属性
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var btn_enter: UIButton!
    @IBOutlet private weak var pageController: UIPageControl!
    
    /// 创建XIB视图
    ///
    /// - Returns: 返回创建对象
    class func newFeatureView() -> YTNewfeatureView {
        let newfeatureView = UINib.init(nibName: "YTNewfeatureView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! YTNewfeatureView
        return newfeatureView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let count = 4
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            let image = "new_feature_\(i+1)"
            let imageV = UIImageView.init(image: UIImage.init(named: image))
            imageV.frame = rect.offsetBy(dx: CGFloat(i)*rect.width, dy: 0)
            scrollView.addSubview(imageV)
        }
        
        // 制定scrollView的属性
        scrollView.contentSize = CGSize.init(width: CGFloat(count+1)*rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        btn_enter.isHidden = true
    }
    
    /// 点击进入微博按钮
    ///
    /// - Parameter sender: 按钮
    @IBAction private func enterButtonDidClicked(_ sender: UIButton) {
        removeFromSuperview()
    }
}

// MARK: - UIScrollViewDelegate
extension YTNewfeatureView:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        // 判断是否为最后一页
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
        btn_enter.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        btn_enter.isHidden = true
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.width + 0.5)
        pageController.currentPage = page
        pageController.isHidden = (page == scrollView.subviews.count)
    }
}
