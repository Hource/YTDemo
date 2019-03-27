//
//  YTMeiTuRefreshView.swift
//  CustomRefresh
//
//  Created by pro on 2019/3/21.
//  Copyright © 2019年 易涛. All rights reserved.
//

import UIKit

class YTMeiTuRefreshView: YTRefreshView {

    @IBOutlet weak var imageV_building: UIImageView!
    
    @IBOutlet weak var imageV_earth: UIImageView!
    
    @IBOutlet weak var imageV_kangaroo: UIImageView!
    
    override var paramentHeight: CGFloat {
        didSet {
            if paramentHeight < 23 {
                return
            }
            var scale:CGFloat
            
            if paramentHeight > 126 {
                scale = 1
            } else {
                scale = 1 - ((126-paramentHeight) / (126 - 23))
            }
            imageV_kangaroo.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 建筑
        let bImage1 = UIImage.init(named: "icon_building_loading_1")
        let bImage2 = UIImage.init(named: "icon_building_loading_2")
        imageV_building.image = UIImage.animatedImage(with: [bImage1!,bImage2!], duration: 0.5)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        // 地球
        anim.toValue = -2*Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 5
        anim.isRemovedOnCompletion = false
        imageV_earth.layer.add(anim, forKey: nil)
        
        imageV_kangaroo.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 23
        imageV_kangaroo.center = CGPoint(x: x, y: y)
        
        let kImage1 = UIImage.init(named: "icon_small_kangaroo_loading_1")
        let kImage2 = UIImage.init(named: "icon_small_kangaroo_loading_2")
        imageV_kangaroo.image = UIImage.animatedImage(with: [kImage1!,kImage2!], duration: 0.5)
    }
    
    
    
    
}
