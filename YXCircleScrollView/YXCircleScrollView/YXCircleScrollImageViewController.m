//
//  YXCircleScrollView.m
//  YXebookReader
//
//  Created by BZBY on 15/12/4.
//  Copyright (c) 2015年 BZBY. All rights reserved.
//

#import "YXCircleScrollImageViewController.h"
#import "YXImageViewController.h"



@interface YXCircleScrollImageViewController()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong,nonatomic) UIPageViewController * pageViewController;
@property (assign,nonatomic) NSInteger totalPages;

@property (strong,nonatomic) UIView *pageView;
@property (strong,nonatomic) UIPageControl * pageControl;
@property (strong,nonatomic) NSTimer * timer;
@property (assign,nonatomic) NSInteger seconds;

@property (assign,nonatomic) BOOL isLongPressing;

@property (assign,nonatomic) BOOL pauseTimerCount;

@property (strong,nonatomic) UIView * disableScrollView;
@end
@implementation YXCircleScrollImageViewController
@synthesize pageControllBottom = _pageControllBottom;
-(CGFloat)pageControllBottom{
    return self.pageControl.frame.origin.y + self.pageControl.frame.size.height;
}
-(void)setPageControllBottom:(CGFloat)pageControllBottom{
    _pageControllBottom = pageControllBottom;
    CGPoint centerPoint = self.pageControl.center;
    centerPoint.y = self.pageView.frame.size.height - self.pageControl.frame.size.height - _pageControllBottom;
    self.pageControl.center = centerPoint;
    
}
-(void)setCustomBottomView:(UIView *)customBottomView{
    _customBottomView = customBottomView;
    CGRect frame = _customBottomView.frame;
    if(_customBottomView.frame.size.height>self.view.frame.size.height/4.0){
        frame.size.height = self.view.frame.size.height/4.0;
    }
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    _customBottomView.frame = frame;
    
    if(_customBottomView){
        self.pageControl.hidden = YES;
        _customBottomView.userInteractionEnabled = YES;
    }else{
        self.pageControl.hidden = NO;
    }
    [self.view addSubview:_customBottomView];
}
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}
-(UIColor *)pageIndicatorTintColor{
    return self.pageControl.pageIndicatorTintColor;
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
-(UIColor *)currentPageIndicatorTintColor{
    return self.pageControl.currentPageIndicatorTintColor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.autoScrollSecconds = 3;
        _isOpenAotuScroll = YES;
        self.pauseTimerCount = NO;
    }
    return self;
}
/**
 *  初始化轮播滚动控制器
 *
 *  @param totalPages              总页数
 *  @param imageOrUrlAtPageIndex   图片或者图片url
 *  @param defaultImageAtPageIndex 默认图片
 *  @param imageSingleTapHandle    图片点击回调
 *
 *  @return 返回轮播滚动控制器实例
 */
- (instancetype)initWithTotalPages:(TotalPagesBlock)totalPages ImageOrUrlAtPageIndex:(ImageOrUrlAtPageIndexBlock)imageOrUrlAtPageIndex DefaultImageAtPageIndexBlock:(DefaultImageAtPageIndexBlock)defaultImageAtPageIndex ImageSingleTapHandleBlock:(ImageSingleTapHandleBlock)imageSingleTapHandle{
    self = [super init];
    if (self) {
        self.totalPagesBlock = totalPages;
        self.imageOrUrlAtPageIndexBlock = imageOrUrlAtPageIndex;
        self.defaultImageAtPageIndexBlock = defaultImageAtPageIndex;
        self.imageSingleTapHandleBlock = imageSingleTapHandle;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    [self createPageView];
    [self createPageViewController];
    [self createPageControll];
    
    //self.view.backgroundColor = [UIColor blueColor];
    [self startShowPageVcWithPageIndex:0];

}


-(void)appEnterForeground{
    [self startTimer];
}
-(void)appEnterBackground{
    [self endTimer];
}
-(void)initData{
    self.totalPages = 0;
    if(self.totalPagesBlock){
        self.totalPages = self.totalPagesBlock(self);
    }
    self.isLongPressing = NO;
    self.autoScrollSecconds = 3;
    _isOpenAotuScroll = YES;
    self.pauseTimerCount = NO;
}
-(void)initUI{
    CGFloat ZYX_SCREEN_WIDTH = [[UIScreen mainScreen] bounds].size.width;
    CGFloat ZYX_SCREEN_HEIGHT = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = self.view.frame;
    if(CGRectEqualToRect(self.frame, CGRectZero)){
        frame.size.width = ZYX_SCREEN_WIDTH;
        frame.size.height = ZYX_SCREEN_HEIGHT;

        self.view.frame = frame;
        
        self.frame = self.view.frame;
    }else{
        self.view.frame = self.frame;
    }
    
    self.view.autoresizingMask = UIViewAutoresizingNone;
}
/**
 *  刷新数据
 */
-(void)reloadData{
    if(self.totalPagesBlock){
        self.totalPages = self.totalPagesBlock(self);
    }
    
    self.disableScrollView.hidden = self.totalPages>1;
    
    self.pageControl.hidden = self.totalPages<2;
    
    self.pageControl.numberOfPages = self.totalPages;
    
    if(self.totalPages<2){
        [self endTimer];
    }else{
        [self startTimer];
    }
    
    [self gotoPageWithPageIndex:0];
}
- (void)createPageView{
    self.pageView = [[UIView alloc] init];
    CGRect frame = self.pageView.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height;
    self.pageView.frame = frame;
    [self.view addSubview:self.pageView];
}
- (void)createPageViewController{
    // 设置UIPageViewController的配置项
    
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate =self;
    [self.pageView addSubview:self.pageViewController.view];
    
    if(nil == self.disableScrollView){
        self.disableScrollView = [[UIView alloc] initWithFrame:self.pageView.bounds];
        self.disableScrollView.backgroundColor = [UIColor clearColor];
        self.disableScrollView.hidden = self.totalPages>1;
        [self.pageView addSubview:self.disableScrollView];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetureHandle:)];
        self.disableScrollView.userInteractionEnabled = YES;
        [self.disableScrollView addGestureRecognizer:tapGesture];
    }
    
}
- (void)tapGetureHandle:(UITapGestureRecognizer*)tapGeture{
    if(self.imageSingleTapHandleBlock){
        self.imageSingleTapHandleBlock(0);
    }
}
#pragma  mark 进入页码显示的页面，第一页或者上一次阅读记录的那一页
- (void)startShowPageVcWithPageIndex:(NSInteger)pageIndex{
    CGRect frame = self.pageViewController.view.frame;
    
    frame.size.width = self.pageView.frame.size.width;
    frame.size.height = self.pageView.frame.size.height;
    self.pageViewController.view.frame = frame;
    
    UIViewController * startingViewController = [self viewControllerAtIndex:pageIndex];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    
    [self.pageViewController didMoveToParentViewController:self];
    [self startTimer];
}
-(void)createPageControll{
    
    self.pageControl = [[UIPageControl alloc] init];
    CGPoint centerPoint = self.pageControl.center;
    centerPoint.x = self.pageView.frame.size.width/2.0;
    centerPoint.y = self.pageView.frame.size.height - self.pageControl.frame.size.height -10;
    self.pageControl.center = centerPoint;

    self.pageControl.currentPage = 0;
    if(self.pageChangedBlock){
        self.pageChangedBlock(0);
    }
    self.pageControl.numberOfPages = self.totalPages;
    [self.pageControl setDefersCurrentPageDisplay:YES];

    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:237/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:153/255.0 blue:86/255.0 alpha:1];
    [self.view addSubview:self.pageControl];
    self.pageControl.hidden = self.totalPages<2;
}


//**/
-(void)setIsOpenAotuScroll:(BOOL)isOpenAotuScroll{
    _isOpenAotuScroll = isOpenAotuScroll;
    if(!_isOpenAotuScroll){
        [self endTimer];
    }else{
        if(nil == self.timer){
            [self startTimer];
        }
    }
}
#pragma mark 轮播图自动播放
-(void)startTimer{
    if(!self.isOpenAotuScroll){
        return;
    }
    if(self.totalPages<2){
        return;
    }
    if(self.timer){
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
    self.seconds = 0;
}
-(void)endTimer{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)timerHandle{
    if(self.pauseTimerCount){
        self.seconds = 0;
        return;
    }
    self.seconds++;
    if(self.seconds>=self.autoScrollSecconds && !self.isLongPressing){
        [self gotoNextPage];
        self.seconds = 0;
    }
}

/**/

#pragma mark 页面切换
- (void)gotoLastPage{
    NSArray * array = self.pageViewController.viewControllers;
    NSInteger currentPageIndex = [array.firstObject pageIndex];
    NSInteger index = currentPageIndex;
    if(0 == index){
        index = self.totalPages -1;
    }else{
        index -= 1;
    }
    [self gotoPageWithPageIndex:index];
}
- (void)gotoNextPage{
    NSArray * array = self.pageViewController.viewControllers;
    NSInteger currentPageIndex = [array.firstObject pageIndex];
    NSInteger index = currentPageIndex;
    if(self.totalPages-1 == index){
        index = 0;
    }else{
        index += 1;
    }
    [self gotoPageWithPageIndex:index];
    
}
#pragma mark 切换到指定页面
- (void)gotoPageWithPageIndex:(NSInteger)pageIndex{
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    YXImageViewController * contentViewController = [self viewControllerAtIndex:pageIndex];
    [self.pageViewController setViewControllers:@[contentViewController] direction:direction animated:YES completion:NULL];
    self.pageControl.currentPage = pageIndex;
    if(self.pageChangedBlock){
        self.pageChangedBlock(pageIndex);
    }
}

#pragma mark  UIPageViewController数据源与代理方法
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YXImageViewController *)viewController).pageIndex;
    if(0 == index){
        index = self.totalPages -1;
    }else{
        index -= 1;
    }
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YXImageViewController *)viewController).pageIndex;
    if(self.totalPages-1 == index){
        index = 0;
    }else{
        index += 1;
    }
    return [self viewControllerAtIndex:index];
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    NSLog(@"didFinishAnimating");
    if(completed){
        NSArray * array = self.pageViewController.viewControllers;
        NSInteger currentPageIndex = [array.firstObject pageIndex];
        self.pageControl.currentPage = currentPageIndex;
        if(self.pageChangedBlock){
            self.pageChangedBlock(currentPageIndex);
        }
    }
}
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    NSLog(@"willTransitionToViewControllers");
    self.seconds = 0;
}



-(YXImageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    YXImageViewController * pageContentViewController = [[YXImageViewController alloc] init];
    __unsafe_unretained typeof(self) weakSelf = self;
    [pageContentViewController setSingleTapHandle:^(YXImageViewController *imageViewController, UITapGestureRecognizer *tapGesture) {
        if(weakSelf.imageSingleTapHandleBlock){
            weakSelf.imageSingleTapHandleBlock(imageViewController.pageIndex);
        }
    }];
    [pageContentViewController setLongPressHandle:^(YXImageViewController * imageViewController, UILongPressGestureRecognizer*longPressGesture){
        if(longPressGesture.state == UIGestureRecognizerStateBegan){
            weakSelf.isLongPressing = YES;
        }else {
            weakSelf.isLongPressing = NO;
        }
    }];
    [pageContentViewController setDownloadNetImageStartBlock:^(){
        weakSelf.pauseTimerCount = YES;
    }];
    [pageContentViewController setDownloadNetImageFinishBlock:^(){
        weakSelf.pauseTimerCount = NO;
    }];
    
    
    pageContentViewController.size = self.pageView.frame.size;
    pageContentViewController.pageIndex = index;
    if(self.imageOrUrlAtPageIndexBlock){
        id imageOrurl = self.imageOrUrlAtPageIndexBlock(index);
        if([imageOrurl isKindOfClass:[UIImage class]]){
            pageContentViewController.image = imageOrurl;
        }else if([imageOrurl isKindOfClass:[NSURL class]]){
            pageContentViewController.url = imageOrurl;
        }
    }else if(self.defaultImageAtPageIndexBlock){
        UIImage * defalultImage = self.defaultImageAtPageIndexBlock(index);
        pageContentViewController.defaultImage = defalultImage;
    }else{
        
    }
    return pageContentViewController;
}
-(void)dealloc{
    [self endTimer];
}
@end
