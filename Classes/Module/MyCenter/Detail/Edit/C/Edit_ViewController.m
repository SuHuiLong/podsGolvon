
//
//  Edit_ViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/28.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Edit_ViewController.h"
#import "GPProvince.h"
#import "CitypickerView.h"
#import "AgePickerView.h"
#import "DetailHeaderModel.h"
#import "SlectMarksViewController.h"
#import "PoleNumber.h"
#import "JobViewController.h"
#import "SignViewController.h"
#import "rightJobTableView.h"
#import "DownLoadDataSource.h"
#import "RegistViewController.h"
#import "HomePageViewController.h"
#import "UIImageView+WebCache.h"
#import "DetailHeaderModel.h"

#import "TabBarViewController.h"

#import "MBProgressHUD.h"
#import "ImageTool.h"

#import "Edit_TableViewCell.h"

@interface Edit_ViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>{
    
    
    MBProgressHUD *_HUD;
    MBProgressHUD *_HUD2;
    
    
}

/** 网络请求*/
@property (nonatomic,strong)DownLoadDataSource * loadDate;
@property (strong, nonatomic) UIActionSheet *actionSheet;

/** 省和城市*/
@property (nonatomic,copy)NSString * provinceAndCity;
/** 省*/
@property (nonatomic,copy)NSString * proVinceName;
/** 市*/
@property (nonatomic,copy)NSString * cityName;

/** pickerView的背景*/
@property (nonatomic,strong)UIView * pickerVBg;
/** pickerView的和按钮背景*/
@property (nonatomic,strong)UIView * pickV;
/** 取消按钮*/
@property (nonatomic,strong)UIButton * cancleBtn;
/** 确定按钮*/
@property (nonatomic,strong)UIButton * sureBtn;

/**省数组*/
@property (nonatomic, strong) NSMutableArray *provinces;
//年代数组
@property (nonatomic, strong) NSMutableArray *AgeArr;

/**索引*/
@property (nonatomic, assign) NSInteger proIndex;
/**索引*/
@property (nonatomic, assign) NSInteger cityIndex;
/**日期*/
@property (nonatomic, weak) UIDatePicker *datePicker;

@property (nonatomic, weak) UIPickerView *pickerView;

/** 年代*/
@property (nonatomic,strong)AgePickerView * AgepickerView;
//年代文字
@property (nonatomic,copy)NSString * Agetitle;
/**索引*/
@property (nonatomic, assign) NSInteger AgeIndex;

/** 杆数*/
@property (nonatomic,strong)PoleNumber *poleView;

@property (nonatomic, strong) NSMutableArray *PoleArr;

//多少杆数
@property (nonatomic,copy)NSString * Poletitle;
/**索引*/
@property (nonatomic, assign) NSInteger poleIndex;

//性别
@property (nonatomic, strong) NSMutableArray *sexArr;
@property (nonatomic, strong) NSString *sexname;

/** 拿到标签对象*/
@property (nonatomic,strong) SlectMarksViewController* labC;
/** 行业对象*/
@property (nonatomic,strong)JobViewController *jobC;
/** 行业名字*/
@property (nonatomic,strong)NSString *jobName;
/** 行业赋值用*/
//@property (nonatomic,strong)NSString *jobName2;

/** 行业id*/
@property (nonatomic,copy)NSString * jobid;

/** 签名*/
@property (nonatomic,strong)SignViewController * signC;

/**个性签名加手势*/
@property (nonatomic,strong)UIImageView * imageV;

/** 标签集合*/
@property (nonatomic,strong)NSArray * labelbuts;


/** 标签文字*/
@property (nonatomic,strong)NSString * labelContent;

@property (nonatomic,strong)NSString * labelID;         //标签的ID

@property (nonatomic,strong)NSMutableArray * labelIDArr;//标签ID数组


/** 头像返回的url*/
@property (nonatomic,strong)NSString * headerUrl;
/** 服务器返回的图片id*/
@property (nonatomic,strong)NSString * pictureid;



/** 注册控制器*/
@property (nonatomic,strong)RegistViewController *regiC;


@property(nonatomic,copy)NSMutableArray *iconArry;

@property(nonatomic,copy)NSString *selectStr;



@end

@implementation Edit_ViewController

-(NSMutableArray *)iconArry{
    if (!_iconArry) {
        _iconArry = [NSMutableArray array];
    }
    return _iconArry;
}

-(NSMutableArray *)labelIDArr{
    if (!_labelIDArr) {
        _labelIDArr = [[NSMutableArray alloc]init];
    }
    return _labelIDArr;
}

- (NSString *)pictureid{
    
    if (!_pictureid) {
        _pictureid = [[NSString alloc]init];
    }
    return  _pictureid;
}

- (NSString *)jobid{
    if (!_jobid) {
        _jobid = [[NSString alloc]init];
    }
    return  _jobid;
}
- (DownLoadDataSource *)loadDate{
    
    if (!_loadDate) {
        _loadDate = [[DownLoadDataSource alloc]init];
    }
    return _loadDate;
}

//杆数
- (NSMutableArray *)PoleArr{
    
    if (!_PoleArr) {
        _PoleArr = [NSMutableArray array];
        NSString *poleFile = [[NSBundle mainBundle]pathForResource:@"number.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:poleFile];
        for (NSString *poleNum in arr) {
            NSString *poleS = [NSString stringWithFormat:@"%@",poleNum];
            [_PoleArr addObject:poleS];
        }
    }
    
    
    return _PoleArr;
}

//懒加载年代
- (NSMutableArray *)AgeArr{
    
    if (_AgeArr ==nil) {
        _AgeArr = [NSMutableArray array];
        
        //加载plis文件
        NSString *AfeFile = [[NSBundle mainBundle]pathForResource:@"Age List.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:AfeFile];
        for (NSString *Age in arr) {
            [_AgeArr addObject:Age];
        }
    }
    
    return _AgeArr;
}

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


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobC = [[JobViewController alloc]init];
    _phoneNumber = [userDefaults objectForKey:@"phone"];
    self.signC = [[SignViewController alloc]init];
    self.view.backgroundColor = GPColor(244, 244, 244);
    
    [self createUI];
    [self createTable];
    [self createNav];
    [self loadDataNet];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    if (_jobStr) {
        
        self.jobName = self.jobStr;
        self.jobid = self.jobID;
        [self loadDataNet];
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_labelIDArr removeAllObjects];
    [userDefaults removeObjectForKey:@"SelectLabel"];
    
}
#pragma mark - 数据请求
- (void)loadDataNet{
    
//    NSDictionary *parameter = @{@"name_id":userDefaultId};
    __weak typeof(self) weakself = self;
    if (![self.nameid isEqualToString:@"0"]) {
        self.tableView.userInteractionEnabled = NO;
        
        DownLoadDataSource *loadData = [[DownLoadDataSource alloc] init];
        
        NSDictionary *parameters = @{@"name_id":userDefaultId};
        
        [loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=getui",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
            _tableView.userInteractionEnabled = YES;
            if (success) {
                NSDictionary *uiDic = data[@"ui"];
                DetailHeaderModel *headerModel = [DetailHeaderModel initWithDictionary:uiDic];
                weakself.cityName = headerModel.city;
                weakself.sexname = headerModel.gender;
                weakself.Agetitle = headerModel.year_label;      //年龄
                weakself.nickName.text = headerModel.nickname;
                weakself.Poletitle = headerModel.rodnum;
                weakself.proVinceName = headerModel.province;
                weakself.signature.text = headerModel.sign;
                weakself.pictureid = headerModel.avatorpid;
                
                if (!_jobStr) {

                    weakself.jobName = headerModel.work_content;
                    weakself.jobid = headerModel.workID;
                }
                
                [self.headerImage sd_setImageWithURL:[NSURL URLWithString:headerModel.avator] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];
                
                self.provinceAndCity= [NSString stringWithFormat:@"%@ %@",self.proVinceName,self.cityName];
                
                NSArray *tempLabelArr = uiDic[@"labels"];
                for (int i = 0; i<tempLabelArr.count; i++) {
                    NSString *tempStr = tempLabelArr[i][@"label_id"];
                    
                    weakself.labelID = tempStr;
                    
                    [weakself.labelIDArr addObject:self.labelID];
                }
                
                if (weakself.labelIDArr.count>0) {
                    
                    weakself.labelContent = @"已选择标签";
                    [userDefaults setValue:tempLabelArr forKey:@"labels"];
                }else{
                    [userDefaults removeObjectForKey:@"labels"];
                }
                [weakself.tableView reloadData];
            }
        }];
    }
}
-(void)saveAllData{
    NSString *signature;
    if (self.signature.text.length == 0) {
        signature = @" ";
    }else{
        signature = self.signature.text;
    }
    __block  NSString *labelstr = @"";
    [self.labelIDArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        labelstr  = [labelstr stringByAppendingString:obj];
        if (idx<self.labelIDArr.count-1) {
            labelstr  = [labelstr stringByAppendingString:@","];
        }
    }];
    
    self.labelID = labelstr;
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{@"name_id":userDefaultId,
                                 @"nickname":self.nickName.text,
                                 @"pid":_pictureid,
                                 @"gender":_sexname,
                                 @"age":_Agetitle,
                                 @"city":_cityName,
                                 @"province":_proVinceName,
                                 @"rodnum":_Poletitle,
                                 @"sig":signature,
                                 @"labels":_labelID,
                                 @"wid":_jobid };
    
    [self.loadDate downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=updateuserinfo",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        
        if (success) {
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self initData];
                
                    [userDefaults removeObjectForKey:@"labels"];
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
                
            }else if([code isEqualToString:@"505"]){
                
                NSLog(@"505");
            }else if([code isEqualToString:@"506"]){
                [self alertShowView:@"此昵称不可注册"];
//                NSLog(@"506");
            }else if([code isEqualToString:@"507"]){
                
                NSLog(@"507");
            }else if([code isEqualToString:@"512"]){
                
                NSLog(@"512");
            }else if([code isEqualToString:@"510"]){
                
                NSLog(@"510");
            }else if([code isEqualToString:@"1"]){
                
                NSLog(@"1");
            }else if([code isEqualToString:@"509"]){
                
                [self alertShowView:@"昵称被占用"];
            }
            
        }
    }];
    
}

-(void)initData{
    
    DownLoadDataSource *loadData = [[DownLoadDataSource alloc] init];
    
    NSDictionary *parameters = @{@"name_id":userDefaultId};
    
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
#pragma mark ---- 创建视图
-(void)createNav{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, 15)];
    titleLabel.text = @"个人设置";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.view.frame.size.height <= 568)
    {
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(20)];
        
    }
    else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667)
    {
        
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    }else{
        
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(17)];
        
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:titleLabel];
    
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.frame = CGRectMake(0, 20, 44, 44);
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(pressesBack) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_backBtn];
    
}
-(void)createTable{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64 + HScale(17.7), ScreenWidth, HScale(56.4))];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.rowHeight = ScreenHeight * 0.094;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
-(void)createUI{
    
    
    _editView = [[UIView alloc]initWithFrame:CGRectMake(0,64 + HScale(1), ScreenWidth,HScale(15.1))];
    _editView.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:_editView];
    
    
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(4.3), HScale(2.1), WScale(19.5) , HScale(10.9))];
    _headerImage.clipsToBounds = YES;
    _headerImage.layer.cornerRadius = 3;
    _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    line.backgroundColor = NAVLINECOLOR;
    [_editView addSubview:line];
    
    _headerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *headtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBtn)];
    [_headerImage addGestureRecognizer:headtap];
    [_editView addSubview:_headerImage];
    
    
    _nickName = [[UITextField alloc]initWithFrame:CGRectMake(WScale(28.3), HScale(0),WScale(65.7)  ,HScale(7.5) )];
    _nickName.placeholder = @"请输入昵称(15字内中英文,数字,下划线)";
    [_nickName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nickName.textColor = deepColor;
    _nickName.font = [UIFont systemFontOfSize:kHorizontal(14)];
    self.nickName.delegate = self;
    _nickName.returnKeyType = UIReturnKeyDone;
    [_editView addSubview:_nickName];
    
    
    _signature = [[UITextField alloc]initWithFrame:CGRectMake(WScale(28.3),HScale(7.7) , WScale(67.7) , HScale(7.5))];
    _signature.placeholder = @"请输入个性签名";
    _signature.textColor = deepColor;
    _signature.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _signature.text = self.signC.signText.text;
    
    
    self.imageV = [[UIImageView alloc] init];
    self.imageV.frame = CGRectMake(WScale(21.5), HScale(17.7) , ScreenWidth *0.76 , ScreenHeight * 0.079);
    self.imageV.userInteractionEnabled = YES;
    self.imageV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageV];
    
    /**
     *  添加手势
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    _signature.userInteractionEnabled = YES;
    
    [_imageV addGestureRecognizer:tap];
    
    [_editView addSubview:_signature];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(WScale(28.3), HScale(6.7), ScreenWidth * 0.765, 0.5)];
    _lineView.backgroundColor = GPColor(229, 230, 231);
    [_editView addSubview:_lineView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, HScale(15.2)-0.5, ScreenWidth, 0.5)];
    bottomLine.backgroundColor = GPColor(229, 230, 231);
    [_editView addSubview:bottomLine];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:8];
    [_editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.frame = CGRectMake(WScale(7.2), HScale(11.1), ScreenWidth * 0.053, ScreenHeight * 0.021);
    [_editView addSubview:_editBtn];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(WScale(5.9), 64 + HScale(76.6), ScreenWidth * 0.882, ScreenHeight * 0.06);
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.layer.cornerRadius = 3;
    [_saveBtn setBackgroundColor:localColor];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    
}
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


-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
#pragma mark ---- 点击事件

-(void)pressesBack{
    if ([_loginView isEqualToString:@"RegistViewController"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//个性签名的手势
- (void)tap{
    SignViewController *sign = [[SignViewController alloc]init];
    sign.signblock = ^(NSString * signText){
        self.signature.text = signText;
        
    };
    _selectStr = [NSString string];
    [_tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:sign animated:YES completion:nil];
    });
    
}

-(void)clickBtn{
    [_nickName resignFirstResponder];
    /**
     编辑按钮/弹框选择
     */
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"尊敬的用户，为了保持“打球去”社区的高尔夫特质和纯粹性，我们将对您最新上传的头像进行审核，审核通过后，我们将在第一时间通过系统消息通知您。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self alertPhotoSheet];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//保存数据
- (void)clickSave{
    NSString *nickNameStr = _nickName.text;
    //    NSString *signatureStr = _signature.text;
    
    if (nickNameStr.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请填写昵称" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //    else if (signatureStr.length==0){
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请填写个性签名" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
    //        [alert show];
    //        return;
    //    }
    else if (!_sexname){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请填写性别" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
        
    }else if (!_proVinceName){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请填写城市" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
        
    }else if (!_jobid){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请选择职业" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
        
    }else if (!_Poletitle){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请选择杆数" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
        
    }else if (!_cityName){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请填写城市" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
        
    }else if (!_Agetitle){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请填写年龄段" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
        
    }else if (!_pictureid){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请选择图片" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    [self saveAllData];
}


#pragma mark ---- tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HScale(9.6);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Edit_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Edit_TableViewCell"];
    if (cell == nil) {
        
        cell = [[Edit_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Edit_TableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    switch (indexPath.row) {
        case 0:
            
            [cell relayoutDataWithParameter:@"年龄" WithPlaceHold:@"请选择年龄" WithTarget:_Agetitle];
            break;
            
        case 1:
            
            [cell relayoutDataWithParameter:@"性别" WithPlaceHold:@"请选择性别" WithTarget:self.sexname];
            break;
        case 2:
            
            [cell relayoutDataWithParameter:@"地区" WithPlaceHold:@"请选择城市" WithTarget:_provinceAndCity];
            break;
        case 3:
//        {
            
//            if (!self.jobName.length) {
//                
//                self.jobName = self.jobC.jobLabel;
//            }
//            if (!_jobid) {
//                self.jobid = self.jobC.jobID;
//            }
            
            [cell relayoutDataWithParameter:@"行业" WithPlaceHold:@"请选择行业" WithTarget: self.jobName];
            
//        }
            break;
        case 4:
            
            [cell relayoutDataWithParameter:@"杆数" WithPlaceHold:@"请选择杆数" WithTarget:_Poletitle];
            break;
        case 5:
            
            if (self.labelIDArr.count > 0) {
                
                [cell relayoutDataWithParameter:@"标签" WithPlaceHold:@"已选择标签" WithTarget:self.labelContent];
                
            }else{
                
                [cell relayoutDataWithParameter:@"标签" WithPlaceHold:@"请选择标签" WithTarget:self.labelContent];
            }
            
            break;
            
        
            default:
            return cell;
            break;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_nickName resignFirstResponder];
    
    switch (indexPath.row) {
        case 0:
        {
            //年代
            [self setUpAgePickerView];
        }
            break;
        case 1:
            //性别
        { UIActionSheet *myActionSheet;
            myActionSheet = [[UIActionSheet alloc] initWithTitle:@"修改性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
            myActionSheet.frame = CGRectMake(0, 200, ScreenWidth, 300);
            myActionSheet.layer.cornerRadius = 0;
            [myActionSheet showInView:self.view];
            
        }
            
            break;
        case 2:
        {
            // 自定义城市键盘
            [self setUpCityKeyboard];
            
        }
            break;
        case 3:
        {
            
            //职业
//            __weak typeof(self) weakself = self;
//            self.jobC.jobBlock = ^(NSString * jobname,NSString*jobid){
//            if (!_jobName) {
//                
//                self.selectStr = @"行业";
//            }
//            };
//            if (_jobC) {
//                <#statements#>
//            }
            dispatch_async(dispatch_get_main_queue(), ^{
                JobViewController *job = [[JobViewController alloc] init];
                job.controllerID = @"2";
                job.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:job animated:YES];
            });
        }
            
            break;
        case 4:
        {
            //杆数
            if (!_Poletitle) {
                [self createPoleView];
            }else{
                NSMutableString *LastmStr = [[NSMutableString alloc] initWithString: _Poletitle];
                [LastmStr deleteCharactersInRange:NSMakeRange(0, LastmStr.length-1)];
                if (![LastmStr isEqualToString:@"杆"]) {
                    [self createPoleView];
                }
            }
        }
            break;
        case 5:
        {
            /**
             *  跳转到标签页面
             */
            
            self.labC = [[SlectMarksViewController alloc]init];
            __weak typeof(self) weakSelf = self;
            
            self.labC.back = ^(NSArray*buts){
                _selectStr = @"标签";
                
                weakSelf.labelbuts =buts;
                [weakSelf.labelIDArr addObjectsFromArray:weakSelf.labelbuts];
                weakSelf.labelContent = weakSelf.labC.lableName;
                NSLog(@"拿到buttons--%@",weakSelf.labelIDArr);
                [weakSelf.tableView reloadData];
            };
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:self.labC animated:YES completion:nil];
            });
            
        }
            break;
            
        default:
            
            break;
    }
}

#pragma mark --action sheet 性别-代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    self.sexArr = [NSMutableArray array];
    self.sexArr = [NSMutableArray arrayWithObjects:@"男",@"女",nil];
    switch (buttonIndex) {
        case -1:
            break;
        case 0:
            self.sexname = self.sexArr[buttonIndex];
            _selectStr = @"性别";
            break;
        case 1:
            self.sexname = self.sexArr[buttonIndex];
            _selectStr = @"性别";
            break;
        default:
            break;
    }
    
    
    [self.tableView reloadData];
}

#pragma mark- 选择图片
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
                                 @"name_id":userDefaultId,
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
        
        NSData *imageData =UIImageJPEGRepresentation(resizedImage, 1.0f);
        
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
        
        [_headerImage setImage:resizedImage];
        _headerImage.layer.masksToBounds = true;
        _headerImage.layer.cornerRadius = kWvertical(75)/2;
        NSError *error = nil;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        NSString *code = data[@"code"];
        if ([code isEqualToString:@"1"]) {
            
            _pictureid = data[@"pid"][0];
            _headerUrl = data[@"url"][0];
            
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

#pragma  mark - 相册相机选择方法
- (void)callActionSheetFunc{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    }
    
    self.actionSheet.tag = 1000;
    self.actionSheet.delegate = self;
    [self.actionSheet showInView:self.view];
}

#pragma mark - 以下是自定义城市部分
- (void)setUpCityKeyboard
{
    CitypickerView *pickerView = [[CitypickerView alloc] init];
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
    //CGRectMake(WScale(0), HScale(65.47), ScreenWidth, ScreenHeight*0.054)];
    self.pickV.backgroundColor = [UIColor whiteColor];
    
    [self.pickerVBg addSubview:self.pickV];
    //添加取消和确定按钮
    self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15.0f)];
    [self.cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancleBtn.frame = CGRectMake(0, 0,ScreenWidth*0.16, ScreenHeight*0.051);
    [self.cancleBtn addTarget:self action:@selector(clickCancle) forControlEvents:UIControlEventTouchUpInside];
    [self.pickV addSubview:_cancleBtn];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15.0f)];
    
    [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.sureBtn.frame = CGRectMake(WScale(81.4), 0,ScreenWidth*0.16, ScreenHeight*0.051);
    //CGRectMake(WScale(81.4),HScale(1), ScreenWidth*0.16, ScreenHeight*0.051);
    
    [self.sureBtn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    
    [self.pickV addSubview:_sureBtn];
    
    //按钮背景
    [self.pickerVBg addSubview:self.pickV];
    [self.pickerVBg addSubview:self.pickerView];
    [self.view addSubview:self.pickerVBg];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        pickerView.frame = CGRectMake(WScale(0),HScale(70.9), ScreenWidth, ScreenHeight*0.301);
        self.pickV.frame = CGRectMake(WScale(0), HScale(65.47), ScreenWidth, ScreenHeight*0.054);
        self.cancleBtn.frame = CGRectMake(WScale(5.3),HScale(1), ScreenWidth*0.16, ScreenHeight*0.051);
        self.sureBtn.frame = CGRectMake(WScale(81.4),HScale(1), ScreenWidth*0.16, ScreenHeight*0.051);
        
        
        pickerView.frame = CGRectMake(WScale(0),HScale(70.9), ScreenWidth, ScreenHeight*0.301);
        self.pickV = [[UIView alloc] initWithFrame:CGRectMake(WScale(0), HScale(65.47), ScreenWidth, ScreenHeight*0.054)];
        self.cancleBtn.frame = CGRectMake(0,0, kWvertical(70), kHvertical(37));
        self.sureBtn.frame = CGRectMake(ScreenWidth -kWvertical(70),0, kWvertical(70), kHvertical(37));
        
    }];
    
}


-(void)hideCityPick{
    _proIndex = 0;
    
    [self.pickerVBg removeFromSuperview];
}

/**城市取消按钮*/
- (void)clickCancle{
    _proIndex = 0;
    
    [self.pickerVBg removeFromSuperview];
}
/**城市确定按钮*/
- (void)clickSure{
    if (self.cityName == nil  && self.proVinceName ==nil ) {
        self.cityName =@"北京";
        self.proVinceName = @"北京";
        self.provinceAndCity = [NSString stringWithFormat:@"%@ %@",self.proVinceName,self.cityName];
    }
    _selectStr = @"城市";
    [self.tableView reloadData];
    [self.pickerVBg removeFromSuperview];
    _proIndex = 0;
    
}

#pragma mark - 年代
- (void)setUpAgePickerView{
    
    self.AgepickerView = [[AgePickerView alloc] init];
    self.AgepickerView.backgroundColor = [UIColor whiteColor];
    self.AgepickerView.frame = CGRectMake(WScale(0),HScale(100), ScreenWidth, ScreenHeight*0);
    
    
    self.AgepickerView.dataSource = self;
    self.AgepickerView.delegate = self;
    
    [self.AgepickerView creatAgeview];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.AgepickerView.frame = CGRectMake(WScale(0),HScale(70.9), ScreenWidth, ScreenHeight*0.301);
        
        
        self.AgepickerView.frame = CGRectMake(WScale(0),HScale(70.9), ScreenWidth, ScreenHeight*0.301);
        self.AgepickerView.pickV.frame = CGRectMake(WScale(0), HScale(65.47), ScreenWidth, ScreenHeight*0.054);
        self.AgepickerView.Agetitle.frame = CGRectMake(0, kHvertical(14), ScreenWidth, ScreenHeight*0.018);
        self.AgepickerView.cancleAgeBtn.frame = CGRectMake(0,0, kWvertical(70), kHvertical(37));
        self.AgepickerView.sureAgeBtn.frame = CGRectMake(ScreenWidth -kWvertical(70),0, kWvertical(70), kHvertical(37));
        
        
    }];
    [self.AgepickerView.cancleAgeBtn addTarget:self action:@selector(clickAgeCancle) forControlEvents:UIControlEventTouchUpInside];
    [self.AgepickerView.sureAgeBtn addTarget:self action:@selector(clickAgeSure) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAge)];
    self.AgepickerView.pickerVBg.userInteractionEnabled = YES;
    [self.AgepickerView.pickerVBg addGestureRecognizer:tpg];
    
    //按钮背景
    [self.AgepickerView.pickerVBg addSubview:self.AgepickerView.pickV];
    [self.AgepickerView.pickerVBg addSubview:self.AgepickerView];
    [self.view addSubview:self.AgepickerView.pickerVBg];
    
}

-(void)hideAge{
    NSLog(@"年代取消按钮");
    [self.AgepickerView.pickerVBg removeFromSuperview];
    
}

/**年底取消和确定按钮*/
- (void)clickAgeCancle{
    NSLog(@"年代取消按钮");
    [self.AgepickerView.pickerVBg removeFromSuperview];
    
}

- (void)clickAgeSure{
    NSLog(@"年代确定按钮");
    _selectStr = @"年龄";
    [self createTable];
    [self.AgepickerView.pickerVBg removeFromSuperview];
    
}

#pragma mark - 杆数
- (void)createPoleView{
    
    self.poleView = [[PoleNumber alloc] init];
    self.poleView.backgroundColor = [UIColor whiteColor];
    self.poleView.frame = CGRectMake(0, HScale(100), WScale(100), HScale(30.1));
    
    self.poleView.dataSource = self;
    self.poleView.delegate = self;
    
    [self.poleView creatPoleNumber];
    
    [self.poleView.canclePoleBtn addTarget:self action:@selector(clickPoleCancle) forControlEvents:UIControlEventTouchUpInside];
    [self.poleView.surePoleBtn addTarget:self action:@selector(clickPoleSure) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tpg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPoleCancleBtn)];
    self.poleView.pickerVBg2.userInteractionEnabled = YES;
    
    [self.poleView.pickerVBg2 addGestureRecognizer:tpg];
    
    //按钮背景
    [self.poleView.pickerVBg2 addSubview:self.poleView.pickV2];
    [self.poleView.pickerVBg2 addSubview:self.poleView];
    [self.view addSubview:self.poleView.pickerVBg2];
    [UIView animateWithDuration:0.3 animations:^{
        self.poleView.frame = CGRectMake(WScale(0),HScale(70.9), ScreenWidth, ScreenHeight*0.301);
        self.poleView.pickV2 = [[UIView alloc] initWithFrame:CGRectMake(WScale(0), HScale(65.47), ScreenWidth, ScreenHeight*0.054)];
        self.poleView.Poletitle.frame = CGRectMake(0, kHvertical(14), ScreenWidth, ScreenHeight*0.018);
        self.poleView.canclePoleBtn.frame = CGRectMake(0,0, kWvertical(70), kHvertical(37));
        self.poleView.surePoleBtn.frame = CGRectMake(ScreenWidth -kWvertical(70),0, kWvertical(70), kHvertical(37));
    }];
    
}

-(void)clickPoleCancleBtn{
    [self.poleView.pickerVBg2 removeFromSuperview];
}


/**杆数-确定--取消*/
- (void)clickPoleCancle{
    NSLog(@"杆数取消按钮");
    [self.poleView.pickerVBg2 removeFromSuperview];
    
}
- (void)clickPoleSure{
    
    NSLog(@"杆数确定按钮");
    _selectStr = @"杆数";
    [self.tableView reloadData];
    [self.poleView.pickerVBg2 removeFromSuperview];
    
}

#pragma mark UIPickerView的数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.AgepickerView == pickerView) {
        return 1;
    }
    if (self.poleView == pickerView) {
        return 1;
    }else{
        return 2;
    }
    
}
#pragma mark -UIPickerView的代理


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (_AgepickerView == pickerView) {
        if (component == 0) {
            
            return self.AgeArr.count;
        }
        
    }
    //杆数
    if (_poleView == pickerView) {
        if (component == 0) {
            
            return self.PoleArr.count;
        }
        
    }
    
    //城市
    if (component == 0) { // 描述省会
        
        return self.provinces.count;
        
    }else{ // 描述选中的省会的城市
        
        // 获取省会
        GPProvince *p = self.provinces[_proIndex];
        return p.cities.count;
        
    }
    
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //年代
    if (_AgepickerView == pickerView) {
        
        if (component == 0) {
            self.Agetitle = self.AgeArr[row];
            
            return self.Agetitle;
        }
        
    }
    //杆数
    if (_poleView == pickerView) {
        
        if (component == 0) {
            self.Poletitle = self.PoleArr[row];
            
            return self.Poletitle;
        }
        
    }
    
    //城市
    if (component ==0) { // 描述省会
        
        // 获取省会
        GPProvince *p = self.provinces[row];
        
        return p.name;
        
    }else{
        // 获取选中省会
        GPProvince *p = self.provinces[_proIndex];
        
        // 当前选中的内蒙古省，只有12个城市，角标0~11，但是右边城市是北京，北京的城市大于12个城市，所以滚动的时候会出现越界。
        return p.cities[row];
    }
    
}



// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //杆数
    if (self.poleView == pickerView) {
        _poleIndex = [_poleView selectedRowInComponent:0];
        self.Poletitle = self.PoleArr[_poleIndex];
        return ;
    }
    
    //年代
    if (self.AgepickerView == pickerView) {
        _AgeIndex = [pickerView selectedRowInComponent:0];
        
        self.Agetitle = self.AgeArr[_AgeIndex];
        
    }else{
        
        if (component == 0) { // 滚动省会,刷新城市（1列）
            
            // 记录当前选中的省会
            _proIndex = [pickerView selectedRowInComponent:0];
            
            [pickerView reloadComponent:1];
            
        }
        // 获取选中省会
        GPProvince *p = self.provinces[_proIndex];
        
        // 获取选中的城市
        _cityIndex = [pickerView selectedRowInComponent:1];
        
        self.proVinceName = p.name;
        self.cityName = p.cities[_cityIndex];
        self.provinceAndCity = [NSString stringWithFormat:@"%@ %@",self.proVinceName, self.cityName];
        
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *tc = [touches anyObject];
    if (tc.view == self.view) {
        [_nickName resignFirstResponder];
        
    }
}

#pragma mark - UItextfild代理
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField{
    
    if (theTextField == self.nickName) {
        
        [self.nickName resignFirstResponder]; //这句代码可以隐藏 键盘
    }
    
    return  YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _selectStr = [NSString string];
    [_tableView reloadData];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _nickName) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 15) {
            return NO;
        }
    }
    //    //   限制苹果系统输入法  禁止输入表情
    //    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
    //        return NO;
    //    }
    //    //禁止输入emoji表情
    //    if ([self stringContainsEmoji:string]) {
    //        return NO;
    //    }
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
    if (textField == _nickName) {
        
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_tableView) {
        [self.nickName resignFirstResponder];
    }
    
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
