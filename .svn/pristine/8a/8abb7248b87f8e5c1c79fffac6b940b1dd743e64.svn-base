//
//  SeachViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/6.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "SeachViewController.h"
#import "SearchResultTableViewCell.h"
#import "SearchResultModel.h"
#import "RecommendModel.h"
#import "HomePageViewController.h"

@interface SeachViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton *resignFirstResponder;
    UIView *lableBtn;
    MBProgressHUD *_HUD;
    UIImageView *hotImge;
    UILabel *hotLabel;
}

/***  输入框*/
@property (strong, nonatomic) UITextField    *inputText;
/***  默认文字*/
@property (strong, nonatomic) UILabel    *placeLabel;
/***  默认图像*/
@property (strong, nonatomic) UIImageView    *placeImage;

@property (strong, nonatomic) DownLoadDataSource   *loadData;

@property (strong, nonatomic) NSMutableArray   *dataArr;

@property (strong, nonatomic) UITableView    *tableView;
/***  没有搜索结果的时候*/
@property (strong, nonatomic) UILabel    *noneLabel;
/***  没开始搜索的时候*/
@property (strong, nonatomic) UIView    *placeView;

@end

static NSString *cellID = @"SearchResultTableViewCell";
@implementation SeachViewController

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    if (_hotDataArr.count == 0) {
        
        [self requestData];
    }
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self createInputTextView];
    
    [self cresteHotView];
}

#pragma mark ---- UI
-(void)createInputTextView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *line          = [[UIView alloc]init];
    line.backgroundColor  = GPColor(232, 232, 232);
    line.frame            = CGRectMake(0, 63, ScreenWidth, 1);
    [self.view addSubview:line];
    
    UIView *groundView = [[UILabel alloc] init];
    groundView.frame = CGRectMake(kWvertical(7), line.top - 6-28, kWvertical(316), 28);
    groundView.backgroundColor = GPColor(243, 245, 249);
    [self.view addSubview:groundView];
    
    
    _placeImage = [[UIImageView alloc] init];
    [_placeImage setImage:[UIImage imageNamed:@"搜索图标"]];
    [self.view addSubview:_placeImage];
    [_placeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(groundView);
        make.left.equalTo(groundView).with.offset(7);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    
    
    //输入框
    _inputText                 = [[UITextField alloc]init];
    _inputText.frame           = CGRectMake(kWvertical(30), line.top - 6-28, kWvertical(290), 28);
    _inputText.delegate        = self;
    _inputText.font            = [UIFont systemFontOfSize:kHorizontal(12)];
    _inputText.backgroundColor = ClearColor;
    _inputText.tintColor       = localColor;
    _inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inputText.placeholder = @"用户昵称";
    [_inputText addTarget:self action:@selector(clickToHidden) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_inputText];
    _inputText.returnKeyType = UIReturnKeyGoogle;
    [self.view addSubview:_inputText];
    [_inputText becomeFirstResponder];
    //
    //取消按钮
    UIButton *cancelBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame           = CGRectMake(groundView.right, kHvertical(20), 46, 40);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    [cancelBtn setTitleColor:localColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    
    //取消第一响应
    resignFirstResponder                 = [UIButton buttonWithType:UIButtonTypeCustom];
    resignFirstResponder.hidden          = YES;
    resignFirstResponder.backgroundColor = [UIColor clearColor];
    resignFirstResponder.frame           = CGRectMake(0, 0, ScreenWidth, kHvertical(400));
    [resignFirstResponder addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignFirstResponder];
    
    //    [self cresteHotView];
    
}

//没有开始搜索的时候
-(void)createTableview{
    
    [_tableView removeFromSuperview];
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, kHvertical(75), ScreenWidth, ScreenHeight - 64);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = kHvertical(67);
    [_tableView registerClass:[SearchResultTableViewCell class] forCellReuseIdentifier:cellID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
-(void)cresteHotView{
    
    _placeView=[[UIView alloc]initWithFrame:CGRectMake(0, kHorizontal(123), [UIScreen mainScreen].bounds.size.width, kWvertical(200))];
    _placeView.backgroundColor = [UIColor whiteColor];
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    for (int i = 0; i < 10; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1 + i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        RecommendModel *model = _hotDataArr[i];
        NSString *str = model.nickname;
        
        CGSize titleSize = [str boundingRectWithSize:CGSizeMake(999, kHvertical(27)) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(12)]} context:nil].size;
        titleSize.width += kWvertical(6);
        //自动的折行
        han = han +titleSize.width+kWvertical(18);
        if (han > [[UIScreen mainScreen]bounds].size.width) {
            han = 0;
            han = han + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(kWvertical(18),kHvertical(40)*height, titleSize.width, kHvertical(27));
        }else{
            button.frame = CGRectMake(width+kWvertical(18)+(number*15), kHvertical(40)*height, titleSize.width, kHvertical(27));
            width = width+titleSize.width;
        }
        number++;
        button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderWidth = 1;
        button.layer.borderColor = LightGrayColor.CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
        [button setTitleColor:GRYTEXTCOLOR forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateNormal];
        [_placeView addSubview:button];
    }
    
    for (UIButton *btn in _placeView.subviews) {
        [btn addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [hotImge removeFromSuperview];
    hotImge = [[UIImageView alloc]init];
    hotImge.frame = CGRectMake(kWvertical(18), kHvertical(89), kWvertical(12), kHvertical(14));
    hotImge.image = [UIImage imageNamed:@"人气用户"];
    
    [hotLabel removeFromSuperview];
    hotLabel = [[UILabel alloc]init];
    hotLabel.frame = CGRectMake(hotImge.right + kWvertical(9), kHvertical(89), kWvertical(100), kHvertical(16));
    hotLabel.textColor = GRYTEXTCOLOR;
    hotLabel.text = @"人气球友";
    hotLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    
    [self.view addSubview:hotLabel];
    [self.view addSubview:hotImge];
    [self.view addSubview:_placeView];
}

//没有找到搜索结果的时候
-(void)createNoneResult{
    [_noneLabel removeFromSuperview];
    _noneLabel = [[UILabel alloc] init];
    _noneLabel.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));
    _noneLabel.text = @"没有找到您搜索的结果";
    _noneLabel.textAlignment = NSTextAlignmentCenter;
    _noneLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _noneLabel.textColor = textTintColor;
    [self.view addSubview:_noneLabel];
}
#pragma mark ---- 点击事件
-(void)clickCancelBtn{
    
    [_inputText resignFirstResponder];
    for (HomePageViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[HomePageViewController class]]) {
            VC.controllID = 3;
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}
-(void)clickToHidden{
    
    _placeLabel.hidden = YES;
    
}
- (void)handleButton:(UIButton *)button{
    
    
    RecommendModel *model = _hotDataArr[button.tag-1];
    
    NewDetailViewController *VC = [[NewDetailViewController alloc] init];
    VC.nameID = model.nameID;
    [VC setBlock:^(BOOL isback) {
    }];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ---- 获取数据
-(void)textFieldChanged:(NSNotification *)notification{
    _inputText = notification.object;
    if (_inputText.text.length == 0) {
        [_tableView removeFromSuperview];
        [self cresteHotView];
        //        _placeImage.hidden = NO;
        _placeLabel.hidden = NO;
        return;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{@"name_id":userDefaultId,
                                 @"keyword":_inputText.text};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=searchbynickname",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data;
            if (dic.count == 0) {
                [_placeView removeAllSubviews];
                
                hotImge.hidden = YES;
                hotLabel.hidden = YES;
                weakself.tableView.hidden = YES;
//                _placeView.hidden = YES;
                [weakself createNoneResult];
                
            }else{
                NSArray *tempArr = data[@"data"];

                [weakself.dataArr removeAllObjects];
                for (NSDictionary *temp in tempArr) {
                    SearchResultModel *model = [SearchResultModel initWithDictionary:temp];
                    [weakself.dataArr addObject:model];
                }
                weakself.noneLabel.hidden = YES;
                [weakself createTableview];
            }
            
            [_tableView reloadData];
        }else{

        }
        
    }];
    
    
    
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (_inputText.text.length == 0) {
        
//        textField = _inputText;
        _noneLabel.hidden = YES;
        [_tableView removeAllSubviews];
        [self cresteHotView];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _inputText) {
        [_inputText resignFirstResponder];
        NSString *str = textField.text;
        
        if (textField.text.length < 1) {
            return NO;
        }else{
            __weak typeof(self) weakself = self;
            NSDictionary *parameters = @{@"name_id":userDefaultId,
                                         @"keyword":str};
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@commonapi.php?func=searchbynickname",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    NSDictionary *dic = data;
                    if (dic.count == 0) {
                        [weakself.placeView removeAllSubviews];
                        
                        hotImge.hidden = YES;
                        hotLabel.hidden = YES;
                        weakself.tableView.hidden = YES;
//                      _placeView.hidden = YES;
                        [weakself createNoneResult];
                        
                    }else{
                        NSArray *tempArr = data[@"data"];
                        
                        [_dataArr removeAllObjects];
                        for (NSDictionary *temp in tempArr) {
                            SearchResultModel *model = [SearchResultModel initWithDictionary:temp];
                            [weakself.dataArr addObject:model];
                        }
                        weakself.noneLabel.hidden = YES;
                        [weakself createTableview];
                    }
                    
                    [_tableView reloadData];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        
                        [weakself presentViewController:alertController animated:YES completion:nil];
                        
                    });
                    
                }
                
            }];
        }
    }
    return YES;
}

-(void)requestData{
    _hotDataArr = [NSMutableArray array];
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.alpha = 0.5;
    NSDictionary *parameter = @{@"nameID":userDefaultId};
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/FriendsRecommend",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dict = data[@"FriendsReco"];
            
            for (NSDictionary *temp in dict) {
                RecommendModel *model = [RecommendModel initWithFromDictionary:temp];
                [self.hotDataArr addObject:model];
            }
            _HUD.hidden = YES;
            _HUD = nil;
            [_tableView reloadData];
            
            [weakself cresteHotView];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [weakself presentViewController:alertController animated:YES completion:nil];
            });
        }
        
    }];
}


#pragma mark ---- tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell relayoutWithModel:_dataArr[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    SearchResultModel *model = _dataArr[indexPath.row];
    
    NewDetailViewController *VC = [[NewDetailViewController alloc] init];
    VC.nameID = model.nameID;
    [VC setBlock:^(BOOL isback) {
    }];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:_inputText];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_inputText resignFirstResponder];
    
}
@end
