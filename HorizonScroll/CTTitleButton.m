//
//  CTTitleButton.m
//
//
//  Created by fan frank on 12-6-11.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "CTTitleButton.h"

#define kDefaultSpan 2
#define kLblHeight 15

@interface CTTitleButton()

@property (nonatomic, retain) UIColor *normalColor;
@property (nonatomic, retain) UIColor *highlightedColor;
@property (nonatomic, retain) UIImageView *funNewImageView;
@property (nonatomic, retain) UIButton *numberButton;
@property (nonatomic, retain) UIImageView *downloadImageView;

- (void)initCode;

@end

@implementation CTTitleButton

@synthesize ivIcon = _ivIcon;
@synthesize lblTitle = _lblTitle;
@synthesize index = _index;
@synthesize keepSelect = _keepSelect;
@synthesize normalColor = _normalColor;
@synthesize highlightedColor = _highlightedColor;
@synthesize downloadImageView = _downloadImageView;

#pragma mark - MemoryManage

- (void)dealloc
{
    self.normalColor = nil;
    self.highlightedColor = nil;
    self.ivIcon = nil;
    self.lblTitle = nil;
    self.downloadImageView = nil;
    self.numberButton = nil;
    self.funNewImageView = nil;
}

#pragma mark - InitMethods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:nil forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateHighlighted];
        [self initCode];
        [self resetFrame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initCode];
        [self resetFrame];
    }
    return self;
}

- (void)awakeFromNib {
    [self initCode];
    [super awakeFromNib];
    [self resetFrame];
}

#pragma mark - GetOrSet

- (void)setNumber:(int)number
{
    _number = number;
    
    if (number > 0)
    {
        NSString *title = number < 100 ? [NSString stringWithFormat:@"%d", number] : @"...";
        [self.numberButton setTitle:title forState:UIControlStateNormal];
    }
    else
    {
        [_numberButton removeFromSuperview];
        self.numberButton = nil;
    }
}

- (void)setShowNew:(BOOL)showNew
{
    _showNew = showNew;
    if (showNew)
    {
        [self funNewImageView];
    }
    else
    {
        [_funNewImageView removeFromSuperview];
        self.funNewImageView = nil;
    }
}

- (UIImageView *)funNewImageView
{
    if (!_funNewImageView)
    {
        self.funNewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 20, 8)];
        _funNewImageView.image = [UIImage imageNamed:@"tools_new_tag.png"];
        [self addSubview:_funNewImageView];
    }
    return _funNewImageView;
}

- (UIButton *)numberButton
{
    if (!_numberButton)
    {
#ifdef IOS_DEVICE_PAD
        self.numberButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, 2, 14, 14)];
#else
        self.numberButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 16, 2, 14, 14)];
#endif
        
        [_numberButton setBackgroundImage:[UIImage imageNamed:@"module_number.png"] forState:UIControlStateNormal];
        [_numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _numberButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:_numberButton];
    }
    return _numberButton;
}
- (void)setShowDownload:(BOOL)showDownload
{
    _showDownload = showDownload;
    if (showDownload)
    {
        [self downloadImageView];
    }
    else
    {
        [_downloadImageView removeFromSuperview];
        self.downloadImageView = nil;
    }
}

- (void)setShowUpdate:(BOOL)showUpdate
{
    _showUpdate = showUpdate;
    if (showUpdate)
    {
        [self upWithDownImageView:YES];
    }
    else
    {
        [_downloadImageView removeFromSuperview];
        self.downloadImageView = nil;
    }
}

- (UIImageView *)downloadImageView
{
    return [self upWithDownImageView:NO];
}

- (UIImageView *)upWithDownImageView:(BOOL)isUp
{
    if (!_downloadImageView)
    {
        self.downloadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 17, self.frame.size.height - 18, 15, 15)];
        _downloadImageView.image = [UIImage imageNamed:(isUp ? @"module_update.png" : @"module_download.png")];
        [self addSubview:_downloadImageView];
    }
    
    return _downloadImageView;
}

#pragma mark - RewriteMethods

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [super setTitleColor:color forState:state];
    if (state == UIControlStateHighlighted) self.highlightedColor = color;
    if (state == UIControlStateNormal) {
        self.lblTitle.textColor = color;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_keepSelect)
    {
        highlighted = YES;
    }
    if ([self backgroundImageForState:UIControlStateHighlighted] != [self backgroundImageForState:UIControlStateNormal])
    {
        [super setHighlighted:highlighted];
    }
    if (_highlightedColor != nil)
    {
        if (_normalColor == nil)
        {
            self.normalColor = self.lblTitle.textColor;
        }
        self.lblTitle.textColor = highlighted ? _highlightedColor : _normalColor;
    }
    
    self.ivIcon.highlighted = highlighted;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetFrame];
}

- (void)setLblHeight:(float)lblHeight
{
    _lblHeight = lblHeight;
    [self resetFrame];
}

- (void)setSpan:(float)span
{
    _span = span;
    [self resetFrame];
}

#pragma mark - PrivateMethods

- (void)resetFrame
{
    CGRect frame = self.frame;
    self.ivIcon.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - _lblHeight - _span);
    self.lblTitle.frame = CGRectMake(0, frame.size.height - _lblHeight - _span, frame.size.width, _lblHeight);
}

- (void)initCode
{
    self.lblHeight = kLblHeight;
    self.span = kDefaultSpan;
    
    self.ivIcon = [[UIImageView alloc] init];
    [self addSubview:_ivIcon];
    [_ivIcon setContentMode:UIViewContentModeCenter];
    
    self.lblTitle = [[UILabel alloc] init];
    [self addSubview:_lblTitle];
    [_lblTitle setTextAlignment:UITextAlignmentCenter];
    [_lblTitle setFont:[UIFont systemFontOfSize:14.0f]];
    [_lblTitle setBackgroundColor:[UIColor clearColor]];
    _lblTitle.textColor = [self titleColorForState:UIControlStateNormal];
}

@end
