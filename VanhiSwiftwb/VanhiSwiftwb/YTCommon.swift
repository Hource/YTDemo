//
//  YTCommon.swift
//  VanhiSwiftwb
//
//  Created by pro on 2019/3/15.
//  Copyright © 2019年 YT. All rights reserved.
//


//MARK: - 全局通知

/// 用户需要登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"
/// 用户登录成功通知
let WBUserLoginSuccessNotification = "WBUserLoginSuccessNotification"

/// 微博AppKey
let WBAppKey = "2700785349"
/// 微博AppSecret
let WBAppSecret = "50dd11eeee157b7c5f5b1d9a831cf7ac"
/// 微博回掉地址
let WBAppReduri = "http://www.baidu.com"

//MARK: - 微博配图视图常量
// 视图外侧间距
let WBOutterMargin = CGFloat(12)
// 内侧间距
let WBInnerMargin = CGFloat(3)
// 视图宽度
let WBPictureViewWidth = UIScreen.cz_screenWidth() - 2*WBOutterMargin
// 每个Item默认的宽度
let WBItemWidth = (WBPictureViewWidth - 2*WBInnerMargin) / 3



