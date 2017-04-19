//
//  SelectPoleView.m
//  Select
//
//  Created by shiyingdong on 16/8/9.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "SelectPoleView.h"

@implementation SelectPoleView


-(instancetype)initWithFrame:(CGRect)frame dataDict:(NSDictionary *)dic{
    
    self = [super initWithFrame:frame];
    if (self) {
        @synchronized (self) {
            _dataDict = [NSDictionary dictionaryWithDictionary:dic];
            [self createUI];
        }
    }
    return self;

}





-(void)createUI{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    __weak typeof(self) weakself = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakself dissMiss];
    
    }];
    [backView addGestureRecognizer:tap];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.3;
    [self addSubview:backView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(65)+(ScreenWidth - kWvertical(54))/5*4.5)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 3;
    [self addSubview:whiteView];
    
    
    UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHvertical(37), kWvertical(14), kHvertical(14))];
    flagView.image = [UIImage imageNamed:@"scoring球洞旗"];
    
    UILabel *pole = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(30), kWvertical(40), kHvertical(25)) textColor:rgba(61,61,61,1) fontSize:kHorizontal(18) Title:@"球洞"];
    [pole sizeToFit];
    
    flagView.frame = CGRectMake((ScreenWidth - flagView.width - pole.width - kWvertical(7))/2, kHvertical(37),kWvertical(14), kHvertical(14));
    pole.frame = CGRectMake(flagView.x_width + kWvertical(7), kHvertical(30), pole.width, kHvertical(25));
    
    [whiteView addSubview:flagView];
    [whiteView addSubview:pole];
    
    
    UIButton *closeBtn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth - kWvertical(50), 0, kWvertical(50), kHvertical(60)) image:[UIImage imageNamed:@"scoring退出"] target:self selector:@selector(dissMiss) Title:nil];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(kHvertical(35), kWvertical(20), kHvertical(10), kWvertical(15))];
    
    [whiteView addSubview:closeBtn];
    
    
    NSArray *poleNameArray = [_dataDict objectForKey:@"poleNameArray"];
    NSArray *ParArray = [_dataDict objectForKey:@"ParArray"];
    NSArray *selectArray =  [_dataDict objectForKey:@"selectArray"];
    NSString *index = [_dataDict objectForKey:@"index"];
    NSString *selectIndex = index;
    for (int y = 0; y<4; y++) {
        for (int x = 0; x<5; x++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
            [btn setBackgroundColor:WhiteColor];
            btn.frame = CGRectMake(kWvertical(27) + (ScreenWidth - kWvertical(54))/5*x, kHvertical(65)+(ScreenWidth - kWvertical(54))/5*y, (ScreenWidth - kWvertical(54))/5, (ScreenWidth - kWvertical(54))/5);
            NSString *poleNumStr = [NSString string];
            NSString *t0 = [NSString string];
            NSString *t1 = [NSString string];
            
            NSDictionary *attrTitleDict0 = @{
                                             NSFontAttributeName: [UIFont systemFontOfSize:kHorizontal(13)],
                                             NSForegroundColorAttributeName:rgba(85,85,85,1)
                                             };
            NSDictionary *attrTitleDict1 = @{
                                             NSFontAttributeName: [UIFont systemFontOfSize:kHorizontal(11)],
                                             NSForegroundColorAttributeName: rgba(164,164,164,1)
                                             };
            if (x==4&&y==1) {
                t0 = @"OUT";
                attrTitleDict0 = @{
                                   NSFontAttributeName: [UIFont systemFontOfSize:kHorizontal(14)],
                                   NSForegroundColorAttributeName: rgba(105,105,105,1)
                                   };
            }else if (x==4&&y==3){
                t0 = @"IN";
                attrTitleDict0 = @{
                                   NSFontAttributeName: [UIFont systemFontOfSize:kHorizontal(14)],
                                   NSForegroundColorAttributeName: rgba(105,105,105,1)
                                   };
            }else if (y<2) {
                int index = x + 5*y;
                poleNumStr = [NSString stringWithFormat:@"%d",index];
                t0 = [NSString stringWithFormat:@"%@",poleNameArray[index]];
                t1 = [NSString stringWithFormat:@"\nPAR%@",ParArray[index]];
                selectIndex = [NSString stringWithFormat:@"%d",[poleNumStr intValue]+1];

            }else{
                int index = x + 5*y - 1;
                poleNumStr = [NSString stringWithFormat:@"%d",index+1];
                t0 =[NSString stringWithFormat:@"%@",poleNameArray[index]];
                t1 = [NSString stringWithFormat:@"\nPAR%@",ParArray[index]];
                
                selectIndex = [NSString stringWithFormat:@"%d",[poleNumStr intValue]];
            }
            NSInteger poleNum = [poleNumStr integerValue];
            NSInteger indexInteger = [index integerValue];
            if ([poleNumStr integerValue]>=10) {
                poleNum = poleNum - 1;
            }
            if (poleNum == indexInteger) {
                if (poleNumStr.length>0) {
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = kWvertical(4);
                    [btn setBackgroundColor:rgba(237,246,255,1)];
                }
            }
            for (int i = 0; i<selectArray.count; i++) {
                if ([selectIndex isEqualToString:selectArray[i]]) {
                    if ([t0 isEqualToString:@"IN"]||[t0 isEqualToString:@"OUT"]) {
                    }else{
                    attrTitleDict0 = @{
                                       NSFontAttributeName: [UIFont systemFontOfSize:kHorizontal(14)],
                                       NSForegroundColorAttributeName: rgba(53,141,227,1)
                                       };
                    }
            
                }
            }
            NSAttributedString *attrStr0 = [[NSAttributedString alloc] initWithString: [t0 substringWithRange: NSMakeRange(0, t0.length)] attributes: attrTitleDict0];
            NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: [t1 substringWithRange: NSMakeRange(0, t1.length)] attributes: attrTitleDict1];

            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr0];
            [attributedStr appendAttributedString:attrStr1];
            [btn setAttributedTitle:attributedStr forState:UIControlStateNormal];
            btn.titleLabel.numberOfLines = 0;
            [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [btn addTarget:self action:@selector(DidSelect:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:btn];
        }
    }
}


-(void)dissMiss{
    [self removeFromSuperview];
}

//洞号选择
-(void)DidSelect:(UIButton *)Btn{
    UIView *backView = (UIView *)[self.subviews objectAtIndex:1];
    for (int i = 0; i<backView.subviews.count-1; i++) {
        UIButton *selectBtn = (UIButton *)[backView.subviews objectAtIndex:i];
        if ([Btn isEqual:selectBtn]) {
            if (i==12||i==22) {
                return;
            }
            [self dissMiss];
            if (i>12) {
                _indexBlock(i-4);
            }else{
                _indexBlock(i-3);
            }
        }
    }
}

@end
