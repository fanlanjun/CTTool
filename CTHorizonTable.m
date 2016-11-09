//
//  CTHorizonTable.m
//  Infinitus
//
//  Created by fan frank on 12-6-1.
//  Copyright 2012年 frank. All rights reserved.
//

#import "CTHorizonTable.h"

@interface CTHorizonTable()

- (void)initCode;

@end

@implementation CTHorizonTable

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ((self = [super initWithFrame:frame style:style]))
    {
        [self initCode];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initCode];
    }
    return self;
}

#pragma mark - PrivateMethods

- (void)initCode
{
    [self setAlwaysBounceVertical:NO];
    // 把表格的宽度和高度互相调换
    CGRect tvImageRect = self.frame;
    [self setFrame:CGRectMake(tvImageRect.origin.x, tvImageRect.origin.y, tvImageRect.size.height, tvImageRect.size.width)];
    self.center = CGPointMake(tvImageRect.size.width / 2 + tvImageRect.origin.x, tvImageRect.size.height / 2 + tvImageRect.origin.y);
    
    //tableView逆时针旋转90度。
    self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    
    // 设置UITableViewCell样式
    self.separatorColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end

@interface CTHorizonTableCell()

- (void)initCode;

@end

@implementation CTHorizonTableCell

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initCode];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.frame = frame;
        [self initCode];
    }
    return self;
}

#pragma mark - PrivateMethods

- (void)initCode
{
    // 把表格单元的宽度和高度互相调换
    CGRect tvImageRect = self.frame;
    [self setFrame:CGRectMake(tvImageRect.origin.x, tvImageRect.origin.y, tvImageRect.size.height, tvImageRect.size.width)];
    self.center = CGPointMake(tvImageRect.size.width / 2 + tvImageRect.origin.x, tvImageRect.size.height / 2 + tvImageRect.origin.y);
    
    //tableViewCell逆时针旋转90度。
    self.transform = CGAffineTransformMakeRotation(M_PI / 2);
}

@end