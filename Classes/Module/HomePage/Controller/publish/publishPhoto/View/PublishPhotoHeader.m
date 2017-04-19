//
//  PublishPhotoHeader.m
//  podsGolvon
//
//  Created by suhuilong on 16/9/12.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublishPhotoHeader.h"

@implementation PublishPhotoHeader
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            [self createView];
        }
    }
    return self;
}

-(void)createView{
    _textView = [[ShlTextView alloc] init];
    _textView.tag = 101;
    _textView.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _textView.frame = CGRectMake(kWvertical(10), kHvertical(9.5), ScreenWidth - kWvertical(20), kHvertical(55));
    _textView.placeStr = @"这一刻你的想法...";
    CGRect rect = CGRectMake(kWvertical(8), 0, ScreenWidth*2/3, 20);
    _textView.placeLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_textView setPlaceLableFrame:rect];
    [self addSubview:_textView];
    
}


@end
