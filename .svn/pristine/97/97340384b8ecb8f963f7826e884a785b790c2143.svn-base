//
//  LPPeriscommentView.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "LPPeriscommentView.h"
#import "LPPeriscommentUtils.h"
#import "LPPeriscommentCell.h"

static void lp_release(UIView *view) {
    view = nil;
}

@interface LPPeriscommentView ()

@property (nonatomic, strong) NSMutableArray *visibleCells;
@property (nonatomic, strong) LPPeriscommentConfig *config;

@end

@implementation LPPeriscommentView

- (instancetype)initWithFrame:(CGRect)frame {
    LPPeriscommentConfig *config = [[LPPeriscommentConfig alloc] init];
    return [self initWithFrame:frame config:config];
}

- (instancetype)initWithFrame:(CGRect)frame config:(LPPeriscommentConfig *)config {
    if (self = [super initWithFrame:frame]) {
        self.config = config;
        self.visibleCells = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.config = [[LPPeriscommentConfig alloc] init];
        self.visibleCells = [NSMutableArray array];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.backgroundColor = self.config.layout.backgroundColor;
}

- (void)addCellWithName:(NSString *)name comment:(NSString *)comment profileImage:(UIImage *)profileImage {
    CGRect rect = CGRectZero;
    LPPeriscommentCell *cell = [[LPPeriscommentCell alloc] initWithFrame:rect name:name comment:comment profileImage:profileImage config:self.config];
    [self addCell:cell];
    
}

- (void)addCell:(LPPeriscommentCell *)commentCell {
//    commentCell.frame = CGRectMake(ScreenWidth/2,44 + 80 +commentCell.frame.size.height, commentCell.frame.size.width, commentCell.frame.size.height);
    
    CGFloat comentW = commentCell.frame.size.width;
    CGFloat comentH = commentCell.frame.size.height;
    CGFloat comentX = ScreenWidth-comentW-WScale(1.6);
    CGFloat comentY = 120+comentH;

    
    commentCell.frame = CGRectMake(comentX,comentY,comentW,comentH);
    [self addSubview:commentCell];
    [self.visibleCells addObject:commentCell];
    [self moveCellWithAnimation:commentCell];
    [self hideCellWithAnimatioin:commentCell];
}

- (void)moveCellWithAnimation:(LPPeriscommentCell *)cell {
    [UIView animateWithDuration:self.config.appearDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGFloat dy = cell.frame.size.height + self.config.layout.cellSpace+20;
        for (LPPeriscommentCell *c in self.visibleCells) {
            CGAffineTransform originTransform = c.transform;
            CGAffineTransform newTransform = CGAffineTransformMakeTranslation(0, -dy);
            c.transform = CGAffineTransformConcat(originTransform, newTransform);
        }
    } completion:nil];
}

- (void)hideCellWithAnimatioin:(LPPeriscommentCell *)cell {
    [UIView animateWithDuration:3 delay:self.config.appearDuration options:UIViewAnimationOptionCurveEaseIn animations:^{
        cell.alpha = 0;
    } completion:^(BOOL finished) {
        [cell removeFromSuperview];
        [self.visibleCells removeObject:cell];
        //        tt_release(cell);
    }];
}


@end
