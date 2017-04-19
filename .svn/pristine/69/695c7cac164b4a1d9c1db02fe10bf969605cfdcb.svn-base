//
//  Liuyan_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/14.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Liuyan_TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation Liuyan_TableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createCell];
        
    }
    return self;
}

-(void)createCell{
    _headerImage = [[UIButton alloc]init];
    [self.contentView addSubview:_headerImage];
    
    _nameLabel = [[UIButton alloc]init];
    //WithFrame:];
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
    [self.contentView addSubview:_reaply];
    
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_button];
    
}
-(void)relayoutWithLY:(LiuYanModel *)model{
//    [_headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:model.picture_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    _headerImage.frame = CGRectMake(WScale(3.2), HScale(1.8), WScale(13.3), HScale(7.5));
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = ScreenHeight * 0.075/2;
    
    UILabel *nick = [[UILabel alloc]init];
//    nick.text = model.message_name;
    [nick sizeToFit];
    _nameLabel.frame = CGRectMake(WScale(21.3), HScale(2.1), nick.frame.size.width,ScreenHeight * 0.031);
//    [_nameLabel setTitle:[NSString stringWithFormat:@"%@",model.message_name] forState:UIControlStateNormal];
    [_nameLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nameLabel.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    //    居左
    _nameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
//    if ([model.reply_message_sta isEqualToString:@"0"]) {
        _reaply.hidden = YES;
        _button.hidden = YES;
        
//        _titleLabel.text = [NSString stringWithFormat:@"%@",model.message_content];
        _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        _titleLabel.textColor = GPColor(169, 169, 169);
        
        CGSize TitleSize= [_titleLabel.text boundingRectWithSize:CGSizeMake(WScale(75.4), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        _titleLabel.frame = CGRectMake(WScale(21.3), HScale(6.6), WScale(75.4), TitleSize.height);
        if (TitleSize.height + HScale(6.6)<HScale(11.1)) {
            _line.frame = CGRectMake(0, HScale(11.1)-1, ScreenWidth, 1);
            
        }else{
            _line.frame = CGRectMake(0, TitleSize.height + HScale(6.6) + 11, ScreenWidth, 1);
        }
        
//    }else{
//        _reaply.hidden = NO;
//        _button.hidden = NO;
//        UILabel *test = [[UILabel alloc] init];
//        test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
//        test.text = model.cover_reply_nackname;
//        [test sizeToFit];
//        _button.frame = CGRectMake(WScale(28.3)+WScale(1.9), HScale(6.6), test.frame.size.width, HScale(2.4));
//        [_button setTitle:model.cover_reply_nackname forState:UIControlStateNormal];
//        _button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
//        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//        
//        
//        _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
//        _titleLabel.textColor = GPColor(169, 169, 169);
//        NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.cover_reply_nackname,model.message_content];
//        CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(WScale(96.7)-WScale(21.3), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
//        
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" : %@",model.message_content]];
//        
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        style.headIndent = 0;//缩进
//        style.firstLineHeadIndent = _button.frame.size.width+_button.frame.origin.x - WScale(21.3);
//        style.lineSpacing = 0;//行距
//        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
//        _titleLabel.attributedText = text;
//        
//        
//        _titleLabel.frame = CGRectMake(WScale(21.3), HScale(6.6), WScale(96.7)-WScale(21.3), TitleSize.height);
//        if (TitleSize.height + HScale(6.6)<HScale(11.1)) {
//            _line.frame = CGRectMake(0, HScale(11.1)-1, ScreenWidth, 1);
//            
//        }else{
//            _line.frame = CGRectMake(0, TitleSize.height + HScale(6.6) + 11, ScreenWidth, 1);
//        }
//    }
//    
//    _timeLabel.text = [NSString stringWithFormat:@"%@",model.message_time];
//    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
//    _timeLabel.textColor = [UIColor grayColor];
//    _timeLabel.textAlignment = NSTextAlignmentRight;
}

@end
