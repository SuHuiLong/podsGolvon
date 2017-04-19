//
//  Edit_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Edit_TableViewCell.h"

@implementation Edit_TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{

    _parameter = [[UILabel alloc]initWithFrame:CGRectMake(WScale(5.9), HScale(3.4), ScreenWidth * 0.100, ScreenHeight * 0.025)];
    [self.contentView addSubview:_parameter];
    
    _target = [[UITextField alloc]initWithFrame:CGRectMake(WScale(50), HScale(3.4), ScreenWidth * 0.46, ScreenHeight * 0.025)];
    _target.userInteractionEnabled = NO;
    [self.contentView addSubview:_target];
    
    UIImageView *linView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HScale(9.6) - 1, ScreenWidth, 1)];
    linView.backgroundColor = GPColor(229, 230, 231);
    [self.contentView addSubview:linView];
    
}

-(void)relayoutDataWithParameter:(NSString *)parameter WithPlaceHold:(NSString *)place WithTarget:(NSString *)target{
    _parameter.text = parameter;
    _parameter.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _parameter.textColor = deepColor;
    
    _target.placeholder = place;
    _target.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _target.text = target;
    _target.textColor = deepColor;
    _target.textAlignment = NSTextAlignmentRight;
    
}

//-(void)iconImage:(NSString *)iconName iconImage:(NSString *)iconName2 iconImage:(NSString *)iconNam3  type:(NSString *)type selectIndexName:(NSString *)name{
//
//        _parameter.textColor = deepColor;
//        _target.textColor = deepColor;
//
//}




@end
