//
//  YXCircleScrollImageView.m
//  YXebookReader
//
//  Created by BZBY on 15/12/8.
//  Copyright (c) 2015年 BZBY. All rights reserved.
//

#import "YXCircleScrollImageView.h"
#import "YXCircleScrollImageViewController.h"
@interface YXCircleScrollImageView()
@property (strong,nonatomic) YXCircleScrollImageViewController * circleScrollView;
@end
@implementation YXCircleScrollImageView
-(CGFloat)pageControllBottom{
    return self.circleScrollView.pageControllBottom;
}
-(void)setPageControllBottom:(CGFloat)pageControllBottom{
    self.circleScrollView.pageControllBottom = pageControllBottom;
}
-(void)setCustomBottomView:(UIView *)customBottomView{
    self.circleScrollView.customBottomView = customBottomView;
}
-(UIView *)customBottomView{
    return self.circleScrollView.customBottomView;
}
-(void)setIsAotuScrollImage:(BOOL)isAotuScrollImage{
    self.circleScrollView.isOpenAotuScroll = isAotuScrollImage;
}
-(BOOL)isAotuScrollImage{
    return self.circleScrollView.isOpenAotuScroll;
}

-(void)setAutoScrollSeconds:(NSInteger)autoScrollSeconds{
    if(autoScrollSeconds>0){
        self.circleScrollView.autoScrollSecconds = autoScrollSeconds;
    }
}
-(NSInteger)autoScrollSeconds{
    return self.circleScrollView.autoScrollSecconds;
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    self.circleScrollView.pageIndicatorTintColor = pageIndicatorTintColor;
}
-(UIColor *)pageIndicatorTintColor{
    return self.circleScrollView.pageIndicatorTintColor;
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    self.circleScrollView.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
-(UIColor *)currentPageIndicatorTintColor{
    return self.circleScrollView.currentPageIndicatorTintColor;
}

/**
 *  实例化图片轮播滚动视图
 *
 *  @param frame                    frame
 *  @param imageNumberBlock         图片数量
 *  @param ImageOrUrlAtIndexBlock   每一个图片或url
 *  @param imageDefaultAtIndexBlock 默认图片
 *  @param singleTapHandleBlock     图片点击回调
 *
 *  @return 图片轮播滚动视图
 */
+(instancetype)circleScrollImageViewWithFrame:(CGRect)frame ImageNumber:(ImageNumberBlock)imageNumberBlock ImageOrUrlAtIndex:(ImageOrUrlAtIndexBlock)ImageOrUrlAtIndexBlock ImageDefaultAtIndex:(ImageDefaultAtIndexBlock)imageDefaultAtIndexBlock SingleTapHandle:(SingleTapHandleBlock)singleTapHandleBlock{
    YXCircleScrollImageView * view = [[YXCircleScrollImageView alloc] initWithFrame:frame];
    view.imageNumber = imageNumberBlock;
    view.imageOrUrlAtIndex = ImageOrUrlAtIndexBlock;
    view.imageDefaultAtIndex = imageDefaultAtIndexBlock;
    view.singleTapHandle = singleTapHandleBlock;
    [view createCircleScrollImageViewController];
    return view;
}
/**
 *  刷新数据
 */
-(void)reloadData{
    [self.circleScrollView reloadData];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
    [self initUI];
}

-(void)initData{
    
}
-(void)initUI{
    
}
/**
 *  创建轮播滚动视图控制器
 */
-(void)createCircleScrollImageViewController{
    if(self.circleScrollView){
        return;
    }
    self.circleScrollView = [[YXCircleScrollImageViewController alloc] initWithTotalPages:^NSInteger(YXCircleScrollImageViewController *viewController) {
        NSInteger number = 0;
        if(self.imageNumber){
            number = self.imageNumber(self);
        }
        return number;
    } ImageOrUrlAtPageIndex:^id(NSInteger pageIndex) {
        id imageOrUrl = nil;
        if(self.imageOrUrlAtIndex){
            imageOrUrl = self.imageOrUrlAtIndex(pageIndex);
        }
        return imageOrUrl;
    } DefaultImageAtPageIndexBlock:^UIImage *(NSInteger pageIndex) {
        UIImage * image = nil;
        if(self.imageDefaultAtIndex){
            image = self.imageDefaultAtIndex(pageIndex);
        }
        return image;
    } ImageSingleTapHandleBlock:^(NSInteger pageIndex) {
        if(self.singleTapHandle){
            self.singleTapHandle(pageIndex);
        }
    }];
    __unsafe_unretained typeof(self) weakSelf = self;
    self.circleScrollView.pageChangedBlock = ^(NSInteger pageIndex){
        if(weakSelf.imagePageChanged){
            weakSelf.imagePageChanged(pageIndex);
        }
    };
    self.circleScrollView.frame = self.bounds;
    [self addSubview:self.circleScrollView.view];
}

@end
