//
//  LikeTableViewCell.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/31.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "LikeTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation LikeTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        _pressLikeHeader = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressHeader:)];
        _pressLikeHeader.minimumPressDuration = 0.5;
        [self addGestureRecognizer:_pressLikeHeader];
    }
    return self;
}

- (void)createUI{
    
    _headerIcon = [[UIImageView alloc]init];
    _headerIcon.frame = CGRectMake(0, 0, self.width, self.width);
    _headerIcon.layer.masksToBounds = YES;
    _headerIcon.layer.cornerRadius = self.width/2;
    _headerIcon.userInteractionEnabled = YES;
    [self.contentView addSubview:_headerIcon];
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.image = [UIImage imageNamed:@"专访小v"];
    _Vimage.hidden = YES;
    _Vimage.frame = CGRectMake(_headerIcon.right-8, kHvertical(18), kWvertical(10), kWvertical(10));
    [self.contentView addSubview:_Vimage];
    
}
-(void)relayoutWithModel:(LikeUsersModel *)model{

    self.model = model;
    _headerIcon.backgroundColor = [UIColor grayColor];
    [_headerIcon sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    
    if ([model.interview isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }
}
-(void)longpressHeader:(UILongPressGestureRecognizer *)longpress{
    if (longpress.state == UIGestureRecognizerStateBegan) {
        
        if (self.pressHeaderBlock) {
            self.pressHeaderBlock(self.model);
        }
    }
}
@end
