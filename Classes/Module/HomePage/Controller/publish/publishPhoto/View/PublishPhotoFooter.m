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
    UIView *line = [Factory createViewWithBackgroundColor:GPColor(223, 223, 223) frame:CGRectMake(kWvertical(21), kHvertical(26), ScreenWidth - kWvertical(42), 1)];
    
    [self addSubview:line];
    
    UIImageView *locationView =[Factory createImageViewWithFrame:CGRectMake(kWvertical(5.5), line.frame.origin.y + 1 +kHvertical(16), kWvertical(12), kHvertical(16)) Image:[UIImage imageNamed:@"PublishLocation"]];
    [self addSubview:locationView];
    
    _loactionLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(27), line.frame.origin.y + 1 + kHvertical(17), ScreenWidth - kWvertical(50), kHvertical(15)) textColor:BlackColor fontSize:kHorizontal(14) Title:@"所在位置"];
    
    [self addSubview:_loactionLabel];
    
    UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth - kWvertical(14), line.frame.origin.y + 1 + kHvertical(17), kWvertical(7), kHvertical(11.5)) Image:[UIImage imageNamed:@"PublishArrow"]];
    [self addSubview:arrowView];
}

@end
