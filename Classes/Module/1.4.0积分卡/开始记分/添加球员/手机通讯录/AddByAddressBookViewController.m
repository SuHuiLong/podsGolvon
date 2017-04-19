//
//  AddByAddressBookViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "AddByAddressBookViewController.h"
#import <ContactsUI/ContactsUI.h>
#import "GolfersTableViewCell.h"
#import "AddressListModel.h"
#import "PPGetAddressBook.h"
#import "GolfersModel.h"

@interface AddByAddressBookViewController ()<CNContactPickerDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
//本地联系人数组
@property (nonatomic,strong)NSMutableArray *dataArray;
//数据源
@property (nonatomic,strong)NSDictionary *dataDict;
//首字母集合
@property (nonatomic,strong)NSArray *headArray;
//tableview
@property (nonatomic,copy)UITableView *mainTableView;
//创建HUD
@property (nonatomic,copy)MBProgressHUD *HUD;

@end

@implementation AddByAddressBookViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

#pragma mark - createView
-(void)createView{
    [self createTableView];
}
//创建tableview
-(void)createTableView{
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + kHvertical(45), ScreenWidth, ScreenHeight-64-kHvertical(45))];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [mainTableView registerClass:[GolfersTableViewCell class] forCellReuseIdentifier:@"GolfersTableViewCell"];
    mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}
//创建HUD
-(void)createHUD{
    
//    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _HUD.mode = MBProgressHUDModeIndeterminate;
//    _HUD.delegate = self;
//    _HUD.label.text = @"加载中...";
}
-(void)createAlertView{
    SucessView *sview = [[SucessView alloc] initWithFrame:CGRectMake((ScreenWidth- kWvertical(136))/2, kHvertical(286), kWvertical(136), kHvertical(96)) imageImageName:@"失败" descStr:@"最多选择三名球员"];
    
    [self.view addSubview:sview];
    
}

//跳转至系统
-(void)createPushSystemView{
   
    NSString *desc = @"请打开iPhone中的\"设置-隐私-照片\"选项中，\r允许打球去访问你的通讯录";

    UILabel *descLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(10), kHvertical(160), ScreenWidth-kWvertical(20), kHvertical(80)) textColor:BlackColor fontSize:kHorizontal(18) Title:desc];
    descLabel.numberOfLines = 0;
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:descLabel];
    
    UIButton *btn = [Factory createButtonWithFrame:CGRectMake(ScreenWidth/2-kWvertical(30), descLabel.y_height, kWvertical(60), kHvertical(40)) titleFont:kHvertical(18) textColor:localColor backgroundColor:ClearColor target:self selector:@selector(pushToSystem) Title:@"设置"];
    [self.view addSubview:btn];
    
}

-(void)pushToSystem{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - loadData
//获取已选择球员
-(void)initViewData{
//    _selectPlayerArray = [userDefaults objectForKey:@"SelectPlayerArray"];
}


-(void)initData{
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    //     2.判断授权状态,如果不是已经授权,则直接返回    
    if (status == CNAuthorizationStatusNotDetermined) {
        [[[CNContactStore alloc]init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){
                [self loadPhoneData];
                NSLog(@"选择了同意");
            }
        }];
        
    }else if (status == CNAuthorizationStatusAuthorized){
//        [self createHUD];
        [self loadPhoneData];

    }else if(status == CNAuthorizationStatusDenied){
        // 弹窗显示
        [self createPushSystemView];
    }
}


-(void)loadPhoneData{
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 0, 80, 80);
    indicator.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*0.5-80);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];

    
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        [indicator stopAnimating];
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        for (int i = 0; i<nameKeys.count; i++) {
            NSMutableArray *newArray = [NSMutableArray array];
            NSArray *selectArray = [addressBookDict objectForKey:nameKeys[i]];
            for (PPPersonModel *Model  in selectArray) {
                if (Model.mobileArray.count==0) {
                    break;
                } 
                for (GolfersModel *model in _selectPlayerArray) {
                    if ([Model.mobileArray[0] isEqualToString:model.phoneStr]) {
                        Model.isSelect = YES;
                    }
                }
                [newArray addObject:Model];
            }
            [newDict setValue:newArray forKey:nameKeys[i]];
        }
        
        self.dataDict = [NSDictionary dictionaryWithDictionary:newDict];
        self.headArray = [NSArray arrayWithArray:nameKeys];
        
        [self.mainTableView reloadData];
    } authorizationFailure:^{
        // 弹窗显示
        [self createPushSystemView];
    }];


}




#pragma mark - Action

//选中按钮点击
-(void)selectBtnClick:(UIButton *)sender{
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:_dataDict];
    NSInteger selectNum = _selectPlayerArray.count;
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    
    NSString *headName = [_headArray objectAtIndex:indexPath.section];
    NSMutableArray *selectModelArray = [_dataDict objectForKey:headName];
    
    PPPersonModel *personModel = selectModelArray[indexPath.item];

    GolfersModel *selectModel = [[GolfersModel alloc] init];
    
    selectModel.phoneStr = personModel.mobileArray[0];
    selectModel.nickname = personModel.name;
    selectModel.avator = @"";
    selectModel.isSelect = personModel.isSelect;
    
    if (selectModel.isSelect) {
        selectModel.isSelect = false;
        personModel.isSelect = false;
        for (GolfersModel *model in _selectPlayerArray) {
            if ([model.uid isEqualToString:selectModel.uid]) {
                NSMutableArray *selectArray = [NSMutableArray arrayWithArray:_selectPlayerArray];
                [selectArray removeObject:model];
                _selectPlayerArray = [NSMutableArray arrayWithArray:selectArray];
            }
        }
    }else{
        NSString *playerNum = [userDefaults objectForKey:@"selectPlayerNum"];
        if ([playerNum integerValue]>4) {
            [self createAlertView];
            return;
        }else{
            selectModel.isSelect = true;
            personModel.isSelect = true;
            NSMutableArray *selectArray = [NSMutableArray arrayWithArray:_selectPlayerArray];
            [selectArray insertObject:selectModel atIndex:selectArray.count-1];
            _selectPlayerArray = [NSMutableArray arrayWithArray:selectArray];
        }
    }
    
    [selectModelArray replaceObjectAtIndex:indexPath.item withObject:personModel];
    
    _dataDict = [NSDictionary dictionaryWithDictionary:mDict];
    [_mainTableView reloadData];
    
    NSString *isSelectStr = @"0";
    if (selectModel.isSelect) {
        isSelectStr = @"1";
    }
    
    NSDictionary *selectPlayerdict = @{
                                       @"phoneStr":selectModel.phoneStr,
                                       @"nickname":selectModel.nickname,
                                       @"isSelect":isSelectStr,
                                       @"addType":@"1",
                                       };
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"playerChangeNotice" object:nil userInfo:selectPlayerdict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}



#pragma mark - TableViewDelegate;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _headArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *keys = _headArray[section];
    NSArray *sectionArray = [_dataDict objectForKey:keys];
    return sectionArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(45);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(30);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GolfersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GolfersTableViewCell" forIndexPath:indexPath];
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *keys = _headArray[indexPath.section];
    NSArray *sectionArray = [_dataDict objectForKey:keys];
    [cell configAddressModel:sectionArray[indexPath.row]];

    return cell;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    NSArray *sectionArray = _dataArray[section];
    
    UIView *headerView = [Factory createViewWithBackgroundColor:GPColor(238, 239, 241) frame:CGRectMake(0, 0, ScreenWidth, kHvertical(30))];
    NSString *titleStr = _headArray[section];
//    AddressListModel *model = sectionArray[0];
//    titleStr = [self firstCharactor:model.nickName];
    
    UILabel *titleLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(13), 0, ScreenWidth/2, kHvertical(30)) textColor:BlackColor fontSize:kHorizontal(13.0f) Title:titleStr];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [headerView addSubview:titleLabel];
    return headerView;
}


-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSMutableArray *titleArray = [NSMutableArray array];
//    for (int i =0 ; i<_dataArray.count; i++) {
//        AddressListModel *model = _dataArray[i][0];
//        NSString *indexStr = [self firstCharactor:model.nickName];
//        
//        [titleArray addObject:indexStr];
//    }
    
    return _headArray;
    
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{

    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

#pragma mark - Others
//手机号码正则
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13，15，18  14开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
