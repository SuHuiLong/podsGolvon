//
//  SearchResultTableViewCell.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void)createCell{
    
    _headerIcon = [[UIImageView alloc]init];
    _headerIcon.frame = CGRectMake(kWvertical(12), (kHvertical(67) - kWvertical(42))/2, kWvertical(42), kWvertical(42));
    _headerIcon.layer.masksToBounds = YES;
    _headerIcon.layer.cornerRadius = kWvertical(21);
    [self.contentView addSubview:_headerIcon];
    
    _nickName = [[UILabel alloc]init];
    [self.contentView addSubview:_nickName];
    
    _sexIcon = [[UIImageView alloc]init];
    [self.contentView addSubview:_sexIcon];
    
    _intviewIcon = [[UIImageView alloc]init];
    _intviewIcon.image = [UIImage imageNamed:@"专访v"];
    [self.contentView addSubview:_intviewIcon];
    
    _poleLabel = [[UILabel alloc]init];
    _poleLabel.textColor = GRYTEXTCOLOR;
    [self.contentView addSubview:_poleLabel];
}



-(void)relayoutWithModel:(SearchResultModel *)model{
    
    [_headerIcon sd_setImageWithURL:[NSURL URLWithString:model.pic150Url] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    
    _nickName.text = model.nickname;
    _nickName.frame = CGRectMake(_headerIcon.right + kWvertical(13), kHvertical(13), kWvertical(249), kHvertical(22));
    _nickName.font = [UIFont boldSystemFontOfSize:kHorizontal(16)];
    [_nickName sizeToFit];
    
    _poleLabel.text = [NSString stringWithFormat:@"%@  %@",model.pole_number,model.city];
    _poleLabel.frame = CGRectMake(_nickName.left, _nickName.bottom,kWvertical(100) , kHvertical(17));
    _poleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_poleLabel sizeToFit];
    
    if ([model.gender isEqualToString:@"男"]) {
        _sexIcon.image = [UIImage imageNamed:@"男（首页）"];
    }else{
        _sexIcon.image = [UIImage imageNamed:@"女（首页）"];
    }
    
    _sexIcon.frame = CGRectMake(_nickName.right+kWvertical(7), kHvertical(18), kWvertical(12), kWvertical(12));
    
    if ([model.interview_state isEqualToString:@"0"]) {
        _intviewIcon.hidden = YES;
    }else{
        _intviewIcon.hidden = NO;
    }
    
    _intviewIcon.frame = CGRectMake(_sexIcon.right+kWvertical(7), kHvertical(18), kWvertical(12), kWvertical(12));

}

@end