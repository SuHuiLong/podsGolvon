//
//  SignViewController.m
//  Golvon
//
//  Created by CYL－Mac on 16/4/8.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()<UITextViewDelegate>

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    self.view.backgroundColor = GPColor(244, 244, 244);
    
    [self creatSignText];
    [self textlenth];
    _signText.delegate = self;
}


/**
 *  自定义导航条
 */
-(void)createNav{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(41.6), HScale(4.5), ScreenWidth * 0.171, ScreenHeight * 0.033)];
    _titleLabel.text = @"个性签名";
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:_titleLabel];
    
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    _backBtn.frame = CGRectMake(0, HScale(3), ScreenWidth * 0.091, ScreenHeight * 0.066);
    [_backBtn addTarget:self action:@selector(pressesBack2) forControlEvents:UIControlEventTouchUpInside];
    
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _finishBtn.backgroundColor = [UIColor redColor];
    [_finishBtn setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateNormal];
    _finishBtn.frame = CGRectMake(WScale(88.0), HScale(3.8), ScreenWidth * 0.109, ScreenHeight * 0.057);
    [_finishBtn addTarget:self action:@selector(FinishButton) forControlEvents:UIControlEventTouchUpInside];
    
    [_navView addSubview:_finishBtn];
    [_navView addSubview:_backBtn];
    
}
//返回
- (void)pressesBack2{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//完成
- (void)FinishButton{
    _signblock(_signText.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)creatSignText{

    self.signText = [[UITextView alloc]init];
    self.signText.frame = CGRectMake(0, HScale(12.4), ScreenWidth, ScreenHeight*0.172);
//    _signText.backgroundColor = [UIColor redColor];
    _signText.font = [UIFont boldSystemFontOfSize:15];
    
    self.signText.text = [userDefaults objectForKey:@"siignature"];
    
    self.signLabel = [[UILabel alloc]init];
    _signLabel.frame = CGRectMake(WScale(0), HScale(25.3), WScale(98), ScreenHeight*0.033);
    _signLabel.textAlignment = NSTextAlignmentRight;
    _signLabel.font = [UIFont systemFontOfSize:13.f];
    _signLabel.textColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_signText];
    [self.view addSubview:_signLabel];

}






- (void)textViewDidChange:(UITextView *)textView
{
    

    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)self.signText.text.length];
    int a = 40 - [len intValue];
    if (a<=0) {
        NSString *str = textView.text;
        textView.text = [str substringToIndex:39];
        self.signLabel.text = [NSString stringWithFormat:@"昵称字数已达上限"];
        
    }else{
        self.signLabel.text = [NSString stringWithFormat:@"你还可以输入%d个字",a];
    }
}












-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
   
    //判断加上输入的字符，是否超过界限
    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (string.length > 40){
        return NO;
    }
    //   限制苹果系统输入法  禁止输入表情
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
//    //禁止输入emoji表情
//    if ([self stringContainsEmoji:text]) {
//        return NO;
//    }
    
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






-(void)textlenth{
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)self.signText.text.length];
    int a = [len intValue];
    
    self.signLabel.text = [NSString stringWithFormat:@"你还可以输入%d个字",40-a];
    
}
#pragma mark - 隐藏键盘
-(BOOL)textViewShouldBeginEditing:(UITextField *)textField{
    [_signText resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_signText resignFirstResponder];
}


- (BOOL)shouldAutorotate{
    return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
