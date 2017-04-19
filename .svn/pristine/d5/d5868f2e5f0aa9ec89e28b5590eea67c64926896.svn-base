//
//  BallParkTableViewCell.m
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/17.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "BallParkTableViewCell.h"


@implementation BallParkTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    _Backview = [[UIView alloc]initWithFrame:CGRectMake(WScale(2.9)-0.5, HScale(1.5)-0.5, WScale(7.7)+1, HScale(4.3)+1)];
    _Backview.layer.cornerRadius = (HScale(4.3)+1)/2;
    _Backview.backgroundColor = GPColor(239, 239, 239);
    [self.contentView addSubview:_Backview];
    
    _imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0.5, 0.5, WScale(7.7), HScale(4.3))];
    _imageIcon.layer.masksToBounds = YES;
    _imageIcon.layer.cornerRadius = HScale(4.3)/2;
    [_Backview addSubview:_imageIcon];
    
    _ballParkName = [[UILabel alloc] initWithFrame:CGRectMake(WScale(12.2), HScale(2.3), ScreenWidth - WScale(14), HScale(2.7))];
    _ballParkName.textColor = GPColor(51, 51, 51);
    _ballParkName.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [self.contentView addSubview:_ballParkName];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line.backgroundColor = GPColor(243, 243, 243);
    [self.contentView addSubview:line];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(7.5),ScreenWidth, 0.5)];
    line1.backgroundColor = GPColor(243, 243, 243);
    [self.contentView addSubview:line1];
    
}
-(void)relayoutWithModel:(id)model{
    if ([model isKindOfClass:[NSString class]]) {
        _ballParkName.text = model;

    }else{
    NearParkModel *Model = model;
    [_imageIcon sd_setImageWithURL:[NSURL URLWithString:Model.qlogo] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    _ballParkName.text = Model.qname;
    }
}
-(void)relayoutWithOldModel:(id)model{
    if ([model isKindOfClass:[NSString class]]) {
        _ballParkName.text = model;
        
    }else{
        BallParkSelectModel *Model = model;
        [_imageIcon sd_setImageWithURL:[NSURL URLWithString:Model.logo] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
        _ballParkName.text = Model.name;
    }
}


@end
