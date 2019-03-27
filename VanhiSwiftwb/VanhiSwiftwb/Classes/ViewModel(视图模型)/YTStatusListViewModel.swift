//
//  YTStatusListViewModel.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/15.
//  Copyright © 2019年 YT. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage


/// 处理微博数据
// 1.字典转模型
// 2.上下拉 刷新数据处理
private let maxpullupErrorTime = 3

class YTStatusListViewModel {
    // MARK: - 属性
    lazy var statusList = [YTStatusViewModel]()
    private var errorTime = 0
    
    ///
    /// 微博模型数组懒加载
    ///
    /// - Parameters:
    ///   - pullup: 是否上拉
    ///   - completion: 完成回掉
    func loadStatus(pullup:Bool ,completion: @escaping (_ isSuccess:Bool, _ shouldRefresh:Bool)->()) {
        // 判断是否超过最大错误上拉次数
        if pullup && errorTime > maxpullupErrorTime {
            completion(false,false)
        }
        
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0);
        YTNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            // 1.网络请求失败，返回
            if !isSuccess {
                completion(false,false)
            }
            
            // 2.字典转模型
            guard let list = list
                else {
                    completion(false,false)
                    return
            }
            var array = [YTStatusViewModel]()
            let json = JSON.init(list)
            for i in 0..<list.count {
                let json1 = json[i]
                let status = YTStatus().setupJsonToModel(json: json1)
                let statusViewModel = YTStatusViewModel(model: status)
                array.append(statusViewModel)
            }
            
            // 上拉，下来，分别添加到数组相应位置
            if pullup { // 上拉
                self.statusList += array
            } else {
               self.statusList = array + self.statusList
            }
            // 判断上拉刷新的数据量
            if pullup && array.count == 0 {
                self.errorTime += 1
                completion(isSuccess,false)
            } else {
                self.cacheSigleImage(list: array,finish: completion)
            }
        }
    }
    
    /// 缓存单张图片
    ///
    /// - Parameter list: 网络获取到的数据
    private func cacheSigleImage(list:[YTStatusViewModel],finish: @escaping (_ isSuccess:Bool, _ shouldRefresh:Bool)->()) {
        // 调度组
        let group = DispatchGroup()
        
        for vm in list {
            if vm.picURLs?.count != 1 {
                continue
            }
            
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL.init(string: pic)
                else {
                    continue
            }
            group.enter()
            SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil) { (image, _, _, _, _, _) in
                
                if let image = image {
                    vm.updateSigleImageSize(image: image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            finish(true,true)
        }
    }
    
}




