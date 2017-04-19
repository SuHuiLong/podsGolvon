//
//  UIImageView+RoundedCorner.m
//  podsGolvon
//
//  Created by MAYING on 2016/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "UIImageView+RoundedCorner.h"

@implementation UIImageView (RoundedCorner)

- (void)addCornerWithRadius:(CGFloat)radius {
    self.image = [self.image imageAddCornerWithRadius:radius andSize:self.bounds.size];
}

@end
