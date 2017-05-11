//
//  UIImageView+YXCacheURL.h
//  ZYXImageCircleScrollView
//
//  Created by 极客天地 on 2017/5/11.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^YXImageDownloadComplete)(UIImage* image);
@interface UIImageView (YXCacheURL)
/**
 *  为UIImageView设置网络图片,带缓存
 *
 *  @param url                   图片url
 *  @param placeholder           默认图片
 *  @param imageDownloadComplete 图片下载完成回调
 */
- (void)yx_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder ImageDownloadComplete:(YXImageDownloadComplete)imageDownloadComplete;
/**
 *  根据url获取对应缓存图片
 *
 *  @param url 图片url
 *
 *  @return 图片
 */
+(UIImage*)yx_getCacheImageWithUrl:(NSURL*)url;
@end
