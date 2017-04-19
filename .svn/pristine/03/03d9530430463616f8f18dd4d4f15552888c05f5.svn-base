//
//  LocationTableViewCell.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/31.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _state = 0;
    _localImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWvertical(12), kHvertical(8), kWvertical(12), kHvertical(16))];
    _localImage.image = [UIImage imageNamed:@"动态定位"];
    [self.contentView addSubview:_localImage];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.frame = CGRectMake(_localImage.right+kWvertical(5), kHvertical(8), _localImage.width, kHvertical(11));
    [self.contentView addSubview:_addressLabel];
    
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(ScreenWidth - kWvertical(50), 0, kWvertical(50), kHvertical(36));
    [self.contentView addSubview:_commentBtn];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn setImage:[UIImage imageNamed:@"喜欢_默认（首页）"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"喜欢_点击（首页）"] forState:UIControlStateSelected];
    _likeBtn.frame = CGRectMake(_commentBtn.left-kWvertical(50), 0, kWvertical(50), kHvertical(36));
    [self.contentView addSubview:_likeBtn];
    [_likeBtn addTarget:self action:@selector(clickToLike) forControlEvents:UIControlEventTouchUpInside];

}

- (void)relayoutWithModel:(FriendsterModel *)model{
    self.model = model;
    _addressLabel.text = model.position;
    _addressLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [_addressLabel sizeToFit];
    
    
    
    [_commentBtn setImage:[UIImage imageNamed:@"首页评论"] forState:UIControlStateNormal];
    [_commentBtn setTitle:model.dynamicCommentNumber forState:UIControlStateNormal];
    [_commentBtn setTitleColor:GPColor(135, 135, 135) forState:UIControlStateNormal];
    _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, kWvertical(5), 0, 0);
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    
    [_likeBtn setTitle:model.likeUsersNumber forState:UIControlStateNormal];
    _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, kWvertical(5), 0, 0);
    [_likeBtn setTitleColor:GPColor(135, 135, 135) forState:UIControlStateNormal];
    _likeBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    
    _state = [model.likeStatr intValue];
    _likeBtn.selected = _state;
    
    
}
-(void)clickToLike{
    if (self.likeBtnBlock) {
        self.likeBtnBlock(self.model);
    }
}

@end
