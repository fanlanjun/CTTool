//
//  CTScrollLabel.h
//  CTSqliteSecurityDemo
//
//  Created by fan frank on 12-8-24.
//  Copyright (c) 2012年 gdcattsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CTScrollLabelDelegate <NSObject>

@required

- (NSInteger)numberOfTitles;

- (NSString *)titleForIndex:(NSInteger)index;

@optional

- (void)didSelectWithIndex:(NSInteger)index;

@end

/**
 * 使用注意事项：先把font和frame设置好才能设置text；
 * 因为在设置text时会判断text长度；长度大小frame才会添加时钟左右滚动文本
 */
@interface CTScrollLabel : UIView<UITableViewDataSource, UITableViewDelegate>
{
    float hideWidth;
    BOOL scrollRight;
    NSTimer *rollTimer;
    NSTimer *waitTimer;
}

// 跑马灯需要点击选择时，实现代理
@property (nonatomic, assign) id<CTScrollLabelDelegate> delegate;
@property (nonatomic, retain) UILabel *lblText;
@property (nonatomic, assign) BOOL marquee;

- (void)setTitle:(NSString *)title;
- (void)releaseTimer;
- (void)reloadData;

@end
