//
//  ViewController.m
//  ZYXImageCircleScrollView
//
//  Created by 极客天地 on 2017/5/10.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "ViewController.h"

#import "YXCircleScrollImageView.h"

#import "NetworkImageCircleBottomView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *localImageCircleView;
@property (weak, nonatomic) IBOutlet UIView *networkImageCircleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCircleScorllImageViewLocal];
    
    [self createCircleScorllImageViewNetwork];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 创建循环滚动轮播图
-(void)createCircleScorllImageViewLocal{
    CGRect frame = CGRectZero;
    frame.size = self.localImageCircleView.frame.size;
    __weak typeof(self) weakSelf = self;
    YXCircleScrollImageView * view = [YXCircleScrollImageView circleScrollImageViewWithFrame:frame ImageNumber:^NSInteger(YXCircleScrollImageView *view) {
        return 6;
    } ImageOrUrlAtIndex:^id(NSInteger index) {
        NSString * imageName = [@"inbar" stringByAppendingFormat:@"%ld_02",index];
        return [UIImage imageNamed:imageName];
    } ImageDefaultAtIndex:^UIImage *(NSInteger index) {
        return nil;
    } SingleTapHandle:^(NSInteger index) {
        [weakSelf localCircleScorllImageViewClickAtIndex:index];
    }];
    view.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:85/255.0 alpha:1];
    [self.localImageCircleView addSubview:view];
}
-(void)localCircleScorllImageViewClickAtIndex:(NSInteger)index{
    
}

-(void)createCircleScorllImageViewNetwork{
    NSArray * urlArray = @[
                           @{@"picUrl":@"http://bmob-cdn-5476.b0.upaiyun.com/2017/05/10/7a07947b40133f3f802d25897636753f.png",@"description":@"送钱啦，哈哈哈"},
                           @{@"picUrl":@"http://bmob-cdn-5476.b0.upaiyun.com/2017/05/10/2237567640ecddfb804bd9e6714537c4.png",@"description":@"所有的故事，嘻嘻"},
                           @{@"picUrl":@"http://bmob-cdn-5476.b0.upaiyun.com/2017/05/10/7020171940d944ed806becbe3fe39437.png",@"description":@"好看不，啦啦"},
                           @{@"picUrl":@"http://bmob-cdn-5476.b0.upaiyun.com/2017/05/10/cff98fbf40722e8780eef9b45662d031.png",@"description":@"乖乖啦。。。。"},
                           @{@"picUrl":@"http://bmob-cdn-5476.b0.upaiyun.com/2017/05/10/7a07947b40133f3f802d25897636753f.png",@"description":@"不知道未来咯咯咯"}
                           ];
    
    CGRect frame = CGRectZero;
    frame.size = self.networkImageCircleView.frame.size;
    __weak typeof(self) weakSelf = self;
    YXCircleScrollImageView * view = [YXCircleScrollImageView circleScrollImageViewWithFrame:frame ImageNumber:^NSInteger(YXCircleScrollImageView *view) {
        NSInteger count = urlArray.count;
        return count;
    } ImageOrUrlAtIndex:^id(NSInteger index) {
        NSDictionary * dict = urlArray[index];
        NSString * urlString = dict[@"picUrl"];
        
        NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL * url = [NSURL URLWithString:encodedString];
        return url;
    } ImageDefaultAtIndex:^UIImage *(NSInteger index) {
        return nil;
    } SingleTapHandle:^(NSInteger index) {
        [weakSelf networkCircleScorllImageViewClickAtIndex:index];
    }];
    view.currentPageIndicatorTintColor = [UIColor colorWithRed:83/255.0 green:255/255.0 blue:85/255.0 alpha:1];
    
    //自定义图片轮播页面提示
    NetworkImageCircleBottomView * bottomView = [NetworkImageCircleBottomView loadFromXib];
    CGRect bframe = bottomView.frame;
    bframe.size.width = view.frame.size.width;
    bottomView.frame = bframe;
    
    NSString * indexStr = [NSString stringWithFormat:@"1/%ld",urlArray.count];
    bottomView.pageIndexLabel.text = indexStr;
    bottomView.titleLabel.text = urlArray[0][@"description"];
    view.imagePageChanged = ^(NSInteger index){
        NSInteger totals = urlArray.count;
        NSString * indexStr = [NSString stringWithFormat:@"%ld/%ld",index+1,totals];
        bottomView.pageIndexLabel.text = indexStr;
        bottomView.titleLabel.text = urlArray[index][@"description"];
    };
    view.customBottomView = bottomView;
    
    
    [self.networkImageCircleView addSubview:view];
}
-(void)networkCircleScorllImageViewClickAtIndex:(NSInteger)index{
    
}
@end
