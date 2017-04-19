//
//  FriendsterTableViewCell.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "FriendsterTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface FriendsterTableViewCell ()
{
    
}
@property (strong, nonatomic) UILabel *comnicktest;
@property (strong, nonatomic) UILabel *testtime;
@property (nonatomic, assign) CGSize commentSize;
@property (nonatomic, assign) CGSize TitleSize;

/***  时间*/
@property (copy, nonatomic) UILabel     *timeLabel;

@property (copy, nonatomic) UIImageView    *headerImage;
/***  内容*/
@property (copy, nonatomic) UILabel     *contentLabel;
/***  回复*/
@property (copy, nonatomic) UILabel     *reaply;
/***  根线*/
@property (copy, nonatomic) UIView    *line;
/***  最新评论*/
@property (copy, nonatomic) UIView    *comlinView;
@property (copy, nonatomic) UILabel    *comLabel;
@property (copy, nonatomic) UIImageView      *Vimage;

@property (strong, nonatomic) UILongPressGestureRecognizer      *longpress;
@property (strong, nonatomic) UILongPressGestureRecognizer      *pressHeader;

@property (copy, nonatomic) DynamicMessageModel  *model;

@end

@implementation FriendsterTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)createUI{
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = SeparatorColor;
    [self.contentView addSubview:_line];
    
    
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWvertical(30), kWvertical(30))];
    [self.contentView addSubview:_headerImage];
    
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.image = [UIImage imageNamed:@"专访小v"];
    _Vimage.hidden = YES;
    [self.contentView addSubview:_Vimage];
    
    _headerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_headerBtn];
    _pressHeader = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressHeader:)];
    _pressHeader.minimumPressDuration = 0.5f;
    [_headerBtn addGestureRecognizer:_pressHeader];
    
    
    
    _commentNickname = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentNickname setTitleColor:GPColor(40, 155, 229) forState:UIControlStateNormal];
    if (Device >= 9.0) {
        
        _commentNickname.titleLabel.font = [UIFont fontWithName:Light size:kHorizontal(12)];
    }else{
        
        _commentNickname.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    }
    
    _commentNickname.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _commentNickname.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_commentNickname];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = GPColor(135, 135, 135);
    if (Device >= 9.0) {
        _timeLabel.font = [UIFont fontWithName:Light size:kHorizontal(10)];
    }else{
        
        _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(10)];
    }
    [self.contentView addSubview:_timeLabel];
    
    
    _contentLabel = [[UILabel alloc]init];
    if (Device >=9.0) {
        _contentLabel.font = [UIFont fontWithName:Light size:kHorizontal(13)];
    }else{
        _contentLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    }
    _contentLabel.textColor = GPColor(2, 2, 2);
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLabel];
    
    
    _reaply = [[UILabel alloc]init];
    _reaply.text = @"回复  ";
    _reaply.hidden = YES;
    _reaply.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _reaply.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_reaply];
    
    
    _replyNickname = [UIButton buttonWithType:UIButtonTypeCustom];
    _replyNickname.hidden = YES;
    [_replyNickname setTitleColor:GPColor(40, 155, 229) forState:UIControlStateNormal];
    if (Device >= 9.0) {
        
        _replyNickname.titleLabel.font = [UIFont fontWithName:Light size:kHorizontal(13)];
    }else{
        
        _replyNickname.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    }
    [self.contentView addSubview:_replyNickname];
    
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(kWvertical(50), 0, ScreenWidth - kWvertical(50), kHvertical(50))];
    clearView.backgroundColor = ClearColor;
    [self addSubview:clearView];
    
    
    _longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongpress:)];
    _longpress.minimumPressDuration = 0.5f;
    [clearView addGestureRecognizer:_longpress];
    
    _comnicktest = [[UILabel alloc]init];
    _comnicktest.frame=CGRectMake(0, 0, 200, kHvertical(14));
    _comnicktest.font = [UIFont systemFontOfSize:kHorizontal(10)];
    
    _testtime = [[UILabel alloc]init];
    _testtime.frame = CGRectMake(0, 0, 200, kHvertical(14));
    _testtime.font = [UIFont systemFontOfSize:kHorizontal(10)];
    
    
    _line.frame = CGRectMake(kWvertical(15), 0, ScreenWidth-kWvertical(30), 0.5);
    
    _headerImage.frame = CGRectMake(kWvertical(18), kHvertical(10), kWvertical(30), kWvertical(30));
    
    _Vimage.frame = CGRectMake(_headerImage.right-8, kHvertical(25), kWvertical(10), kWvertical(10));
    
    _headerBtn.frame = CGRectMake(0, 0, kWvertical(45), kHvertical(50));
    
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    
    
    CGFloat viewHeight = 0;
    
    if ([_model.type isEqualToString:@"0"]) {
        if (Device >=9.0) {
            
            CGSize TitleSize= [_model.content boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Light size:kHorizontal(13)]} context:nil].size;
            
            if (TitleSize.height + kHvertical(23)<kHvertical(50)) {
                viewHeight = kHvertical(50);
                
            }else{
                viewHeight = TitleSize.height + kHvertical(23)+kHvertical(10);
            }
            
        }
        
        CGSize TitleSize= [_model.content boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        
        if (TitleSize.height + kWvertical(23)<kWvertical(50)) {
            viewHeight = kWvertical(55);
            
        }else{
            viewHeight = TitleSize.height + kWvertical(23)+kHvertical(10);
        }
        
    }
    else{
        if (Device >=9.0) {
            UILabel *test = [[UILabel alloc] init];
            test.font =  [UIFont fontWithName:Light size:kHorizontal(13)];
            test.text = _model.covnickname;
            [test sizeToFit];
            NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",test.text,_model.content];
            CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Light size:kHorizontal(13)]} context:nil].size;
            
            if (TitleSize.height + kHvertical(23)<kHvertical(50)) {
                
                viewHeight = kHvertical(55);
                
            }else{
                
                viewHeight = TitleSize.height + kHvertical(23)+kHvertical(20);
            }
            
        }
        //        回复的时候的高度
        UILabel *test = [[UILabel alloc] init];
        test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
        test.text = _model.covnickname;
        [test sizeToFit];
        NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",test.text,_model.content];
        CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        
        if (TitleSize.height + kHvertical(23)<kHvertical(50)) {
            viewHeight = kHvertical(55);
            
        }else{
            
            viewHeight = TitleSize.height + kHvertical(23)+kHvertical(10);
        }
    }
    return CGSizeMake(ScreenWidth, viewHeight);
}

-(void)relayoutWithModel:(DynamicMessageModel *)model{
    _model = model;
    
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                               if (image) {
                                   UIGraphicsBeginImageContextWithOptions(_headerImage.bounds.size, NO, [UIScreen mainScreen].scale);
                                   [[UIBezierPath bezierPathWithRoundedRect:_headerImage.bounds
                                                               cornerRadius:kWvertical(15)] addClip];
                                   [image drawInRect:_headerImage.bounds];
                                   _headerImage.image = UIGraphicsGetImageFromCurrentImageContext();
                               }
                           }];
    
    if ([model.interview isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }
    
    _comnicktest.text = model.nickname;
    [_comnicktest sizeToFit];
    
    [_commentNickname setTitle:model.nickname forState:UIControlStateNormal];
    _commentNickname.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _testtime.text = model.time;
    [_testtime sizeToFit];
    
    _timeLabel.text = _testtime.text;
    
    
    _commentNickname.frame = CGRectMake(_headerImage.right + kWvertical(9), kHvertical(8), _comnicktest.width+kWvertical(100), kHvertical(9));
    
    _timeLabel.frame = CGRectMake(ScreenWidth-kWvertical(15)-_testtime.width, _commentNickname.top, _testtime.width, kHvertical(11));
    
    _reaply.frame = CGRectMake(_headerImage.right + kWvertical(9),  kHvertical(25), WScale(8), kHvertical(18));
    //    [_reaply sizeToFit];
    /**
     *  0:一级
     1:二级
     */
    if ([self.model.type isEqualToString:@"0"]) {
        _reaply.hidden = YES;
        _replyNickname.hidden = YES;
//        NSString *str = [NSString stringWithCString:[self.model.content UTF8String] encoding:NSUTF8StringEncoding];
        _contentLabel.text = self.model.content;
        if (Device >= 9.0) {
            
            _commentSize = [_contentLabel.text boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Light size:kHorizontal(13)]} context:nil].size;
            _contentLabel.frame = CGRectMake(_commentNickname.left, kHvertical(25), kWvertical(300),_commentSize.height);
        }
        
        _commentSize = [_contentLabel.text boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        _contentLabel.frame = CGRectMake(_commentNickname.left, kHvertical(25), kWvertical(300),_commentSize.height);
        [_contentLabel sizeToFit];
    }else{
        //回复人
        _reaply.hidden = NO;
        _replyNickname.hidden = NO;
        UILabel *test = [[UILabel alloc] init];
        test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
        test.text = self.model.covnickname;
        if (test.text) {
            [test sizeToFit];
        }
        _replyNickname.frame = CGRectMake(_reaply.right, kHvertical(25), test.width, kHvertical(18));
        [_replyNickname setTitle:test.text forState:UIControlStateNormal];
        
        
        
        NSString *contenText = [NSString stringWithFormat:@"回复%@:%@",test.text,self.model.content];
        if (Device >= 9.0) {
            
            _TitleSize= [contenText boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Light size:kHorizontal(13)]} context:nil].size;
            
            //回复的内容
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" : %@",self.model.content]];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = 0;//整体缩进，除首行外
            style.firstLineHeadIndent = _replyNickname.right - kWvertical(60);
            style.lineSpacing = 0;//字体的行距
            [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
            
            _contentLabel.attributedText = text;
            _contentLabel.frame = CGRectMake(_commentNickname.left, kHvertical(25), kWvertical(300), _TitleSize.height);
            //            [_contentLabel sizeToFit];
            
        }else{
            
            _TitleSize= [contenText boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
            
            //回复的内容
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" : %@",self.model.content]];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.headIndent = 0;//整体缩进，除首行外
            style.firstLineHeadIndent = _replyNickname.right - kWvertical(60);//首行缩进
            style.lineSpacing = 0;//字体的行距
            [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
            
            _contentLabel.attributedText = text;
            
            _contentLabel.frame = CGRectMake(_commentNickname.left, kHvertical(25), kWvertical(300), _TitleSize.height);
            //            [_contentLabel sizeToFit];
        }
        
    }
    

}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}
-(void)clickLongpress:(UILongPressGestureRecognizer *)longpress{
    if (longpress.state == UIGestureRecognizerStateBegan) {
        
        if (self.longpressBlock) {
            self.longpressBlock(self.model);
        }
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
