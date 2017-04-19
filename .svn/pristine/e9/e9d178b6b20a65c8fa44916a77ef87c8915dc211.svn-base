//
//  SignaturesViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "SignaturesViewController.h"
#import "ShlTextView.h"
#import "HomePageViewController.h"
#import "TabBarViewController.h"

@interface SignaturesViewController ()<UITextViewDelegate>

@property (strong, nonatomic) UITextView      *signaturesTextView;

@property (strong, nonatomic) UIView      *groundView;

@property (strong, nonatomic) UIView      *bottomView;

@property (copy, nonatomic) NSString    *selectedStr;

@property (copy, nonatomic) NSString    *selectedLabelID;

@property (strong, nonatomic) UILabel      *limitLabel;

@property (strong, nonatomic) UILabel      *placeStr;

@property (strong, nonatomic) UIButton     *completeBtn;

@property (strong, nonatomic) NSMutableArray      *unSelectedArr;

@property (strong, nonatomic) NSMutableArray      *selectedArr;
@property (strong, nonatomic) NSMutableArray      *selectedIDArr;

@property (strong, nonatomic) DownLoadDataSource      *loadData;

@property (strong, nonatomic) NSMutableAttributedString *attributedStr;

@property (assign, nonatomic) int    limitNum;

@property (strong, nonatomic) UILabel      *chooselabel;

@property (strong, nonatomic) UIView      *placeView;

@property (strong, nonatomic) UIButton      *changeBtn;


@end

@implementation SignaturesViewController

-(NSMutableArray *)unSelectedArr{
    if (!_unSelectedArr) {
        _unSelectedArr = [[NSMutableArray alloc] init];
    }
    return _unSelectedArr;
}
-(NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = [[NSMutableArray alloc] init];
    }
    return _selectedArr;
}
-(NSMutableArray *)selectedIDArr{
    if (!_selectedIDArr) {
        _selectedIDArr = [[NSMutableArray alloc] init];
    }
    return _selectedIDArr;
}
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestDataArr];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    _limitNum = 0;
    
    [self createCompleteBtn];
}

#pragma mark ---- UI
-(void)createSubview{
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 20, 44, 44);
//    [backBtn addTarget:self action:@selector(returnVC) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:[UIImage imageNamed:@"BlackBack"] forState:UIControlStateNormal];
//    [self.view addSubview:backBtn];
    
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.frame = CGRectMake(ScreenWidth - 44, 20, 44, 44);
    [skipBtn setTitleColor:localColor forState:UIControlStateNormal];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    [skipBtn addTarget:self action:@selector(skipVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"签名&标签";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(20)];
    titleLabel.frame = CGRectMake(0, kHvertical(67), ScreenWidth, kHvertical(28));
    [self.view addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"个性签名";
    contentLabel.frame = CGRectMake(kWvertical(20), titleLabel.bottom + kHvertical(27), kWvertical(100), kHvertical(18));
    contentLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    contentLabel.textColor = GPColor(69, 69, 69);
    [self.view addSubview:contentLabel];
    
//    输入框
    _signaturesTextView = [[UITextView alloc] init];
    _signaturesTextView.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _signaturesTextView.frame = CGRectMake(kWvertical(16), contentLabel.bottom+kHvertical(10), ScreenWidth - kWvertical(34), kHvertical(149));
    _signaturesTextView.delegate = self;
    _signaturesTextView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_signaturesTextView];
    
    
    _placeStr = [[UILabel alloc] init];
    _placeStr.text = @"请输入你的个性签名（左下角提供一键填写!）";
    _placeStr.textColor = [UIColor lightGrayColor];
    _placeStr.frame = CGRectMake(2, 4, _signaturesTextView.width, kHorizontal(20));
    _placeStr.hidden = NO;
    _placeStr.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_signaturesTextView addSubview:_placeStr];

    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, kHvertical(100), kWvertical(80), kHvertical(40));
    [setBtn setTitle:@"一键填写" forState:UIControlStateNormal];
    [setBtn setTitleColor:localColor forState:UIControlStateNormal];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [setBtn addTarget:self action:@selector(randomSignatures) forControlEvents:UIControlEventTouchUpInside];
    [_signaturesTextView addSubview:setBtn];
    
//    限制字符
    _limitLabel = [[UILabel alloc] init];
    _limitLabel.frame = CGRectMake(_signaturesTextView.width - kWvertical(80), setBtn.y, kWvertical(80), kHvertical(40));
    _limitLabel.textColor = localColor;
    _limitLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _limitLabel.text = [NSString stringWithFormat:@"%d/100",_limitNum];
    _attributedStr = [[NSMutableAttributedString alloc] initWithString:_limitLabel.text];
    [_attributedStr addAttribute:NSForegroundColorAttributeName value:LightGrayColor range:NSMakeRange(_attributedStr.length-4, 4)];
    _limitLabel.textAlignment = NSTextAlignmentRight;
    _limitLabel.attributedText = _attributedStr;
    [_signaturesTextView addSubview:_limitLabel];
    
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, _signaturesTextView.bottom, ScreenWidth, 5);
    line.backgroundColor = SeparatorColor;
    [self.view addSubview:line];
    [self createTagView];
    
}
//创建未选中的标签
-(void)createTagView{
    
    [_chooselabel removeFromSuperview];
    _chooselabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(20), _signaturesTextView.bottom + kHvertical(13), kWvertical(200), kHvertical(18))];
    _chooselabel.text = @"选择标签(可选6个)";
    _chooselabel.textColor = GPColor(69, 69, 69);
    _chooselabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    NSMutableAttributedString *attributed1 = [[NSMutableAttributedString alloc]initWithString:_chooselabel.text];
    [attributed1 addAttribute:NSForegroundColorAttributeName value:NAVLINECOLOR range:NSMakeRange(attributed1.length-6, 6)];
    _chooselabel.attributedText = attributed1;
    [self.view addSubview:_chooselabel];
    
 
    [_placeView removeFromSuperview];
    _placeView=[[UIView alloc]init];
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    for (int i = 0; i < self.unSelectedArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = [self.unSelectedArr[i][@"lid"]intValue];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        NSString *str = self.unSelectedArr[i][@"content"];
        
        CGSize titleSize = [str boundingRectWithSize:CGSizeMake(999, kHvertical(27)) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        titleSize.width += kWvertical(30);
        //自动的折行
        han = han +titleSize.width+kWvertical(18);
        if (han > [[UIScreen mainScreen]bounds].size.width) {
            han = 0;
            han = han + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(kWvertical(18),kHvertical(40)*height, titleSize.width, kHvertical(24));
        }else{
            button.frame = CGRectMake(width+kWvertical(18)+(number*kWvertical(15)), kHvertical(40)*height, titleSize.width, kHvertical(27));
            width = width+titleSize.width;
        }
        number++;
        button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = kWvertical(15);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderWidth = 1;
        button.layer.borderColor = LightGrayColor.CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        [button setTitleColor:GRYTEXTCOLOR forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateNormal];
        
        _placeView.frame = CGRectMake(0, _chooselabel.bottom + kHvertical(16), ScreenWidth,  han/2);
        [_placeView addSubview:button];
    }
    
    for (UIButton *btn in _placeView.subviews) {
        [btn addTarget:self action:@selector(clickLabelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_placeView];
    
    
    UILabel *seleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(20), _signaturesTextView.bottom + kHvertical(158), kWvertical(200), kHvertical(18))];
    seleLabel.text = @"已选标签";
    seleLabel.textColor = GPColor(69, 69, 69);
    seleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.view addSubview:seleLabel];
    
    [_changeBtn removeFromSuperview];
    _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBtn.frame = CGRectMake(ScreenWidth - kWvertical(70), _chooselabel.y, kWvertical(70), kHvertical(18));
    [_changeBtn setImage:[UIImage imageNamed:@"change_regist"] forState:UIControlStateNormal];
    [_changeBtn setTitle:@"换一组" forState:UIControlStateNormal];
    [_changeBtn setTitleColor:localColor forState:UIControlStateNormal];
    _changeBtn.adjustsImageWhenHighlighted = NO;
    [_changeBtn addTarget:self action:@selector(requestDataArr) forControlEvents:UIControlEventTouchUpInside];
    _changeBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    [self.view addSubview:_changeBtn];
    
    
    if (_selectedArr.count >0 || _signaturesTextView.text.length > 0) {
        
        _completeBtn.selected = YES;
    }else{
        _completeBtn.selected = NO;

    }
    if(_selectedArr.count >= 6){
        [self alertShowView:@"最多选择6个"];
    }
}
-(void)createCompleteBtn{
    
    [_completeBtn removeFromSuperview];
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    _completeBtn.frame = CGRectMake((ScreenWidth - kWvertical(335))/2, ScreenHeight - kHorizontal(62), kWvertical(335), kHvertical(42));
    _completeBtn.layer.masksToBounds = YES;
    _completeBtn.layer.cornerRadius = 3;
    _completeBtn.adjustsImageWhenHighlighted = NO;
    _completeBtn.selected = NO;
    [_completeBtn setBackgroundImage:[self imageWithColor:rgba(53,141,227,0.65)] forState:UIControlStateNormal];
    [_completeBtn setBackgroundImage:[self imageWithColor:localColor] forState:UIControlStateSelected];
    [_completeBtn addTarget:self action:@selector(clickToComplete) forControlEvents:UIControlEventTouchUpInside];
    [_completeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.view addSubview:_completeBtn];
}
-(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    return image;
}
//创建已选的标签
-(void)createSelectedBtn{
    
    [_groundView removeFromSuperview];
    _groundView = [[UIView alloc]init];
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    
    for (int i = 0; i < self.selectedArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *str = _selectedArr[i];
        CGSize titleSize = [str boundingRectWithSize:CGSizeMake(999, kHvertical(27)) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        titleSize.width += kWvertical(40);
        //自动的折行
        han = han +titleSize.width+kWvertical(18);
        if (han > [[UIScreen mainScreen]bounds].size.width) {
            han = 0;
            han = han + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(kWvertical(18),kHvertical(40)*height, titleSize.width, kHvertical(24));
        }else{
            button.frame = CGRectMake(width+kWvertical(18)+(number*kWvertical(15)), kHvertical(40)*height, titleSize.width, kHvertical(27));
            width = width+titleSize.width;
        }
        number++;
        button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = kWvertical(15);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderWidth = 1;
        button.layer.borderColor = localColor.CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        [button setTitleColor:localColor forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"deleteLabel_regist"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(2, button.width-25, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        _groundView.frame = CGRectMake(0, _signaturesTextView.bottom + kHvertical(190), ScreenWidth, kHvertical(115));
//        _groundView.backgroundColor = RedColor;
        [_groundView addSubview:button];
    }
    
    for (UIButton *btn in _groundView.subviews) {
        
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(clickSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_groundView];

    
}
//提示界面
-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
#pragma mark ---- 点击事件

-(void)returnVC{
    if ([self.delegate respondsToSelector:@selector(signaturesSendNameid:)]) {
        [self.delegate signaturesSendNameid:_name_id];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)clickToComplete{
    
    NSDictionary *parmeters;
    if ([_signaturesTextView.text isEqualToString:@""]) {
        _signatureStr = @"空";
    }else{
        _signatureStr = _signaturesTextView.text;
    }
    
    
    NSString *tempID = [self.selectedIDArr componentsJoinedByString:@","];
   
    parmeters = @{@"name_id":_name_id,
                   @"sig":_signatureStr,
                   @"labels":tempID
                   };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=regstage2",apiHeader120] parameters:parmeters complicate:^(BOOL success, id data) {
        if (success) {
            
            [userDefaults setValue:_name_id forKey:@"name_id"];
            [self setViewData];
            
            //获取版本号
            NSString *versionKey = @"CFBundleVersion";
            //上一次使用的版本
//            NSString *lastVersion = [userDefaults objectForKey:versionKey];
            //当前使用的版本
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
            [userDefaults setObject:currentVersion forKey:versionKey];
            TabBarViewController *tbc = [[TabBarViewController alloc] init];
            self.view.window.rootViewController = tbc;
        }else{
            [self alertShowView:@"网络错误"];
        }
    }];

    
}
-(void)skipVC{
    
    [userDefaults setValue:_name_id forKey:@"name_id"];
    [self setViewData];
    
    //获取版本号
    NSString *versionKey = @"CFBundleVersion";
    //上一次使用的版本
//    NSString *lastVersion = [userDefaults objectForKey:versionKey];
    //当前使用的版本
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    [userDefaults setObject:currentVersion forKey:versionKey];
    
    TabBarViewController *tbc = [[TabBarViewController alloc] init];
    self.view.window.rootViewController = tbc;

}

//点击选择标签
- (void)clickLabelButton:(UIButton *)button{
    button.selected = !button.selected;
    
    if (button.selected == NO) {
        
        for (int i = 0; i<_unSelectedArr.count; i++) {
            if (button.tag == [self.unSelectedArr[i][@"lid"] intValue]) {
                _selectedStr = self.unSelectedArr[i][@"content"];
                _selectedLabelID = self.unSelectedArr[i][@"lid"];
                
                [self.selectedIDArr removeObject:_selectedLabelID];
                [self.selectedArr removeObject:_selectedStr];
            }
        }
    }else{
        for (int i = 0; i<_unSelectedArr.count; i++) {
            if (button.tag == [self.unSelectedArr[i][@"lid"] intValue]) {
                _selectedStr = self.unSelectedArr[i][@"content"];
                _selectedLabelID = self.unSelectedArr[i][@"lid"];
                
                [self.selectedIDArr addObject:_selectedLabelID];
                [self.selectedArr addObject:_selectedStr];
            }
            
        }
        
        if (_selectedArr.count >0 || _signaturesTextView.text.length > 0) {
            
            _completeBtn.selected = YES;
        }else{
            _completeBtn.selected = NO;
            
        }
        
        if (_selectedArr.count >= 6) {
            button.enabled = NO;
            [self alertShowView:@"最多选择6个"];
        }
    }
    
    [self createSelectedBtn];
    
}
//点击取消标签
-(void)clickSelected:(UIButton *)sender{
    
    [_selectedArr removeObjectAtIndex:sender.tag];
    if (_selectedArr.count >0 || _signaturesTextView.text.length > 0) {
        
        _completeBtn.selected = YES;
    }else{
        _completeBtn.selected = NO;
        
    }
    [self createSelectedBtn];
    
}
#pragma mark ---- TextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    if (_signaturesTextView.text.length > 0) {
        _placeStr.hidden = YES;
    }else{
        _placeStr.hidden = NO;
    }
    if (_selectedArr.count >0 || _signaturesTextView.text.length > 0) {
        
        _completeBtn.selected = YES;
    }else{
        _completeBtn.selected = NO;

    }
    _limitNum = (unsigned int)textView.text.length;
    _limitLabel.text = [NSString stringWithFormat:@"%d/100",_limitNum];
    _attributedStr = [[NSMutableAttributedString alloc] initWithString:_limitLabel.text];
    [_attributedStr addAttribute:NSForegroundColorAttributeName value:LightGrayColor range:NSMakeRange(_attributedStr.length-4, 4)];
    _limitLabel.attributedText = _attributedStr;
    if (textView.text.length>100) {
        textView.text = [textView.text substringFromIndex:100];
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _placeStr.hidden = YES;
    return YES;
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //判断加上输入的字符，是否超过界限
    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
 
    if (string.length > 100){
        return NO;
    }
    //   限制苹果系统输入法  禁止输入表情
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [_signaturesTextView resignFirstResponder];

        return NO;
    }
    return YES;
}

//判断是否输入了emoji 表情
- (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                    
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }else if (hs == 0x200d){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_signaturesTextView resignFirstResponder];
    if (_signaturesTextView.text.length == 0) {
        _placeStr.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark ---- LoadData
-(void)setViewData{
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc] init];
    
    NSDictionary *dict = @{
                           @"name_id":_name_id,
                           };
    
    [loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_name_id",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            
            NSArray *FristinterviewArr = data[@"data"];
            NSArray *dataArry = data[@"label"];
            
            if (dataArry.count>0) {
                
                [userDefaults setValue:dataArry forKey:@"label"];
                
            }
            if (FristinterviewArr.count==0) {
                return ;
            }
            NSDictionary *temp = FristinterviewArr[0];
            id interViewArr = [temp objectForKey:@"interview"];
            
            //            专访
            if (![interViewArr isKindOfClass:[NSString class]]) {
                NSDictionary *interviewDict = interViewArr[0];
                [userDefaults setValue:interviewDict forKey:@"interviewDict"];
                [userDefaults setValue:[interviewDict objectForKey:@"interview_id"] forKey:@"interview_id"];
                [userDefaults setValue:[interviewDict objectForKey:@"picture_url"] forKey:@"interview_picture_url"];
                
            }
            
            //            基本信息
            [userDefaults setValue:[temp objectForKey:@"siignature"] forKey:@"siignature"];
            [userDefaults setValue:[temp objectForKey:@"access_amount"] forKey:@"access_amount"];
            [userDefaults setValue:[temp objectForKey:@"attention_number"] forKey:@"attention_number"];
            [userDefaults setValue:[temp objectForKey:@"changCi"] forKey:@"changCi"];
            [userDefaults setValue:[temp objectForKey:@"cishan_jiner"] forKey:@"cishan_jiner"];
            [userDefaults setValue:[temp objectForKey:@"city"] forKey:@"city"];
            [userDefaults setValue:[temp objectForKey:@"phone"] forKey:@"phone"];
            [userDefaults setValue:[temp objectForKey:@"examine_state"] forKey:@"examine_state"];
            [userDefaults setValue:[temp objectForKey:@"gender"] forKey:@"gender"];
            [userDefaults setValue:[temp objectForKey:@"befocus"] forKey:@"follow_number"];        //关注
            [userDefaults setValue:[temp objectForKey:@"focus"] forKey:@"attention_number"];       //粉丝
            [userDefaults setValue:[temp objectForKey:@"interview_state"] forKey:@"interview_state"];
            [userDefaults setValue:[temp objectForKey:@"message_number"] forKey:@"message_number"];
            [userDefaults setValue:[temp objectForKey:@"nickname"] forKey:@"nickname"];
            [userDefaults setValue:[temp objectForKey:@"photo"] forKey:@"photo"];
            [userDefaults setValue:[temp objectForKey:@"picture_id"] forKey:@"pic_id"];
            [userDefaults setValue:[temp objectForKey:@"province"] forKey:@"province"];
            [userDefaults setValue:[temp objectForKey:@"label_content"] forKey:@"age"];
            [userDefaults setValue:[temp objectForKey:@"picture_url"] forKey:@"pic"];
            [userDefaults setValue:[temp objectForKey:@"touxiang_url"] forKey:@"coverPic"];
            [userDefaults setValue:[temp objectForKey:@"pole_number"] forKey:@"polenum"];
            [userDefaults setValue:[temp objectForKey:@"work_content"] forKey:@"job"];
            [userDefaults setValue:[temp objectForKey:@"work_fu"] forKey:@"work_fu"];
            [userDefaults setValue:[temp objectForKey:@"zhuaNiao"] forKey:@"zhuaNiao"];
            [userDefaults setValue:[temp objectForKey:@"uid"] forKey:@"uid"];
            
        }else{
            
            
        }
    }];
}

//随机选择签名
-(void)randomSignatures{
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@/commonapi.php?func=randsig",apiHeader120] parameters:nil complicate:^(BOOL success, id data) {
        _placeStr.hidden = YES;
        _signaturesTextView.text = @"";
        if (success) {
            weakself.signaturesTextView.text = data[@"sign"];
            weakself.limitNum = (unsigned int)_signaturesTextView.text.length;
            weakself.limitLabel.text = [NSString stringWithFormat:@"%d/100",_limitNum];
            weakself.attributedStr = [[NSMutableAttributedString alloc] initWithString:_limitLabel.text];
            [weakself.attributedStr addAttribute:NSForegroundColorAttributeName value:LightGrayColor range:NSMakeRange(_attributedStr.length-4, 4)];
            weakself.limitLabel.attributedText = _attributedStr;
            
            if (_signaturesTextView.text.length > 0 || _selectedArr.count > 0) {
                _completeBtn.selected = YES;
            }else{
                _completeBtn.selected = NO;

            }
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
    
}
//
-(void)requestDataArr{
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=randlabel",apiHeader120] parameters:nil complicate:^(BOOL success, id data) {
        if (success) {
            
            [self.unSelectedArr removeAllObjects];
            
            for (NSDictionary *dic in data) {
                
                [self.unSelectedArr addObject:dic];
            }
            [self createSubview];
        }
    }];
}
//-(void)changeDara{
//    
//    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=randlabel",apiHeader120] parameters:nil complicate:^(BOOL success, id data) {
//        if (success) {
//            
//            [self.unSelectedArr removeAllObjects];
//            
//            for (NSDictionary *dic in data) {
//                
//                [self.unSelectedArr addObject:dic];
//            }
//            
//            [self createTagView];
//        }
//    }];
//}

@end
