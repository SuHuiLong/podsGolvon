//
//  LPPeriscommentUtils.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "LPPeriscommentUtils.h"

@implementation LPPeriscommentUtils


+ (UIColor *)colorGenerator {
    
    UIColor *red = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *pink = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *purple = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIColor *blue = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    UIColor *green = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    UIColor *yellow = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIColor *orange = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    
    NSArray *colors = @[red, pink, purple, blue, green, yellow, orange];
    uint32_t index = arc4random_uniform((uint32_t)colors.count);
    
    return colors[(NSInteger)index];
}

@end


@implementation LPPeriscommentConfig

- (instancetype)init {
    if (self = [super init]) {
        _disappearDuration = 6.0;
        _appearDuration = 1.0;
        _layout = [[LPPeriscommentLayout alloc] init];
        _commentFont = [[LPTPeriscommentFont alloc] initWithFont:[UIFont systemFontOfSize:14]
                                                          color:[UIColor blackColor]];
        _nameFont = [[LPTPeriscommentFont alloc] initWithFont:[UIFont systemFontOfSize:12]
                                                       color:[UIColor lightGrayColor]];
    }
    return self;
}

@end

@implementation LPPeriscommentLayout

- (instancetype)init {
    if (self = [super init]) {
        _offset = 10.0;
        _padding = 2.5;
        _commentSpace = 1.5;
        _cellSpace = 4.0;
        _maximumWidth = 200.0;
        _markWidth = 40.0;
        _allowLineBreak = YES;
        _backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (CGFloat)prepareCommentMaxWidth {
    return self.maximumWidth - (self.padding * 2 + self.markWidth + self.offset);
}

@end


@implementation LPTPeriscommentFont

- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color {
    if (self = [super init]) {
        _color = color;
        _font = font;
    }
    return self;
}

@end

