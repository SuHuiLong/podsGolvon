//
//  ReviewPhotoBrownView.h
//  podsGolvon
//
//  Created by suhuilong on 16/8/30.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol ReviewPhotoBrownViewDelegate <NSObject>
//
////点击图片时，隐藏边框
//-(void)TapHiddenView;

//@end

@interface ReviewPhotoBrownView : UIScrollView
 //添加的图片
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;

/***  图片*/
@property (strong, nonatomic) UIImageView    *beforeView; //之前的图片的位置

//代理
//@property(nonatomic, assign) id<ReviewPhotoBrownViewDelegate>delegate;
//本地照片
-(void)setImage:(UIImage *)image;
//网络照片
-(void)setImageWithUrl:(NSString *)str;


@end
