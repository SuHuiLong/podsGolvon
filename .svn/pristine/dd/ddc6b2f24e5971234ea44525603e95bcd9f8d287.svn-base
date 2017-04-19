//
//  AddBallParkTableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/8/22.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import "AddBallParkTableViewCell.h"

@implementation AddBallParkTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _ballParkName                        = [[UILabel alloc]initWithFrame:CGRectMake(kWvertical(12), kHvertical(12), ScreenWidth - kWvertical(100), kHvertical(20))];
        _ballParkName.textAlignment          = NSTextAlignmentLeft;
        _ballParkName.font                   = [UIFont systemFontOfSize:kHorizontal(14)];
        _deleBtn                             = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleBtn.frame                       = CGRectMake(ScreenWidth - kWvertical(40), 0, kWvertical(40), self.height);
        _deleBtn.adjustsImageWhenHighlighted = NO;
        [_deleBtn setImage:[UIImage imageNamed:@"添加球场历史删除"] forState:UIControlStateNormal];
        [_deleBtn addTarget:self action:@selector(clickDelete) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_ballParkName];
        [self.contentView addSubview:_deleBtn];
        
    }
    return self;
}

-(void)relayoutWithModel:(BallParkSelectModel *)model{
    self.model = model;
    _ballParkName.text = model.name;
    
}
-(void)clickDelete{
    if (self.deleteHistoryBallPark) {
        
        self.deleteHistoryBallPark(self.model);
        
    }
}


@end
