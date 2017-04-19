//
//  ShlTextView.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ShlTextView.h"

@implementation ShlTextView


- (instancetype)init
{
    self = [super init];
    @synchronized (self) {
        if (self) {
            [self createView];
        }
    }
    return self;
}


-(void)createView{
    self.textContainerInset = UIEdgeInsetsMake(kWvertical(3), 0, 0, 0);
    _placeLabel = [[UILabel alloc] init];
    _placeLabel.userInteractionEnabled = NO;//lable必须设置为不可用
    _placeLabel.backgroundColor = [UIColor clearColor];
    _placeLabel.textColor = LightGrayColor;
    [self addSubview:_placeLabel];
}

-(void)setPlaceLableFrame:(CGRect)frame{
    _placeLabel.frame = frame;
    _placeLabel.text = _placeStr;
}

-(void)textViewDidChange:(NSString *)str{
    if (str.length == 0) {
        _placeLabel.text = _placeStr;
    }else{
        _placeLabel.text = @"";
        }

}

@end
