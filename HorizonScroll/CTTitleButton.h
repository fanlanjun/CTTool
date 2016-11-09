//
//  CTTitleButton.h
//
//
//  Created by fan frank on 12-6-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 垂直 图标＋标题
 */
@interface CTTitleButton : UIButton

/** 图标 */
@property (nonatomic, retain) UIImageView *ivIcon;
/** 标题 */
@property (nonatomic, retain) UILabel *lblTitle;
/** 可用于保存索引 */
@property (nonatomic, assign) NSInteger index;
/** 保持选中状态 */
@property (nonatomic, assign) BOOL keepSelect;
/** 标签高度 */
@property (nonatomic, assign) float lblHeight;
/** 图标和标题的间距 */
@property (nonatomic, assign) float span;
/** 显示new */
@property (nonatomic, assign) BOOL showNew;
/** 提示数字，0时隐藏 */
@property (nonatomic, assign) int number;
/** 显示下载 */
@property (nonatomic, assign) BOOL showDownload;
/** 显示更新 */
@property (nonatomic, assign) BOOL showUpdate;

@end