//
//  LPPeriscommentMark.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "LPPeriscommentMark.h"
#import "LPPeriscommentUtils.h"

@interface LPPeriscommentMark ()

@property (nonatomic, strong) UIColor *color;

@end

@implementation LPPeriscommentMark

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    if (self = [super initWithFrame:frame]) {
        [self tt_layoutSubviews:image];
    }
    return self;
}

- (void)tt_layoutSubviews:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.backgroundColor = [UIColor redColor];
    imageView.frame = CGRectMake(HScale(0.9), HScale(0.9), WScale(6.4),HScale(3.6));

    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 4.0;

    

    [self addSubview:imageView];
}




@end
