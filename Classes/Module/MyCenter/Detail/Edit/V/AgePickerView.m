//
//  AgePickerView.m
//  Golvon
//
//  Created by CYL－Mac on 16/4/4.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "AgePickerView.h"

@implementation AgePickerView

- (void)creatAgeview{

    //pickerView蒙版
    self.pickerVBg = [[UIView alloc] init];
    self.pickerVBg.frame = [UIScreen mainScreen].bounds;
    self.pickerVBg.backgroundColor = GPRGBAColor(.2, .2, .2, .5);
    
    //选择器和按钮背景
    self.pickV = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(100), ScreenWidth, 0)];
                  //CGRectMake(WScale(0), HScale(65.47), ScreenWidth, ScreenHeight*0.054)];
    self.pickV.backgroundColor = [UIColor whiteColor];
    
    [self.pickerVBg addSubview:self.pickV];
    
    
    
    
    //添加取消和确定按钮
    self.cancleAgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleAgeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleAgeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancleAgeBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15.0f)];
    self.cancleAgeBtn.frame = CGRectMake(0,ScreenHeight, kWvertical(70), kHvertical(37));
    [self.pickV addSubview:_cancleAgeBtn];
    
    self.sureAgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureAgeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureAgeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sureAgeBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15.0f)];
    self.sureAgeBtn.frame = CGRectMake(ScreenWidth -kWvertical(70),ScreenHeight, kWvertical(70), kHvertical(37));
    
    [self.pickV addSubview:_sureAgeBtn];
    self.Agetitle = [[UILabel alloc] init];
    self.Agetitle.text = @"选择年龄段";
    self.Agetitle.font = [UIFont systemFontOfSize:kHorizontal(13.0f)];
    self.Agetitle.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight*0.018);
    self.Agetitle.textAlignment = NSTextAlignmentCenter;
    [self.pickV addSubview:self.Agetitle];
    

}

@end
