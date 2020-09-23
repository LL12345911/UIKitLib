//
//  UIImage+ATCompress.m
//  HighwayDoctor
//
//  Created by Mars on 2019/5/21.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "UIImage+ATCompress.h"
//#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <Photos/Photos.h>
#import <CoreImage/CoreImage.h>

@implementation UIImage (ATCompress)
#pragma mark - 压缩图片处理
/// 压缩图片精确至指定Data大小, 只需循环3次, 并且保持图片不失真
- (UIImage*)kj_compressTargetByte:(NSUInteger)maxLength{
    return [UIImage kj_compressImage:self TargetByte:maxLength];
}
/// 压缩图片精确至指定Data大小, 只需循环3次, 并且保持图片不失真
+ (UIImage *)kj_compressImage:(UIImage *)image TargetByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1.;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1,min = 0;
    // 二分法处理
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return resultImage;
}


@end
