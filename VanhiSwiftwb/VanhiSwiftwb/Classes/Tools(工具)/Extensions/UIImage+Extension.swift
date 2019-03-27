//
//  UIImage+Extension.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/18.
//  Copyright © 2019年 YT. All rights reserved.
//

import Foundation


extension UIImage {
    
    func yt_avatarImage(size:CGSize?,backColor:UIColor = UIColor.white,lineColor:UIColor = UIColor.lightGray) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    
}
