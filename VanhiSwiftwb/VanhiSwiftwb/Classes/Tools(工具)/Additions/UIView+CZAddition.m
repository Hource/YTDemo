//
//  UIView+CZAddition.m
//
//  Created by 刘凡 on 16/5/11.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "UIView+CZAddition.h"

@implementation UIView (CZAddition)

- (UIImage *)cz_snapshotImage {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

- (CGSize)yt_size
{
    return self.frame.size;
}

- (void)setYt_size:(CGSize)yt_size
{
    CGRect frame = self.frame;
    frame.size = yt_size;
    self.frame = frame;
}

- (CGFloat)yt_width
{
    return self.frame.size.width;
}

- (CGFloat)yt_height
{
    return self.frame.size.height;
}

- (void)setYt_width:(CGFloat)yt_width
{
    CGRect frame = self.frame;
    frame.size.width = yt_width;
    self.frame = frame;
}

- (void)setYt_height:(CGFloat)yt_height
{
    CGRect frame = self.frame;
    frame.size.height = yt_height;
    self.frame = frame;
}

- (CGFloat)yt_x
{
    return self.frame.origin.x;
}

- (void)setYt_x:(CGFloat)yt_x
{
    CGRect frame = self.frame;
    frame.origin.x = yt_x;
    self.frame = frame;
}

- (CGFloat)yt_y
{
    return self.frame.origin.y;
}

- (void)setYt_y:(CGFloat)yt_y
{
    CGRect frame = self.frame;
    frame.origin.y = yt_y;
    self.frame = frame;
}

- (CGFloat)yt_centerX
{
    return self.center.x;
}

- (void)setYt_centerX:(CGFloat)yt_centerX
{
    CGPoint center = self.center;
    center.x = yt_centerX;
    self.center = center;
}

- (CGFloat)yt_centerY
{
    return self.center.y;
}

- (void)setYt_centerY:(CGFloat)yt_centerY
{
    CGPoint center = self.center;
    center.y = yt_centerY;
    self.center = center;
}

- (CGFloat)yt_right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)yt_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setYt_right:(CGFloat)yt_right
{
    self.yt_x = yt_right - self.yt_width;
}

- (void)setYt_bottom:(CGFloat)yt_bottom
{
    self.yt_y = yt_bottom - self.yt_height;
}

+ (instancetype)yt_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (BOOL)yt_intersectWithView:(UIView *)view
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}


@end
