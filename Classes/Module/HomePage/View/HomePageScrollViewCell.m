//
//  HomePageScrollViewCell.m
//  podsGolvon
//
//  Created by suhuilong on 16/9/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "HomePageScrollViewCell.h"


#import "Masonry.h"
#import "UIView+Size.h"
#import "UIImageView+WebCache.h"

float const kCustomEditCellHorizontalMargin = 3; ///< 水平边距
float const kCustomEditCellVerticalMargin = 3; ///< 垂直边距
@implementation HomePageScrollViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    //头像
    _coverImage = [[UIImageView alloc]init];
    _coverImage.frame = CGRectMake(0, 0, self.width, self.width*ScreenScale);
    [self addSubview:_coverImage];
    
    //蒙版
    UIImageView *mask = [[UIImageView alloc] init];
    mask.image = [UIImage imageNamed:@"HomePageMask_Top"];
    mask.frame = CGRectMake(0, 0, self.width, kHvertical(43));
    [self addSubview:mask];
    
    /** 正在进行*/
    _ingImage = [[UIImageView alloc]init];
    _ingImage.image = [UIImage imageNamed:@"正在记分（首页）"];
    _ingImage.frame = CGRectMake(0, kHvertical(10)*ScreenScale, kWvertical(64), kWvertical(18)*ScreenScale);
    _ingImage.hidden = YES;
    [mask addSubview:_ingImage];
    
    //访问量
    _accessMent = [[UILabel alloc] init];
    [mask addSubview:_accessMent];
    
    //昵称
    _nickName = [[UILabel alloc]init];
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(12.5)];
    _nickName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nickName];
    
    //性别
    _sexImage = [[UIImageView alloc]init];
    [self addSubview:_sexImage];
    
    //专访
    _Vimage = [[UIImageView alloc]init];
    _Vimage.image = [UIImage imageNamed:@"专访v"];
    _Vimage.hidden = YES;
    [self addSubview:_Vimage];
    
    _siignature = [[UILabel alloc]init];
    if (Device >= 9.0) {
        _siignature.font = [UIFont fontWithName:Light size:kHorizontal(12)];
    }else{
        _siignature.font = [UIFont systemFontOfSize:kHorizontal(12)];
    }
    _siignature.textColor = GPColor(135, 135, 135);
    [self addSubview:_siignature];
    
    _maskView = [[UIImageView alloc]init];
    _maskView.frame = CGRectMake(0, kHvertical(136)*ScreenScale, self.width, kHvertical(61)*ScreenScale);
    _maskView.image = [UIImage imageNamed:@"HomePageMask"];
    [self addSubview:_maskView];
    
    
    
    //职业
    _work       = [[UILabel alloc]init];
    _poleNumber = [[UILabel alloc]init];
    _address    = [[UILabel alloc]init];
    _line1      = [[UIView alloc]init];
    _line2      = [[UIView alloc]init];
    
    
    _work.textColor        = [UIColor whiteColor];
    _poleNumber.textColor  = [UIColor whiteColor];
    _address.textColor     = [UIColor whiteColor];
    _line1.backgroundColor = [UIColor whiteColor];
    _line2.backgroundColor = [UIColor whiteColor];
    
    
    
    
    _work.font                = [UIFont systemFontOfSize:kHorizontal(10)];
    _address.font             = [UIFont systemFontOfSize:kHorizontal(10)];
    _poleNumber.font          = [UIFont systemFontOfSize:kHorizontal(10)];
    
    _work.frame = CGRectMake(0, kHvertical(167)*ScreenScale, self.width/3-1, kHvertical(14));
    
    _line1.frame = CGRectMake(_work.right+1, kHvertical(170)*ScreenScale, 1, kHvertical(9));
    _poleNumber.frame = CGRectMake(_line1.right, kHvertical(167)*ScreenScale, self.width/3-1, kHvertical(14));
    _line2.frame = CGRectMake(_poleNumber.right+1, kHvertical(170)*ScreenScale, 1, kHvertical(9));
    _address.frame = CGRectMake(_line2.right, kHvertical(167)*ScreenScale, self.width/3-2, kHvertical(14));
    
    [self addSubview:_work];
    [self addSubview:_address];
    [self addSubview:_poleNumber];
    [self addSubview:_line1];
    [self addSubview:_line2];
    
    
}

-(void)relayoutWithModel:(CollectionCardModel *)model{
    
    [_coverImage setImageURLString:model.pic600Url];
    
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    _coverImage.clipsToBounds = YES;
    
    
    
    UILabel *test = [[UILabel alloc]init];
    test.text = [NSString stringWithFormat:@"%@浏览",model.access_amount];
    test.frame = CGRectMake(ScreenWidth - kWvertical(8)-200, kHvertical(10), 200, kHvertical(8));
    test.font = [UIFont systemFontOfSize:kHorizontal(10)];
    [test sizeToFit];
    
    _accessMent.textAlignment = NSTextAlignmentRight;
    _accessMent.text = test.text;
    _accessMent.textColor = WhiteColor;
    _accessMent.font = [UIFont systemFontOfSize:kHorizontal(10)];
    _accessMent.frame = CGRectMake(self.width - test.width - kWvertical(8), test.top * ScreenScale, test.width, kHvertical(8));
    _poleNumber.text = model.pole_number;
    
    UILabel *nameTest = [[UILabel alloc]init];
    nameTest.text = model.nickname;
    nameTest.frame = CGRectMake(0, _maskView.bottom + kHvertical(9), ScreenWidth, kHvertical(12));
    nameTest.font = [UIFont systemFontOfSize:kHorizontal(12.5)];
    [nameTest sizeToFit];
    
    _nickName.text = nameTest.text;
    _nickName.frame = CGRectMake((self.width - nameTest.width)/2, _maskView.bottom + kHvertical(9), nameTest.width, kHvertical(20)*ScreenScale);
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(12.5)];
    _nickName.textAlignment = NSTextAlignmentCenter;
    
    _siignature.text = model.siignature;
    _siignature.textAlignment = NSTextAlignmentCenter;
    _siignature.frame = CGRectMake(kWvertical(8), _nickName.bottom + kHvertical(7), self.width-kWvertical(16), kHvertical(17)*ScreenScale);
    
    _sexImage.frame = CGRectMake(_nickName.right + kWvertical(4), _maskView.bottom + kHvertical(16), kWvertical(7), kWvertical(7));
    if ([model.gender isEqualToString:@"0"]) {
        _sexImage.image = [UIImage imageNamed:@"女"];
    }else{
        _sexImage.image = [UIImage imageNamed:@"男"];
    }
    
    _Vimage.frame = CGRectMake(_sexImage.right + kWvertical(4), _maskView.bottom + kHvertical(16), kWvertical(7), kWvertical(7));
    if ([model.interview_state isEqualToString:@"0"]) {
        _Vimage.hidden = YES;
    }else{
        _Vimage.hidden = NO;
    }
    
    if ([model.groupStatr isEqualToString:@"0"]) {
        _ingImage.hidden = YES;
    }else{
        
        
        _ingImage.hidden = NO;
    }
    
    _work.text = model.work_content;
    _poleNumber.text = model.pole_number;
    _address.text = model.city;
    
    
    _work.textAlignment       = NSTextAlignmentCenter;
    _address.textAlignment    = NSTextAlignmentCenter;
    _poleNumber.textAlignment = NSTextAlignmentCenter;
    
    
}
@end
