//
//  CTPageControl.h
//  CTTelecomNetOpti
//
//  这个类修改了默认UIPageControl的指示器图片
//  可根据自己需要重新制作active_page@2x.png和inactive_page@2x.png两个图片
//
//
//  Created by fan frank on 12-7-16.
//  Copyright (c) 2012年 gdcattsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTPageControl;

@protocol CTPageControlDelegate<NSObject>

- (void)pageControl:(CTPageControl *)pageControl activeImg:(UIImage **)activeImg inactiveImg:(UIImage **)inactiveImg;

@end

@interface CTPageControl : UIPageControl
{
    UIImage *activeImage;
    UIImage *inactiveImage;
    CGRect _defaultFrame;
}

@property (nonatomic, assign) id<CTPageControlDelegate> delegate;
@property (nonatomic, assign) UITextAlignment align;

- (void)updateDots; // 更新分页指示器图片

@end