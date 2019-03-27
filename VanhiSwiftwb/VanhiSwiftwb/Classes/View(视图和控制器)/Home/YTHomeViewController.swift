//
//  YTHomeViewController.swift
//  VanhiSwiftwb
//
//  Created by yt on 2018/7/6.
//  Copyright © 2018年 YT. All rights reserved.
//

import UIKit

private let originalCellId = "originalCellId"
private let retweetedCellId = "retweetedCellId"


class YTHomeViewController: YTBaseViewController {
    
    private lazy var statuslist = [String]()
    private lazy var listViewModel = YTStatusListViewModel()
    
    
    /// 加载数据
    override func loadData() {
//        super.loadData()
        self.refreshControl?.beginRefreshing()
        
        listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
            self.refreshControl?.endRefreshing()
            self.isPullup = false
            if shouldRefresh {
                self.tableView?.reloadData()
            }
        }
    }
    
    /// 好友被点击
    @objc private func showFriends() {
        print("好友")
    }
}

// MARK: - 设置界面
extension YTHomeViewController {
    /// 设置UI
    override func setupTableView() {
        super.setupTableView()
        // 好友
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册cell
        tableView?.register(UINib.init(nibName: "YTStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib.init(nibName: "YTStatusRetweetCell的", bundle: nil), forCellReuseIdentifier: retweetedCellId)
//        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        setupNaviTitle()
    }
    
    /// 设置导航栏标题
    private func setupNaviTitle() {
        let button = YTTitleButton(title: YTNetworkManager.shared.userAccount.screen_name)
        navItem.titleView = button
        button.addTarget(self, action: #selector(clickTitleButton(btn:)), for: .touchUpInside)
    }
    
    @objc private func clickTitleButton(btn:UIButton) {
        btn.isSelected = !btn.isSelected
    }
}

// MARK: - 表格数据源方法
extension YTHomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = listViewModel.statusList[indexPath.row]
        let cellId = (vm.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! YTStatusCell
        cell.viewModel = vm
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let vm = listViewModel.statusList[indexPath.row]
        return vm.rowHeight
    }
}

// MARK: - YTStatusCellDelegate
extension YTHomeViewController:YTStatusCellDelegate {
    func statusCellDidClickUrl(cell: YTStatusCell, urlString: String) {
        let webVc = YTWebViewController()
        webVc.urlString = urlString
        navigationController?.pushViewController(webVc, animated: true)
    }
}











