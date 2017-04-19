//
//  UIImageView+WebImage.m
//  IGWebViewTest
//
//  Created by Steven on 16/9/6.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation UIImageView (WebImage)
@dynamic imageURLString;

-(void)setImageURLString:(NSString *)imageURLString{
    // imageView_placeholer
    [self sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"动态等待图"] options:SDWebImageRetryFailed|SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk) { // 如果还没将图片添加到缓存中才渐变替换图片, 否则直接替换.
            [UIView transitionWithView:self duration:.25f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.image = image;
            } completion:nil];
        } else {
            self.image = image;
        }
    }];

}

-(void)setCardImageStr:(NSString *)cardImageStr{
    [self sd_setImageWithURL:[NSURL URLWithString:cardImageStr] placeholderImage:[UIImage imageNamed:@"动态等待图"] options:SDWebImageRetryFailed | SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk) {
            [UIView transitionWithView:self duration:.25f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.image = image;
            } completion:nil];
        }else{
            self.image = image;
        }
    }];
}

-(void)setFindImageStr:(NSString *)findImageStr{
    [self sd_setImageWithURL:[NSURL URLWithString:findImageStr] placeholderImage:[UIImage imageNamed:@"发现专访默认图"] options:SDWebImageRetryFailed | SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk) {
            [UIView transitionWithView:self duration:.25f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.image = image;
            } completion:nil];
        }else{
            self.image = image;
        }
    }];
}
@end


@implementation UIButton (IGWebImage)

/*! @brief 根据按钮状态设置按钮web图片 */
- (void)setImageWithURLString:(NSString *)urlString forState:(UIControlState)state {
    [self sd_setImageWithURL:[NSURL URLWithString:[urlString copy]] forState:state placeholderImage:[UIImage imageNamed:@"image_placeholer"] options:SDWebImageRetryFailed|SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk) { // 如果还没将图片添加到缓存中才渐变替换图片, 否则直接替换.
            [UIView transitionWithView:self duration:.25f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [self setImage:image forState:state];
            } completion:nil];
        } else {
            [self setImage:image forState:state];
        }
    }];
}

@end

