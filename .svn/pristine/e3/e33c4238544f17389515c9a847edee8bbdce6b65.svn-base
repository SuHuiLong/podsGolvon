//
//  InterviewCollectionViewCell.m
//  podsGolvon
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "InterviewCollectionViewCell.h"

@implementation InterviewCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCell];
    }
    return self;
}
-(void)createCell{
    
    _interPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWvertical(109), kHvertical(141))];
    [self.contentView addSubview:_interPic];
    
    _nickName = [[UILabel alloc] init];
    _nickName.frame = CGRectMake(0, _interPic.bottom + kHvertical(17), kWvertical(109), kHvertical(17));
    _nickName.textColor = deepColor;
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [self.contentView addSubview:_nickName];
    
    
    _visitorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nickName.left, _nickName.bottom, _interPic.width, kHvertical(14))];
    _visitorLabel.textColor = textTintColor;
    _visitorLabel.font = [UIFont systemFontOfSize:kHorizontal(10)];
    [self.contentView addSubview:_visitorLabel];

}
-(void)relayoutDataWithModel:(RecomInteModel *)model{
    [_interPic setImageURLString:model.pic];
    
    _nickName.text = model.nickname;
    _visitorLabel.text = model.readnum;
}
@end
