//
//  InterviewTableViewCell.m
//  podsGolvon
//
//  Created by apple on 2016/12/12.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "InterviewTableViewCell.h"
#import "UIImageView+WebImage.h"

@interface InterviewTableViewCell ()

@property (nonatomic, strong) UIImageView   *interPic;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *timeLabel;

@end

@implementation InterviewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}
-(void)createCell{
    //专访图片
    _interPic = [[UIImageView alloc] init];
    _interPic.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(198));
    _interPic.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_interPic];
    
    //点赞记录
    
    _groundImage = [[UIImageView alloc] init];
    _groundImage.image = [UIImage imageNamed:@"findGroundView"];
    _groundImage.contentMode = UIViewContentModeRedraw;
    [self.contentView addSubview:_groundImage];
    
    
    _visitorImage = [[UIImageView alloc] init];
    _visitorImage.image = [UIImage imageNamed:@"findVisitorIcon"];
    [_groundImage addSubview:_visitorImage];

    _visitorLabel = [[UILabel alloc] init];
    _visitorLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _visitorLabel.textColor = WhiteColor;
    _visitorLabel.textAlignment = NSTextAlignmentRight;
    [_groundImage addSubview:_visitorLabel];
    
    //title
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(kWvertical(12), _interPic.bottom + kHvertical(9), ScreenWidth - kWvertical(24), kHvertical(20));
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _titleLabel.textColor = deepColor;
    [self.contentView addSubview:_titleLabel];
    
    //time
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(kWvertical(12), _titleLabel.bottom + kHvertical(4), kWvertical(120), kHvertical(16));
    _timeLabel.textColor = textTintColor;
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [self.contentView addSubview:_timeLabel];
    
    //like
    _likeLabel = [[UILabel alloc] init];
    _likeLabel.frame = CGRectMake(ScreenWidth - kWvertical(120)-kWvertical(12), _interPic.bottom+kHvertical(33), kWvertical(120), kHvertical(16));
    _likeLabel.textAlignment = NSTextAlignmentRight;
    _likeLabel.textColor = textTintColor;
    _likeLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [self.contentView addSubview:_likeLabel];
    
    _temp = [[UILabel alloc] init];
    _temp.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _temp.frame = CGRectMake(0, 0, 100, 100);
}
-(void)relayoutInterviewDataWithModel:(ChildInterviewModel *)model{
    [_interPic setFindImageStr:model.pic];
    
    UILabel *readLabel = [[UILabel alloc] init];
    readLabel.text = [NSString stringWithFormat:@"%@看过",model.readnum];
    readLabel.frame = CGRectMake(0, 0, 100, 100);
    readLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [readLabel sizeToFit];
    
    _groundImage.frame = CGRectMake(ScreenWidth-readLabel.width-kWvertical(11)-kWvertical(13)-4, 0, readLabel.width+kWvertical(11)+kWvertical(13)+4, kHvertical(18));
    _visitorLabel.text = readLabel.text;
    _visitorImage.frame = CGRectMake(6, kHvertical(4.5), kWvertical(11), kHvertical(9));
    _visitorLabel.frame = CGRectMake(_visitorImage.right+4, 0, readLabel.width, kHvertical(18));
    _titleLabel.text = model.describe;
    _timeLabel.text = model.time;
    _likeLabel.text = [NSString stringWithFormat:@"点赞 %@",model.clikenum];
    
}

-(void)relayoutActivityDataWithModel:(ChildCompetionData *)model{
    
    [_interPic setFindImageStr:model.pic];
    _visitorImage.image = [UIImage imageNamed:@"findTimeIcon"];
    _titleLabel.text = model.title;
    _timeLabel.text = model.addts;
    
    _likeLabel.text = [NSString stringWithFormat:@"阅读 %@",model.readnum];
}
-(void)relayoutOtherviewDataWithModel:(ChildCompetionData *)model{
    
    [_interPic setFindImageStr:model.pic];
//    _interPic.backgroundColor = RandomColor;
    UILabel *readLabel = [[UILabel alloc] init];
    readLabel.text = [NSString stringWithFormat:@"%@看过",model.readnum];
    readLabel.frame = CGRectMake(0, 0, 100, 100);
    readLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [readLabel sizeToFit];
    
    _groundImage.frame = CGRectMake(ScreenWidth-readLabel.width-kWvertical(11)-kWvertical(13)-4, 0, readLabel.width+kWvertical(11)+kWvertical(13)+4, kHvertical(18));
    
    _visitorLabel.text = readLabel.text;
    _visitorImage.frame = CGRectMake(6, kHvertical(4.5), kWvertical(11), kHvertical(9));
    _visitorLabel.frame = CGRectMake(_visitorImage.right+4, 0, readLabel.width, kHvertical(18));
    _titleLabel.text = model.title;
    _timeLabel.text = model.addts;
    _likeLabel.text = [NSString stringWithFormat:@"点赞 %@",model.clikenum];
}
@end
