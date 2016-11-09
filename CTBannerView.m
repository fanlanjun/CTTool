//
//  CTBannerView.m
//  LaiFanJade
//
//  Created by FanFrank on 16/4/15.
//  Copyright © 2016年 com.frankfan. All rights reserved.
//

#import "CTBannerView.h"
#import "UIImageView+WebCache.h"

#define BANNER_WIDTH self.bounds.size.width
#define BANNER_HEIGHT self.bounds.size.height

@interface CTBannerView ()<UIScrollViewDelegate>

//subviews of the banner
@property (nonatomic, weak) UIScrollView *scrollView; //the banner's main scroll
@property (nonatomic, weak) UIPageControl *pageControl;//the page control of banner - no user interaction enable
@property (nonatomic, weak) UILabel *titleLable; //the title label of the banner
@property (nonatomic, weak) UIView *placeHolderView;// the place holder view to show when images are not setted ;
//custon view item of the banner --- for custom style ------ implemente later ----
@property (nonatomic, strong) UIView *customView;
//properties inner class changes at runtime;
@property (nonatomic, strong) NSMutableArray<UIImage *> *currentImages;//the current three images to show in the scrol view
@property (nonatomic, strong) NSMutableArray<NSString *> *currentImageUrls;// the current url of images
@property (nonatomic, assign) NSUInteger currentPage;// the current index of images
@property (nonatomic, weak) NSTimer *timer;


@end


@implementation CTBannerView
#pragma mark - initialization
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *placeHolderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, BANNER_WIDTH, BANNER_HEIGHT)];
        placeHolderView.image = [UIImage imageNamed:@"defaultImage"];
        [self addSubview:placeHolderView];
        self.placeHolderView = placeHolderView;
    }
    return self;
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame
                   bannerSourceType:(CTBannerViewSourceType)bannerSourceType
                     bannerItemType:(CTBannerViewItemType)bannerItemType
                           autoPlay:(BOOL)autoPlay{
    CTBannerView *banner = [[CTBannerView alloc]initWithFrame:frame];
    banner.bannerViewItemType = bannerItemType;
    banner.bannerViewSourceType = bannerSourceType;
    banner.autoPlay = autoPlay;
    return banner;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
    }
    
}
#pragma mark - properties
- (CTBannerViewSourceType)bannerViewSourceType{
    if (!_bannerViewSourceType) {
        _bannerViewSourceType = CTBannerViewSourceTypeNetWork;
    }
    return _bannerViewSourceType;
}
- (CTBannerViewItemType)bannerViewItemType{
    if (!_bannerViewItemType) {
        _bannerViewItemType = CTBannerViewItemTypeNormal;
    }
    return _bannerViewItemType;
}

- (NSTimeInterval)autoPlayTime{
    if (!_autoPlayTime) {
        _autoPlayTime = 2.0;
    }
    return _autoPlayTime;
}

- (UIColor *)currentControlColor{
    if (!_currentControlColor) {
        _currentControlColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1];
    }
    return _currentControlColor;
}

- (UIColor *)controlColor{
    if (!_controlColor) {
        _controlColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    }
    return _controlColor;
}
- (UIColor *)titleLableColor{
    if (!_titleLableColor) {
        _titleLableColor = [UIColor whiteColor];
    }
    return _titleLableColor;
}
- (UIColor *)bottomViewBackGroundColor{
    if (!_bottomViewBackGroundColor) {
        _bottomViewBackGroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    return _bottomViewBackGroundColor;
}
- (CTBannerViewPageControlType)bannerViewPageControlType{
    if (!_bannerViewPageControlType) {
        _bannerViewPageControlType = CTBannerViewPageControlTypeRight;
    }
    return _bannerViewPageControlType;
}
- (CGFloat)bottomHeight{
    if (!_bottomHeight) {
        _bottomHeight = BANNER_HEIGHT/6;
    }
    return _bottomHeight;
}
#pragma mark - auto change properties
- (NSMutableArray *)currentImages{
    
    if (!_currentImages) {
        _currentImages = [NSMutableArray array];
    }
    //get the image
    [_currentImages removeAllObjects];
    NSInteger count = self.images.count;
    int i = (int)(_currentPage + count - 1)%count;
    [_currentImages addObject:self.images[i]];
    [_currentImages addObject:self.images[_currentPage]];
    i = (int)(_currentPage + 1)%count;
    [_currentImages addObject:self.images[i]];
    return _currentImages;
}
- (NSMutableArray *)currentImageUrls{
    if (!_currentImageUrls) {
        _currentImageUrls = [NSMutableArray array];
    }
    [_currentImageUrls removeAllObjects];
    NSInteger count = self.imageUrls.count;
    //add the front one of current
    int i = (int)(_currentPage +count -1)%count;
    
    [_currentImageUrls addObject:self.imageUrls[i]];
    [_currentImageUrls addObject:self.imageUrls[_currentPage]];
    //get the behind one in the recycle array ;
    i = (int)(_currentPage +count +1)%count;
    [_currentImageUrls addObject:self.imageUrls[i]];
    
    return _currentImageUrls;
}


#pragma mark - public method

- (void)setImages:(NSArray<UIImage *> *)images
           titles:(NSArray<NSString *> *)titles
     autoPlayTime:(NSTimeInterval)autoPlayTime{
    
    self.images = images;
    self.titles = titles;
    self.autoPlayTime = autoPlayTime;
    [self addViews];
}

- (void)setImageUrls:(NSArray<NSString *> *)imageUrls
              titles:(NSArray<NSString *> *)titles
        autoPlayTime:(NSTimeInterval)autoPlayTime{
    self.imageUrls = imageUrls;
    self.titles = titles;
    self.autoPlayTime = autoPlayTime;
    [self addViews];
    
}
- (void)stopAutoPlay{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setCurrentControlColor:(UIColor *)currentControlColor controlColor:(UIColor *)controlColor{
    self.currentControlColor = currentControlColor;
    self.controlColor = controlColor;
}
#pragma mark - private methods
- (void)addViews{
    //add scroll view and page control then remove the place holder view
    
    // 数据重新设置时，停用timer和当前显示图片 fanlanjun
    [_timer invalidate];
    _timer = nil;
    _currentPage = 0;
    _currentImageUrls = nil;
    
    [self addScrollView];
    if (self.bannerViewItemType != CTBannerViewItemTypeNoPageControl) {
        [self addPageControl];
    }
    [self.placeHolderView removeFromSuperview];
    [self checkAutoPlay];
}
// check if need to auto play
- (void)checkAutoPlay{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
    _timer = timer;
    if (self.autoPlay) {
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)scrollToNext{
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH*2, 0) animated:YES];
    [self refreshImages];
}


// add the scroll view
- (void)addScrollView{
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:
                                CGRectMake(0, 0, BANNER_WIDTH, BANNER_HEIGHT)];
    for (int i = 0; i < 3; i ++) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:
                                  CGRectMake(BANNER_WIDTH*i, 0, BANNER_WIDTH, BANNER_HEIGHT)];
        //imageView.image = self.currentImages[i];
        //set the image of these images
        if (self.bannerViewSourceType == CTBannerViewSourceTypeNetWork) {
            [imageView sd_setImageWithURL:[NSURL URLWithString: self.currentImageUrls[i]]
                         placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        }else {
            imageView.image = self.currentImages[i] ? self.currentImages[i]:[UIImage imageNamed:@"defaultImage"];
        }
        [scrollView addSubview:imageView];
    }
    [scrollView setContentSize:CGSizeMake(BANNER_WIDTH*3, BANNER_HEIGHT)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setPagingEnabled:YES];
    [scrollView setContentOffset :CGPointMake(BANNER_WIDTH, 0) ];
    scrollView.delegate = self;
    //to recognize the gesture for the scrollView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [scrollView addGestureRecognizer:tap];
    
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
}

- (void)singleTapped:(UIGestureRecognizer*) recognizer{
    
    if ([self.delegate respondsToSelector:@selector(bannerViewDidSelectedBanner:atIndex:)]) {
        [self.delegate bannerViewDidSelectedBanner:self atIndex :_currentPage];
    }
}

// add the page control
- (void)addPageControl{
    UIView* backGroud = [[UIView alloc]initWithFrame:
                         CGRectMake(0, BANNER_HEIGHT - self.bottomHeight, BANNER_WIDTH,self.bottomHeight)];
    CGRect pageControlFrame;
    CGRect titleLabelFrame;
    if (self.bannerViewPageControlType == CTBannerViewPageControlTypeRight) {
        pageControlFrame =  CGRectMake(BANNER_WIDTH*0.8, 10, BANNER_WIDTH/6, self.bottomHeight-10);
        titleLabelFrame = CGRectMake(10, 0, BANNER_WIDTH*0.75, self.bottomHeight);
    }else if (self.bannerViewPageControlType == CTBannerViewPageControlTypeLeft){
        pageControlFrame = CGRectMake(10, 10, BANNER_WIDTH/6, self.bottomHeight-10);
        titleLabelFrame = CGRectMake(BANNER_WIDTH - 10 - BANNER_WIDTH*0.75, 0, BANNER_WIDTH*0.75, self.bottomHeight);
    }else{
        pageControlFrame = CGRectMake(BANNER_WIDTH/12*5, 10, BANNER_WIDTH/6, self.bottomHeight-10);
        titleLabelFrame = CGRectMake(0, 0, 0, 0);// should remove it but this work
    }
    
    [backGroud setBackgroundColor:
     self.bottomViewBackGroundColor];
    UIPageControl* pageControl = [[UIPageControl alloc]initWithFrame:pageControlFrame];
    
    [pageControl setNumberOfPages:self.imageUrls.count ? self.imageUrls.count :self.images.count];
    [pageControl setCurrentPage:0];
    [pageControl setUserInteractionEnabled:NO];
    [pageControl setCurrentPageIndicatorTintColor:self.currentControlColor];
    [pageControl setPageIndicatorTintColor:self.controlColor];
    [backGroud addSubview:pageControl];
    self.pageControl = pageControl;
    
    UILabel* titleLable = [[UILabel alloc]initWithFrame:titleLabelFrame];
    titleLable.text = _titles[0];
    if (self.bannerViewPageControlType == CTBannerViewPageControlTypeLeft) {
        titleLable.textAlignment = NSTextAlignmentRight;
    }
    titleLable.numberOfLines = 1;
    [backGroud addSubview:titleLable];
    titleLable.textColor = self.titleLableColor;
    self.titleLable = titleLable;
    [self addSubview:backGroud];
}


#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger count;
    if (self.bannerViewSourceType == CTBannerViewSourceTypeLocal) {
        count = self.images.count;
    }else{
        count = self.imageUrls.count;
    }
    if (x >= BANNER_WIDTH * 2 ) {
        _currentPage = (++_currentPage)%count;
        self.pageControl.currentPage = _currentPage;
        [self refreshImages];
    }
    if (x <= 0) {
        _currentPage = (int)(_currentPage + count -1)%count;
        self.pageControl.currentPage = _currentPage;
        [self refreshImages];
    }
    self.titleLable.text = _titles[_currentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}


// refrensh the image of the image view the data of current image will change with the current page property
- (void)refreshImages{
    // if want the code more safe there should have an if else but i dont know what to judgement
    [self.placeHolderView removeFromSuperview];
    NSArray *subViews = self.scrollView.subviews;
    for (int i = 0; i < subViews.count; i++) {
        if (self.bannerViewSourceType == CTBannerViewSourceTypeLocal) {
            UIImageView *imageView = (UIImageView *)subViews[i];
            imageView.image = self.currentImages[i];
        }else {
            UIImageView* imageView = (UIImageView *)subViews[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.currentImageUrls[i]]placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        }
    }
    //move the scroll view offset back to the center ---this is another important thing of my banner
    [self.scrollView setContentOffset:CGPointMake(BANNER_WIDTH, 0)];
    
}

@end
