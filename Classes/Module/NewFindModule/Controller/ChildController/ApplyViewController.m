//
//  ApplyViewController.m
//  podsGolvon
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ApplyViewController.h"
#import "ApplyTableViewCell.h"

@interface ApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView   *tableview;
@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) DownLoadDataSource   *loadData;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *num;
@end

static NSString *applyCellID = @"ApplyTableViewCell";
@implementation ApplyViewController

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self createUI];
    [self createNavigationBar];
}
#pragma mark ---- UI
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

-(void)createNavigationBar{
    
    self.navigationItem.title = @"填写报名信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];
    
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(turnBack)];
    leftBarbutton.tintColor = localColor;
    self.navigationItem.leftBarButtonItem = leftBarbutton;

    UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickFinish)];
    [rightBarbutton setTintColor:localColor];
    self.navigationItem.rightBarButtonItem = rightBarbutton;

}
-(void)createUI{
    
    UIView *groundView = [[UIView alloc] init];
    groundView.frame = CGRectMake(0, 0, ScreenWidth, kHvertical(78));
    groundView.backgroundColor = WhiteColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(14), kHvertical(14), kWvertical(60), kHvertical(18))];
    titleLabel.textColor = textTintColor;
    titleLabel.text = @"活动时间";
    titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [groundView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(14), titleLabel.bottom+kHvertical(12), kWvertical(200), kHvertical(20))];
    contentLabel.textColor = textTintColor;
    contentLabel.text = @"11月 11日 14:00 星期五";
    contentLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [groundView addSubview:contentLabel];

    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    [_tableview registerClass:[ApplyTableViewCell class] forCellReuseIdentifier:applyCellID];
    _tableview.rowHeight = kHvertical(38);
    _tableview.tableHeaderView = groundView;
    [self.view addSubview:_tableview];
}
#pragma mark ---- 点击事件
-(void)turnBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickFinish{
    [_textField resignFirstResponder];
    
    if (_name.length == 0) {
        
        [self createPromptWithStr:@"请输入昵称"];
        return;
    }else if (![self validateMobile:_phone]){
        [self createPromptWithStr:@"请输入正确的手机号"];
        return;
    }else if (_num.length == 0){
        [self createPromptWithStr:@"请输入人数"];
        return;
    }
    NSDictionary *dic = @{@"discid":_ID,
                          @"jname":_name,
                          @"jphone":_phone,
                          @"uid":userDefaultUid,
                          @"num":_num};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=joindisc",apiHeader120] parameters:dic complicate:^(BOOL success, id data) {
        if (success) {
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"1"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
            }
        }
    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(14), kHvertical(16), ScreenWidth - kWvertical(28), kHvertical(32))];
    label.numberOfLines = 2;
    label.text = @"以下信息将提供给（活动）发起人\n打球去不会泄露你的个人信息";
    label.font = [UIFont systemFontOfSize:kHorizontal(11)];
    label.textColor = textTintColor;
    [header addSubview:label];
    
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(14), kHvertical(16), ScreenWidth - kWvertical(28), kHvertical(32))];
    label.numberOfLines = 2;
    label.text = @"填写报名表并不代表报名成功，请完成活动介绍中的全部步骤，我们将在1个工作日内与你取得联系";
    label.font = [UIFont systemFontOfSize:kHorizontal(11)];
    label.textColor = textTintColor;
    [footer addSubview:label];
    
    return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(63);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kHvertical(370);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:applyCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField = cell.contentField;
    self.textField.tag = indexPath.row+100;
    switch (indexPath.row) {
        case 0:
            cell.typeLabel.text = @"报名姓名";
            cell.contentField.placeholder = @"请输入姓名";
            self.textField.delegate = self;
            break;
            
        case 1:
            cell.typeLabel.text = @"移动电话";
            cell.contentField.placeholder = @"请输入联系电话";
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.delegate = self;

            break;
            
        case 2:
            cell.typeLabel.text = @"参加人数";
            cell.contentField.placeholder = @"请输入参加的人数";
            cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.delegate = self;

            break;
    
        default:
            break;
    }
    
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}
#pragma mark ---- UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 100:
            _name = textField.text;
            break;
            
        case 101:
            _phone = textField.text;
            break;
            
        case 102:
            _num = textField.text;
            break;
            
        default:
            break;
            
    }

}
//手机号码正则
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13，15，18  14开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
@end
