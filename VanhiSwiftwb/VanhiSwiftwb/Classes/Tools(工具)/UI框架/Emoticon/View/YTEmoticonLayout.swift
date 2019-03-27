//
//  YTEmoticonLayout.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/26.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

class YTEmoticonLayout: UICollectionViewFlowLayout {
    
    /// prepare 就是 OC 中的 prepareLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        itemSize = collectionView.bounds.size
        
        // 设定滚动方向
        // 水平方向滚动，cell 垂直方向布局
        // 垂直方向滚动，cell 水平方向布局
        scrollDirection = .horizontal
    }
    
}
