//
//  CTPageControl.m
//  CTTelecomNetOpti
//
//  Created by fan frank on 12-7-16.
//  Copyright (c) 2012年 gdcattsoft.com. All rights reserved.
//

#import "CTPageControl.h"

@implementation CTPageControl

@synthesize align = _align;
@synthesize delegate = _delegate;

- (void)dealloc
{
    activeImage = nil;
    inactiveImage = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.align = UITextAlignmentRight;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    _defaultFrame = frame;
    [self setAlign:_align];
}

#pragma mark - Public methods

- (void)setAlign:(UITextAlignment)align
{
    _align = align;
    float x = _defaultFrame.origin.x, width = _defaultFrame.size.width;
    int count = self.numberOfPages;
    switch (_align)
    {
        case UITextAlignmentLeft:
        {
            CGSize size = [self sizeForNumberOfPages:count];
            width = (size.width < width) ? size.width : width;
        }
            break;
        case UITextAlignmentCenter:
        {
            CGSize size = [self sizeForNumberOfPages:count];
            if (size.width < width)
            {
                x += (width - size.width) / 2.0f;
                width = size.width;
            }
        }
            break;
        default:
            break;
    }
    [super setFrame:CGRectMake(x, _defaultFrame.origin.y, width, _defaultFrame.size.height)];
}

- (void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (activeImage == nil)
        {
            if ([_delegate respondsToSelector:@selector(pageControl:activeImg:inactiveImg:)])
            {
                UIImage *theActiveImage = nil;
                UIImage *theInactiveImage = nil;
                [_delegate pageControl:self activeImg:&theActiveImage inactiveImg:&theInactiveImage];
                
                activeImage = theActiveImage;
                inactiveImage = theInactiveImage;
            }
            else
            {
                activeImage = [UIImage imageNamed:@"active_page.png"];
                inactiveImage = [UIImage imageNamed:@"inactive_page.png"];
            }
        }
        
        if ([dot isKindOfClass:[UIImageView class]])
        {
            dot.image = (i == self.currentPage ? activeImage : inactiveImage);
        }
        else
        {
            dot.backgroundColor = [UIColor colorWithPatternImage:(i == self.currentPage ? activeImage : inactiveImage)];
        }
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    [self setAlign:_align];
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end;