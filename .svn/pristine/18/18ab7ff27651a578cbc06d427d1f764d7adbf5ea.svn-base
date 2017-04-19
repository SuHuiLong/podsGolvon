//
//  Self_LY_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/23.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_LY_TableViewCell.h"
#import "UIButton+WebCache.h"

@implementation Self_LY_TableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _headerImage = [[UIButton alloc]init];
    _headerImage.frame = CGRectMake(WScale(3.2), HScale(1.8), WScale(13.3), WScale(13.3));
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = WScale(13.3)/2;
    [self.contentView addSubview:_headerImage];
    
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.frame = CGRectMake(_headerImage.right - kWvertical(12), HScale(7.5), kWvertical(14), kWvertical(14));
    _Vimage.image = [UIImage imageNamed:@"个人中心加v"];
    _Vimage.hidden = YES;
    [self.contentView addSubview:_Vimage];
    
    
    _nameLabel = [[UIButton alloc]init];
    [self.contentView addSubview:_nameLabel];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(21.3), HScale(6.6), ScreenWidth * 0.75, ScreenHeight * 0.027)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(2.4), ScreenWidth * 0.967, ScreenHeight * 0.025)];
    [self.contentView addSubview:_timeLabel];
    
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:0.5];
    [self.contentView addSubview:_line];
    
    _reaply = [[UILabel alloc]init];
    _reaply.frame = CGRectMake(WScale(21.3), HScale(6.6), WScale(7), HScale(2.4));
    _reaply.text = @"回复  ";
    _reaply.hidden = YES;
    _reaply.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _reaply.textColor = [UIColor lightGrayColor];
    [_reaply sizeToFit];
    [self.contentView addSubview:_reaply];
    
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_button];
    
}
-(void)realyoutWithModel:(SelfLiuYanModel *)model{
    [_headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:model.picture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    
    if ([model.interview_state isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        
        _Vimage.hidden = NO;
    }
    UILabel *nick = [[UILabel alloc]init];
    nick.text = model.nickname;
    [nick sizeToFit];
    _nameLabel.frame = CGRectMake(WScale(21.3), HScale(2.1), nick.frame.size.width,ScreenHeight * 0.031);
    [_nameLabel setTitle:[NSString stringWithFormat:@"%@",model.nickname] forState:UIControlStateNormal];
    [_nameLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nameLabel.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    //    居左
    _nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    if ([model.reply_message_sta isEqualToString:@"0"]) {
        _reaply.hidden = YES;
        _button.hidden = YES;
        
        _titleLabel.text = [NSString stringWithFormat:@"%@",model.messageContent];
        _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        _titleLabel.textColor = GPColor(169, 169, 169);
        
        CGSize TitleSize= [_titleLabel.text boundingRectWithSize:CGSizeMake(WScale(75.4), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        _titleLabel.frame = CGRectMake(WScale(21.3), HScale(6.6), WScale(75.4), TitleSize.height);
        if (TitleSize.height + HScale(6.6)<HScale(11.1)) {
            _line.frame = CGRectMake(0, HScale(11.1)-1, ScreenWidth, 1);
            
        }else{
            _line.frame = CGRectMake(0, TitleSize.height + HScale(6.6) + 11, ScreenWidth, 1);
        }
        
    }else{
        _reaply.hidden = NO;
        _button.hidden = NO;
        UILabel *test = [[UILabel alloc] init];
        test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
        test.text = model.cover_reply_nackname;
        if (test.text) {
            [test sizeToFit];
        }
        _button.frame = CGRectMake(WScale(28.3)+WScale(1.9), HScale(6.6), test.frame.size.width, HScale(2.4));
        [_button setTitle:model.cover_reply_nackname forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        
        
        _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        _titleLabel.textColor = GPColor(169, 169, 169);
        NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.cover_reply_nackname,model.messageContent];
        CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(WScale(96.7)-WScale(21.3), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" : %@",model.messageContent]];

        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 0;//缩进
        style.firstLineHeadIndent = _button.frame.size.width+_button.frame.origin.x - WScale(21.3);
        style.lineSpacing = 0;//行距
        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
        _titleLabel.attributedText = text;
 

        _titleLabel.frame = CGRectMake(WScale(21.3), HScale(6.6), WScale(96.7)-WScale(21.3), TitleSize.height);
        
        if (TitleSize.height + HScale(6.6)<HScale(11.1)) {
            _line.frame = CGRectMake(0, HScale(11.1)-1, ScreenWidth, 1);
            
        }else{
            _line.frame = CGRectMake(0, TitleSize.height + HScale(6.6) + 11, ScreenWidth, 1);
        }
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.messageTime];
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
}


@end
