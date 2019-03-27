//
//  UIImageView+Extension.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/18.
//  Copyright © 2019年 YT. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    /// 隔离 SDWebImage
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholdImage: 占位图
    ///   - isavator: 是否为头像
    func yt_setImage(urlString:String?,placeholdImage:UIImage?,isavator:Bool = false) {
        guard let urlString = urlString,
            let url = URL.init(string: urlString)
        else {
            image = placeholdImage
            return
        }
        
        sd_setImage(with: url, placeholderImage: placeholdImage, options: [], progress: nil) { (image, _, _, _) in
            if isavator {
                guard let image = image,
                    let image1 = image.yt_avatarImage(size: self.bounds.size)
                    else {
                        return self.image = placeholdImage
                }
                self.image = image1
                
            } else {
                self.image = image
            }
        }
    }
}
    

