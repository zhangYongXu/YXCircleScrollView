//
//  YXCircleScrollView.h
//  YXebookReader
//
//  Created by BZBY on 15/12/4.
//  Copyright (c) 2015年 BZBY. All rights reserved.
//
#import <UIKit/UIKit.h>


@class YXCircleScrollImageViewController;
typedef void (^ImageSingleTapHandleBlock)(NSInteger pageIndex);
typedef NSInteger(^TotalPagesBlock)(YXCircleScrollImageViewController * viewController);
typedef id(^ImageOrUrlAtPageIndexBlock)(NSInteger pageIndex);
typedef UIImage*(^DefaultImageAtPageIndexBlock)(NSInteger pageIndex);
typedef void (^PageChangedBlock)(NSInteger pageIndex);

@interface YXCircleScrollImageViewController : UIViewController

@property (assign,nonatomic) CGRect frame;
@property (assign,nonatomic) CGFloat pageControllBottom;
@property (strong,nonatomic) UIView * customBottomView;


@property (copy,nonatomic) ImageSingleTapHandleBlock imageSingleTapHandleBlock;
@property (copy,nonatomic) TotalPagesBlock totalPagesBlock;
@property (copy,nonatomic) ImageOrUrlAtPageIndexBlock imageOrUrlAtPageIndexBlock;
@property (copy,nonatomic) DefaultImageAtPageIndexBlock defaultImageAtPageIndexBlock;
@property (copy,nonatomic) PageChangedBlock pageChangedBlock;


@property (assign,nonatomic) BOOL isOpenAotuScroll;
@property (assign,nonatomic) NSInteger autoScrollSecconds;

@property (strong,nonatomic) UIColor * pageIndicatorTintColor;
@property (strong,nonatomic) UIColor * currentPageIndicatorTintColor;


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
- (instancetype)initWithTotalPages:(TotalPagesBlock)totalPages ImageOrUrlAtPageIndex:(ImageOrUrlAtPageIndexBlock)imageOrUrlAtPageIndex DefaultImageAtPageIndexBlock:(DefaultImageAtPageIndexBlock)defaultImageAtPageIndex ImageSingleTapHandleBlock:(ImageSingleTapHandleBlock)imageSingleTapHandle;

/**
 *  刷新数据
 */
-(void)reloadData;
@end


