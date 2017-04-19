//
//  NewDetailPhotoAblumCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/6/3.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "NewDetailPhotoAblumCell.h"

@implementation NewDetailPhotoAblumCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WScale(3.5), HScale(2.1), WScale(5.9), HScale(2.4))];
    label.text = @"相册";
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [self.contentView addSubview:label];
    [label sizeToFit];
    
    _photoNum = [[UILabel alloc]initWithFrame:CGRectMake(WScale(3.5), HScale(4.2), WScale(6.5), HScale(4.5))];
    _photoNum.textAlignment = NSTextAlignmentCenter;
    _photoNum.textColor = [UIColor blackColor];
    _photoNum.font = [UIFont systemFontOfSize:kHorizontal(22)];
    [self.contentView addSubview:_photoNum];
    
    _photoImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - WScale(22.1), HScale(1.2), WScale(14.9), HScale(8.4))];
    [self.contentView addSubview:_photoImage1];
    
    _photoImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - WScale(39.1), HScale(1.2), WScale(14.9), HScale(8.4))];
    [self.contentView addSubview:_photoImage2];
    
    _photoImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - WScale(56.1), HScale(1.2), WScale(14.9), HScale(8.4))];
    [self.contentView addSubview:_photoImage3];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    line.backgroundColor = GPColor(243, 243, 243);
    [self.contentView addSubview:line];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, (ScreenHeight - HScale(66.4))/3,ScreenWidth, 0.5)];
    line1.backgroundColor = GPColor(243, 243, 243);
    [self.contentView addSubview:line1];
}



@end
