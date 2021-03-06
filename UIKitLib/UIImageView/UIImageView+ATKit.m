
    //
//  UIImageView+ATKit.m
//  HighwayDoctor
//
//  Created by Mars on 2019/5/23.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "UIImageView+ATKit.h"

//************//
// 画水印
static const CGFloat kFontResizingProportion = 0.42f;

@interface UIImageView (LettersPrivate)

- (UIImage *)imageSnapshotFromText:(NSString *)text backgroundColor:(UIColor *)color circular:(BOOL)isCircular textAttributes:(NSDictionary *)attributes;

@end
//************//


@implementation UIImageView (ATKit)

/**
 UIImageView显示放大后的图片时模糊的问题
 */
- (void)at_EnlargedImageIsBlurry{
    CALayer *layer = self.layer;
    layer.magnificationFilter = @"nearest";
}

//- (void)at_loadImageWithURL:(NSString *)url {
//    
//    UIColor *color = self.backgroundColor;
//    self.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
//    __weak typeof(self) weakSelf = self;
//    
//    CGFloat width = MIN(self.frame.size.width, self.frame.size.height);
//    width = width > 40 ? 40 : 20;
//    
//   __block DMProgressHUD *hud = [[DMProgressHUD alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2.0, (self.frame.size.height-width)/2.0, width, width)];
//    [self addSubview:hud];
//    hud.progress = 0;
//    
//    [self yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    
//       // DebugLog(@"receivedSize %ld,expectedSize %ld",receivedSize,expectedSize);
//        double progress = receivedSize/(expectedSize*1.0);
//        hud.progress = progress;
//        
//    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//        return image;
//
//    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        weakSelf.backgroundColor = color;
//        [hud removeFromSuperview];
//        hud = nil;
//        if (!image) {
//            weakSelf.backgroundColor = [UIColor lightGrayColor];
//            //[HUDTools showText:@"图片加载失败！"];
//        }
//       
//    }];
//}
//
//#pragma mark -
//- (void)at_setImageWithURL:(NSString *)imageURL{
//    @autoreleasepool {
//        NSURL *url = [NSURL URLWithString:imageURL];
//        // 渐进式加载，增加模糊效果和渐变动画
//        [self yy_setImageWithURL:url placeholder:[UIImage imageNamed:@"jiazaizhong"] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//            
//        }];
//    }
//}
//
//
//
//+ (void)at_clearMemory{
//    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
//    //    cache.memoryCache.totalCost;
//    //    cache.memoryCache.totalCount;
//    //    cache.diskCache.totalCost;
//    //    cache.diskCache.totalCount;
//    
//    // clear cache
//    [cache.memoryCache removeAllObjects];
//    [cache.diskCache removeAllObjects];
//    
//    // clear disk cache with progress
//    [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
//        // progress
//    } endBlock:^(BOOL error) {
//        // end
//    }];
//}


/**
 *  @brief  倒影
 */
- (void)reflect {
    CGRect frame = self.frame;
    frame.origin.y += (frame.size.height + 1);
    
    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    self.clipsToBounds = TRUE;
    reflectionImageView.contentMode = self.contentMode;
    [reflectionImageView setImage:self.image];
    reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    CALayer *reflectionLayer = [reflectionImageView layer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.5,0.5);
    gradientLayer.endPoint = CGPointMake(0.5,1.0);
    reflectionLayer.mask = gradientLayer;
    
    [self.superview addSubview:reflectionImageView];
    
}

+ (id)imageViewWithImageNamed:(NSString*)imageName{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

+ (id)imageViewWithFrame:(CGRect)frame{
    return [[UIImageView alloc] initWithFrame:frame];
}

+ (id)imageViewWithStretchableImage:(NSString*)imageName Frame:(CGRect)frame{
    UIImage *image =[UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return imageView;
}

- (void) setImageWithStretchableImage:(NSString*)imageName{
    UIImage *image =[UIImage imageNamed:imageName];
    self.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

+ (id) imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration;{
    if (imageArray && !([imageArray count]>0)){
        return nil;
    }
    UIImageView *imageView = [UIImageView imageViewWithImageNamed:[imageArray objectAtIndex:0]];
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i < imageArray.count; i++){
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        [images addObject:image];
    }
    [imageView setImage:[images objectAtIndex:0]];
    [imageView setAnimationImages:images];
    [imageView setAnimationDuration:duration];
    [imageView setAnimationRepeatCount:0];
    return imageView;
}


#pragma mark -
#pragma mark - 画水印
// 画水印
- (void) setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
        // CGContextRef thisctx = UIGraphicsGetCurrentContext();
        // CGAffineTransform myTr = CGAffineTransformMake(1, 0, 0, -1, 0, self.height);
        // CGContextConcatCTM(thisctx, myTr);
        //CGContextDrawImage(thisctx,CGRectMake(0,0,self.width,self.height),[image CGImage]); //原图
        //CGContextDrawImage(thisctx,rect,[mask CGImage]); //水印图
        //原图
    [image drawInRect:self.bounds];
        //水印图
    [mark drawInRect:rect];
        // NSString *s = @"dfd";
        // [[UIColor redColor] set];
        // [s drawInRect:self.bounds withFont:[UIFont systemFontOfSize:15.0]];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newPic;
}
- (void) setImage:(UIImage *)image withStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
        //原图
    [image drawInRect:self.bounds];
        //文字颜色
    [color set];
        // const CGFloat *colorComponents = CGColorGetComponents([color CGColor]);
        // CGContextSetRGBFillColor(context, colorComponents[0], colorComponents[1], colorComponents [2], colorComponents[3]);
        //水印文字
    if ([markString respondsToSelector:@selector(drawInRect:withAttributes:)]){
        [markString drawInRect:rect withAttributes:@{NSFontAttributeName:font}];
    }else{
            // pre-iOS7.0
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [markString drawInRect:rect withFont:font];
#pragma clang diagnostic pop
    }
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newPic;
}
- (void) setImage:(UIImage *)image withStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0){
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
        //原图
    [image drawInRect:self.bounds];
        //文字颜色
    [color set];
        //水印文字
    
    if ([markString respondsToSelector:@selector(drawAtPoint:withAttributes:)]){
        [markString drawAtPoint:point withAttributes:@{NSFontAttributeName:font}];
    }else{
            // pre-iOS7.0
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [markString drawAtPoint:point withFont:font];
#pragma clang diagnostic pop
    }
    
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newPic;
}






- (void)setImageWithString:(NSString *)string {
    [self setImageWithString:string color:nil circular:NO textAttributes:nil];
}

- (void)setImageWithString:(NSString *)string color:(UIColor *)color {
    [self setImageWithString:string color:color circular:NO textAttributes:nil];
}

- (void)setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular {
    [self setImageWithString:string color:color circular:isCircular textAttributes:nil];
}

- (void)setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular fontName:(NSString *)fontName {
    [self setImageWithString:string color:color circular:isCircular textAttributes:@{
                                                                                     NSFontAttributeName:[self fontForFontName:fontName],
                                                                                     NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                     }];
}

- (void)setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular textAttributes:(NSDictionary *)textAttributes {
    if (!textAttributes) {
        textAttributes = @{
                           NSFontAttributeName: [self fontForFontName:nil],
                           NSForegroundColorAttributeName: [UIColor whiteColor]
                           };
    }
    
    NSMutableString *displayString = [NSMutableString stringWithString:@""];
    
    NSMutableArray *words = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    
    //
    // Get first letter of the first and last word
    //
    if ([words count]) {
        NSString *firstWord = [words firstObject];
        if ([firstWord length]) {
            // Get character range to handle emoji (emojis consist of 2 characters in sequence)
            NSRange firstLetterRange = [firstWord rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)];
            [displayString appendString:[firstWord substringWithRange:firstLetterRange]];
        }
        
        if ([words count] >= 2) {
            NSString *lastWord = [words lastObject];
            
            while ([lastWord length] == 0 && [words count] >= 2) {
                [words removeLastObject];
                lastWord = [words lastObject];
            }
            
            if ([words count] > 1) {
                // Get character range to handle emoji (emojis consist of 2 characters in sequence)
                NSRange lastLetterRange = [lastWord rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)];
                [displayString appendString:[lastWord substringWithRange:lastLetterRange]];
            }
        }
    }
    
    UIColor *backgroundColor = color ? color : [self randomColor];
    
    self.image = [self imageSnapshotFromText:[displayString uppercaseString] backgroundColor:backgroundColor circular:isCircular textAttributes:textAttributes];
}

#pragma mark - Helpers

- (UIFont *)fontForFontName:(NSString *)fontName {
    
    CGFloat fontSize = CGRectGetWidth(self.bounds) * kFontResizingProportion;
    if (fontName) {
        return [UIFont fontWithName:fontName size:fontSize];
    }
    else {
        return [UIFont systemFontOfSize:fontSize];
    }
    
}

- (UIColor *)randomColor {
    
    float red = 0.0;
    while (red < 0.1 || red > 0.84) {
        red = drand48();
    }
    
    float green = 0.0;
    while (green < 0.1 || green > 0.84) {
        green = drand48();
    }
    
    float blue = 0.0;
    while (blue < 0.1 || blue > 0.84) {
        blue = drand48();
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (UIImage *)imageSnapshotFromText:(NSString *)text backgroundColor:(UIColor *)color circular:(BOOL)isCircular textAttributes:(NSDictionary *)textAttributes {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize size = self.bounds.size;
    if (self.contentMode == UIViewContentModeScaleToFill ||
        self.contentMode == UIViewContentModeScaleAspectFill ||
        self.contentMode == UIViewContentModeScaleAspectFit ||
        self.contentMode == UIViewContentModeRedraw)
    {
        size.width = floorf(size.width * scale) / scale;
        size.height = floorf(size.height * scale) / scale;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (isCircular) {
        //
        // Clip context to a circle
        //
        CGPathRef path = CGPathCreateWithEllipseInRect(self.bounds, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    //
    // Fill background of context
    //
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    //
    // Draw text in the context
    //
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    CGRect bounds = self.bounds;
    
    [text drawInRect:CGRectMake(bounds.size.width/2 - textSize.width/2,
                                bounds.size.height/2 - textSize.height/2,
                                textSize.width,
                                textSize.height)
      withAttributes:textAttributes];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}
@end
