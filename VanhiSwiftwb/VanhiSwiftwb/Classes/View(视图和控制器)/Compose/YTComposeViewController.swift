//
//  YTComposeViewController.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/22.
//  Copyright © 2019年 YT. All rights reserved.
//

import UIKit
import SVProgressHUD


class YTComposeViewController: UIViewController {
    /// 文本编辑视图
    @IBOutlet weak var textView: YTComposeTextView!
    /// toolBar
    @IBOutlet weak var toolBar: UIToolbar!
    /// 发布按钮
    @IBOutlet var btn_post: UIButton!
    
    /// 标题标签 - 换行的热键 option + 回车
    /// 逐行选中文本并且设置属性
    /// 如果要想调整行间距，可以增加一个空行，设置空行的字体，lineHeight
    /// 导航栏标题
    @IBOutlet var label_title: UILabel!
    /// toolbar底部约束
    @IBOutlet weak var constraint_toolbarBottom: NSLayoutConstraint!
    
    /// 表情输入视图
    lazy var emoticonView:YTEmoticonInputView = YTEmoticonInputView.inputView { [weak self] (emotion) in
        
        self?.textView.insertEmoticon(em: emotion)
    }
    
    
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // 监听键盘通知 - UIWindow.h
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeAction(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    // MARK: - 监听
    /// 监听键盘变化
    ///
    /// - Parameter noti: 通知
    @objc private func keyboardChangeAction(noti:NSNotification) {
        
        guard let rect = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else {
            return
        }
        let offset = view.bounds.height - rect.origin.y
        constraint_toolbarBottom.constant = offset
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 关闭 事件
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 发布微博
    ///
    /// - Parameter sender: 按钮
    @IBAction func postWeiBoAction(_ sender: Any) {
        print("发布微博")
        
        // 1. 获取发送给服务器的表情微博文字
        let text = textView.emoticonText
        
        YTNetworkManager.shared.postStatus(text: textView.text, image: nil) { (json, isSuccess) in
            
            let message = isSuccess ? "发布成功" : "网络不给力"
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showInfo(withStatus: message)
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    SVProgressHUD.setDefaultStyle(.light)
                    self.close()
                })
            }
        }
    }
    
    /// 切换表情键盘
    @objc private func emoticonKeyboard() {
        // textView.inputView 就是文本框的输入视图
        // 如果使用系统默认的键盘，输入视图为 nil
        
        // 1> 测试键盘视图 - 视图的宽度可以随便，就是屏幕的宽度
//                let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 253))
//                keyboardView.backgroundColor = UIColor.blue
        
        // 2> 设置键盘视图
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        
        // 3> !!!刷新键盘视图
        textView.reloadInputViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - YTComposeViewController
extension YTComposeViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        btn_post.isEnabled = textView.hasText
    }
}

// MARK: - 设置UI
private extension YTComposeViewController {
    
    /// 设置UI
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        
        setupToolbar()
        
        btn_post.isEnabled = false
    }
    
    /// 设置导航栏
    func setupNavigationBar() {
        navigationItem.titleView = label_title
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn_post)
    }
    
    /// 设置toolbar
    func setupToolbar() {
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        // 遍历数组
        var items = [UIBarButtonItem]()
        for s in itemSettings {
            
            guard let imageName = s["imageName"] else {
                continue
            }
            
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            
            btn.sizeToFit()
            
            // 判断 actionName
            if let actionName = s["actionName"] {
                // 给按钮添加监听方法
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            // 追加按钮
            items.append(UIBarButtonItem(customView: btn))
            
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        // 删除末尾弹簧
        items.removeLast()
        toolBar.items = items
    }
}
