//
//  YTComposeTypeButton.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/21.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

class YTComposeTypeButton: UIControl {

    @IBOutlet weak var imageV_icon: UIImageView!
    @IBOutlet weak var label_describle: UILabel!
    /// 类名
    var clsName:String?
    
    
    class func composeTypeButton(imageName:String,title:String) -> YTComposeTypeButton {
        let btn_composeType = UINib.init(nibName: "YTComposeTypeButton", bundle: nil).instantiate(withOwner: nil, options: nil).first as! YTComposeTypeButton
        btn_composeType.imageV_icon.image = UIImage.init(named: imageName)
        btn_composeType.label_describle.text = title
        btn_composeType.backgroundColor = UIColor.clear
        
        return btn_composeType
    }
    

}
