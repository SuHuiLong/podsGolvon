//
//  ZhuanfangTableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/14.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "ZhuanfangTableViewCell.h"

@implementation ZhuanfangTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(1.5), HScale(2.6), ScreenWidth * 0.635, ScreenHeight * 0.024)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"";
    [self.contentView addSubview:_titleLabel];
    
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(80.3), HScale(1.8), ScreenWidth * 0.165, ScreenHeight * 0.036)];
    _image.image = [UIImage imageNamed:@"专访icon"];
    [self.contentView addSubview:_image];
    
}
-(void)relayOutDataAZhuanfangWithTitle:(ZhuanFangModel *)model{
    if (model.title) {
        _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    }
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
}
@end
