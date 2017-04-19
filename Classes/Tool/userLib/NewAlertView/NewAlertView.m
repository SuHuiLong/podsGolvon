//
//  NewAlertView.m
//  podsGolvon
//
//  Created by suhuilong on 16/9/12.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "NewAlertView.h"

@implementation NewAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            [self createUI];
        }
    }
    return self;
}

-(void)createUI{
    _BackView = [Factory createViewWithBackgroundColor:BlackColor frame:CGRectMake(0, 0, ScreenWidth, kHvertical(64))];
    _BackView.layer.masksToBounds = YES;
    _BackView.layer.cornerRadius = 4.0f;
    _BackView.alpha = 0.7;
    [self addSubview:_BackView];
    
    _contentLabel = [Factory createLabelWithFrame:CGRectMake(0, ScreenHeight/2 - kHvertical(11), ScreenWidth, kHvertical(22)) textColor:RedColor fontSize:kHorizontal(16.0f) Title:@"😅最多选择六张图片"];
}


-(void)setContentWith:(NSString *)str{
    if (str) {
        _contentLabel.text = str;
    }
    [_contentLabel sizeToFit];
    CGFloat lableLength = _contentLabel.frame.size.width;

    _contentLabel.frame = CGRectMake((ScreenWidth-lableLength)/2, ScreenHeight/2 - kHvertical(11), lableLength, kHvertical(22));
    
    _BackView.frame = CGRectMake((ScreenWidth-lableLength - kWvertical(32))/2, 0, lableLength + kWvertical(32), kHvertical(64));
    
}


@end




