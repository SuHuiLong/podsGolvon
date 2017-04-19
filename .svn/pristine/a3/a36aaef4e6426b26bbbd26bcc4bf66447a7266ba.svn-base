//
//  ImageTool.h
//  SystemFunction
//
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//可以压缩 或者 截屏
@interface ImageTool : NSObject

//返回单例的静态方法
+(ImageTool *)shareTool;

//返回特定尺寸的UImage  ,  image参数为原图片，size为要设定的图片大小
-(UIImage*)resizeImageToSize:(CGSize)size
                 sizeOfImage:(UIImage*)image;

/**
 *  以图片中心为中心裁剪
*/
- (UIImage *)reCenterSizeImage:(UIImage *)image toSize:(CGSize)reSize;


//在指定的视图内进行截屏操作,返回截屏后的图片
-(UIImage *)imageWithScreenContentsInView:(UIView *)view;


-(UIImage *)reFromCenterSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/**
 *  防止图片裁剪后旋转
 *
 *  @param aImage 会旋转的图片
 *
 *  @return 正常的照片
 */
- (UIImage *)fixOrientation:(UIImage *)aImage ;

@end
