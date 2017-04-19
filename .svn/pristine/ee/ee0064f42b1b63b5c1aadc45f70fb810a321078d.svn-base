//
//  DetailComment.m
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/7.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "DetailComment.h"
#import "UIButton+WebCache.h"

@implementation DetailComment
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self ceateUI];
    }
    return self;
}

-(void)ceateUI{
    
    _headerImage = [[UIButton alloc]initWithFrame:CGRectMake(WScale(3.2), HScale(2.2),WScale(9.6) ,WScale(9.6))];
    _headerImage.clipsToBounds = YES;
    _headerImage.layer.cornerRadius = WScale(9.6)/2;
    [self.contentView addSubview:_headerImage];
    
    _nickName = [[UIButton alloc]initWithFrame:CGRectMake(WScale(16.6), HScale(1.9), ScreenWidth * 0.44, ScreenHeight * 0.027)];
    [_nickName setTitleColor:textTintColor forState:UIControlStateNormal];
    _nickName.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _nickName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [self.contentView addSubview:_nickName];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(16.6),HScale(5.2), ScreenWidth * 0.968, ScreenHeight *0.021)];
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _timeLabel.textColor = textTintColor;
    _timeLabel.textAlignment = NSTextAlignmentLeft;

    [self.contentView addSubview:_timeLabel];
    
    _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(16.6), HScale(8.5), ScreenWidth * 0.784, ScreenHeight * 0.06)];
    _commentLabel.textColor = deepColor;
    _commentLabel.numberOfLines = 0;
    [self.contentView addSubview:_commentLabel];
    
    _zanshu = [[UILabel alloc]initWithFrame:CGRectMake(WScale(60), HScale(2.2), ScreenWidth * 0.314, ScreenHeight * 0.024)];
    [self.contentView addSubview:_zanshu];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(WScale(80), 0,ScreenWidth * 0.2, ScreenHeight * 0.171)];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clckView)];
    [view addGestureRecognizer:tgp];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    
//    _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _zanBtn.frame = CGRectMake(WScale(90), HScale(0), ScreenWidth * 0.09, ScreenHeight * 0.080);
//    
//    [_zanBtn setBackgroundColor:[UIColor clearColor]];
//    
//    _zanview = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(2.5), HScale(1.9), WScale(4), HScale(2.4))];
//    _zanview.image = [UIImage imageNamed:@"点赞"];
//
//    [_zanBtn addSubview:_zanview];
//    [self.contentView addSubview:_zanBtn];
    

    _reaply = [[UILabel alloc]init];
    _reaply.frame = CGRectMake(WScale(16.6), HScale(8.3), WScale(7), HScale(2.4));
    _reaply.text = @"回复";
    _reaply.hidden = YES;
    _reaply.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _reaply.textColor = [UIColor lightGrayColor];
    [_reaply sizeToFit];
    [self.contentView addSubview:_reaply];
    
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(WScale(28.5), WScale(28.5), 0, HScale(2.4));
    [self.contentView addSubview:_button];
    
}

-(void)clckView{

}
-(void)realoadDataWith:(ChildCommentModel *)model{
    
    [_headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:model.compic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    
    [_nickName setTitle:[NSString stringWithFormat:@"%@",model.comnickname] forState:UIControlStateNormal];
    //    居左
    
    //    时间
    _timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
    //    留言内容
    if ([model.statr isEqualToString:@"0"]) {
        _reaply.hidden = YES;
        _button.hidden = YES;
        _commentLabel.text = [NSString stringWithFormat:@"%@",model.content];
        _commentLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        CGSize TitleSize= [_commentLabel.text boundingRectWithSize:CGSizeMake(WScale(78.4), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        _commentLabel.frame = CGRectMake(WScale(16.6), HScale(8.3), WScale(78.4), TitleSize.height);
        
    }else{
        _reaply.hidden = NO;
        _button.hidden = NO;
        UILabel *test = [[UILabel alloc] init];
        test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
        test.text = model.replynickname;
        [test sizeToFit];
        _button.frame = CGRectMake(_reaply.frame.size.width+_reaply.frame.origin.x+WScale(1.9), HScale(8.3), test.frame.size.width, HScale(2.4));
        [_button setTitle:model.replynickname forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        [_button setTitleColor:localColor forState:UIControlStateNormal];
        
        
        _commentLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.replynickname,model.content];
        CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(WScale(96.7)-WScale(16.6), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" : %@",model.content]];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 0;//缩进
        style.firstLineHeadIndent = _button.frame.size.width+_button.frame.origin.x - WScale(16.6);
        style.lineSpacing = 0;//行距
        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
        _commentLabel.attributedText = text;
        
        
        _commentLabel.frame = CGRectMake(WScale(16.6), HScale(8.3), WScale(96.7)-WScale(16.6), TitleSize.height);
        
    }

}
//-(void)realoadDataWith:(CommentModel *)model{
//    
//    
//    //    头像昵称
//    [_headerImage sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
//    
//    [_nickName setTitle:[NSString stringWithFormat:@"%@",model.nickName] forState:UIControlStateNormal];
//    [_nickName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _nickName.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
//    //    居左
//    _nickName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    
//    //    时间
//    _timeLabel.text = [NSString stringWithFormat:@"%@",model.timeLabel];
//    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
//    _timeLabel.textColor = [UIColor lightGrayColor];
//    _timeLabel.textAlignment = NSTextAlignmentLeft;
//    
//    //    留言内容
//    if ([model.reply_comment_sta isEqualToString:@"0"]) {
//        _reaply.hidden = YES;
//        _button.hidden = YES;
//        _commentLabel.text = [NSString stringWithFormat:@"%@",model.comment];
//        _commentLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
//        CGSize TitleSize= [_commentLabel.text boundingRectWithSize:CGSizeMake(WScale(78.4), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
//        _commentLabel.frame = CGRectMake(WScale(16.6), HScale(8.3), WScale(78.4), TitleSize.height);
//        
//    }else{
//        _reaply.hidden = NO;
//        _button.hidden = NO;
//        UILabel *test = [[UILabel alloc] init];
//        test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
//        test.text = model.reply_name;
//        [test sizeToFit];
//        _button.frame = CGRectMake(_reaply.frame.size.width+_reaply.frame.origin.x+WScale(1.9), HScale(8.3), test.frame.size.width, HScale(2.4));
//        [_button setTitle:model.reply_name forState:UIControlStateNormal];
//        _button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
//        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//        
//        _commentLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
//        NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.reply_name,model.comment];
//        CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(WScale(96.7)-WScale(16.6), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
//        
//        
//        
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" : %@",model.comment]];
//        
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        style.headIndent = 0;//缩进
//        style.firstLineHeadIndent = _button.frame.size.width+_button.frame.origin.x - WScale(16.6);
//        style.lineSpacing = 0;//行距
//        [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
//        _commentLabel.attributedText = text;
//        
//        
//        _commentLabel.frame = CGRectMake(WScale(16.6), HScale(8.3), WScale(96.7)-WScale(16.6), TitleSize.height);
//        
//        
//        
//        //        _commentLabel.frame = CGRectMake(_button.frame.origin.x + _button.frame.size.width, HScale(8.3), WScale(78.4)-_button.frame.size.width-_reaply.frame.size.width, TitleSize.height);
//    }
//    //    点赞
//    _zanshu.text = [NSString stringWithFormat:@"%@",model.zanLabel];
//    _zanshu.font = [UIFont systemFontOfSize:kHorizontal(11)];
//    _zanshu.textAlignment = NSTextAlignmentRight;
//    _zanshu.textColor = [UIColor redColor];
//    _zanview.image = [UIImage imageNamed:@"点赞"];
//    if ([model.like_statr isEqualToString:@"1"]) {
//        _zanview.image = [UIImage imageNamed:@"dianzan"];
//        
//    }
//}
@end




