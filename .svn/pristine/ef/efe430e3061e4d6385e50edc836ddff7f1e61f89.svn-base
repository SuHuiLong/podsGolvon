//
//  LPPeriscommentCell.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPeriscommentMark.h"
#import "LPPeriscommentUtils.h"

NS_ASSUME_NONNULL_BEGIN
@interface LPPeriscommentCell : UIView

- (instancetype)initWithFrame:(CGRect)frame
                         name:(NSString *)name
                      comment:(NSString *)comment
                 profileImage:(UIImage *)profileImage;

- (instancetype)initWithFrame:(CGRect)frame
                         name:(NSString *)name
                      comment:(NSString *)comment
                 profileImage:(UIImage *)profileImage
                       config:(LPPeriscommentConfig *)config;

@end

@interface LPPeriscommentLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame
                         font:(LPTPeriscommentFont *)commentfont
               allowLineBreak:(BOOL)allow
                     maxWidth:(CGFloat)maxWidth;

@property (nonatomic, assign) BOOL allowLineBreak;
@property (nonatomic, assign, readonly) CGFloat maxCommentWidth;


@end
NS_ASSUME_NONNULL_END

