//
//  YTRefreshControl.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/20.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit

private let ytRefreshOffset:CGFloat = 126

/// 刷新状态
///
/// - Normal: 普通状态
/// - Pulling: 超过临界点，要去刷新
/// - WillRefresh: 松手后 将要刷新
enum YTRefreshStatus {
    case Normal
    case Pulling
    case WillRefresh
}

class YTRefreshControl: UIControl {
    
    // MARK: - 属性
    /// 刷新控件的父视图
    private weak var scrollView:UIScrollView?
    private var refreshView = YTRefreshView.refreshView()
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    /// 监听刷新控件移动
    ///
    /// - Parameter newSuperview: 父视图
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        scrollView = sv
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    /// KVO 统一调此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let sv = scrollView else {
            return
        }
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        if refreshView.refreshState != .WillRefresh {
            refreshView.paramentHeight = height
        }
        
        // 判断临界点
        if sv.isDragging { // 拖
            if height > ytRefreshOffset && refreshView.refreshState == .Normal {
                refreshView.refreshState = .Pulling
            } else if height <= ytRefreshOffset && refreshView.refreshState == .Pulling{
                refreshView.refreshState = .Normal
            }
        } else { // 放手
            if refreshView.refreshState == .Pulling {
                beginRefreshing()
                // 发送刷新事件
                sendActions(for: .valueChanged)
            }
        }
        
    }
    
    /// 从父视图移除监听方法
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    /// 开始刷新
    public func beginRefreshing() {
        guard let sv = scrollView else {
            return
        }
        if refreshView.refreshState == .WillRefresh { // 如果正在刷新返回
            return
        }
        refreshView.refreshState = .WillRefresh
        var inset = sv.contentInset
        inset.top += ytRefreshOffset
        sv.contentInset = inset
        
        refreshView.paramentHeight = ytRefreshOffset
    }
    
    /// 结束刷新
    public func endRefreshing() {
        guard let sv = scrollView else {
            return
        }
        // 没有刷新，则返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        refreshView.refreshState = .Normal
        var inset = sv.contentInset
        inset.top -= ytRefreshOffset
        sv.contentInset = inset
    }
}


extension YTRefreshControl {
    /// 设置UI
    private func setupUI() {
        // 添加刷新视图
//        clipsToBounds = true
        backgroundColor = superview?.backgroundColor
        addSubview(refreshView)
    // 自动布局
    refreshView.translatesAutoresizingMaskIntoConstraints = false
    
    addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
    addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -64))
    
    addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
    addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
    }
}




