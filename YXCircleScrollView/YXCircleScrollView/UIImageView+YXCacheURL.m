//
//  UIImageView+YXCacheURL.m
//  ZYXImageCircleScrollView
//
//  Created by 极客天地 on 2017/5/11.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "UIImageView+YXCacheURL.h"

#import <CommonCrypto/CommonDigest.h>


#define YX_STR_IS_NIL(key) (([@"<null>" isEqualToString:(key)] || [@"" isEqualToString:(key)] || key == nil || [key isKindOfClass:[NSNull class]]) ? 1: 0)

@implementation UIImageView (YXCacheURL)
-(void)yx_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder ImageDownloadComplete:(YXImageDownloadComplete)imageDownloadComplete{
    UIImage * cacheImage = [UIImageView getNetImageWithUrlString:url.absoluteString];
    if(cacheImage){
        self.image = cacheImage;
        if(imageDownloadComplete){
            imageDownloadComplete(cacheImage);
        }
        return;
    }
    
    self.image = placeholder;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:20];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        UIImage * image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(nil == data || nil == image){
                self.image = placeholder;
            }else{
                self.image = image;
            }
            if(imageDownloadComplete){
                imageDownloadComplete(image);
            }
        });
        if(image){
            [UIImageView cacheNetImage:image WithUrlString:url.absoluteString];
        }
    });
}

//缓存图片
+(void)cacheNetImage:(UIImage*)image WithUrlString:(NSString*)urlString{
    
    if(YX_STR_IS_NIL(urlString)){
        return;
    }
    if(!image){
        return;
    }
    NSString * imageFileName = [[self md5StringWithOringalString:urlString] stringByAppendingString:@".png"];
    NSString * imageFilePath = [self getNetImageCacheDir];
    imageFilePath = [imageFilePath stringByAppendingPathComponent:imageFileName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UIImagePNGRepresentation(image) writeToFile:imageFilePath atomically:YES];
    });
    
}
+(UIImage*)yx_getCacheImageWithUrl:(NSURL*)url{
    return [self getNetImageWithUrlString:url.absoluteString];
}
+(UIImage*)getNetImageWithUrlString:(NSString*)urlString{
    if(YX_STR_IS_NIL(urlString)){
        return nil;
    }
    NSString * imageFileName = [[self md5StringWithOringalString:urlString] stringByAppendingString:@".png"];
    NSString * imageFilePath = [self getNetImageCacheDir];
    imageFilePath = [imageFilePath stringByAppendingPathComponent:imageFileName];
    
    UIImage * image = [UIImage imageWithContentsOfFile:imageFilePath];
    return image;
}
//缓存目录
+(NSString*)getNetImageCacheDir{
    NSString * homeDir = NSHomeDirectory();
    NSString * documents = [homeDir stringByAppendingPathComponent:@"Documents"];
    NSString * dirctoryPath = [documents stringByAppendingPathComponent:@"ZYXCommonImageCache"];
    
    NSFileManager *FM = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL isExist = [FM fileExistsAtPath:dirctoryPath isDirectory:&isDir];
    if(!isExist){
        NSError * error = nil;
        BOOL isSuccess = [FM createDirectoryAtPath:dirctoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(!isSuccess){
            NSLog(@"创建目录失败  getDirctoryInHomeDocumentsWithPath error: %@",error);
        }
    }
    return dirctoryPath;
}
//字符串md5
+(NSString *) md5StringWithOringalString:(NSString*)oringalString
{
    const char *cStr = [oringalString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


@end
