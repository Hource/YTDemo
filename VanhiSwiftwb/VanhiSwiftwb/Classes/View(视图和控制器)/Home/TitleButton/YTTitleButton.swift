//
//  YTTitleButton.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/18.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

class YTTitleButton: UIButton {

    private lazy var count = 0
    
    init(title:String?) {
        super.init(frame: CGRect())
        
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle(title, for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
       titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,
            let imageView = imageView
        else {
            return
        }
        
        count += 1
        
        if count > 1 {
            titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
            imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width+5, dy: 0)
        }
        
//        print("----\(titleLabel)-----\(imageView)")
    }
    
}
