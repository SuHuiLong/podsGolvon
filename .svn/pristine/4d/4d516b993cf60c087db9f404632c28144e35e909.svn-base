//
//  HomePageCollectionViewCell.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "HomePageCollectionViewCell.h"
#import "Masonry.h"
#import "UIView+Size.h"
#import "UIImageView+WebCache.h"

@implementation HomePageCollectionViewCell
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
    _coverImage.frame = CGRectMake(0, 0, self.width, self.width);
    [self.contentView addSubview:_coverImage];
    
    //蒙版
    _mask = [[UIImageView alloc] init];
    _mask.hidden = YES;
    _mask.image = [UIImage imageNamed:@"HomePageMask_Top"];
    _mask.frame = CGRectMake(0, 0, self.width, kHvertical(43));
    [self.contentView addSubview:_mask];
    
    //正在进行的标志
    _playingImage = [[UIImageView alloc]init];
    _playingImage.hidden = YES;
    _playingImage.image = [UIImage imageNamed:@"直播记分首页底色"];
    _playingImage.frame = CGRectMake(0, kHvertical(8), kWvertical(82) , kHvertical(21) );
    [self.contentView addSubview:_playingImage];
    
    _bezelImage = [[UIImageView alloc]init];
    _bezelImage.image = [UIImage imageNamed:@"scoringPlay_small"];
    _bezelImage.frame = CGRectMake(kWvertical(4), kHvertical(3), kWvertical(15) , kWvertical(15));
    [_playingImage addSubview:_bezelImage];
    
    _playImage = [[UIImageView alloc]init];
    _playImage.image = [UIImage imageNamed:@"scoringCenter_small"];
    _playImage.frame = CGRectMake(kWvertical(5), kHvertical(4), kWvertical(13) , kWvertical(13));
    [_playingImage addSubview:_playImage];
    
    _scroingLabel = [[UILabel alloc]init];
    _scroingLabel.text = @"直播记分";
    _scroingLabel.textColor = [UIColor whiteColor];
    _scroingLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _scroingLabel.frame = CGRectMake(kWvertical(25) , kHvertical(3), kWvertical(44) , kHvertical(16) );
    [_scroingLabel sizeToFit];
    [_playingImage addSubview:_scroingLabel];
    
    _loadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loadingBtn.backgroundColor = ClearColor;
    _loadingBtn.frame = CGRectMake(0, 0, 100, 50);
    [_loadingBtn addTarget:self action:@selector(clickToLoadingBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loadingBtn];
    
    //访问量
    _accessMent = [[UILabel alloc] init];
    [_mask addSubview:_accessMent];
    
    _accessImageView = [[UIImageView alloc] init];
    _accessImageView.image = [UIImage imageNamed:@"iconfont-yanjing"];
    [_mask addSubview:_accessImageView];
    
    //昵称
    _nickName = [[UILabel alloc]init];
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(12.5)];
    _nickName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nickName];
    
    //性别
    _sexImage = [[UIImageView alloc]init];
    _sexImage.clipsToBounds = YES;
    _sexImage.layer.cornerRadius = kWvertical(13)/2;
    [self.contentView addSubview:_sexImage];
    
    //专访
    _Vimage = [[UIImageView alloc]init];
    _Vimage.image = [UIImage imageNamed:@"专访v"];
    _Vimage.hidden = YES;
    _Vimage.clipsToBounds = YES;
    _Vimage.layer.cornerRadius = kWvertical(13)/2;
    [self.contentView addSubview:_Vimage];
    
    _siignature = [[UILabel alloc]init];
    _siignature.textColor = GPColor(135, 135, 135);
    
    if (Device >= 9.0) {
        _siignature.font = [UIFont fontWithName:Light size:kHorizontal(12)];
    }else{
        _siignature.font = [UIFont systemFontOfSize:kHorizontal(12)];
    }
    
    [self.contentView addSubview:_siignature];
    
    _maskView = [[UIImageView alloc]init];
    _maskView.frame = CGRectMake(0, kHvertical(136), self.width, kHvertical(61));
    
    _maskView.hidden = YES;
    _maskView.image = [UIImage imageNamed:@"HomePageMask"];
    [self.contentView addSubview:_maskView];
    
    
    
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
    
    _work.frame = CGRectMake(0, kHvertical(167) , self.width/3-1, kHvertical(14) );
    
    _line1.frame = CGRectMake(_work.right+1, kHvertical(170) , 1, kHvertical(9));
    _poleNumber.frame = CGRectMake(_line1.right, kHvertical(167) , self.width/3-1, kHvertical(14));
    _line2.frame = CGRectMake(_poleNumber.right+1, kHvertical(170) , 1, kHvertical(9));
    _address.frame = CGRectMake(_line2.right, kHvertical(167) , self.width/3-2, kHvertical(14));
    
    [self.contentView addSubview:_work];
    [self.contentView addSubview:_address];
    [self.contentView addSubview:_poleNumber];
    [self.contentView addSubview:_line1];
    [self.contentView addSubview:_line2];
}

-(void)relayoutWithModel:(CollectionCardModel *)model{
    self.model = model;

    [_coverImage setCardImageStr:model.picture_url];
    
    _coverImage.clipsToBounds = YES;
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    
    _maskView.hidden = NO;
    _mask.hidden = NO;
    

//    浏览量
    UILabel *test = [[UILabel alloc]init];
    test.text = [NSString stringWithFormat:@"%@",model.access_amount];
    test.frame = CGRectMake(ScreenWidth - kWvertical(8)-200, kHvertical(10), 200, kHvertical(8));
    test.font = [UIFont systemFontOfSize:kHorizontal(10)];
    [test sizeToFit];
    
    _accessMent.textAlignment = NSTextAlignmentRight;
    _accessMent.text = test.text;
    _accessMent.textColor = WhiteColor;
    _accessMent.font = [UIFont systemFontOfSize:kHorizontal(10)];
    _accessMent.frame = CGRectMake(self.contentView.width - test.width - kWvertical(8), test.top, test.width, kHvertical(10));
    
    _accessImageView.frame = CGRectMake(_accessMent.left-WScale(4), test.top+kHvertical(1.5), WScale(3), WScale(2));
//    杆数
    _poleNumber.text = model.pole_number;
//    昵称
    UILabel *nameTest = [[UILabel alloc]init];
    nameTest.text = model.nickname;
    nameTest.frame = CGRectMake(0, _maskView.bottom + kHvertical(9), ScreenWidth, kHvertical(12));
    nameTest.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [nameTest sizeToFit];
    
    _nickName.text = nameTest.text;
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _nickName.textAlignment = NSTextAlignmentCenter;
    
//    签名
    _siignature.text = model.siignature;
    _siignature.textAlignment = NSTextAlignmentCenter;
    
    if ([model.gender isEqualToString:@"女"]) {
        _sexImage.image = [UIImage imageNamed:@"女（首页）"];
    }else{
        _sexImage.image = [UIImage imageNamed:@"男（首页）"];
    }
    
    if ([model.interview_state isEqualToString:@"0"]) {
        
        _Vimage.hidden = YES;
        
        _nickName.frame = CGRectMake((self.contentView.width - nameTest.width)/2 - kWvertical(10), _maskView.bottom + kHvertical(9), nameTest.width, kHvertical(20) );
    }else{
        
        _Vimage.hidden = NO;
        _nickName.frame = CGRectMake((self.contentView.width - nameTest.width)/2 - kWvertical(14), _maskView.bottom + kHvertical(9), nameTest.width, kHvertical(20) );
    }
    _sexImage.frame = CGRectMake(_nickName.right + kWvertical(4), _maskView.bottom + kHvertical(14) , kWvertical(13), kWvertical(13));
    
    _Vimage.frame = CGRectMake(_sexImage.right + kWvertical(4), _maskView.bottom + kHvertical(14) , kWvertical(13), kWvertical(13));
    
    _siignature.frame = CGRectMake(kWvertical(8), _nickName.bottom + kHvertical(7), self.contentView.width-kWvertical(16), kHvertical(17) );
    
    
    //是否有正在进行
    if ([model.group_id isEqualToString:@"0"]) {
        _playingImage.hidden = YES;
        _loadingBtn.hidden = YES;
    }else{
        _playingImage.hidden = NO;
        _loadingBtn.hidden = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CABasicAnimation *rotationAnim = [CABasicAnimation animation];
            rotationAnim.keyPath = @"transform.rotation.z";
            rotationAnim.toValue = @(2 * M_PI);
            rotationAnim.duration = 5;
            rotationAnim.cumulative = YES;
            rotationAnim.repeatCount = HUGE_VALF;
            rotationAnim.removedOnCompletion = NO;
            [_bezelImage.layer addAnimation:rotationAnim forKey:nil];
        });

    }

    
    _work.text = model.province;
    _poleNumber.text = model.pole_number;
    _address.text = model.work_content;
    
    
    _work.textAlignment       = NSTextAlignmentCenter;
    _address.textAlignment    = NSTextAlignmentCenter;
    _poleNumber.textAlignment = NSTextAlignmentCenter;
}

-(void)clickToLoadingBtn{
    
    if (self.LoadingBlock) {
        (self.LoadingBlock)(self.model);
        
    }
}
@end
