//
//  UIBarButtonItem+extension.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/14.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(title:String,fontSize:CGFloat=16,target:Any?,action:Selector,isBack:Bool = false) {
        let btn:UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        if isBack {
            let  imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: .normal)
            btn.setImage(UIImage(named: imageName+"_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        
        self.init(customView: btn)
    }
}


