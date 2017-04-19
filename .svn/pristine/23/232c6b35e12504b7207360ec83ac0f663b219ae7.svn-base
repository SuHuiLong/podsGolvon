//
//  RecomentOtherCell.m
//  podsGolvon
//
//  Created by apple on 2016/12/8.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "RecomentOtherCell.h"

@implementation RecomentOtherCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createOtherCell];
    }
    return self;
}

-(void)createOtherCell{
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.frame = CGRectMake(kWvertical(12), 0, kWvertical(120), kHvertical(40));
    _typeLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_typeLabel];
        
    _pictureView = [[UIImageView alloc] init];
    _pictureView.frame = CGRectMake(0, kHvertical(40), ScreenWidth, kHvertical(198));
//    _pictureView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_pictureView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(kWvertical(12), _pictureView.bottom+kHvertical(9), ScreenWidth - kWvertical(24), kHvertical(20));
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.contentView addSubview:_titleLabel];
    
    _timegroundView = [[UIImageView alloc] init];
    _timegroundView.image = [UIImage imageNamed:@"findGroundView"];
    _timegroundView.contentMode = UIViewContentModeRedraw;
    [self.contentView addSubview:_timegroundView];
    
    _timeIcon = [[UIImageView alloc] init];
    _timeIcon.image = [UIImage imageNamed:@"findVisitorIcon"];
    [_timegroundView addSubview:_timeIcon];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _timeLabel.textColor = WhiteColor;
    [_timegroundView addSubview:_timeLabel];
    
    _tempLabel = [[UILabel alloc] init];
    _tempLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _tempLabel.frame = CGRectMake(0, 0, 100, 100);
    
    _readLabel = [[UILabel alloc] init];
    _readLabel.textColor = textTintColor;
    _readLabel.frame = CGRectMake(ScreenWidth - kWvertical(14) - kWvertical(120), _pictureView.bottom + kHvertical(33), kWvertical(120), kHvertical(15));
    _readLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _readLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_readLabel];
    
    
    _addTime = [[UILabel alloc] init];
    _addTime.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _addTime.textColor = textTintColor;
    _addTime.frame = CGRectMake(kWvertical(12), _pictureView.bottom + kHvertical(33), kWvertical(120), kHvertical(15));
    [self.contentView addSubview:_addTime];
    
}

-(void)relyoutDataWithModel:(ChildRecomModel *)model{
    [_pictureView setFindImageStr:model.pic];
    _typeLabel.text = [NSString stringWithFormat:@"%@推荐",model.content];
    UILabel *readLabel = [[UILabel alloc] init];
    readLabel.text = [NSString stringWithFormat:@"%@看过",model.readnum];
    readLabel.frame = CGRectMake(0, 0, 100, 100);
    readLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [readLabel sizeToFit];
    
    //visitorLabel
    _timegroundView.frame = CGRectMake(ScreenWidth-readLabel.width-kWvertical(11)-kWvertical(13)-4,kHvertical(40), readLabel.width+kWvertical(11)+kWvertical(13)+4, kHvertical(18));
    _timeLabel.text = readLabel.text;
    _timeIcon.frame = CGRectMake(6, kHvertical(4.5), kWvertical(11), kHvertical(9));
    _timeLabel.frame = CGRectMake(_timeIcon.right+4, 0, readLabel.width, kHvertical(18));

    
    _titleLabel.text = model.title;
    _readLabel.text = [NSString stringWithFormat:@"点赞%@",model.clikenum];
    _addTime.text = model.addts;
}
@end
