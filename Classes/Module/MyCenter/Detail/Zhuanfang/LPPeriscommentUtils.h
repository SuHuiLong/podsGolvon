//
//  LPPeriscommentUtils.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LPPeriscommentLayout;
@class LPTPeriscommentFont;

@interface LPPeriscommentUtils : NSObject

+ (UIColor *)colorGenerator;

@end


@interface LPPeriscommentConfig : NSObject

@property (nonatomic, strong, readonly) LPPeriscommentLayout *layout;
@property (nonatomic, strong, readonly) LPTPeriscommentFont *commentFont;
@property (nonatomic, strong, readonly) LPTPeriscommentFont *nameFont;
@property (nonatomic, assign, readonly) CGFloat disappearDuration;
@property (nonatomic, assign, readonly) CGFloat appearDuration;


@end

@interface LPPeriscommentLayout : NSObject

@property (nonatomic, assign, readonly) CGFloat offset;
@property (nonatomic, assign, readonly) CGFloat padding;
@property (nonatomic, assign, readonly) CGFloat commentSpace;
@property (nonatomic, assign, readonly) CGFloat cellSpace;
@property (nonatomic, assign, readonly) CGFloat maximumWidth;
@property (nonatomic, assign, readonly) CGFloat markWidth;
@property (nonatomic, assign, readonly) BOOL allowLineBreak;
@property (nonatomic, strong, readonly) UIColor *backgroundColor;

- (CGFloat)prepareCommentMaxWidth;

@end

@interface LPTPeriscommentFont : NSObject

- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color;

@property (nonatomic, strong, readonly) UIFont *font;
@property (nonatomic, strong, readonly) UIColor *color;

@end


NS_ASSUME_NONNULL_END

