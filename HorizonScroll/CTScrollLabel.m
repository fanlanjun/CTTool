//
//  CTScrollLabel.m
//  CTSqliteSecurityDemo
//
//  Created by fan frank on 12-8-24.
//  Copyright (c) 2012年 gdcattsoft.com. All rights reserved.
//

#import "CTScrollLabel.h"
#import "CTHorizonTable.h"

#define kScrollLableIdentifier @"ScrollLableIdentifier"
#define kItemBetweenPadding 50
#define kScrollSpeed 0.4f/60.f

@interface CTScrollLabelCell : CTHorizonTableCell

@property (nonatomic, retain) UIButton *btnTitle;

@end

@implementation CTScrollLabelCell

@synthesize btnTitle = _btnTitle;

- (void)dealloc
{
    self.btnTitle = nil;
}

@end

@interface CTScrollLabel()

@property (nonatomic, retain) CTHorizonTable *table;

- (void)releaseRollTimer;
- (void)releaseWaitTimer;
- (void)waitTwoSecond;
- (void)rollText;

@end

@implementation CTScrollLabel

@synthesize lblText;
@synthesize marquee;
@synthesize delegate;
@synthesize table;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.clipsToBounds=YES;
        self.lblText = [[UILabel alloc] init];
        [lblText setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblText];
    }
    return self;
}

- (void)dealloc
{
    delegate = nil;
    self.table = nil;
    self.lblText=nil;
    [self releaseTimer];
}

#pragma mark - Public methods

- (void)setTitle:(NSString *)title
{
    if (lblText == nil)
    {
        return;
    }
    CGSize textSize = [title sizeWithFont:lblText.font];
    hideWidth = textSize.width - self.frame.size.width;
    [lblText setText:title];
    
    if (!marquee)
    {
        self.userInteractionEnabled=NO;
        [lblText setFrame:CGRectMake(0, 0, (self.frame.size.width > textSize.width ? self.frame.size.width : textSize.width), self.frame.size.height)];
        if (hideWidth > 0 && waitTimer == nil)
        {
            [self waitTwoSecond];
            waitTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(waitTwoSecond) userInfo:nil repeats:YES];
        }
        else
        {
            [self releaseRollTimer];
        }
    }
    else
    {
        if (hideWidth > 0)
        {
            [lblText setFrame:CGRectMake(lblText.frame.origin.x, 0, (self.frame.size.width > textSize.width ? self.frame.size.width : textSize.width), self.frame.size.height)];
            [self waitTwoSecond];
        }
        else
        {
            [self waitTwoSecond];
            //            [self releaseRollTimer];
            [lblText setFrame:CGRectMake(0, 0, textSize.width, self.frame.size.height)];
        }
    }
}

- (void)releaseTimer
{
    [self releaseRollTimer];
    [self releaseWaitTimer];
}

- (void)reloadData
{
    [table reloadData];
}

- (void)setDelegate:(id<CTScrollLabelDelegate>)theDelegate
{
    self.marquee = YES;
    delegate = theDelegate;
    if (table == nil)
    {
        self.table = [[CTHorizonTable alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        table.backgroundColor = [UIColor clearColor];
        table.delegate = self;
        table.dataSource = self;
        table.showsHorizontalScrollIndicator = NO;
        table.showsVerticalScrollIndicator = NO;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.bounces = NO;
        table.allowsSelection = NO;
        table.scrollEnabled = NO;
        [self addSubview:table];
    }
    [self waitTwoSecond];
}

#pragma mark - Private methods

- (void)releaseRollTimer
{
    if (rollTimer != nil)
    {
        [rollTimer invalidate];
        rollTimer = nil;
    }
}

- (void)releaseWaitTimer
{
    if (waitTimer != nil)
    {
        [waitTimer invalidate];
        waitTimer = nil;
    }
}

- (void)waitTwoSecond
{
    [self releaseRollTimer];
    if (!marquee)
    {
        rollTimer = [NSTimer scheduledTimerWithTimeInterval:kScrollSpeed target:self selector:@selector(rollText) userInfo:nil repeats:YES];
    }
    else
    {
        rollTimer = [NSTimer scheduledTimerWithTimeInterval:kScrollSpeed target:self selector:@selector(rollText) userInfo:nil repeats:YES];
    }
}

- (void)rollText
{
    CGRect frame = self.lblText.frame;
    if (!marquee)
    {
        if (scrollRight)
        {
            if (frame.origin.x >= 0)
            {
                scrollRight = NO;
                [self releaseRollTimer];
            }
            frame.origin.x += 0.4 * 0.5f;
        }
        else
        {
            if (frame.origin.x <= -hideWidth)
            {
                scrollRight = YES;
                [self releaseRollTimer];
            }
            frame.origin.x -= 0.4 * 0.5;
        }
        self.lblText.frame=frame;
    }
    else
    {
        if (delegate == nil)
        {
            if (frame.origin.x <= -frame.size.width)
            {
                frame.origin.x = frame.size.width - hideWidth;
            }
            frame.origin.x -= 0.4;
            
            self.lblText.frame=frame;
        }
        else
        {
            CGPoint point = table.contentOffset;
            if (point.y > table.contentSize.height)
            {
                point.y = -table.frame.size.width;
            }
            point.y += 0.4;
            
            [table setContentOffset:point];
        }
    }
}

- (void)btnTitleUpInside:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(didSelectWithIndex:)])
    {
        [delegate didSelectWithIndex:sender.tag];
    }
    [self waitTwoSecond];
}

- (void)btnTitleDownInside:(UIButton *)sender
{
    [self releaseRollTimer];
}

- (void)btnTitleNotInside:(UIButton *)sender
{
    [self waitTwoSecond];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [delegate numberOfTitles];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTScrollLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:kScrollLableIdentifier];
    if (cell == nil)
    {
        cell = [[CTScrollLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kScrollLableIdentifier frame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        
        UIButton *btn =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width - tableView.frame.size.width, cell.frame.size.height)];
        [btn addTarget:self action:@selector(btnTitleUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(btnTitleDownInside:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(btnTitleNotInside:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        btn.titleLabel.font = lblText.font;
        [btn setTitleColor:lblText.textColor forState:UIControlStateNormal];
        cell.btnTitle = btn;
        [cell addSubview:btn];
    }
    
    NSString *title = [delegate titleForIndex:indexPath.row];
    cell.btnTitle.tag = indexPath.row;
    CGRect frame = cell.btnTitle.frame; frame.size.width = [title sizeWithFont:lblText.font].width;
    cell.btnTitle.frame = frame;
    [cell.btnTitle setTitle:title forState:UIControlStateNormal];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [delegate titleForIndex:indexPath.row];
    CGSize textSize = [title sizeWithFont:lblText.font];
    
    if ([delegate numberOfTitles] > 1 && indexPath.row < [delegate numberOfTitles] - 1)
    {
        return textSize.width + kItemBetweenPadding;
    }
    else
    {
        return textSize.width;
    }
}

@end
