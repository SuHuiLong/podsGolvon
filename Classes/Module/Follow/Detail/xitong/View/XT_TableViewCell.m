//
//  XT_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/22.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "XT_TableViewCell.h"

@implementation XT_TableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        
    }
    return self;
}
-(void)createUI{
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(34));
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor colorWithHexString:@"9a9a9a"];
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [self.contentView addSubview:_timeLabel];
    
    _groundView = [[UIView alloc] init];
    _groundView.layer.masksToBounds = YES;
    _groundView.layer.borderColor = SeparatorColor.CGColor;
    _groundView.layer.borderWidth = 1.0f;
    _groundView.layer.cornerRadius = 4.0f;
    [self.contentView addSubview:_groundView];
    
    
    _deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleBtn setImage:[UIImage imageNamed:@"动态删除"] forState:UIControlStateNormal];
    [_deleBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:_deleBtn];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"212121"];
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    _titleLabel.frame = CGRectMake(kWvertical(11), kHorizontal(9), kWvertical(300), kHvertical(21));
    [_groundView addSubview:_titleLabel];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorWithHexString:@"6f6f6f"];
    _nameLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_groundView addSubview:_nameLabel];
    
    _system_picurl = [[UIImageView alloc] init];
    _system_picurl.hidden = YES;
    _system_picurl.clipsToBounds = YES;
    _system_picurl.contentMode = UIViewContentModeScaleAspectFill;
    _system_picurl.frame = CGRectMake(WScale(2.4), kHvertical(61), (ScreenWidth - kWvertical(28))-WScale(4.8), kHvertical(205));
    [_groundView addSubview:_system_picurl];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = SeparatorColor;
    _lineView.frame = CGRectMake(_system_picurl.left, _system_picurl.bottom + HScale(1.2), _system_picurl.width, 0.5);
    _lineView.hidden = YES;
    [_groundView addSubview:_lineView];
    
    _checkLabel = [[UILabel alloc] init];
    _checkLabel.textColor = [UIColor colorWithHexString:@"6b6b6b"];
    _checkLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _checkLabel.text = @"查看全文";
    _checkLabel.hidden = YES;
    _checkLabel.frame = CGRectMake(_lineView.left, _lineView.bottom, WScale(20), HScale(4.3));
    [_groundView addSubview:_checkLabel];
    
    _moreImage = [[UIImageView alloc] init];
    _moreImage.frame = CGRectMake(_lineView.right - WScale(1.6), _lineView.bottom +HScale(1.4), WScale(1.6), HScale(1.5));
    _moreImage.image = [UIImage imageNamed:@"通知角标"];
    _moreImage.hidden = YES;
    [_groundView addSubview:_moreImage];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.hidden = YES;
    _contentLabel.textColor = [UIColor colorWithHexString:@"282828"];
    [_groundView addSubview:_contentLabel];
    
}
-(void)realyoutWithModel:(XiTongModel *)model{
    self.model = model;
    _timeLabel.text = model.time;
    
    _titleLabel.text = model.title;
    
    _nameLabel.text = [NSString stringWithFormat:@"发布者：打球去"];
    _nameLabel.frame = CGRectMake(kWvertical(11), _titleLabel.bottom+5, kWvertical(123), kHvertical(17));
    [_nameLabel sizeToFit];
    
    
    if ([model.picurl isEqualToString:@"0"]) {
        _system_picurl.hidden = YES;
        _lineView.hidden = YES;
        _checkLabel.hidden = YES;
        _moreImage.hidden = YES;
        _contentLabel.hidden = NO;
        _contentLabel.text = model.content;
        CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(kWvertical(324), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(14)]} context:nil].size;
        _contentLabel.frame = CGRectMake(kWvertical(11), _nameLabel.bottom+kHorizontal(18), kWvertical(324), contentSize.height);
        
        _groundView.frame = CGRectMake(kWvertical(14), kHvertical(34), ScreenWidth - kWvertical(28),kHvertical(19)+contentSize.height + kHvertical(70));
        
        _deleBtn.frame = CGRectMake(_groundView.width - 40, 0, 40, 40);
    }else{
        _system_picurl.hidden = NO;
        _lineView.hidden = NO;
        _checkLabel.hidden = NO;
        _moreImage.hidden = NO;
        _contentLabel.hidden = YES;
        [_system_picurl sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"发现专访默认图"]];
        _groundView.frame = CGRectMake(kWvertical(14), kHvertical(34), ScreenWidth - kWvertical(28), kHvertical(205)+kHvertical(43)+kHvertical(61));
        _deleBtn.frame = CGRectMake(_groundView.width - 40, 0, 40, 40);
    }
    
}

-(void)clickDeleteBtn{
    if (self.deleteMessageBlock) {
        self.deleteMessageBlock(self.model);
    }
}

@end
