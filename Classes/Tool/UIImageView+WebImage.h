//
//  UIImageView+WebImage.h
//  IGWebViewTest
//
//  Created by Steven on 16/9/6.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIImageView
@interface UIImageView (WebImage)

@property (nonatomic, copy) NSString *imageURLString; ///< 加载网络图片, 赋值图片URL的字符串格式即可.

@property (nonatomic, copy) NSString *findImageStr;//发现等带图

@property (nonatomic, copy) NSString *cardImageStr;//卡片

@end

// UIButton
@interface UIButton (WebImage)

/*! @brief 根据按钮状态设置按钮web图片
 *  @param urlString web图片url字符串
 *  @param state     按钮状态
 */
- (void)setImageWithURLString:(NSString *)urlString forState:(UIControlState)state;

@end
