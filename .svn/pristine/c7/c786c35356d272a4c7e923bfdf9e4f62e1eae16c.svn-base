//
//  PoleNumber.m
//  Golvon
//
//  Created by CYL－Mac on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "PoleNumber.h"

@implementation PoleNumber

- (void)creatPoleNumber{
    
    //pickerView蒙版
    self.pickerVBg2 = [[UIView alloc] init];
    self.pickerVBg2.frame = [UIScreen mainScreen].bounds;
    self.pickerVBg2.backgroundColor = GPRGBAColor(.2, .2, .2, .5);
    //选择器和按钮背景
    
    self.pickV2 = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight*0.054)];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickV2.frame =  CGRectMake(0, HScale(65.47), ScreenWidth, ScreenHeight*0.054);
    }];
    self.pickV2.backgroundColor = [UIColor whiteColor];
    
    [self.pickerVBg2 addSubview:self.pickV2];
    //添加取消和确定按钮
    self.canclePoleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.canclePoleBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.canclePoleBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15.0f)];
    [self.canclePoleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.canclePoleBtn.frame = CGRectMake(0,ScreenHeight, kWvertical(70), kHvertical(37));
    
    self.surePoleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.surePoleBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.surePoleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.surePoleBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15.0f)];

    self.surePoleBtn.frame = CGRectMake(ScreenWidth -kWvertical(70),ScreenHeight, kWvertical(70), kHvertical(37));
    
    self.Poletitle = [[UILabel alloc] init];
    self.Poletitle.text = @"选择杆数";
    self.Poletitle.font = [UIFont systemFontOfSize:kHorizontal(13.0f)];
    self.Poletitle.frame = CGRectMake(0, HScale(100), ScreenWidth, ScreenHeight*0.018);
    self.Poletitle.textColor = RGBA(107,107,107,1);
    self.Poletitle.textAlignment = NSTextAlignmentCenter;
    
    [self.pickV2 addSubview:self.Poletitle];
    [self.pickV2 addSubview:_surePoleBtn];
    [self.pickV2 addSubview:_canclePoleBtn];
}

@end
