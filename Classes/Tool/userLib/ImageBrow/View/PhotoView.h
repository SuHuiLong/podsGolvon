//
//  PhotoView.h
//  aoyouHH
//
//  Created by jinzelu on 15/4/30.
//  Copyright (c) 2015年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
//1.
@protocol PhotoViewDelegate <NSObject>

//点击图片时，隐藏图片浏览器
-(void)TapHiddenPhotoView;

@end

@interface PhotoView : UIView

/**
 *  添加的图片
 */

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *descLabel;

//2.
/**
 *  代理
 */
@property(nonatomic, assign) id<PhotoViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)photoUrl PhotoDesc:(NSString *)photoDesc;

-(id)initWithFrame:(CGRect)frame withPhotoImage:(UIImage *)image;



@end
