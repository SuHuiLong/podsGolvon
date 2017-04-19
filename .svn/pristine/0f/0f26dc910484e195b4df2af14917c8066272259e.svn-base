//
//  UIImage+Addition.m
//  BytalkApp
//
//  Created by zhihuiguan on 13-4-10.
//  Copyright (c) 2013年 zhihuiguan. All rights reserved.
//

#import "UIImage+Addition.h"
#define PREVIEW_IMAGE_HEIGHT 46.0
#define PREVIEW_IMAGE_WIDTH 60.0
#define MAX_WIDTH_OF_LITTLE_IMAGE       80.0  // 图片缩略图的最大边长.
//CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
//CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
@implementation UIImage (Addition)


// 自定长宽缩放
+(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


+ (void)createPreviewImageScaleToSize:(NSString *)orgImagePath{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize size = CGSizeMake(PREVIEW_IMAGE_WIDTH, PREVIEW_IMAGE_HEIGHT);
    // 原始图片
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:orgImagePath];
    
    if (image.size.width>image.size.height) {
        size = CGSizeMake(100.0, 80.0);
    }
    
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 缩略图的名称： 在现有的图片后面，加.png
    NSString *previewImgPath = [orgImagePath stringByAppendingString:@".png"];
    
    // 保存之。
    [UIImageJPEGRepresentation(scaledImage, 0.75) writeToFile:previewImgPath atomically:YES];

}

+ (void)createPreviewImage:(NSString *)orgImagePath{
    // 缩略图的名称： 在现有的图片后面，加.png
    NSString *previewImgPath = [orgImagePath stringByAppendingString:@".png"];
    
    // 原始图片
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:orgImagePath];
    
    // 原始的大小
    int imgHeight = CGImageGetHeight(image.CGImage);
    int imgWidth = CGImageGetWidth(image.CGImage);
    
    
    CGSize tgtSize = CGSizeZero;
    
    if (imgHeight < MAX_WIDTH_OF_LITTLE_IMAGE && imgWidth < MAX_WIDTH_OF_LITTLE_IMAGE) {
        // 如果图片的边长小于 最大边长, 显示图片的实际大小.
        [UIImagePNGRepresentation(image) writeToFile:previewImgPath atomically:YES];
        switch (image.imageOrientation) {
            case UIImageOrientationUp:
            case UIImageOrientationDown:
                tgtSize = CGSizeMake(imgWidth, imgHeight);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                tgtSize = CGSizeMake(imgHeight , imgWidth);
                break;
            default:
                break;
        }
    }else{
        // 以长边为准,算出图片缩小的倍率
        float resizeRate = MAX(imgHeight, imgWidth) / MAX_WIDTH_OF_LITTLE_IMAGE;
        
        switch (image.imageOrientation) {
            case UIImageOrientationUp:
            case UIImageOrientationDown:
                tgtSize = CGSizeMake(imgWidth / resizeRate, imgHeight /resizeRate);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                tgtSize = CGSizeMake(imgHeight /resizeRate, imgWidth / resizeRate);
                break;
            default:
                break;
        }
    }
    
    // 生成缩略图，
    UIImage *imageToShow = [UIImage scaleToSize:image size:tgtSize];
    
    // 保存之。
    [UIImageJPEGRepresentation(imageToShow, 0.75) writeToFile:previewImgPath atomically:YES];
    //[UIImagePNGRepresentation(imageToShow) writeToFile:previewImgPath atomically:YES];
}

+ (void)createPreviewImageForVideo:(NSString *)orgImagePath videoPath:(NSString *)vPath{
    // 缩略图的名称： 在现有的图片后面，加.png
    NSString *previewImgPath = [vPath stringByAppendingString:@".png"];
    
    // 原始图片
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:orgImagePath];
    
    // 原始的大小
    NSInteger imgHeight = CGImageGetHeight(image.CGImage);
    NSInteger imgWidth = CGImageGetWidth(image.CGImage);
    
    
    CGSize tgtSize = CGSizeZero;
    
    if (imgHeight < MAX_WIDTH_OF_LITTLE_IMAGE && imgWidth < MAX_WIDTH_OF_LITTLE_IMAGE) {
        // 如果图片的边长小于 最大边长, 显示图片的实际大小.
        [UIImagePNGRepresentation(image) writeToFile:previewImgPath atomically:YES];
        switch (image.imageOrientation) {
            case UIImageOrientationUp:
            case UIImageOrientationDown:
                tgtSize = CGSizeMake(imgWidth, imgHeight);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                tgtSize = CGSizeMake(imgHeight , imgWidth);
                break;
            default:
                break;
        }
    }else{
        // 以长边为准,算出图片缩小的倍率
        float resizeRate = MAX(imgHeight, imgWidth) / MAX_WIDTH_OF_LITTLE_IMAGE;
        
        switch (image.imageOrientation) {
            case UIImageOrientationUp:
            case UIImageOrientationDown:
                tgtSize = CGSizeMake(imgWidth / resizeRate, imgHeight /resizeRate);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                tgtSize = CGSizeMake(imgHeight /resizeRate, imgWidth / resizeRate);
                break;
            default:
                break;
        }
    }
    
    // 生成缩略图，
    UIImage *imageToShow = [UIImage scaleToSize:image size:tgtSize];
    
    // 保存之。
    [UIImageJPEGRepresentation(imageToShow, 0.75) writeToFile:previewImgPath atomically:YES];
    //[UIImagePNGRepresentation(imageToShow) writeToFile:previewImgPath atomically:YES];

}

// 保存PNG到Caches下
+(void)savePNGImage:(UIImage *)image toCachesWithName:(NSString *) fileName{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]
                      stringByAppendingPathComponent:fileName];
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    NSLog(@"%@",path);
}

+(NSString *)getPNGImageFilePathFromCache:(NSString *)fileName
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]
                      stringByAppendingPathComponent:fileName];
    return path;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;

    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
@end
