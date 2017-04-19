//
//  Fans_CollectionViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/16.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Fans_CollectionViewCell.h"
#import "UIImageView+WebCache.h"


@implementation Fans_CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

            self.contentView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
            [self createUI];
    }
    return self;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(DownLoadDataSource *)loadData{
    if (!_loadData) {

        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}

-(void)createUI{
    _fansImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(2.9), HScale(1.6), ScreenWidth * 0.283, ScreenHeight * 0.159)];
    [self.contentView addSubview:_fansImage];
    
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(2.9), HScale(19.4), ScreenWidth * 0.283, ScreenHeight * 0.028)];
    [self.contentView addSubview:_nameLabel];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(2.9),  HScale(22.2), ScreenWidth * 0.283, ScreenHeight * 0.024)];
    [self.contentView addSubview:_titleLabel];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(WScale(2.9), HScale(25.5), ScreenWidth * 0.283, ScreenHeight * 0.039);
    [_followBtn setBackgroundImage:[UIImage imageNamed:@"详情已关注"] forState:UIControlStateSelected];
    [_followBtn setBackgroundImage:[UIImage imageNamed:@"添加关注点击"] forState:UIControlStateHighlighted];
    [_followBtn setBackgroundImage:[UIImage imageNamed:@"添加关注默认"] forState:UIControlStateNormal];
    [_followBtn addTarget:self action:@selector(addFollow) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followBtn];
    
}


-(void)realodDataWith:(FansModel *)model{
    [_fansImage sd_setImageWithURL:[NSURL URLWithString:model.headerImageName] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.nickName];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _nameId = model.nameid;
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.signLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    if ([_nameId isEqualToString:userDefaultId]) {
        _followBtn.hidden = YES;
    }else{
        _followBtn.hidden = NO;
    }
    _followState = model.followState;
    
    if ([_followState isEqualToString:@"1"]) {
        _followBtn.selected = YES;
    }else{
        _followBtn.selected = NO;
    }

}

-(void)addFollow{
    
    NSDictionary *paramters = @{
                                @"follow_name_id":userDefaultId,
                                @"cof_name_id":self.nameId
                                };
    
    NSDictionary *deleteParamters = @{
                                      @"follow_user_id":userDefaultId,
                                      @"name_id":self.nameId
                                      };
    NSString *deleteUrlStr = [NSString stringWithFormat:@"%@Golvon/delete_follow",urlHeader120];
    
    if ([self.followState isEqualToString:@"0"]) {
        [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insert_follow",urlHeader120] parameters:paramters complicate:^(BOOL success, id data) {
            if (success) {
                self.followState = @"1";
                [self sendNotification];

            }
        }];
    } else {
        [self.loadData downloadWithUrl:deleteUrlStr parameters:deleteParamters complicate:^(BOOL success, id data) {
            if (success) {
                self.followState = @"0";
                [self sendNotification];


            }
        }];
    }
}

-(void)sendNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDetailData" object:nil];
}



@end
