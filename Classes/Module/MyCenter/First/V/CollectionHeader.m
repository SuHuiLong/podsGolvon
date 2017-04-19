//
//  CollectionHeader.m
//  我的 改1
//
//  Created by 李盼盼 on 16/5/26.
//  Copyright © 2016年 李盼盼. All rights reserved.
//


#import "CollectionHeader.h"

@implementation CollectionHeader
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    /**背景图*/
    _backGroundImage = [[UIImageView alloc]init];
    _backGroundImage.frame = CGRectMake(0, 0, ScreenWidth, HScale(24.7));
    _backGroundImage.userInteractionEnabled = YES;
    _backGroundImage.clipsToBounds = YES;
    _backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
    
    
    
    
    UIImageView *maskBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0,HScale(15.6), ScreenWidth, HScale(9.1))];
    maskBottom.image = [UIImage imageNamed:@"蒙板移动_下"];
    
    
    /**头像*/
    _groundLabel = [[UILabel alloc]init];
    _groundLabel.frame = CGRectMake((ScreenWidth - WScale(20.5))/2, HScale(19.35)   , WScale(20.5), HScale(11.7));
    _groundLabel.backgroundColor = [UIColor whiteColor];
    _groundLabel.layer.masksToBounds = YES;
    _groundLabel.layer.cornerRadius = HScale(11.7)/2;
    [self addSubview:_groundLabel];
    
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(20))/2, HScale(19.6)   , WScale(20), HScale(11.2))];
    _headerImage.userInteractionEnabled = YES;
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = HScale(11.2)/2;
    _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    
    
    _Vimage = [[UIImageView alloc] init];
    _Vimage.frame = CGRectMake(_headerImage.right-kWvertical(17), _headerImage.height-kWvertical(17)+ HScale(19.6), kWvertical(17), kWvertical(17));
    
    
    /**昵称*/
    _nickName = [[UILabel alloc]init];
    

    
    _sexImage = [[UIImageView alloc]init];
    
    
    /**个人资料*/
    //@"80后 9字头 上海 运动体育";
    _ownMessage = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(36.3), ScreenWidth, HScale(2.4))];
    _ownMessage.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _ownMessage.textAlignment = NSTextAlignmentCenter;
    _ownMessage.textColor = GPColor(125, 122, 136);
    _ownMessage.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",@"0",@"0",@"0",@"0",@"0"];
    [self addSubview:_ownMessage];
    
    /**签名*/
    _signature = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(74.8))/2, HScale(46.8)   , WScale(74.8), HScale(2.4))];
    _signature.textColor = GPColor(125, 122, 136);
    _signature.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _signature.textAlignment = NSTextAlignmentCenter;
    _signature.text = @"签名";
    
    
    /**粉丝，关注，留言*/
    _adjArray = @[@"0",@"0",@"0"];
    _fansBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _followBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _liuyanBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    _unReadFans = [[UIView alloc] init];
    _unReadMessage = [[UIView alloc] init];
    _unReadFans.backgroundColor = RedColor;
    _unReadMessage.backgroundColor = RedColor;

    
    _unReadMessage.layer.masksToBounds = YES;
    _unReadFans.layer.masksToBounds = YES;
    _unReadMessage.layer.cornerRadius = kWvertical(3.5);
    _unReadFans.layer.cornerRadius = kWvertical(3.5);
    
    _unReadFans.hidden = YES;
    _unReadMessage.hidden = YES;
    
    if (_adjArray[0]) {
        [_fansBtn setTitle:[NSString stringWithFormat:@"%@粉丝",@"0" ] forState:(UIControlStateNormal)];
    }
    if (_adjArray[1]) {
        [_followBtn setTitle:[NSString stringWithFormat:@"%@关注",@"0" ] forState:(UIControlStateNormal)];
    }
    if (_adjArray[2]) {
        [_liuyanBtn setTitle:[NSString stringWithFormat:@"%@留言",@"0" ] forState:(UIControlStateNormal)];
    }
    
    [_fansBtn setTitleColor:GPColor(43, 43, 43) forState:(UIControlStateNormal)];
    [_followBtn setTitleColor:GPColor(43, 43, 43) forState:(UIControlStateNormal)];
    [_liuyanBtn setTitleColor:GPColor(43, 43, 43) forState:(UIControlStateNormal)];
    
    _fansBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _followBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _liuyanBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    
    
    _line1 = [[UIView alloc]init];
    _line1.backgroundColor = GPColor(66, 66, 66);
    
    _line2 = [[UIView alloc]init];
    _line2.backgroundColor = GPColor(66, 66, 66);
    
    [self addSubview:_line1];
    [self addSubview:_line2];
    
    
    [self addSubview:_fansBtn];
    [self addSubview:_followBtn];
    [self addSubview:_liuyanBtn];
    
    
    /**场次，抓鸟，慈善*/
    NSArray *titleArr = @[@"场次",@"抓鸟",@"慈善"];
    for (int i = 0; i<3; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*i/3, HScale(52.5), ScreenWidth/3, HScale(2.4))];
        titleLabel.text = titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        titleLabel.textColor = GPColor(51, 51, 59);
        [self addSubview:titleLabel];
        
    }
    _changCi = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(55.5)   , ScreenWidth / 3, HScale(4.5))];
    _changCi.font = [UIFont systemFontOfSize:kHorizontal(22)];
    _changCi.textAlignment = NSTextAlignmentCenter;
    _changCi.text = @"0";
    [self addSubview:_changCi];
    
    _zhuaNiao = [[UILabel alloc]initWithFrame:CGRectMake(_changCi.frame.origin.x +_changCi.frame.size.width, HScale(55.5)   , ScreenWidth / 3, HScale(4.5))];
    _zhuaNiao.font = [UIFont systemFontOfSize:kHorizontal(22)];
    _zhuaNiao.textAlignment = NSTextAlignmentCenter;
    _zhuaNiao.text = @"0";
    [self addSubview:_zhuaNiao];
    
    _ciShan = [[UILabel alloc]initWithFrame:CGRectMake(_zhuaNiao.frame.origin.x +_zhuaNiao.frame.size.width, HScale(55.5)   , ScreenWidth / 3, HScale(4.5))];
    _ciShan.font = [UIFont systemFontOfSize:kHorizontal(22)];
    _ciShan.textAlignment = NSTextAlignmentCenter;
    _ciShan.text = @"0";
    [self addSubview:_ciShan];
    
    _pageViewImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(3.9), HScale(19.9)   +HScale(1.2), WScale(4.5), HScale(1.5))];
    _pageViewImage.image = [UIImage imageNamed:@"iconfont-yanjing"];
    
    _pageViewLabel = [[UILabel alloc]init];
    _pageViewLabel.text = @"0";
    [self addSubview:_backGroundImage];
    [self addSubview:maskBottom];
    [self addSubview:_pageViewImage];
    [self addSubview:_pageViewLabel];
    [self addSubview:_groundLabel];
    [self addSubview:_headerImage];
    [self addSubview:_Vimage];
    [self addSubview:_nickName];
    [self addSubview:_sexImage];
    [self addSubview:_ownMessage];
    [self addSubview:_signature];
    [self addSubview:_material];
    [self addSubview:_subLayer];
    
    
    /**
     存放标签的label
     */
    _markView1 = [[UILabel alloc]init];
    _markView2 = [[UILabel alloc]init];
    _markView3 = [[UILabel alloc]init];
    _markView4 = [[UILabel alloc]init];
    _markView5 = [[UILabel alloc]init];
    _markView6 = [[UILabel alloc]init];
    
    
    [self addSubview:_markView1];
    [self addSubview:_markView2];
    [self addSubview:_markView3];
    [self addSubview:_markView4];
    [self addSubview:_markView5];
    [self addSubview:_markView6];
    
    
    /**
     标签背景
     */
    _markGroundImage1 = [[UIImageView alloc] init];
    
    _markGroundImage2 = [[UIImageView alloc] init];
    
    _markGroundImage3 = [[UIImageView alloc] init];
    
    _markGroundImage4 = [[UIImageView alloc] init];
    
    _markGroundImage5 = [[UIImageView alloc] init];
    
    _markGroundImage6 = [[UIImageView alloc] init];
    
    
    [_markView1 addSubview:_markGroundImage1];
    [_markView2 addSubview:_markGroundImage2];
    [_markView3 addSubview:_markGroundImage3];
    [_markView4 addSubview:_markGroundImage4];
    [_markView5 addSubview:_markGroundImage5];
    [_markView6 addSubview:_markGroundImage6];
    
    /**
     标签内容
     */
    _markLabel1 = [[UILabel alloc] init];
    _markLabel2 = [[UILabel alloc] init];
    _markLabel3 = [[UILabel alloc] init];
    _markLabel4 = [[UILabel alloc] init];
    _markLabel5 = [[UILabel alloc] init];
    _markLabel6 = [[UILabel alloc] init];
    
    
    [_markView1 addSubview:_markLabel1];
    [_markView2 addSubview:_markLabel2];
    [_markView3 addSubview:_markLabel3];
    [_markView4 addSubview:_markLabel4];
    [_markView5 addSubview:_markLabel5];
    [_markView6 addSubview:_markLabel6];
    
    /**
     标签头
     */
    _markHeaderImage1 = [[UIImageView alloc] init];
    _markHeaderImage2 = [[UIImageView alloc] init];
    _markHeaderImage3 = [[UIImageView alloc] init];
    _markHeaderImage4 = [[UIImageView alloc] init];
    _markHeaderImage5 = [[UIImageView alloc] init];
    _markHeaderImage6 = [[UIImageView alloc] init];
    
    
    [_markView1 addSubview:_markHeaderImage1];
    [_markView2 addSubview:_markHeaderImage2];
    [_markView3 addSubview:_markHeaderImage3];
    [_markView4 addSubview:_markHeaderImage4];
    [_markView5 addSubview:_markHeaderImage5];
    [_markView6 addSubview:_markHeaderImage6];

    _cheakStyle = [[UIImageView alloc]init];
    [self addSubview:_cheakStyle];
    
    [self addSubview:_unReadMessage];
    [self addSubview:_unReadFans];

}


-(void)reloadData{
    
    NSString *examine_state = [userDefaults objectForKey:@"examine_state"];
    switch ([examine_state integerValue]) {
        case 0:{
            _cheakStyle.frame = CGRectMake((ScreenWidth - WScale(3.7)-WScale(26.1)), HScale(19.9)   , WScale(26.1), HScale(3.3));
            _cheakStyle.image = [UIImage imageNamed:@"资料审核中"];
        }break;
            
        case 1:{
            
            _cheakStyle.image = [UIImage imageNamed:@""];
        }break;
            
        case 2:{
            _cheakStyle.frame = CGRectMake((ScreenWidth - WScale(3.7)-WScale(26.1)), HScale(19.9)   , WScale(25), HScale(3.3));
            _cheakStyle.image = [UIImage imageNamed:@"更换头像"];
        }break;
        case 3:{
            _cheakStyle.frame = CGRectMake((ScreenWidth - WScale(3.7)-WScale(26.1)), HScale(19.9)   , WScale(26.7), HScale(3.3));
            _cheakStyle.image = [UIImage imageNamed:@"头像不合法"];
        }break;
            
        default:
            break;
    }
    
    [_backGroundImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"coverPic"]] placeholderImage:[UIImage imageNamed:@"动态等待图"]];

    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
    
    
    ///昵称
    UILabel *test = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(28))/2, HScale(31.9)   , WScale(28), HScale(3.3))];
    test.text = [userDefaults objectForKey:@"nickname"];
    test.textAlignment = NSTextAlignmentCenter;
    [test sizeToFit];
    _nickName.frame = CGRectMake((ScreenWidth - test.width)/2, test.y, test.width, test.height);
    if ([userDefaults objectForKey:@"nickname"]) {
        _nickName.text = test.text;
    }
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(18)];
    _nickName.textColor = GPColor(49, 47, 47);
    [_nickName sizeToFit];
    
    _sexImage.frame = CGRectMake(_nickName.x+_nickName.width+3, _nickName.top+3, kWvertical(14), kWvertical(14));
    _sex = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"gender"]];
    if ([_sex isEqualToString:@"女"]) {
        _sexImage.image = [UIImage imageNamed:@"女（首页）"];
    }else{
        _sexImage.image = [UIImage imageNamed:@"男（首页）"];
    }

    
    _signature.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"siignature"]];
    
    /**
     *  工作
     */
    NSString *str0 = [userDefaults objectForKey:@"age"];
    NSString *str1 = [userDefaults objectForKey:@"polenum"];
    NSString *str2 = [userDefaults objectForKey:@"province"];
    NSString *str3 = [userDefaults objectForKey:@"city"];
    NSString *str4 = [userDefaults objectForKey:@"job"];
    
    if (str4 == nil) {
        str4 = @"";
    }
    
    if ([str2 isEqualToString:str3]) {

        _ownMessage.text = [NSString stringWithFormat:@"%@ %@ %@ %@" ,str0,str1,str3,str4];
        
    }else{
        
        _ownMessage.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@" ,str0,str1,str2,str3,str4];
    }
    

    //    粉丝，关注，留言
    if ([userDefaults objectForKey:@"follow_number"]) {
        [_fansBtn setTitle:[NSString stringWithFormat:@"%@粉丝",[userDefaults objectForKey:@"follow_number"]] forState:UIControlStateNormal];
    }
    if ([userDefaults objectForKey:@"attention_number"]) {
        [_followBtn setTitle:[NSString stringWithFormat:@"%@关注",[userDefaults objectForKey:@"attention_number"]] forState:UIControlStateNormal];
    }
    if ([userDefaults objectForKey:@"message_number"]) {
        [_liuyanBtn setTitle:[NSString stringWithFormat:@"%@留言",[userDefaults objectForKey:@"message_number"]] forState:UIControlStateNormal];
    }

    
    _fansBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _followBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _liuyanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_fansBtn sizeToFit];
    [_followBtn sizeToFit];
    [_liuyanBtn sizeToFit];
    
    _unReadFans.frame = CGRectMake(_fansBtn.x + _fansBtn.width, _fansBtn.y+kHvertical(4), kWvertical(7), kWvertical(7));
    _unReadMessage.frame = CGRectMake(_liuyanBtn.x + _liuyanBtn.width, _liuyanBtn.y+kHvertical(4), kWvertical(7), kWvertical(7));
    
    
    [_followBtn setOrigin:CGPointMake((ScreenWidth-_followBtn.width)/2, HScale(40.5)   )];
    CGFloat lineheight = HScale(1.8);
    CGFloat lineY = _followBtn.top+(_followBtn.height-lineheight)/2;

    _line1.frame = CGRectMake(_followBtn.left-WScale(3),lineY , 1, lineheight);
    _line2.frame = CGRectMake(_followBtn.right+WScale(3), lineY, 1, lineheight);
    
    
    
    [_fansBtn setOrigin:CGPointMake(_line1.left-WScale(3)-_fansBtn.width, _followBtn.top)];
    [_liuyanBtn setOrigin:CGPointMake(_line2.right + WScale(3), _followBtn.top)];
    
    
    
    //    场次
    if ([userDefaults objectForKey:@"changCi"]) {
        _changCi.text = [userDefaults objectForKey:@"changCi"];
    }
    if ([userDefaults objectForKey:@"zhuaNiao"]) {
        _zhuaNiao.text = [userDefaults objectForKey:@"zhuaNiao"];
    }
    if ([userDefaults objectForKey:@"cishan_jiner"]) {
        _ciShan.text = [userDefaults objectForKey:@"cishan_jiner"];
    }
    NSString *strchang = [NSString stringWithFormat:@"%@%@",[userDefaults objectForKey:@"changCi"],@"次"];
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc]initWithString:strchang];
    [attribute1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(11)] range:NSMakeRange(attribute1.length-1, 1)];
    [attribute1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attribute1.length-1, 1)];
    if ([userDefaults objectForKey:@"changCi"]) {
        _changCi.attributedText = attribute1;
    }
    
    //    抓鸟
    NSString *strzhua = [NSString stringWithFormat:@"%@%@",[userDefaults objectForKey:@"zhuaNiao"],@"次"];
    NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc]initWithString:strzhua];
    [attribute2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(11)] range:NSMakeRange(attribute2.length-1, 1)];
    [attribute2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attribute2.length-1, 1)];
    if ([userDefaults objectForKey:@"zhuaNiao"]) {
        _zhuaNiao.attributedText = attribute2;

    }
    
    //    慈善
    NSString *strCi = [NSString stringWithFormat:@"%@%@",[userDefaults objectForKey:@"cishan_jiner"],@"元"];
    NSMutableAttributedString *attribute3 = [[NSMutableAttributedString alloc]initWithString:strCi];
    [attribute3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kHorizontal(11)] range:NSMakeRange(attribute3.length-1, 1)];
    [attribute3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attribute3.length-1, 1)];
    if ([userDefaults objectForKey:@"cishan_jiner"]) {
        _ciShan.attributedText = attribute3;
    }
    
    //访问量
    UILabel *test1 = [[UILabel alloc]init];
    test1.backgroundColor = [UIColor redColor];
    test1.text = [userDefaults objectForKey:@"access_amount"];
    test1.frame = CGRectMake(_pageViewImage.right + WScale(1), _pageViewImage.y-3, 80, _pageViewImage.height);
    test1.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [test1 sizeToFit];
    
    _pageViewLabel.text = test1.text;
    _pageViewLabel.frame = test1.frame;
    _pageViewLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _pageViewLabel.textAlignment = NSTextAlignmentCenter;
    _pageViewLabel.shadowColor = GPColor(26, 26, 26);
    _pageViewLabel.textColor = [UIColor whiteColor];
    _pageViewLabel.shadowOffset = CGSizeMake(0, 1);
    [_pageViewLabel sizeToFit];

    
    
    NSString *markStr1 = [NSString string];
    NSString *markStr3 = [NSString string];
    NSString *markStr2 = [NSString string];
    NSString *markStr4 = [NSString string];
    NSString *markStr5 = [NSString string];
    NSString *markStr6 = [NSString string];
    _markArry = [NSMutableArray array];
    NSArray *labArr = [userDefaults objectForKey:@"labels"];
    
    if ([labArr count] != 0) {
        
        if ([[userDefaults objectForKey:@"labels"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *mark_dic in [userDefaults objectForKey:@"labels"]) {
                NSString *mark_label = [mark_dic objectForKey:@"label_content"];
                [_markArry addObject:mark_label];
            }
        }
    }
    _markHeaderImage1.hidden = YES;
    _markHeaderImage2.hidden = YES;
    _markHeaderImage3.hidden = YES;
    _markHeaderImage4.hidden = YES;
    _markHeaderImage5.hidden = YES;
    _markHeaderImage6.hidden = YES;
    
    
    _markGroundImage1.hidden = YES;
    _markGroundImage2.hidden = YES;
    _markGroundImage3.hidden = YES;
    _markGroundImage4.hidden = YES;
    _markGroundImage5.hidden = YES;
    _markGroundImage6.hidden = YES;
    
    
    switch (_markArry.count) {
            
        case 0:{
            
        }break;
        case 1:{
            markStr3 = _markArry[0];
            _markHeaderImage3.hidden = NO;
            _markGroundImage3.hidden = NO;
            
        }break;
        case 2:{
            markStr3 = _markArry[0];
            markStr2 = _markArry[1];
            
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            
            
        }break;
        case 3:{
            
            markStr2 = _markArry[1];
            markStr3 = _markArry[0];
            markStr4 = _markArry[2];
            
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            _markHeaderImage4.hidden = NO;
            
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            _markGroundImage4.hidden = NO;
            
        }break;
        case 4:{
            
            markStr1 = _markArry[3];
            markStr2 = _markArry[1];
            markStr3 = _markArry[0];
            markStr4 = _markArry[2];
            
            _markHeaderImage1.hidden = NO;
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            _markHeaderImage4.hidden = NO;
            
            _markGroundImage1.hidden = NO;
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            _markGroundImage4.hidden = NO;
            
        }break;
            
        case 5:{
            
            markStr3 = _markArry[0];
            markStr2 = _markArry[1];
            markStr4 = _markArry[2];
            markStr1 = _markArry[3];
            markStr5 = _markArry[4];
            
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            _markHeaderImage4.hidden = NO;
            _markHeaderImage1.hidden = NO;
            _markHeaderImage6.hidden = NO;
            
            _markGroundImage1.hidden = NO;
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            _markGroundImage4.hidden = NO;
            _markGroundImage6.hidden = NO;
            
        }break;
        case 6:{
            markStr3 = _markArry[0];
            markStr2 = _markArry[1];
            markStr4 = _markArry[2];
            markStr1 = _markArry[3];
            markStr5 = _markArry[4];
            markStr6 = _markArry[5];
            
            _markHeaderImage2.hidden = NO;
            _markHeaderImage3.hidden = NO;
            _markHeaderImage4.hidden = NO;
            _markHeaderImage1.hidden = NO;
            _markHeaderImage5.hidden = NO;
            _markHeaderImage6.hidden = NO;
            
            _markGroundImage1.hidden = NO;
            _markGroundImage2.hidden = NO;
            _markGroundImage3.hidden = NO;
            _markGroundImage4.hidden = NO;
            _markGroundImage5.hidden = NO;
            _markGroundImage6.hidden = NO;
            
        }
        default:
            break;
    }
    
    
#pragma mark ---- 左边第1个标签
    _markLabel1.text = markStr1;
    _markLabel1.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
    _markLabel1.textColor = [UIColor whiteColor];
    _markLabel1.backgroundColor = [UIColor clearColor];
    _markLabel1.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_markLabel1 sizeToFit];
    _markGroundImage1.frame = CGRectMake(0, 0, _markLabel1.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage1.image = [UIImage imageNamed:@"标签_内容背景"];
    _markHeaderImage1.frame = CGRectMake(_markGroundImage1.frame.origin.x+_markGroundImage1.frame.size.width, 0, WScale(7.5), HScale(4.6));
    _markHeaderImage1.image = [UIImage imageNamed:@"标签头__左"];
    
    _markView1.frame = CGRectMake(0 - _markGroundImage1.frame.size.width - WScale(7.5), 0, _markGroundImage1.frame.size.width + WScale(7.5), HScale(4.6));
    
#pragma mark ---- 左边第2个标签
    _markLabel2.text = markStr2;
    _markLabel2.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
    _markLabel2.textColor = [UIColor whiteColor];
    _markLabel2.backgroundColor = [UIColor clearColor];
    _markLabel2.font = [UIFont systemFontOfSize:kHorizontal(13.f)];
    [_markLabel2 sizeToFit];
    _markGroundImage2.frame = CGRectMake(0, 0, _markLabel2.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage2.image = [UIImage imageNamed:@"标签_内容背景"];
    
    UILabel *testLable = [[UILabel alloc] init];
    testLable.font = [UIFont systemFontOfSize:kHorizontal(12)];
    
    _markHeaderImage2.frame = CGRectMake(_markGroundImage1.frame.origin.x+_markGroundImage2.frame.size.width, 0, WScale(7.5), HScale(4.6));
    
    _markHeaderImage2.image = [UIImage imageNamed:@"标签头__左"];
    
    _markView2.frame = CGRectMake(0 - _markGroundImage2.frame.size.width - WScale(7.5), _markView1.bottom+HScale(2.2), _markGroundImage2.frame.size.width + WScale(7.5), HScale(4.6));
    
#pragma mark ---- 左边第3个标签
    _markLabel5.text = markStr6;
    _markLabel5.frame = CGRectMake(WScale(2.9), HScale(1), 10, HScale(2.4));
    _markLabel5.textColor = [UIColor whiteColor];
    _markLabel5.backgroundColor = [UIColor clearColor];
    _markLabel5.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_markLabel5 sizeToFit];
    _markGroundImage5.frame = CGRectMake(0, 0, _markLabel5.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage5.image = [UIImage imageNamed:@"标签_内容背景"];
    
    _markHeaderImage5.frame = CGRectMake(_markGroundImage5.frame.origin.x+_markGroundImage5.frame.size.width, 0,WScale(7.5), HScale(4.6));
    _markHeaderImage5.image = [UIImage imageNamed:@"标签头__左"];
    _markView5.frame = CGRectMake(0 - _markGroundImage5.frame.size.width - WScale(7.5), _markView2.bottom + HScale(2.2), _markGroundImage5.frame.size.width + WScale(7.5), HScale(4.6));
    
#pragma mark ---- 右边第1个标签
    _markLabel3.text = markStr3;
    testLable.text = _markLabel3.text;
    [testLable sizeToFit];
    _markLabel3.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
    _markLabel3.textColor = [UIColor whiteColor];
    _markLabel3.backgroundColor = [UIColor clearColor];
    _markLabel3.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _markLabel3.textAlignment = NSTextAlignmentRight;
    
    _markGroundImage3.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage3.image = [UIImage imageNamed:@"标签_内容背景"];
    
    _markHeaderImage3.frame = CGRectMake(_markGroundImage3.frame.origin.x-WScale(7.5), 0, WScale(7.5), HScale(4.6));
    
    _markHeaderImage3.image = [UIImage imageNamed:@"标签头__右"];
    
    _markView3.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView1.y, _markGroundImage3.frame.size.width + WScale(7.5), HScale(4.6));
    
#pragma mark ---- 右边第2个标签
    _markLabel4.text = markStr4;
    testLable.text = _markLabel4.text;
    [testLable sizeToFit];
    
    
    _markLabel4.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
    _markLabel4.textColor = [UIColor whiteColor];
    _markLabel4.backgroundColor = [UIColor clearColor];
    _markLabel4.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _markLabel4.textAlignment = NSTextAlignmentRight;
    
    _markGroundImage4.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage4.image = [UIImage imageNamed:@"标签_内容背景"];
    
    
    _markHeaderImage4.frame = CGRectMake(_markGroundImage4.frame.origin.x - WScale(7.5), 0, WScale(7.5), HScale(4.6));
    
    _markHeaderImage4.image = [UIImage imageNamed:@"标签头__右"];
    _markView4.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView2.y, _markGroundImage4.frame.size.width + WScale(7.5), HScale(4.6));
    
    
#pragma mark ---- 右边第3个标签
    _markLabel6.text = markStr5;
    testLable.text = _markLabel6.text;
    [testLable sizeToFit];
    
    _markLabel6.frame = CGRectMake(WScale(2.9), HScale(1), testLable.frame.size.width, HScale(2.4));
    _markLabel6.textColor = [UIColor whiteColor];
    _markLabel6.backgroundColor = [UIColor clearColor];
    _markLabel6.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _markLabel6.textAlignment = NSTextAlignmentRight;
    
    _markGroundImage6.frame = CGRectMake(0, 0, testLable.frame.size.width+WScale(5.8), HScale(4.6));
    _markGroundImage6.image = [UIImage imageNamed:@"标签_内容背景"];
    _markHeaderImage6.frame = CGRectMake(_markGroundImage6.frame.origin.x - WScale(7.5), 0, WScale(7.5), HScale(4.6));
    _markHeaderImage6.image = [UIImage imageNamed:@"标签头__右"];
    _markView6.frame = CGRectMake(ScreenWidth+WScale(7.5), _markView5.y, _markGroundImage6.frame.size.width + WScale(7.5), HScale(4.6));

    
    
    // 标签工具1
    CGPoint centerEnd1 = CGPointMake(_markView1.width/2, _markView1.y+_markView1.height/2);
    MarkItem *item1 = [MarkItem itemWithView:_markView1 centerStart:_markView1.center centerEnd:centerEnd1];
    // 标签工具2
    CGPoint centerEnd2 = CGPointMake(_markView2.width/2, _markView2.y+_markView2.height/2);
    MarkItem *item2 = [MarkItem itemWithView:_markView2 centerStart:_markView2.center centerEnd:centerEnd2];
    // 标签工具5
    CGPoint centerEnd5 = CGPointMake(_markView5.width/2, _markView5.y+_markView5.height/2);
    MarkItem *item5 = [MarkItem itemWithView:_markView5 centerStart:_markView5.center centerEnd:centerEnd5];
    
    // 标签工具3
    CGPoint centerEnd3 = CGPointMake(self.right-_markView3.width/2+WScale(7.5), _markView1.y+_markView3.height/2);
    MarkItem *item3 = [MarkItem itemWithView:_markView3 centerStart:_markView3.center centerEnd:centerEnd3];
    // 标签工具4
    CGPoint centerEnd4 = CGPointMake(self.right-_markView4.width/2+WScale(7.5), _markView2.y+_markView4.height/2);
    MarkItem *item4 = [MarkItem itemWithView:_markView4 centerStart:_markView4.center centerEnd:centerEnd4];
    // 标签工具6
    CGPoint centerEnd6 = CGPointMake(self.right-_markView6.width/2+WScale(7.5), _markView5.y+_markView6.height/2);
    MarkItem *item6 = [MarkItem itemWithView:_markView6 centerStart:_markView6.center centerEnd:centerEnd6];
    
    _markItemsArray = @[item1, item2, item3, item4, item5, item6];
}



@end
