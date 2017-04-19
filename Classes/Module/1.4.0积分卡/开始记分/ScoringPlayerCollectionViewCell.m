//
//  ScoringPlayerCollectionViewCell.m
//  podsGolvon
//
//  Created by SHL on 2016/11/1.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ScoringPlayerCollectionViewCell.h"

@implementation ScoringPlayerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            self.backgroundColor = ClearColor;
            [self createView];
        }
    }
    return self;
}

-(void)createView{
    _headerImageView = [Factory createImageViewWithFrame:CGRectMake((ScreenWidth/4 - kWvertical(40))/2   , kHvertical(14), kWvertical(40), kWvertical(40)) Image:[UIImage imageNamed:@"scoring队伍添加"]];
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = kWvertical(20);
    _nameLabel = [Factory createLabelWithFrame:CGRectMake(0, _headerImageView.y_height+kHvertical(5), ScreenWidth/4, kHvertical(20)) textColor:rgba(53,141,227,1) fontSize:kHorizontal(14.0f) Title:@"添加"];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _headerImageView.userInteractionEnabled = NO;
    _nameLabel.userInteractionEnabled = NO;
    
    [self.contentView addSubview:_headerImageView];
    [self.contentView addSubview:_nameLabel];
}


-(void)configData:(GolfersModel *)model{
    NSString *nameStr = model.nickname;
    NSString *picUrl = model.avator;
    [_nameLabel setText:nameStr];

    if ([picUrl isEqualToString:@"scoring队伍添加"]) {
        _nameLabel.textColor = rgba(53,141,227,1);
        [_headerImageView setImage:[UIImage imageNamed:picUrl]];
        return;
    }
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:picUrl]];
    _nameLabel.textColor = rgba(51,52,54,1);
    
}


@end
