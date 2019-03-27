//
//  YTNavigationBar.swift
//  VanhiSwiftwb
//
//  Created by yt on 2018/7/6.
//  Copyright © 2018年 YT. All rights reserved.
//

import UIKit

class YTNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super .layoutSubviews()
        for view_back in self.subviews {
            if (["_UIBarBackground"].contains(NSStringFromClass(view_back.classForCoder))) {
                view_back.frame = CGRect(x: 0, y: -self.yt_y, width: self.yt_width, height: self.yt_height+self.yt_y)
            }
            if(["_UINavigationBarContentView"].contains(NSStringFromClass(view_back.classForCoder))) {
                view_back.frame = CGRect(x: 0, y: 20, width: self.yt_width, height: self.yt_height-20)
            }
        }
    }

}
