//
//  YXCircleScrollViewController.m
//  YXebookReader
//
//  Created by BZBY on 15/12/4.
//  Copyright (c) 2015年 BZBY. All rights reserved.
//

#import "YXImageViewController.h"

#import "UIImageView+YXCacheURL.h"
@interface YXImageViewController ()

@property (strong,nonatomic) UILabel * downloadTipLabel;

@end

@implementation YXImageViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self createImageView];
    [self addGesture];
    [self createDownloadTipLabel];
    [self refreshUI];
}


-(void)initData{
    
}
-(void)initUI{
    CGFloat ZYX_SCREEN_WIDTH = [[UIScreen mainScreen] bounds].size.width;
    CGFloat ZYX_SCREEN_HEIGHT = [[UIScreen mainScreen] bounds].size.height;

    CGRect frame = self.view.frame;
    if(CGSizeEqualToSize(self.size, CGSizeZero)){
        frame.size.width = ZYX_SCREEN_WIDTH;
        frame.size.height = ZYX_SCREEN_HEIGHT;
    }else{
        frame.size.width = self.size.width;
        frame.size.height = self.size.height;
    }
    self.view.frame = frame;
}
-(void)refreshUI{
    if(self.image){
        self.imageView.image = self.image;
        self.downloadTipLabel.hidden = YES;
    }else if(self.url){

        UIImage *cacheImage  = [UIImageView yx_getCacheImageWithUrl:self.url];
        if(cacheImage){
            self.imageView.image = cacheImage;
            self.downloadTipLabel.hidden = YES;
        }else{
            self.downloadTipLabel.text = @"图片正在载入...";
            self.downloadTipLabel.hidden = NO;
            __weak typeof (self) weakSelf = self;
            if(self.downloadNetImageStartBlock){
                self.downloadNetImageStartBlock();
            }

            [self.imageView yx_setImageWithUrl:self.url placeholderImage:self.defaultImage ImageDownloadComplete:^(UIImage *image) {
                if(image){
                    weakSelf.downloadTipLabel.hidden = YES;
                }else{
                    if(!weakSelf.defaultImage){
                        weakSelf.downloadTipLabel.text = @"图片载入失败";
                    }
                }
                if(weakSelf.downloadNetImageFinishBlock){
                    weakSelf.downloadNetImageFinishBlock();
                }
            }];
        }
    }else{
        if(!self.imageView.image){
            NSLog(@"你没有给ImageView 设置图片");
        }
    }
    
}

-(void)addGesture{
    UITapGestureRecognizer * singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGesture];
    
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    [self.view addGestureRecognizer:longPressGesture];
}
-(void)singleTapHandle:(UITapGestureRecognizer *)tapGesture{
    if(self.singleTapHandle){
        self.singleTapHandle(self,tapGesture);
    }
}
-(void)longPressHandle:(UILongPressGestureRecognizer*)longPressGesture{
    if(self.longPressHandle){
        self.longPressHandle(self,longPressGesture);
    }
}
-(void)createImageView{
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
}
-(void)createDownloadTipLabel{
    self.downloadTipLabel = [[UILabel alloc] init];
    self.downloadTipLabel.font = [UIFont systemFontOfSize:14];
    CGRect frame = self.downloadTipLabel.frame;
    frame.size.width = 300;
    frame.size.height = 50;
    
    self.downloadTipLabel.frame = frame;
    self.downloadTipLabel.center = self.imageView.center;
    
    self.downloadTipLabel.textAlignment =  NSTextAlignmentCenter;
    [self.view addSubview:self.downloadTipLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
