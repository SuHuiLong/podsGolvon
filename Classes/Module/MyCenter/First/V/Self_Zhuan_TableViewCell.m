//
//  Self_Zhuan_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/17.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_Zhuan_TableViewCell.h"

@implementation Self_Zhuan_TableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(3.5), HScale(2.6), ScreenWidth * 0.635, ScreenHeight * 0.024)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
    
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(75.2), HScale(1.8), ScreenWidth * 0.064, ScreenHeight * 0.036)];
    _image.image = [UIImage imageNamed:@"专访"];
    [self.contentView addSubview:_image];
    
    
    _zhaunfang = [[UILabel alloc]initWithFrame:CGRectMake(WScale(82.7), HScale(2.6), ScreenWidth * 0.074, ScreenHeight * 0.025)];
    _zhaunfang.text = @"专访";
    _zhaunfang.textAlignment = NSTextAlignmentCenter;
    _zhaunfang.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_zhaunfang];
    
}
-(void)relayOutDataAZhuanfangWithTitle:(NSString *)title{
    
    _titleLabel.text = title;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
}
@end
