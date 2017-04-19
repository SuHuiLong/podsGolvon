//
//  PublishPhotoFooter.m
//  podsGolvon
//
//  Created by suhuilong on 16/9/12.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublishPhotoFooter.h"

@implementation PublishPhotoFooter
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
    self.backgroundColor = GPColor(241, 243, 249);

    _backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, ScreenWidth, kHvertical(40))];
    UIView *line = [Factory createViewWithBackgroundColor:GPColor(223, 223, 223) frame:CGRectMake(kWvertical(21), kHvertical(0), ScreenWidth - kWvertical(42), 1)];
    
    [_backView addSubview:line];
    
    UIImageView *locationView =[Factory createImageViewWithFrame:CGRectMake(kWvertical(5.5),(kHvertical(41) - kHvertical(16))/2, kWvertical(12), kHvertical(16)) Image:[UIImage imageNamed:@"PublishLocation"]];
    [_backView addSubview:locationView];
    
    _loactionLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(27), kHvertical(10), ScreenWidth - kWvertical(50), kHvertical(20)) textColor:BlackColor fontSize:kHorizontal(14) Title:@"所在位置"];
    
    [_backView addSubview:_loactionLabel];
    
    UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth - kWvertical(14),( kHvertical(41)-kHvertical(11.5))/2, kWvertical(7), kHvertical(11.5)) Image:[UIImage imageNamed:@"PublishArrow"]];
    [_backView addSubview:arrowView];
    [self addSubview:_backView];
}

@end
