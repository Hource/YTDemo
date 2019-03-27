//
//  UIView+CZAddition.h
//
//  Created by 刘凡 on 16/5/11.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CZAddition)
@property (nonatomic, assign) CGSize yt_size;
@property (nonatomic, assign) CGFloat yt_width;
@property (nonatomic, assign) CGFloat yt_height;
@property (nonatomic, assign) CGFloat yt_x;
@property (nonatomic, assign) CGFloat yt_y;
@property (nonatomic, assign) CGFloat yt_centerX;
@property (nonatomic, assign) CGFloat yt_centerY;

@property (nonatomic, assign) CGFloat yt_right;
@property (nonatomic, assign) CGFloat yt_bottom;

/**
 view通过xib加载
 */
+ (instancetype)yt_viewFromXib;

/**
 两个view之间是否有交集
 */
- (BOOL)yt_intersectWithView:(UIView *)view;


/// 返回视图截图
- (UIImage *)cz_snapshotImage;

@end
