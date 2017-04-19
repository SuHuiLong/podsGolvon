//
//  ConsummateViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/11/2.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ConsummateViewController.h"
#import "SignaturesViewController.h"



@interface ConsummateViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,JobViewControllerDelegate,signaturesDelegate>

@property (strong, nonatomic) UIButton *jobBtn;

@property (strong, nonatomic) UIButton *cityBtn;

@property (strong, nonatomic) UIButton *poleBtn;

@property (strong, nonatomic) UIButton      *nextBtn;

@property (strong, nonatomic) DownLoadDataSource *loadData;

@property (nonatomic, strong) NSMutableArray     *provinces;

@property (weak, nonatomic  ) UIPickerView       *pickerView;

@property (strong, nonatomic) NSArray *poleNumArr;

@property (nonatomic,strong ) UIView  * pickerVBg;

@property (nonatomic,strong ) UIView  * pickV;

@property (copy, nonatomic) NSString *sendNameid;


@property (assign, nonatomic) BOOL    isCitySelected;

@property (assign, nonatomic) BOOL    isJobSelected;

@property (assign, nonatomic) BOOL    isPoleSelected;

/**索引*/
@property (nonatomic, assign) NSInteger          proIndex;
/**索引*/
@property (nonatomic, assign) NSInteger          cityIndex;
/** 省和城市*/
@property (nonatomic,copy) NSString * provinceAndCity;

@end

@implementation ConsummateViewController




// 懒加载省会
- (NSMutableArray *)provinces
{
    if (_provinces == nil) {
        // 装所有的省会
        _provinces = [NSMutableArray array];
        
        // 加载plist文件
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
        
        for (NSDictionary *dict in arr) {
            // 字典转模型
            GPProvince *p = [GPProvince provinceWithDict:dict];
            
            [_provinces addObject:p];
        }
    }
    return _provinces;
}

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
#pragma mark ---- 其他代理
-(void)selectedWorkname:(NSString *)workName WorkID:(NSString *)workID{
    _work_ziStr = workName;
    _work_ziID = workID;
}
-(void)signaturesSendNameid:(NSString *)nameID{
    _sendNameid = nameID;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (_work_ziStr == nil) {
        [_jobBtn setTitle:@"选择行业" forState:UIControlStateNormal];
    }else{
        
        [_jobBtn setTitle:[NSString stringWithFormat:@"%@",_work_ziStr] forState:UIControlStateNormal];
        [_jobBtn setTitleColor:localColor forState:UIControlStateNormal];
        [_jobBtn setImage:[UIImage imageNamed:@"RightSelected"] forState:UIControlStateNormal];
        
        _isJobSelected = YES;
        if (_isJobSelected && _isPoleSelected && _isCitySelected) {
            _nextBtn.selected = YES;
        }
    }
    if (_name_id == nil) {
        _name_id = _sendNameid;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self createSubview];
    
}
#pragma mark ---- UI
-(void)createSubview{
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 20, 44, 44);
//    [backBtn addTarget:self action:@selector(returnSuperVC) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setImage:[UIImage imageNamed:@"BlackBack"] forState:UIControlStateNormal];
//    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"信息完善";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(20)];
    titleLabel.frame = CGRectMake(0, kHvertical(67), ScreenWidth, kHvertical(28));
    [self.view addSubview:titleLabel];
    
    _jobBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _jobBtn.frame = CGRectMake((ScreenWidth - kWvertical(335))/2, titleLabel.bottom + kHvertical(34), kWvertical(335), kHvertical(37));
    [_jobBtn setTitle:@"选择行业" forState:UIControlStateNormal];
    
    [_jobBtn setTitleColor:GPColor(153, 153, 153) forState:UIControlStateNormal];
    _jobBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_jobBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    _jobBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [_jobBtn setImage:[UIImage imageNamed:@"RightDefault"] forState:UIControlStateNormal];
    [_jobBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kWvertical(320), 0, 0)];
    [_jobBtn addTarget:self action:@selector(returnToWorkVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jobBtn];
    
    
    UIView *lin1 = [[UIView alloc] init];
    lin1.frame = CGRectMake((ScreenWidth - kWvertical(335))/2, _jobBtn.bottom, kWvertical(335), 0.5);
    lin1.backgroundColor = TINTLINCOLOR;
    [self.view addSubview:lin1];
    
    _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn.frame = CGRectMake((ScreenWidth - kWvertical(335))/2, lin1.bottom, kWvertical(335), kHvertical(37));
    [_cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
    _cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cityBtn setTitleColor:GPColor(153, 153, 153) forState:UIControlStateNormal];
    [_cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [_cityBtn addTarget:self action:@selector(returnToCityVC) forControlEvents:UIControlEventTouchUpInside];
    _cityBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [_cityBtn setImage:[UIImage imageNamed:@"RightDefault"] forState:UIControlStateNormal];
    [_cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kWvertical(320), 0, 0)];
    [self.view addSubview:_cityBtn];
    
    UIView *lin2 = [[UIView alloc] init];
    lin2.frame = CGRectMake((ScreenWidth - kWvertical(335))/2, _cityBtn.bottom, kWvertical(335), 0.5);
    lin2.backgroundColor = TINTLINCOLOR;
    [self.view addSubview:lin2];
    
    UILabel *chooseLabel = [[UILabel alloc] init];
    chooseLabel.frame = CGRectMake(kWvertical(20), lin2.bottom, ScreenWidth - kWvertical(20), kHvertical(46));
    chooseLabel.text = @"选择杆数";
    chooseLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.view addSubview:chooseLabel];
    
    self.poleNumArr = [NSArray arrayWithObjects:@"6字头",@"7字头",@"8字头",@"9字头",@"三轮车", nil];
    
    for (int i = 0; i<5; i++) {
        UIButton *poleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        poleBtn.frame = CGRectMake(i*((kWvertical(12)+kWvertical(56)))+kWvertical(23), chooseLabel.bottom +kHvertical(19), kWvertical(56), kHvertical(25));
        [poleBtn setTitleColor:GPColor(129, 138, 155) forState:UIControlStateNormal];
        [poleBtn setTitleColor:localColor forState:UIControlStateSelected];
        poleBtn.layer.masksToBounds = YES;
        poleBtn.layer.cornerRadius = kHvertical(26)/2;
        poleBtn.layer.borderColor = LightGrayColor.CGColor;
        poleBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        poleBtn.layer.borderWidth = 0.5;
        poleBtn.tag = i;
        [poleBtn setTitle:self.poleNumArr[i] forState:UIControlStateNormal];
        [poleBtn addTarget:self action:@selector(clickToProlNum:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:poleBtn];
        
    }

    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake((ScreenWidth - kWvertical(335))/2, chooseLabel.bottom + kHvertical(90), kWvertical(335), kHvertical(42));
    [_nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.selected = NO;
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.adjustsImageWhenHighlighted = NO;
    _nextBtn.layer.cornerRadius = 3;
    [_nextBtn setBackgroundImage:[self imageWithColor:rgba(53,141,227,0.65)] forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:[self imageWithColor:localColor] forState:UIControlStateSelected];
    [self.view addSubview:_nextBtn];
    
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

- (void)setUpCityKeyboard
{
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.frame = CGRectMake(0,ScreenHeight,ScreenWidth,ScreenHeight*0.301);
    _pickerView = pickerView;
    
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    //pickerView蒙版
    self.pickerVBg = [[UIView alloc] init];
    self.pickerVBg.frame = [UIScreen mainScreen].bounds;
    self.pickerVBg.backgroundColor = GPRGBAColor(.2, .2, .2, .5);
    UITapGestureRecognizer *tgp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCityPick)];
    self.pickerVBg.userInteractionEnabled = YES;
    [self.pickerVBg addGestureRecognizer:tgp];
    
    //选择器和按钮背景
    self.pickV = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(100), ScreenWidth, 0)];
    self.pickV.backgroundColor = [UIColor whiteColor];
    [self.pickerVBg addSubview:self.pickV];
    
    
    //添加取消和确定按钮
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15.0f)];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleBtn.frame = CGRectMake(0, 0,ScreenWidth*0.16, ScreenHeight*0.051);
    [cancleBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [_pickV addSubview:cancleBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15.0f)];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(WScale(81.4), 0,ScreenWidth*0.16, ScreenHeight*0.051);
    [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.pickV addSubview:sureBtn];
    
    
    //按钮背景
    [self.view addSubview:self.pickerVBg];
    [self.pickerVBg addSubview:self.pickV];
    [self.pickerVBg addSubview:self.pickerView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        pickerView.frame = CGRectMake(WScale(0),HScale(70.9), ScreenWidth, ScreenHeight*0.301);
        self.pickV.frame = CGRectMake(WScale(0), HScale(65.47), ScreenWidth, ScreenHeight*0.054);
        cancleBtn.frame = CGRectMake(WScale(5.3),HScale(1), ScreenWidth*0.16, ScreenHeight*0.051);
        sureBtn.frame = CGRectMake(WScale(81.4),HScale(1), ScreenWidth*0.16, ScreenHeight*0.051);
        
        
        pickerView.frame = CGRectMake(WScale(0),HScale(70.9), ScreenWidth, ScreenHeight*0.301);
        self.pickV = [[UIView alloc] initWithFrame:CGRectMake(WScale(0), HScale(65.47), ScreenWidth, ScreenHeight*0.054)];
        cancleBtn.frame = CGRectMake(0,0, kWvertical(70), kHvertical(37));
        sureBtn.frame = CGRectMake(ScreenWidth -kWvertical(70),0, kWvertical(70), kHvertical(37));
        
    }];
    
}
-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}

#pragma mark ---- 点击事件
-(void)returnSuperVC{
    if ([self.delegate respondsToSelector:@selector(sendNameid:)]) {
        [self.delegate sendNameid:_name_id];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)returnToCityVC{
    
    [self setUpCityKeyboard];
    
}
//选择工作
-(void)returnToWorkVC{
    JobViewController *job = [[JobViewController alloc] init];
    job.hidesBottomBarWhenPushed = YES;
    job.controllerID = @"1";
    job.delegate = self;
    [self presentViewController:job animated:YES completion:nil];
}


-(void)hideCityPick{
    
    _proIndex = 0;
    
    [self.pickerVBg removeFromSuperview];
}

- (void)clickCancleBtn{
    _proIndex = 0;
    
    [self.pickerVBg removeFromSuperview];
}
- (void)clickSureBtn{
    if (self.cityStr == nil  && self.provinceStr ==nil ) {
        self.cityStr =@"北京";
        self.provinceStr = @"北京";
        self.provinceAndCity = [NSString stringWithFormat:@"%@ %@",self.provinceStr,self.cityStr];
    }
    [self.pickerVBg removeFromSuperview];
    _proIndex = 0;
    _isCitySelected = YES;
    if (_isJobSelected && _isPoleSelected && _isCitySelected) {
        _nextBtn.selected = YES;
    }
    [_cityBtn setTitle:_provinceAndCity forState:UIControlStateNormal];
    [_cityBtn setTitleColor:localColor forState:UIControlStateNormal];
    [_cityBtn setImage:[UIImage imageNamed:@"RightSelected"] forState:UIControlStateNormal];
}

-(void)nextStep{
    if (!_nextBtn.selected) {
        if (_work_ziID.length == 0) {
            [self createPromptWithStr:@"请选择职业"];
            return;
        }else if (_cityStr.length == 0){
            [self createPromptWithStr:@"请选择城市"];
            return;
        }else if (_poleNumStr.length == 0){
            [self createPromptWithStr:@"请选择杆数"];
            return;
        }
        return;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{@"name_id":_name_id,
                                 @"wid":_work_ziID,
                                 @"city":_cityStr,
                                 @"province":_provinceStr,
                                 @"rodnum":_poleNumStr
                                 };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=regstage1",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
    
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"0"]) {
            
                SignaturesViewController *VC = [[SignaturesViewController alloc]init];
                VC.hidesBottomBarWhenPushed = YES;
                VC.name_id = weakself.name_id;
                VC.delegate = self;
                [weakself presentViewController:VC animated:YES completion:nil];
            }
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
    
}


-(void)clickToProlNum:(UIButton *)sender{
    _isPoleSelected = YES;
    if (_isJobSelected && _isPoleSelected && _isCitySelected) {
        _nextBtn.selected = YES;
    }
    if (sender != _poleBtn) {
        _poleBtn.selected = NO;
        _poleBtn.layer.borderColor = LightGrayColor.CGColor;
        [_poleBtn setTitleColor:textTintColor forState:UIControlStateNormal];
        _poleBtn = sender;

    }
        
    _poleBtn.layer.borderColor = localColor.CGColor;
    [_poleBtn setTitleColor:localColor forState:UIControlStateNormal];


    _poleNumStr = self.poleNumArr[sender.tag];
}

#pragma mark ---- pickerView的代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        
        return self.provinces.count;
        
    }else{
        
        GPProvince *p = self.provinces[_proIndex];
        return p.cities.count;
        
    }
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component ==0) {
        
        GPProvince *p = self.provinces[row];
        
        return p.name;
        
    }else{
        
        GPProvince *p = self.provinces[_proIndex];
        
        return p.cities[row];
    }
    
}

// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        
    if (component == 0) {
        
        _proIndex = [pickerView selectedRowInComponent:0];
        
        [pickerView reloadComponent:1];
        
    }
    
    GPProvince *p = self.provinces[_proIndex];
    
    _cityIndex = [pickerView selectedRowInComponent:1];
    
    self.provinceStr = p.name;
    self.cityStr = p.cities[_cityIndex];
    self.provinceAndCity = [NSString stringWithFormat:@"%@ %@",self.provinceStr, self.cityStr];
    [_cityBtn.titleLabel sizeToFit];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
