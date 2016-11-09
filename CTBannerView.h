//
//  CTBannerView.h
//  LaiFanJade
//
//  Created by FanFrank on 16/4/15.
//  Copyright © 2016年 com.frankfan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CTBannerViewSourceType){
    CTBannerViewSourceTypeNetWork = 10001,// image from network --tight with sd webimage;
    CTBannerViewSourceTypeLocal = 10002// image from local
};

typedef NS_ENUM(NSInteger, CTBannerViewItemType){
    CTBannerViewItemTypeNormal = 10001,
    CTBannerViewItemTypeNoPageControl = 10002,
    CTBannerViewItemTypeCustom = 10003// no available now.....
};
typedef NS_ENUM(NSInteger, CTBannerViewPageControlType){
    CTBannerViewPageControlTypeLeft = 10001,
    CTBannerViewPageControlTypeRight = 10002,
    CTBannerViewPageControlTypeCenter = 10003// if center the label will not show
};
@class CTBannerView;

@protocol CTBannerViewDelegate <NSObject>

@required
//tap on the banner and return the index
-(void)bannerViewDidSelectedBanner:(CTBannerView*) banner atIndex:(NSUInteger)index;


@end

@interface CTBannerView : UIView

//properties must be setted from out sides
@property (nonatomic, strong) NSArray<UIImage *> *images; // array of images --- type UIImage
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) NSArray<NSString *> *titles;// array of titles of image --- type string
//properties can be setted from out sides ---but with default values-- from it's getter
@property (nonatomic, assign,getter=isNoLoop) BOOL noLoop;// useless know
@property (nonatomic, assign) CTBannerViewItemType bannerViewItemType;// item type
@property (nonatomic, assign) CTBannerViewSourceType bannerViewSourceType;// image source type
@property (nonatomic, assign) CTBannerViewPageControlType bannerViewPageControlType;//page control type;
@property (nonatomic,assign,getter=isAutoPlay) BOOL autoPlay;
@property (nonatomic, assign) NSTimeInterval autoPlayTime;
@property (nonatomic, strong) UIColor *currentControlColor;// the color of current page indicator
@property (nonatomic, strong) UIColor *controlColor;// the color of normal page indicator
@property (nonatomic, strong) UIColor *titleLableColor;// the color of the label
@property (nonatomic, strong) UIColor *bottomViewBackGroundColor;// the color of the bottom view back ground
@property (nonatomic,weak) id<CTBannerViewDelegate> delegate;// delegate to recognize the gesture;
@property (nonatomic,assign) CGFloat bottomHeight;
// designated initialize method if not use this method , the source type and item type will be normal and net work;
+ (instancetype)bannerViewWithFrame:(CGRect ) frame
                   bannerSourceType:(CTBannerViewSourceType ) bannerSourceType
                     bannerItemType:(CTBannerViewItemType ) bannerItemType
                           autoPlay:(BOOL) autoPlay;
// set data for the banner --when it's from local the play time only enable when the auto play is yes;
- (void)setImages:(NSArray<UIImage *> *) images
           titles:(NSArray<NSString *> *) titles
     autoPlayTime:(NSTimeInterval) autoPlayTime ;
// set data for the banner --when it's from network the play time only enable when the auto play is yes;
- (void)setImageUrls:(NSArray<NSString *> *)imageUrls
              titles:(NSArray<NSString *> *)titles
        autoPlayTime:(NSTimeInterval) autoPlayTime;
//to stop auto play from outside
- (void)stopAutoPlay;
// set the color of the page control
-(void)setCurrentControlColor:(UIColor *)currentControlColor
                 controlColor:(UIColor *)controlColor;


@end
