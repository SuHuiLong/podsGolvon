//
//  AddByInputViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "AddByInputViewController.h"
#import "AddByInputTableViewCell.h"
#import "GolfersModel.h"

@interface AddByInputViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
}
@property(nonatomic,copy)UITableView *mainTableView;
//滚动前的位置
@property(nonatomic,assign)CGFloat recentIndex;
//可手动输入用户总数
@property(nonatomic,assign)NSInteger playerNum;
//总数据源
@property(nonatomic,strong)NSMutableDictionary *dataDict;

@end

@implementation AddByInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reciveNotice];
}
//接收更改数据通知
-(void)reciveNotice{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPlayerData:) name:@"selectAddByInput" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenKeybord) name:@"hidenInputKeybord" object:nil];
}

-(void)reloadPlayerData:(NSNotification *)notice{
    NSDictionary *userInfo = notice.userInfo;
    NSString *playerNum = [userInfo objectForKey:@"num"];
    _playerNum = 5 + _dataDict.allKeys.count  - [playerNum integerValue];
    [_mainTableView reloadData];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - createView
-(void)createView{
    [self createTableView];
}

-(void)createTableView{
    _dataDict = [NSMutableDictionary dictionary];
    for (GolfersModel *model in _selectPlayerArray) {
        if ([model.addType integerValue]>0) {
            [_dataDict setValue:model forKey:model.addType];
        }
    }
    
    
    _playerNum = 5 + _dataDict.allKeys.count - [[userDefaults objectForKey:@"selectPlayerNum"] integerValue];
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+kHvertical(45), ScreenWidth, ScreenHeight - kHvertical(45)-64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView registerClass:[AddByInputTableViewCell class] forCellReuseIdentifier:@"AddByInputTableViewCell"];
    mainTableView.backgroundColor = GPColor(238, 239, 241);
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
}

#pragma mark - loadData
//获取已选择球员
-(void)initViewData{
//    _selectPlayerArray = [userDefaults objectForKey:@"SelectPlayerArray"];
}

#pragma mark - tableview代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _playerNum;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHvertical(98);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHvertical(30);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddByInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddByInputTableViewCell" forIndexPath:indexPath];
    cell.nickName.delegate = self;
    cell.phoneNumber.delegate = self;
    cell.nickName.tag = 100 + 2*indexPath.row;
    cell.phoneNumber.tag = 100 + 2*indexPath.row + 1;
    [cell.nickName addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.phoneNumber addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    GolfersModel *model = [_dataDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.item+2]];
    [cell configModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [Factory createViewWithBackgroundColor:GPColor(238, 239, 241) frame:CGRectMake(0, 0, ScreenWidth, kHvertical(30))];
    UILabel *titleLable = [Factory createLabelWithFrame:CGRectMake(kWvertical(13), 0, 0, kHvertical(30)) textColor:rgba(123,123,123,1) fontSize:kHorizontal(13) Title:@"添加联系人"];
    [titleLable sizeToFitSelf];
    
    UILabel *alertLabel = [Factory createLabelWithFrame:CGRectMake(titleLable.x_width, 0, ScreenWidth/2, kHvertical(30)) textColor:rgba(199,199,199,1) fontSize:kHorizontal(11) Title:@"(*号为必填项)"];

    [headerView addSubview:titleLable];
    [headerView addSubview:alertLabel];
    return headerView;
}

#pragma mark - textfeild代理
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];

    if (indexPath.row>0) {
        [_mainTableView setContentOffset:CGPointMake(0,kHvertical(98)) animated:YES];
    }else{
        [_mainTableView setContentOffset:CGPointMake(0,0) animated:YES];
    }
}

-(void)textFieldChange:(UITextField *)textField{
    NSInteger kMaxLength = 11;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }  
    }  

    
    
    [self dataChange:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }

    [self dataChange:textField];
}
-(void)dataChange:(UITextField *)textField{
    NSString *str = textField.text;
    NSInteger tag = textField.tag-100;
    
    GolfersModel *model = [[GolfersModel alloc] init];
    switch (tag%2) {
        case 0:{
            UITextField *phoneTextFeild = [self.view viewWithTag:100+tag+1];
            NSString *phoneStr = phoneTextFeild.text;
            if (phoneStr.length==0) {
                return;
            }
            model.nickname = str;
            model.phoneStr = phoneTextFeild.text;
            model.isSelect = YES;
            model.addType = [NSString stringWithFormat:@"%ld",2+tag/2];
        }break;
        case 1:{
            if (str.length<5) {
                return;
            }
            UITextField *nickNameTextFeild = [self.view viewWithTag:100+tag-1];
            model.nickname = nickNameTextFeild.text;
            model.phoneStr = str;
            model.isSelect = YES;
            model.addType = [NSString stringWithFormat:@"%ld",2+tag/2];
        }break;
        default:
            break;
    }
    
    NSDictionary *selectPlayerdict = @{
                                       @"phoneStr":model.phoneStr,
                                       @"nickname":model.nickname,
                                       @"isSelect":@"1",
                                       @"addType":model.addType,
                                       };
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"playerChangeNotice" object:nil userInfo:selectPlayerdict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>11) {
        return NO;
    }else{
        return YES;
    }
}


#pragma mark - uiscrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    recentIndex
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>_recentIndex) {
        _recentIndex = offsetY;
    }else{
        _recentIndex = 0;
        if ([scrollView isEqual:_mainTableView]) {
            [self hidenKeybord];
        }
    }
}


-(void)hidenKeybord{
    for (int i = 0; i<6; i++) {
        
        UITextField *selectTextField = (UITextField *)[self.view viewWithTag:100+i];
        [selectTextField resignFirstResponder];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    for (int i = 0; i<6; i++) {
//        UITextField *selectTextField = (UITextField *)[self.view viewWithTag:100+i];
//        [selectTextField resignFirstResponder];
//    }
    [self hidenKeybord];
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
