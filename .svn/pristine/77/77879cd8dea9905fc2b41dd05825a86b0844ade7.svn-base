//
//  Self_LY_ViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/23.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_LY_ViewController.h"
#import "SelfLiuYanModel.h"
#import "Self_LY_TableViewCell.h"
#import "NewDetailViewController.h"
#import "AidViewController.h"
//#import "DetailView.h"

@interface Self_LY_ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{

    NSInteger _keybordHeight;
    MBProgressHUD *_HUB;

}
@property (strong, nonatomic) DownLoadDataSource *downLoad;
@property (strong, nonatomic) NSMutableArray     *liuYanData;
@property (assign, nonatomic) int                currPage;
@property (assign, nonatomic) int                allPage;
@property (assign, nonatomic) int                currPageTest;

@property (strong, nonatomic) UITextView         *mainTextView;
@property (strong, nonatomic) UIImageView        *liuYanImage;
@property (strong, nonatomic) UILabel            *liuYanLabel;
@property (strong, nonatomic) UIView             *commanBackView;
@property (strong, nonatomic) UILabel            *commentPlaceLabel;
@property (strong, nonatomic) UILabel            *noneDataLabel;
@end

@implementation Self_LY_ViewController
-(DownLoadDataSource *)downLoad{
    if (!_downLoad) {
        _downLoad = [[DownLoadDataSource alloc]init];
    }
    return _downLoad;
}
-(NSMutableArray *)liuYanData{
    if (!_liuYanData) {
        _liuYanData = [[NSMutableArray alloc]init];
    }
    return _liuYanData;
}
#pragma mark - ViewDidLoad
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    self.view.backgroundColor = WhiteColor;
    _currPage = 0;
    _currPageTest = 0;
    [super viewDidLoad];
    
    [self createNav];
    [self createUI];
    [self ReseavNotification];
    
}


-(void)createNav{
    
    
    self.navigationItem.title = @"留言";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];

    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
}




-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 创建textView
-(void)createTextView{
    _mainTextView = [[UITextView alloc]init];
    _commanBackView = [[UIView alloc] init];
    _commanBackView.backgroundColor = [UIColor whiteColor];
    
    _commanBackView.frame = CGRectMake(0, HScale(93.4), ScreenWidth, HScale(6.6));
        
    _mainTextView.frame = CGRectMake(0, HScale(1.1), WScale(96.3), HScale(4.5));
    
    [self.view addSubview:_commanBackView];
    
    _commentPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(WScale(1.2), HScale(1.1), WScale(70), HScale(2.7))];
    _commentPlaceLabel.text = @"发表留言";
    _commentPlaceLabel.hidden = YES;
    _commentPlaceLabel.font = [UIFont systemFontOfSize:13.f];
    _commentPlaceLabel.textColor = [UIColor lightGrayColor];
    [_commentPlaceLabel sizeToFit];
    [_mainTextView addSubview:_commentPlaceLabel];
    
    _mainTextView.font = [UIFont boldSystemFontOfSize:kHorizontal(14)];
//    _mainTextView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:0.88];
    _mainTextView.delegate = self;
    
    _liuYanImage = [[UIImageView alloc] initWithFrame:CGRectMake(WScale(43.7), HScale(1.9), WScale(4), HScale(2.4))];
    _liuYanImage.image = [UIImage imageNamed:@"CommentImage"];
    
    _liuYanLabel= [[UILabel alloc] initWithFrame:CGRectMake(WScale(49.1), HScale(1.5), WScale(20), HScale(3))];
    _liuYanLabel.text = @"留言";
    _liuYanLabel.font = [UIFont systemFontOfSize:12.f];
    _liuYanLabel.textColor = [UIColor colorWithRed:52/255 green:186/255 blue:182/255 alpha:1.0f];
    [_commanBackView addSubview:_mainTextView];
    [_commanBackView addSubview:_liuYanImage];
    [_commanBackView addSubview:_liuYanLabel];
    _mainTextView.returnKeyType = UIReturnKeySend;
    _mainTextView.backgroundColor = [UIColor whiteColor];

}

static CGFloat _lastOffY;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _lastOffY = scrollView.contentOffset.y;
}

-(void)createNoneDataView{
    
    _tableView.hidden = YES;
    [_noneDataLabel removeFromSuperview];
    _noneDataLabel = [[UILabel alloc]init];
    _noneDataLabel.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));
    if ([_nameID isEqualToString:userDefaultUid]) {
        _noneDataLabel.text = @"您还没有留言";

    }else{
        _noneDataLabel.text = @"对方还没有留言";

    }
    _noneDataLabel.textAlignment = NSTextAlignmentCenter;
    _noneDataLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _noneDataLabel.textColor = textTintColor;
    [self.view addSubview:_noneDataLabel];
}
#pragma mark - 接收键盘通知

-(void)ReseavNotification{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(showLiuYanKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [notificationCenter addObserver:self selector:@selector(hideLiuYanKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  接收弹出键盘通知
 *
 */
- (void)showLiuYanKeyboard:(NSNotification *)notice
{
    // 消息的信息
    NSDictionary *dic = notice.userInfo;
    CGSize kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    if (_mainTextView.text.length == 0) {
        _commentPlaceLabel.hidden = NO;
    }
    
    [UIView animateWithDuration:1 animations:^{
        _liuYanLabel.hidden = YES;
        _liuYanImage.hidden = YES;
        _keybordHeight = kbSize.height;

        _commanBackView.frame = CGRectMake(0, HScale(93.4)  - kbSize.height, ScreenWidth, HScale(6.6));
            
        
        _commanBackView.backgroundColor = GPColor(249, 250, 251);
        _mainTextView.layer.borderColor = GPColor(227, 228, 229).CGColor;
        
        
        _commanBackView.layer.borderWidth = 1;
        _commanBackView.layer.cornerRadius = 0;
        
        _commanBackView.layer.masksToBounds = YES;
        
        
        _commanBackView.backgroundColor = [UIColor whiteColor];
        _commanBackView.layer.borderColor = GPColor(227, 228, 229).CGColor;
        
        
        
        _mainTextView.layer.borderWidth = 1;
        _mainTextView.layer.cornerRadius = 3;
        
        _mainTextView.layer.masksToBounds = YES;
        
        _mainTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), WScale(96.3), HScale(4.5));

        
        
    }];
    
}
/**
 *  接收隐藏键盘的通知
 */

- (void)hideLiuYanKeyboard:(NSNotification *)notice
{
    
    [UIView animateWithDuration:1 animations:^{
        [_mainTextView resignFirstResponder];
        _liuYanImage.hidden = NO;
        _liuYanLabel.hidden = NO;
        _commanBackView.frame = CGRectMake(0, HScale(93.4), ScreenWidth, HScale(6.6));

                _commentPlaceLabel.hidden = YES;
        
        _mainTextView.layer.borderWidth = 0;
        _mainTextView.text = @"";
        
        
    }];
}

#pragma mark ---- 刷新
-(void)headerRefresh{
    _currPage = 0;
    [self.tableView.mj_footer resetNoMoreData];
    __weak typeof(self) weakself = self;
    NSDictionary *parmete = @{
                              @"start_number":[NSString stringWithFormat:@"%d",_currPage],
                              @"name_id":self.nameID
                              };
    [self.downLoad downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_message_name_id",urlHeader120] parameters:parmete complicate:^(BOOL success, id data) {
        [self.tableView.mj_header endRefreshing];
        if (success) {
            if (weakself.currPageTest==0) {
                if (![weakself.nameID isEqualToString:userDefaultId]) {
//                    [_mainTextView becomeFirstResponder];
                    weakself.currPageTest = 1;
                }
                
            }
            [weakself.liuYanData removeAllObjects];
            NSDictionary *tempArr = data[@"data"];
            if ([tempArr count] == 0) {
                [weakself createNoneDataView];
            }
            weakself.allPage = (int)data[@"allpage"];
            for (NSDictionary *temp in tempArr) {
                SelfLiuYanModel *model = [SelfLiuYanModel pareFromDictionary:temp];
                [weakself.liuYanData addObject:model];
            }
            [weakself.tableView reloadData];
        }
    }];
}
-(void)footerRefresh{
    _currPage++;
    if (_currPage>_allPage) {
        _currPage--;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *parmete = @{
                              @"start_number":[NSString stringWithFormat:@"%d",_currPage],
                              @"name_id":self.nameID
                              };
    [self.downLoad downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_message_name_id",urlHeader120] parameters:parmete complicate:^(BOOL success, id data) {
        [weakself.tableView.mj_footer endRefreshing];
        if (success) {
            NSDictionary *dic = data;
            weakself.allPage = (int)data[@"allpage"];
            for (NSDictionary *temp in dic[@"data"]) {
                SelfLiuYanModel *model = [SelfLiuYanModel pareFromDictionary:temp];
                [weakself.liuYanData addObject:model];
            }
            [weakself.tableView reloadData];
        }
        
    }];
    
}
-(void)loadData{
    __weak typeof(self) weakself = self;
    NSDictionary *parmete = @{
                              @"start_number":[NSString stringWithFormat:@"%d",_currPage],
                              @"name_id":self.nameID
                              };
    [self.downLoad downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_message_name_id",urlHeader120] parameters:parmete complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *tempArr = data[@"data"];
            for (NSDictionary *temp in tempArr) {
                SelfLiuYanModel *model = [SelfLiuYanModel pareFromDictionary:temp];
                [weakself.liuYanData addObject:model];
            }
            [weakself.tableView reloadData];
        }

    }];
}

#pragma mark - 点击return隐藏键盘&&提交留言&&提交回复

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    __weak typeof(self) weakself = self;
    if ([text isEqualToString:@"\n"]) {
        NSString *commentDesc = [NSMutableString stringWithFormat:@"%@",textView.text];
        NSMutableString *commentTest = [NSMutableString stringWithString:commentDesc];
        
        NSString *str2 = [commentTest stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (str2.length<1) {
                [_mainTextView resignFirstResponder];

            
        }else{
            if ([_commentPlaceLabel.text isEqualToString:@"发表留言"]) {
            NSDictionary *dict = @{
                                   @"content":commentDesc,
                                   @"covmessage_name":self.nickName,
                                   @"name_id":self.nameID,
                                   @"message_name":[userDefaults objectForKey:@"nickname"],
                                   @"login_nameid":userDefaultId
                                   };

            [_mainTextView resignFirstResponder];
            DownLoadDataSource *dataManager = [[DownLoadDataSource alloc] init];
            [dataManager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insert_message",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
                if (success) {
                    
                    weakself.liuYanData = [NSMutableArray array];
                    [weakself headerRefresh];
                    weakself.mainTextView.text = @"";
                    
                    [_noneDataLabel removeFromSuperview];
                    _tableView.hidden = NO;
                }
            }];
                
            }else{
                NSDictionary *dict = @{
                                       @"content":commentDesc,
                                       @"covmessage_name":self.nickName,
                                       @"name_id":self.nameID,
                                       @"message_name":[userDefaults objectForKey:@"nickname"],
                                       @"login_nameid":userDefaultId,
                                       @"cover_reply_nameid":self.replyid,
                                       @"cover_reply_nackname":self.replyname
                                       };
                
                [weakself.mainTextView resignFirstResponder];
                DownLoadDataSource *dataManager = [[DownLoadDataSource alloc] init];
                [dataManager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/insert_reply_message",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
                    weakself.commentPlaceLabel.text = @"发表留言";
                    if (success) {
                        weakself.liuYanData = [NSMutableArray array];
                        
                        [weakself headerRefresh];
                        weakself.mainTextView.text = @"";
                        
                        
                        [_noneDataLabel removeFromSuperview];
                        _tableView.hidden = NO;
                    }
                }];

            }
        }
        return NO;
    }
    return YES;
}

- (void)creatAlert:(NSTimer *)timer{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}


-(void)textViewDidChange:(UITextView *)textView{
    
    NSString *textStr = textView.text;
    NSLog(@"%@",textStr);
    if (textView.text.length == 0) {
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    
    if (textView.contentSize.height>HScale(3.9)) {
        if (textView.contentSize.height>HScale(8.7)) {
            
                _commanBackView.frame = CGRectMake(0, HScale(89.2) - _keybordHeight  , ScreenWidth, HScale(10.8));
                
            _mainTextView.frame = CGRectMake(WScale(1.9), HScale(1.1) , WScale(96.3),HScale(8.7));
        }else{

            _commanBackView.frame = CGRectMake(0, HScale(97.9) - _keybordHeight - textView.contentSize.height, ScreenWidth,  textView.contentSize.height+HScale(2.1));
            
            _mainTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), WScale(96.3), textView.contentSize.height);
            
            
        }
    }
}

#pragma mark - 隐藏键盘


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_mainTextView resignFirstResponder];
}


#pragma mark - 创建视图
-(void)createUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-HScale(6.6))];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorStyle = NO;
    _tableView.rowHeight = ScreenHeight * 0.111;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addSubview:_tableView];
    
    //    头部刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    //    立即刷新
//    [refreshHeader beginRefreshing];
    self.tableView.mj_header = refreshHeader;
    
    //    尾部刷新
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.tableView.mj_footer = refreshFooter;
    [self createTextView];
    [self headerRefresh];

}

-(void)scrollViewDidScroll:(UITableView *)tableview{
    
    if (tableview == _tableView) {
        [_mainTextView resignFirstResponder];
    }

}
-(void)hideKeyboard{

    [_mainTextView resignFirstResponder];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _liuYanData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    SelfLiuYanModel *model = _liuYanData[indexPath.row];
    if ([model.reply_message_sta isEqualToString:@"0"]) {
        CGSize TitleSize= [model.messageContent boundingRectWithSize:CGSizeMake(WScale(75.4), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        
        if (TitleSize.height + HScale(6.6)<HScale(11.1)) {
            return HScale(11.1);
            
        }else{
           return TitleSize.height + HScale(6.6) + 11;
        }

    }else{
    UILabel *test = [[UILabel alloc] init];
    test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
    test.text = model.cover_reply_nackname;
//    [test sizeToFit];
        NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.cover_reply_nackname,model.messageContent];
        CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(WScale(96.7)-WScale(21.3), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
    
        if (TitleSize.height + HScale(6.6)<HScale(11.1)) {
            return HScale(11.1);
            
        }else{
            return TitleSize.height + HScale(6.6)+ 11;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Self_LY_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Self_LY_TableViewCell"];
    if (cell == nil) {
        cell = [[Self_LY_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Self_LY_TableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    [cell realyoutWithModel:_liuYanData[indexPath.row]];
    [cell.headerImage addTarget:self action:@selector(clickToDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.nameLabel addTarget:self action:@selector(clickToDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button addTarget:self action:@selector(clickToDetail1:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.headerImage.tag = 101*indexPath.row;
    cell.nameLabel.tag = 101*indexPath.row;
    cell.button.tag = 102*indexPath.row;
    
    return cell;

}

#pragma mark ---- 跳转
-(void)clickToDetail:(UIButton *)sender{
    
    NSInteger tag1 = sender.tag/101;
    NewDetailViewController *detail= [[NewDetailViewController alloc]init];
    AidViewController *aid = [[AidViewController alloc]init];
    SelfLiuYanModel *model = _liuYanData[tag1];
    if ([model.nameID isEqualToString:@"usergolvon"]) {
        [aid setBlock:^(BOOL isView) {
            
        }];
        [self.navigationController pushViewController:aid animated:YES];
        
    }else if ([model.nameID isEqualToString:userDefaultId]){
        
        detail.nameID = model.nameID;
        [detail setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        
        detail.nameID = model.nameID;
        [detail setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
-(void)clickToDetail1:(UIButton *)sender{
    
    NSInteger tag2 = sender.tag/102;
    SelfLiuYanModel *model2 = _liuYanData[tag2];
    NewDetailViewController *detail2= [[NewDetailViewController alloc]init];
    AidViewController *aid = [[AidViewController alloc]init];
    if ([model2.cover_reply_nameid isEqualToString:@"usergolvon"]) {
        [aid setBlock:^(BOOL isView) {
            
        }];
        [self.navigationController pushViewController:aid animated:YES];
        
    }else if ([model2.cover_reply_nameid isEqualToString:userDefaultId]){
        
        detail2.nameID = model2.cover_reply_nameid;
        
        [detail2 setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:detail2 animated:YES];
    }else{
        
        detail2.nameID = model2.cover_reply_nameid;
        [detail2 setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:detail2 animated:YES];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelfLiuYanModel *model = _liuYanData[indexPath.row];
    _replyname = model.nickname;
    _replyid = model.nameID;
    _commentPlaceLabel.text = [NSString stringWithFormat:@"回复：%@",model.nickname];
    if ([model.nameID isEqualToString:userDefaultId]) {
        _commentPlaceLabel.text = @"发表留言";
        return;
    }
    [_commentPlaceLabel sizeToFit];
    [_mainTextView becomeFirstResponder];
    
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
