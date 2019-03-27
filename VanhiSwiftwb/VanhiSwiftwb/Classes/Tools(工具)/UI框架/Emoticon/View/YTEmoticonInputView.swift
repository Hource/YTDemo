//
//  YTEmoticonInputView.swift
//  表情键盘
//
//  Created by pro on 2019/3/26.
//  Copyright © 2019年 易涛. All rights reserved.
//

import UIKit

/// 可重用的标识符
private let cellId = "cellId"

class YTEmoticonInputView: UIView {
    
    // MARK: - 属性
    @IBOutlet weak var collectionView: UICollectionView!
    /// 表情键盘底部工具栏
    @IBOutlet weak var emoticonToolBar: YTEmoticonToolBar!
    /// 选中表情回调闭包属性
    private var selectedEmoticonCallBack:((_ emoticon:YTEmoticon?)->())?
    
    class func inputView(selectedEmoticon:@escaping (_ emoticon:YTEmoticon?)->()) -> YTEmoticonInputView {
        let v = UINib.init(nibName: "YTEmoticonInputView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! YTEmoticonInputView
        
        // 记录闭包
        v.selectedEmoticonCallBack = selectedEmoticon
        
        return v
    }
    
    override func awakeFromNib() {
        collectionView.dataSource = self as? UICollectionViewDataSource
        collectionView.delegate = self as? UICollectionViewDelegate
        
        // 注册可重用 cell
        collectionView.register(YTEmoticonCell.self, forCellWithReuseIdentifier: cellId)
        
        // 设置工具栏代理
        emoticonToolBar.delegate = self as? YTEmoticonToolBarDelegate
    }
}

// MARK: - YTEmoticonToolBarDelegate
extension YTEmoticonInputView: YTEmoticonToolBarDelegate {
    func emoticonToolbarSelectedItemIndex(toolBar: YTEmoticonToolBar, index: Int) {
        // 让 collectionView 发生滚动 -> 每一个分组的第0页
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        // 设置分组按钮的选中状态
        toolBar.selectedIndex = index
    }
}

// MARK: - UICollectionViewDelegate
extension YTEmoticonInputView:UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1. 获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x
        
        // 2. 获取当前显示的 cell 的 indexPath
        let paths = collectionView.indexPathsForVisibleItems
        
        // 3. 判断中心点在哪一个 indexPath 上，在哪一个页面上
        var targetIndexPath: IndexPath?
        
        for indexPath in paths {
            // 1> 根据 indexPath 获得 cell
            let cell = collectionView.cellForItem(at: indexPath)
            // 2> 判断中心点位置
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                break
            }
        }
        
        guard let target = targetIndexPath else {
            return
        }
        
        // 4. 判断是否找到 目标的 indexPath
        // indexPath.section => 对应的就是分组
        emoticonToolBar.selectedIndex = target.section
        
        // 5. 设置分页控件
        // 总页数，不同的分组，页数不一样
        
        
    }
}

// MARK: - UICollectionViewDataSource
extension YTEmoticonInputView: UICollectionViewDataSource {
    
    // 分组数量 - 返回表情包的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return YTEmoticonManager.shared.packages.count
    }
    
    // 返回每个分组中的表情`页`的数量
    // 每个分组的表情包中 表情页面的数量 emoticons 数组 / 20
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return YTEmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! YTEmoticonCell
        
        cell.emoticons = YTEmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - CZEmoticonCellDelegate
extension YTEmoticonInputView: YTEmoticonCellDelegate {
    /// 选中的表情回调
    ///
    /// - parameter cell: 分页 Cell
    /// - parameter em:   选中的表情，删除键为 nil
    func emoticonCellDidSelectedEmoticon(cell: YTEmoticonCell, em: YTEmoticon?) {
        // 执行闭包，回调选中的表情
        selectedEmoticonCallBack?(em)
        
        // 添加最近使用的表情
        guard let em = em else {
            return
        }
        
        // 如果当前 collectionView 就是最近的分组，不添加最近使用的表情
        let indexPath = collectionView.indexPathsForVisibleItems.first ?? IndexPath.init(row: 0, section: 0)
        if indexPath.section == 0 {
            return
        }
        
        // 添加最近使用的表情
//        YTEmoticonManager.shared.recentEmoticon(em: em)
//        
//        // 刷新数据 - 第 0 组
//        var indexSet = IndexSet()
//        indexSet.insert(0)
//        
//        collectionView.reloadSections(indexSet)
    }
}

