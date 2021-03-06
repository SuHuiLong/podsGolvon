//
//  SetNicknameViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "SetNicknameViewController.h"
#import "ConsummateViewController.h"

#import "TabBarViewController.h"
#import "DetailHeaderModel.h"
#import "ZhuanFangModel.h"

@interface SetNicknameViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,ConsummateDelegate>

@property (strong, nonatomic) UIImageView      *headerIcon;

@property (strong, nonatomic) UITextField      *nicknameTexfield;

@property (strong, nonatomic) UIActionSheet    *actionSheet;

@property (strong, nonatomic) MBProgressHUD      *HUD;

@property (nonatomic,strong)DownLoadDataSource * loadDate;

@property (strong, nonatomic) NSArray      *ageDataArr;

@property (strong, nonatomic) UIButton      *manBtn;

@property (strong, nonatomic) UIButton      *womanBtn;

@property (strong, nonatomic) UIButton      *nextBtn;

@property (strong, nonatomic) UIButton      *ageBtn;

@property (strong, nonatomic) UILabel      *prompt;
/***  记录button状态*/
@property (assign, nonatomic) BOOL    imageSelect;

@property (assign, nonatomic) BOOL    sexSelect;

@property (assign, nonatomic) BOOL    ageSelect;

@property (assign, nonatomic) BOOL    nicknameSelect;

@property (copy, nonatomic) NSString *sendNameid;

@end

@implementation SetNicknameViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
    if (self.name_id == nil) {
        _name_id = _sendNameid;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self createSubview];
}
-(void)sendNameid:(NSString *)nameid{
    _sendNameid = nameid;
}

#pragma mark ---- UI

-(void)createSubview{
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 20, 44, 44);
//    [backBtn addTarget:self action:@selector(returnVC) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:[UIImage imageNamed:@"BlackBack"] forState:UIControlStateNormal];
//    [self.view addSubview:backBtn];
    
    [self createPrompt];
    
    _headerIcon = [[UIImageView alloc] init];
    _headerIcon.userInteractionEnabled = YES;
    _headerIcon.frame = CGRectMake((ScreenWidth - kWvertical(75))/2, kHvertical(90), kWvertical(75), kWvertical(75));
    _headerIcon.contentMode = UIViewContentModeScaleAspectFit;
    _headerIcon.image = [UIImage imageNamed:@"defaultHeader_regist"];
    [self.view addSubview:_headerIcon];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertPhotoSheet)];
    [_headerIcon addGestureRecognizer:tap];
    
    _nicknameTexfield = [[UITextField alloc] init];
    _nicknameTexfield.placeholder = @"填写昵称";
    _nicknameTexfield.delegate = self;
    _nicknameTexfield.frame = CGRectMake(0, _headerIcon.bottom, ScreenWidth, kHvertical(68));
    _nicknameTexfield.textAlignment = NSTextAlignmentCenter;
    _nicknameTexfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nicknameTexfield.returnKeyType = UIReturnKeyDone;
    _nicknameTexfield.font = [UIFont systemFontOfSize:kHorizontal(15)];
    [_nicknameTexfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:_nicknameTexfield];
    
    
    UIView *lin1 = [[UIView alloc] init];
    lin1.frame = CGRectMake((ScreenWidth - kWvertical(320))/2, _nicknameTexfield.bottom, kWvertical(320), 0.5);
    lin1.backgroundColor = TINTLINCOLOR;
    [self.view addSubview:lin1];
    
    
    _manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _manBtn.frame = CGRectMake((ScreenWidth - kWvertical(320))/2, lin1.bottom + kHvertical(9), kWvertical(160), kHvertical(37));
    [_manBtn setTitle:@"男" forState:UIControlStateNormal];
    [_manBtn setTitleColor:GPColor(113, 113, 113) forState:UIControlStateNormal];
    [_manBtn setTitleColor:localColor forState:UIControlStateSelected];
    [_manBtn addTarget:self action:@selector(ClickManBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_manBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [self.view addSubview:_manBtn];
    
    
    UIView *lin2 = [[UIView alloc] init];
    lin2.frame = CGRectMake(ScreenWidth/2, lin1.bottom + kHvertical(9), 0.5, kHvertical(26));
    lin2.backgroundColor = TINTLINCOLOR;
    [self.view addSubview:lin2];
    
    _womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _womanBtn.frame = CGRectMake(lin2.right, _manBtn.y, kWvertical(160), kHvertical(37));
    [_womanBtn setTitle:@"女" forState:UIControlStateNormal];
    [_womanBtn setTitleColor:GPColor(113, 113, 113) forState:UIControlStateNormal];
    [_womanBtn setTitleColor:localColor forState:UIControlStateSelected];
    [_womanBtn addTarget:self action:@selector(ClickWomanBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_womanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self.view addSubview:_womanBtn];
    
    
    UIView *lin3 = [[UIView alloc] init];
    lin3.frame = CGRectMake((ScreenWidth - kWvertical(320))/2, _womanBtn.bottom, kWvertical(320), 0.5);
    lin3.backgroundColor = TINTLINCOLOR;
    [self.view addSubview:lin3];
    
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.text = @"选择年龄";
    ageLabel.frame = CGRectMake(0, lin3.bottom+kHvertical(17), ScreenWidth, kHvertical(18));
    ageLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    ageLabel.textAlignment = NSTextAlignmentCenter;
    ageLabel.textColor = GPColor(69, 69, 69);
    [self.view addSubview:ageLabel];
    
    
    CGFloat Start_Y = kHvertical(321);      // 第一个按钮的Y坐标
    CGFloat Start_X = kWvertical(70);      // 第一个按钮的Y坐标
    CGFloat Width_Space = kWvertical(26);   // 2个按钮之间的横间距
    CGFloat Height_Space = kHvertical(20);  // 竖间距
    CGFloat Button_Height = kHvertical(26); // 高
    CGFloat Button_Width = kHvertical(61);  // 宽
    
    self.ageDataArr = [NSArray arrayWithObjects:@"50后",@"60后",@"70后",@"80后",@"90后",@"00后", nil];
    for (int i = 0 ; i < 6; i++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeCustom];
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        [aBt setTitleColor:GPColor(129, 138, 155) forState:UIControlStateNormal];
        [aBt setTitleColor:localColor forState:UIControlStateSelected];
        aBt.layer.masksToBounds = YES;
        aBt.layer.cornerRadius = kHvertical(26)/2;
        aBt.layer.borderColor = LightGrayColor.CGColor;
        aBt.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        aBt.layer.borderWidth = 0.5;
        aBt.tag = i;
        [aBt setTitle:self.ageDataArr[i] forState:UIControlStateNormal];
        [aBt addTarget:self action:@selector(clickAgebtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aBt];
    }
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake((ScreenWidth - kWvertical(335))/2, lin3.bottom + kHvertical(157), kWvertical(335), kHvertical(42));
    _nextBtn.selected = NO;
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.adjustsImageWhenHighlighted = NO;
    _nextBtn.layer.cornerRadius = 3;
    [_nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setBackgroundImage:[self imageWithColor:rgba(53,141,227,0.65)] forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:[self imageWithColor:localColor] forState:UIControlStateSelected];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:_nextBtn];

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
-(void)createPrompt{
    
    _prompt = [[UILabel alloc] init];
    _prompt.frame = CGRectMake((ScreenWidth - kWvertical(201))/2, kHvertical(47), kWvertical(201), kHvertical(32));
    _prompt.backgroundColor = rgba(166,166,166,1);
    _prompt.text = @"为完善社区体验将对头像进行审核";
    _prompt.layer.masksToBounds = YES;
    _prompt.layer.cornerRadius = 3;
    _prompt.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _prompt.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_prompt];
    
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            _prompt.alpha = 0.0f;
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_prompt removeFromSuperview];
    });
}

-(void)createPromptWithStr:(NSString *)str{
    UILabel *alertView = [[UILabel alloc] init];
    alertView.frame = CGRectMake((ScreenWidth - kWvertical(120))/2, ScreenHeight/2-kHvertical(64), kWvertical(120), kHvertical(32));
    alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    alertView.text = str;
    alertView.textColor = WhiteColor;
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 3;
    alertView.font = [UIFont systemFontOfSize:kHorizontal(12)];
    alertView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertView];
    
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            alertView.alpha = 0.0f;
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView removeFromSuperview];
    });
}


-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}

#pragma mark ---- 点击事件
-(void)returnVC{

    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)nextStep{
    __weak typeof(self) weakself = self;
    if (!_nextBtn.selected) {
        if (_pic_id.length == 0) {
            [self createPromptWithStr:@"请上传头像"];
            return;
        }else if (_nicknameTexfield.text.length == 0){
            
            [self createPromptWithStr:@"请填写昵称"];
            return;

        }else if(_genderStr.length == 0){
            [self createPromptWithStr:@"请选择性别"];
            return;

        }else if (_ageStr.length == 0){
            [self createPromptWithStr:@"请选择年龄"];
            return;

        }
        return;
    }
        DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
        NSDictionary *dict = @{
                               @"name_id":_name_id,
                               @"nickname":_nicknameTexfield.text,
                               @"pid":_pic_id,
                               @"gender":_genderStr,
                               @"age":_ageStr
                               };
        [manager downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=regstage0",apiHeader120] parameters:dict complicate:^(BOOL success, id data) {
            
            if (success) {
                
                NSString *code = data[@"code"];
                if ([code isEqualToString:@"0"]) {
                    
                    ConsummateViewController *VC = [[ConsummateViewController alloc]init];
                    VC.hidesBottomBarWhenPushed = YES;
                    VC.name_id = _name_id;
                    VC.delegate = self;
                    [weakself presentViewController:VC animated:YES completion:nil];
                    
                }else if ([code isEqualToString:@"506"]){
                    
                    [self alertShowView:@"此昵称不可注册"];
                    
                }else if ([code isEqualToString:@"509"]){

                    [weakself alertShowView:@"昵称被占用"];
                }else if ([code isEqualToString:@"510"]){
                    
                    [userDefaults setValue:_name_id forKey:@"name_id"];
                    [self initData];
                    
                    //获取版本号
                    NSString *versionKey = @"CFBundleVersion";
                    //当前使用的版本
                    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
                    [userDefaults setObject:currentVersion forKey:versionKey];
                    TabBarViewController *tbc = [[TabBarViewController alloc] init];
                    self.view.window.rootViewController = tbc;
                }
            }else{
                [weakself alertShowView:@"网络错误"];
            }
        }];

}
//年龄选择
-(void)clickAgebtn:(UIButton *)sender{

    
    _ageSelect = YES;
    if (_ageSelect&&_sexSelect&&_nicknameSelect&&_imageSelect) {
        _nextBtn.selected = YES;
    }
    
    if (sender != _ageBtn) {
        _ageBtn.selected = NO;
        _ageBtn.layer.borderColor = LightGrayColor.CGColor;
        [_ageBtn setTitleColor:textTintColor forState:UIControlStateNormal];
        _ageBtn = sender;
    }
   
    _ageBtn.layer.borderColor = localColor.CGColor;
    [_ageBtn setTitleColor:localColor forState:UIControlStateNormal];
    
    
    _ageBtn.selected = !_ageBtn.selected;
    _ageStr = self.ageDataArr[sender.tag];
}
//性别女点击
-(void)ClickWomanBtn:(UIButton *)sender{

    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _manBtn.selected = NO;
        _sexSelect = YES;
    }else{
        _sexSelect = NO;
    }
    
    if (_ageSelect&&_sexSelect&&_nicknameSelect&&_imageSelect) {
        _nextBtn.selected = YES;
    }

    _genderStr = @"女";
}
//性别男点击
-(void)ClickManBtn:(UIButton *)sender{

    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _womanBtn.selected = NO;
        
        _sexSelect = YES;
    }else{
        _sexSelect = NO;
    }
    
    if (_ageSelect&&_sexSelect&&_nicknameSelect&&_imageSelect) {
        _nextBtn.selected = YES;
    }
    
    _genderStr = @"男";
}

#pragma mark ---- 上传头像
-(void)alertPhotoSheet{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"选择头像" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController * bgimagePikerViewController = [[UIImagePickerController alloc] init];
    bgimagePikerViewController.delegate = self;
    bgimagePikerViewController.allowsEditing = YES;
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            bgimagePikerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:bgimagePikerViewController animated:YES completion:NULL];
        }else{
            
        }
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从手机相册选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            bgimagePikerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:bgimagePikerViewController animated:YES completion:NULL];
        }
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController: alertController animated: YES completion: nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    
    CGFloat imageHeight = image.size.height;
    CGFloat imageWidth  = image.size.width;
    CGFloat scale = imageHeight/imageWidth;     //裁剪比例
    UIImage *resizedImage;      //裁剪之后的图
    if (scale<1) {
        if (imageWidth > 600) {
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(600, 600*scale)];
            
        }else{
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(imageWidth, imageHeight)];
        }
    }
    if (scale>1) {
        if (imageHeight > 600) {
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(600/scale, 600)];
            
        }else{
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(imageWidth, imageHeight)];
            
        }
    }
    if (scale == 1) {
        if (imageHeight > 600) {
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(600, 600)];
            
        }else{
            
            resizedImage = [UIImage scaleToSize:image size:CGSizeMake(imageWidth, imageHeight)];
            
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@upload.php",apiHeader120];
    NSDictionary *parameters = @{
                                 @"name_id":_name_id,
                                 @"type":@"0"
                                 };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         @"text/plain",
                                                         @"multipart/form-data",
                                                         @"text/json",
                                                         nil];
    
        [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

            NSData *imageData =UIImageJPEGRepresentation(resizedImage, 0.8f);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
            
            
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            _imageSelect = YES;
            if (_ageSelect&&_sexSelect&&_nicknameSelect&&_imageSelect) {
                _nextBtn.selected = YES;
            }
            [_headerIcon setImage:resizedImage];
            _headerIcon.layer.masksToBounds = true;
            _headerIcon.layer.cornerRadius = kWvertical(75)/2;
            NSError *error = nil;
            id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"1"]) {
                
                _pic_id = data[@"pid"][0];
                _pic_url = data[@"url"][0];
                
            }else{
                [self alertShowView:@"上传失败"];
            }
            
            [self dismissViewControllerAnimated:YES completion:NULL];
            
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
            //上传失败
            NSLog(@"上传失败%@",error);
        }];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark ---- 输入昵称

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *tc = [touches anyObject];
    if (tc.view == self.view) {
        [_nicknameTexfield resignFirstResponder];
        
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    _nicknameTexfield.text =  @"";
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _nicknameTexfield) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 15) {
            return NO;
        }
        if (textField.text.length >0) {

            
        }
    }
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
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


- (void)textFieldDidChange:(UITextField *)textField
{

    
    if (textField == _nicknameTexfield) {
        
        if (textField.text.length > 0) {
            _nicknameSelect = YES;
        }else{
            _nicknameSelect = NO;
        }
        if (_ageSelect&&_sexSelect&&_nicknameSelect&&_imageSelect) {
            _nextBtn.selected = YES;
        }
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
        _nicknameStr = _nicknameTexfield.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_nicknameTexfield resignFirstResponder];
    _nicknameStr = _nicknameTexfield.text;
    return true;
}
-(void)initData{
    
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc] init];
    
    NSDictionary *parameters = @{@"name_id":_name_id};
    
    [loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=getui",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            
            NSDictionary *uiDic = data[@"ui"];
            
            DetailHeaderModel *headerModel = [DetailHeaderModel initWithDictionary:uiDic];
            
            NSMutableArray *labelArr = uiDic[@"labels"];
            if (labelArr.count>0) {
                
                [userDefaults setValue:labelArr forKey:@"labels"];
                
            }
            
            if ([headerModel.vid isEqualToString:@"0"]) {
                
            }else{
                
                //                ZhuanFangModel *interviewModel = [ZhuanFangModel paresFromDictionary:uiDic[@"V"]];
            }
            
            
            [userDefaults setValue:headerModel.sign forKey:@"siignature"];
            [userDefaults setValue:headerModel.visits forKey:@"access_amount"];
            [userDefaults setValue:headerModel.completegames forKey:@"changCi"];
            [userDefaults setValue:headerModel.charity forKey:@"cishan_jiner"];
            [userDefaults setValue:headerModel.city forKey:@"city"];
            [userDefaults setValue:headerModel.state forKey:@"examine_state"];
            [userDefaults setValue:headerModel.befocus forKey:@"follow_number"];        //关注
            [userDefaults setValue:headerModel.focus forKey:@"attention_number"];       //粉丝
            [userDefaults setValue:headerModel.gender forKey:@"gender"];
            [userDefaults setValue:headerModel.vid forKey:@"interview_state"];
            [userDefaults setValue:headerModel.msgs forKey:@"message_number"];
            [userDefaults setValue:headerModel.nickname forKey:@"nickname"];
            [userDefaults setValue:headerModel.avatorpid forKey:@"pic_id"];
            [userDefaults setValue:headerModel.province forKey:@"province"];
            [userDefaults setValue:headerModel.year_label forKey:@"age"];
            [userDefaults setValue:headerModel.avator forKey:@"pic"];
            [userDefaults setValue:headerModel.cover forKey:@"coverPic"];
            [userDefaults setValue:headerModel.rodnum forKey:@"polenum"];
            [userDefaults setValue:headerModel.work_content forKey:@"job"];
            [userDefaults setValue:headerModel.bird forKey:@"zhuaNiao"];
            [userDefaults setValue:headerModel.uid forKey:@"uid"];
            
            
        }
    }];
}


@end
