//
//  ViewTableViewCell.m
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "ViewTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _ReadNum = [[UILabel alloc] initWithFrame:CGRectMake(0, HScale(10.1), ScreenWidth, HScale(4.7))];
    _ReadNum.textColor = [UIColor lightGrayColor];
    _ReadNum.font = [UIFont systemFontOfSize:kHorizontal(14.f)];
    _ReadNum.textAlignment = NSTextAlignmentCenter;
    ;
    [self.contentView addSubview:_ReadNum];
    
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _ReadBtn = [[UIButton alloc]initWithFrame:CGRectMake(WScale(44), HScale(2.5), ScreenWidth * 0.12, ScreenHeight * 0.067)];
    [_ReadBtn setImage:[UIImage imageNamed:@"阅读"] forState:UIControlStateNormal];
    [_ReadBtn addTarget:self action:@selector(ReadBtnClick:) forControlEvents:UIControlEventTouchDragInside];
//    [self.contentView addSubview:_ReadBtn];
    
}

-(void)ReadBtnClick:(id)sender{


}

@end
