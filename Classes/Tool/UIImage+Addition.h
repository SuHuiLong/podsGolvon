//
//  UIImage+Addition.h
//  BytalkApp
//
//  Created by zhihuiguan on 13-4-10.
//  Copyright (c) 2013年 zhihuiguan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)
// 自定长宽缩放
+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size;

//生成图片缩略图
+ (void)createPreviewImage:(NSString *)orgImagePath;
+ (void)createPreviewImageScaleToSize:(NSString *)orgImagePath;
+ (void)createPreviewImageForVideo:(NSString *)orgImagePath videoPath:(NSString *)vPath;
// 保存PNG到Caches下
+(void)savePNGImage:(UIImage *)image toCachesWithName:(NSString *) fileName;
//从caches文件夹下获取路径
+(NSString *)getPNGImageFilePathFromCache:(NSString *)fileName;
-(UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end
