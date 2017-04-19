//
//  PoleNumber.h
//  Golvon
//
//  Created by CYL－Mac on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoleNumber : UIPickerView
/** pickerView的和按钮背景*/
@property (nonatomic,strong)UIView * pickV2;

/** pickerView的背景*/
@property (nonatomic,strong)UIView * pickerVBg2;
/** 取消按钮*/
@property (nonatomic,strong)UIButton * canclePoleBtn;
/** 确定按钮*/
@property (nonatomic,strong)UIButton * surePoleBtn;
/** 标题*/
@property (nonatomic,strong)UILabel  * Poletitle;


- (void)creatPoleNumber;
@end
