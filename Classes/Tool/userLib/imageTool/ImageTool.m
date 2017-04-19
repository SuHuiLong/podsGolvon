//
//  ImageTool.m
//  SystemFunction
//
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import "ImageTool.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageTool

static ImageTool *_shareImageTool =nil;
//返回单例的静态方法
+(ImageTool *)shareTool
{
    //确保线程安全
    @synchronized(self){
        //确保只返回一个实例
        if (_shareImageTool == nil) {
            _shareImageTool = [[ImageTool alloc] init];
        }
    }
    return _shareImageTool;
}

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//在指定的视图内进行截屏操作,返回截屏后的图片
-(UIImage *)imageWithScreenContentsInView:(UIView *)view
{
    //根据屏幕大小，获取上下文
    UIGraphicsBeginImageContext([[UIScreen mainScreen] bounds].size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}


-(UIImage*)resizeImageToSize:(CGSize)size
                 sizeOfImage:(UIImage*)image
{

    UIGraphicsBeginImageContext(size);
    //获取上下文内容
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //重绘image
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    //根据指定的size大小得到新的image
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}

- (UIImage *)reCenterSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    
    [image drawInRect:CGRectMake(image.size.width/2, image.size.height/2, reSize.width, reSize.height)];
    
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}


- (UIImage *)reFromCenterSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }else{
        
        UIGraphicsBeginImageContext(reSize);
        
        [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];

//        if (image.size.height<image.size.width) {
//            [image drawInRect:CGRectMake((image.size.width-reSize.width)/2, 0, reSize.width, reSize.height)];
//        }else{
//        [image drawInRect:CGRectMake( 0,(image.size.height-reSize.height)/2, reSize.width, reSize.height)];
//        }
        
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
    
}



- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    
        // No-op if the orientation is already correct
        if (aImage.imageOrientation == UIImageOrientationUp)
            return aImage;
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (aImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            default:
                break;
        }
        
        switch (aImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            default:
                break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                                 CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                                 CGImageGetColorSpace(aImage.CGImage),
                                                 CGImageGetBitmapInfo(aImage.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (aImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                // Grr...
                CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
                break;
        }
        
        // And now we just create a new UIImage from the drawing context
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        UIImage *img = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
        return img;
}

@end
