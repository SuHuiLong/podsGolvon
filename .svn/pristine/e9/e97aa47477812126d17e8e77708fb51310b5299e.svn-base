//
//  RespondDetailViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/10/18.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "RespondDetailViewController.h"
#import "EmojiKeybordView.h"
#import "FriendsImageTableViewCell.h"
#import "DownLoadDataSource.h"
#import "SucessView.h"
#import "AFHTTPSessionManager.h"

static NSString *headerID = @"headerID";
static NSString *cellID = @"cellID";
static NSString *FriendsImageTableViewCellIdentifier = @"FriendsImageTableViewCell";

@interface RespondDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextViewDelegate>

/** *回复: dynamicID=动态id  covComNameID=被评论人id replyFirComID=没回复的评论id，如果为一级评论，传0 */
@property (copy, nonatomic) NSString    *dynamicID;
@property (copy, nonatomic) NSString    *covComNameID;
@property (copy, nonatomic) NSString    *replyFirComID;
@property (copy, nonatomic) NSString    *commentID;            //要删除的评论ID
@property (copy, nonatomic) NSString    *commentNameID;        //评论 covComNameID=被评论人id


@property (copy, nonatomic) NSString    *reportType;            //举报类型
@property (copy, nonatomic) NSString    *reportState;            //举报类型
@property (copy, nonatomic) NSString    *reportRid;             //如果举报用户就是uid , 举报动态就是动态的 did, 举报 评论就是评论的cid

@property (copy, nonatomic) NSString    *pastedStr;              //要复制的内容


@property (strong, nonatomic) UITextView *inputTextView;//输入框*
@property (strong, nonatomic) UIButton   *keybordEmojiBtn;//选择图标
@property (strong, nonatomic) UIButton   *resignFirstResponder;
@property (strong, nonatomic) UILabel    *limitLabel;//显示限制字数
@property (strong, nonatomic) UILabel    *commentPlaceLabel;//键盘等待文字
@property (strong, nonatomic) UIView     *placeView;//等待View
@property (strong, nonatomic) UIView     *emojiKeybordView;//切换键盘按钮背景
@property (strong, nonatomic) UIView     *deleteGroundView;//删除的背景
@property (strong, nonatomic) UIView     *deleteView;//删除的view


@property (strong, nonatomic) NSIndexPath *currentInadexpath;
@property (assign, nonatomic) CGFloat     PICWIDHT;
@property (assign, nonatomic) CGFloat     PICHEIGTH;
@property (assign, nonatomic) CGFloat     keyBoardHeight;//当前键盘的高度
@property (assign, nonatomic) CGFloat     offSetY;
@property (assign, nonatomic) CGRect      headerRect;
@property (assign, nonatomic) NSInteger   rowIndex;
@property (assign, nonatomic) NSInteger   sectionIndex;
@property (assign, nonatomic) BOOL        isEmojiBtn;

@property (assign, nonatomic) int         row;
@property (assign, nonatomic) int         section;
@property (assign, nonatomic) int         cellHeght;

@property (strong, nonatomic) UILabel            *noneLabel;

@property (strong, nonatomic) UITableView        *tableview;

@property (strong, nonatomic) NSMutableArray     *dataArray;

@property (strong, nonatomic) NSMutableArray     *dynamicDataArr;

@property (strong, nonatomic) NSMutableArray      *layoutModelArr;

@property (strong, nonatomic) NSMutableArray      *picsArr;

@property (strong, nonatomic) DownLoadDataSource *loadData;
@property (strong, nonatomic) FriendsterModel    *friendModel;
@property (strong, nonatomic) EmojiKeybordView   *emojiView;//表情键盘
@property (strong, nonatomic) NewAlertView       *alertView;



@property (strong, nonatomic) UIActionSheet      *longpressActionSheet;

@property (strong, nonatomic) UIActionSheet      *reportSheet;

@property (strong, nonatomic) UIActionSheet      *reportActionSheet;

@property (assign, nonatomic) CGFloat tableViewKeyboardDelta;


@end

@implementation RespondDetailViewController

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
-(NSMutableArray *)picsArr{
    if (!_picsArr) {
        
        _picsArr = [[NSMutableArray alloc] init];
    }
    return _picsArr;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)dynamicDataArr{
    if (!_dynamicDataArr) {
        _dynamicDataArr = [[NSMutableArray alloc] init];
    }
    return _dynamicDataArr;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.emojiView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    _tableViewKeyboardDelta=0;
    self.rowIndex = 0;
    [self createTableView];
    [self createNotification];
    [self requestRespondDetailData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createTextView];

    
}


-(void)testNetState{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak typeof(self) weakSelf = self;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        appdele.reachAbilety = status > 0;
        if (status == AFNetworkReachabilityStatusNotReachable) {
            
            [weakSelf alertShowView:@"网络连接失败"];
        }else{
            [weakSelf requestRespondDetailData];
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
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

#pragma mark ---- 创建UI
// 创建键盘
-(void)createTextView{
    
    _emojiKeybordView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(44) + kHvertical(216)+kHvertical(49))];
    _emojiKeybordView.backgroundColor = GPColor(243, 245, 249);
    _inputTextView = [[UITextView alloc]init];
    _inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), HScale(4.5));
    _inputTextView.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _inputTextView.delegate = self;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.backgroundColor = [UIColor whiteColor];
    _inputTextView.scrollsToTop = NO;
    [_emojiKeybordView addSubview:_inputTextView];
    [self.view addSubview:_emojiKeybordView];
    
    
    _commentPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(12), HScale(1.1), WScale(70), HScale(2.7))];
    _commentPlaceLabel.text = @"评论";
    _commentPlaceLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _commentPlaceLabel.textColor = [UIColor lightGrayColor];
    [_inputTextView addSubview:_commentPlaceLabel];
    
    
    _emojiView = [[EmojiKeybordView alloc] initWithFrame:CGRectMake(0, _inputTextView.bottom + HScale(1.1), ScreenWidth, kHvertical(216))];
    __weak __typeof(self)weakSelf = self;
    _emojiView.selectEmoji = ^(id select){
        [weakSelf textViewChange:select];
    };
    [_emojiKeybordView addSubview:_emojiView];
    _keybordEmojiBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - kWvertical(44), 0, kWvertical(44), kHvertical(44))];
    [_keybordEmojiBtn addTarget:self action:@selector(changeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [_keybordEmojiBtn setImage:[UIImage imageNamed:@"EmojiKeybord"] forState:UIControlStateNormal];
    [_keybordEmojiBtn setImage:[UIImage imageNamed:@"KeybordEmojiIcon"] forState:UIControlStateSelected];
    
    _keybordEmojiBtn.imageEdgeInsets = UIEdgeInsetsMake(kWvertical(10), kHvertical(10), kWvertical(10), kHvertical(10));
    _keybordEmojiBtn.selected  = NO;
    [_emojiKeybordView addSubview:_keybordEmojiBtn];
    
    [_emojiView.sendBtn addTarget:self action:@selector(writhComment) forControlEvents:UIControlEventTouchUpInside];
    
    
    _limitLabel = [[UILabel alloc] init];
    _limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), 0, kWvertical(44), kWvertical(44));
    _limitLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _limitLabel.hidden = YES;
    _limitLabel.textAlignment = NSTextAlignmentCenter;
    _limitLabel.textColor = [UIColor lightGrayColor];
    [_emojiKeybordView addSubview:_limitLabel];
    
}

-(void)createNav{
    
    self.navigationItem.title = @"动态正文";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];

    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
//    UIView *navi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
//    navi.backgroundColor = [UIColor whiteColor];
//    
//    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.frame = CGRectMake(0, 20, 44, 44);
//    back.userInteractionEnabled = YES;
//    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
//    backImage.image = [UIImage imageNamed:@"返回"];
//    [back addSubview:backImage];
//    [back addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
//    [navi addSubview:back];
//    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-120)/2, 35, 120, 15)];
//    if (self.view.frame.size.height <= 568)
//    {
//        title.font = [UIFont boldSystemFontOfSize:kHorizontal(20)];
//        
//    }
//    else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667)
//    {
//        title.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
//        
//    }else{
//        
//        title.font = [UIFont boldSystemFontOfSize:kHorizontal(17)];
//        
//    }
//    title.text = @"动态正文";
//    title.textAlignment = NSTextAlignmentCenter;
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, ScreenWidth, 0.5)];
//    line.backgroundColor = NAVLINECOLOR;
//    
//    [navi addSubview:line];
//    [navi addSubview:title];
//    [self.view addSubview:navi];
    
    
}
-(void)createTableView{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.backgroundColor = WhiteColor;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerClass:[FriendsterTableViewCell class] forCellReuseIdentifier:cellID];
    [_tableview registerClass:[FriendsImageTableViewCell class] forCellReuseIdentifier:FriendsImageTableViewCellIdentifier];
    [self.view addSubview:_tableview];
    
    //取消键盘第一响应者
    [_resignFirstResponder removeFromSuperview];
    _resignFirstResponder                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _resignFirstResponder.hidden          = YES;
    _resignFirstResponder.backgroundColor = [UIColor clearColor];
    _resignFirstResponder.frame           = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [_resignFirstResponder addTarget:self action:@selector(clickResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resignFirstResponder];
}
-(void)createNoneDynamic{
    
    [_noneLabel removeFromSuperview];
    _noneLabel = [[UILabel alloc] init];
    _noneLabel.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));
    _noneLabel.text = @"你查看的动态不存在";
    _noneLabel.textAlignment = NSTextAlignmentCenter;
    _noneLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _noneLabel.textColor = GRYTEXTCOLOR;
    [self.view addSubview:_noneLabel];
    
}

-(void)alertSuccessShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"成功" descStr: str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
-(void)longpressGestureRecognizer{
    
    _longpressActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制",@"举报", nil];
    _longpressActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_longpressActionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
-(void)createActionSheet{
    
    _reportSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
    _reportSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_reportSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
-(void)createReportView{
    _reportActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情信息",@"广告欺诈",@"不当发言",@"虚假信息", nil];
    
    _reportActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_reportActionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
-(void)createPastedboard{
    
    [UIPasteboard generalPasteboard].string = _pastedStr;
    [self alertSuccessShowView:@"复制成功"];
}
#pragma mark ---- 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FriendsterModel *model = _dataArray[section];
    return model.commets.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:FriendsImageTableViewCellIdentifier configuration:^(id cell) {
            
            FriendsImageTableViewCell *tempCell = (FriendsImageTableViewCell*)cell;
            tempCell.fd_enforceFrameLayout = true;
            
            FriendsterModel *model = _dataArray[indexPath.section ];
            PhotoBrowerLayoutModel *layoutModel = self.layoutModelArr[indexPath.section];
            
            [tempCell setModel:model];
            [tempCell setLayoutModel:layoutModel];
            
        }];
        
    }
    
    FriendsterModel *friendsterModel = _dataArray[indexPath.section];
    DynamicMessageModel *model = friendsterModel.commets[indexPath.row-1];
    if ([model.type isEqualToString:@"0"]) {
        //评论的时的高度
        if (Device >=9.0) {
            
            CGSize TitleSize= [model.content boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Light size:kHorizontal(13)]} context:nil].size;
            if (TitleSize.height + kWvertical(23)<kWvertical(55)) {
                return kWvertical(55);
                
            }else{
                return TitleSize.height + kWvertical(23)+kHvertical(10);
            }
        }else{
            CGSize TitleSize= [model.content boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
            if (TitleSize.height + kWvertical(23)<kWvertical(55)) {
                return kWvertical(55);
                
            }else{
                return TitleSize.height + kWvertical(23)+kHvertical(10);
            }
        }
        
        
    }
    else{
        //        回复的时候的高度
        UILabel *test = [[UILabel alloc] init];
        test.font =  [UIFont systemFontOfSize:kHorizontal(13)];
        test.text = model.covnickname;
        [test sizeToFit];
        if (Device >= 9.0) {
            NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.covnickname,model.content];
            CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:Light size:kHorizontal(13)]} context:nil].size;
            
            if (TitleSize.height + kWvertical(23)<kWvertical(55)) {
                return kWvertical(55);
                
            }else{
                return TitleSize.height + kWvertical(23)+kHvertical(10);
            }
            
        }
        NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.covnickname,model.content];
        CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(kWvertical(300), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
        
        if (TitleSize.height + kWvertical(23)<kWvertical(55)) {
            return kWvertical(55);
            
        }else{
            return TitleSize.height + kWvertical(23)+kHvertical(10);
        }
    }
    //    return [tableView fd_heightForCellWithIdentifier:cellID cacheByKey:[NSString stringWithFormat:@"ROWCACHE_%ld_%ld",(long)indexPath.section, (long)indexPath.row] configuration:^(id cell) {
//        FriendsterTableViewCell *tempCell = (FriendsterTableViewCell*)cell;
//        tempCell.fd_enforceFrameLayout = true;
//        [tempCell relayoutWithModel:model];
//        
//    }];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        FriendsImageTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier: FriendsImageTableViewCellIdentifier forIndexPath:indexPath];
        tempCell.line.hidden = YES;
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([_inquireNameid isEqualToString:userDefaultUid]) {
            
            tempCell.followBtn.hidden = YES;
        }else{
            
            tempCell.followBtn.hidden = NO;

        }
        __weak typeof(self) weakSelf = self;
        
        tempCell.longpressHeader = ^(FriendsterModel *model){
            [weakSelf longpressHeader:model];
        };
        tempCell.followBlock = ^(FriendsterModel *model){
            [weakSelf setFollowBtn:model];
        };
        tempCell.commentBlock = ^(FriendsterModel *model){
            weakSelf.sectionIndex = indexPath.section;
            [weakSelf clickToComment:model];
        };
        
        tempCell.likeBlock = ^(FriendsterModel *model){
            weakSelf.sectionIndex = indexPath.section;
            [weakSelf clickToLike:model];
        };
        
        tempCell.clickHeaderIconBlock = ^(FriendsterModel *model){
            [weakSelf clickToHeaderIconBtn:model];
        };
        tempCell.longpressHeaderImageBlock = ^(FriendsterModel *model){
            
            [weakSelf longpressHeaderImage:model];
        };
        return tempCell;
        
    }
    
    FriendsterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    FriendsterModel *model = _dataArray[indexPath.section];
    [cell relayoutWithModel:model.commets[indexPath.row-1]];
    
    
    [cell.headerBtn addTarget:self action:@selector(clickToOwnDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentNickname addTarget:self action:@selector(clickToOwnDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.replyNickname addTarget:self action:@selector(clickToReplyDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    
    __weak typeof(self) weakSelf = self;
    cell.longpressBlock = ^(DynamicMessageModel *model){
        [weakSelf longpressComment:model];
    };
    
    cell.pressHeaderBlock = ^(DynamicMessageModel *model){
        
        [weakSelf pressCellHeader:model];
        
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /**
     *
     dynamicID=动态id
     covComNameID=被评论人id
     replyFirComID=没回复的评论id，如果为一级评论，传0
     */
    self.rowIndex = indexPath.row;
    [self.tableview deselectRowAtIndexPath:[_tableview indexPathForSelectedRow] animated:YES];
    
    if (indexPath.row > 0 ) {
        
        FriendsterModel *model = _dataArray[indexPath.section];
        DynamicMessageModel *model1 = model.commets[indexPath.row-1];
        
        _covComNameID = model1.covuid;
        _replyFirComID = model1.cid;
        _dynamicID = model.did;
        if ([model1.comuid isEqualToString:userDefaultUid]) {
            
            [self deleteDynamic:model1];
            
        }else{
            
            _currentInadexpath = indexPath;
            [self adjustTableViewToFitKeybord];

            _keybordEmojiBtn.selected = NO;
            _emojiKeybordView.hidden = NO;
            _commentPlaceLabel.text = [NSString stringWithFormat:@"回复：%@",model1.nickname];
            _resignFirstResponder.hidden = NO;
            [self.inputTextView becomeFirstResponder];
            
        }
        
    }else{
        return;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        FriendsImageTableViewCell *tempCell = (FriendsImageTableViewCell*)cell;
        [tempCell setDataWithModel:_dataArray[indexPath.section]];
        [tempCell setLayoutModel:self.layoutModelArr[indexPath.section]];
        
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == _longpressActionSheet) {
        switch (buttonIndex) {
                
            case 0:
                [self createPastedboard];
                break;
            case 1:
                [self createReportView];
                break;
                
            default:
                break;
        }
    }else if (actionSheet == _reportSheet){
        switch (buttonIndex) {
            case 0:
                
                [self createReportView];
                
                break;
                
            default:
                break;
        }
        
    }else{
        switch (buttonIndex) {
            case 0:
                _reportState = @"1";
                [self reportData];
                break;
            case 1:
                
                _reportState = @"2";
                [self reportData];
                break;
            case 2:
                
                _reportState = @"3";
                [self reportData];
                break;
            case 3:
                
                _reportState = @"4";
                [self reportData];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark ---- 点击事件
-(void)clickBackBtn{
    [self setEmojiView:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [self releseViews:self.view];
}

-(void)releseViews:(UIView *)view{
    NSInteger num = view.subviews.count;
    for (int i = 0; i<num; i++) {
        //        NSLog(@"11111");
        UIView *View = view.subviews[i];
        [self releseViews:View];
        [self setView:nil];
        //        NSLog(@"22222");
        
    }
}


//取消响应
-(void)clickResignFirstResponder{
    _resignFirstResponder.hidden = YES;
    _isEmojiBtn = NO;
    _emojiKeybordView.hidden = YES;
    [_inputTextView resignFirstResponder];
    
}
//点赞
-(void)clickToLike:(FriendsterModel *)model{
    
    __weak typeof(self) weakself = self;
    NSDictionary *parameters = @{@"did":model.did,
                                 @"name_id":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=click",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            NSString *code = data[@"code"];
            NSString *isdel = data[@"isdel"];
            NSArray *arr = data[@"clicks"];
            if ([code isEqualToString:@"1"]) {
                if ([isdel isEqualToString:@"0"]) {
                    
                    FriendsterModel *friendModel = weakself.dataArray[self.sectionIndex];
                    NSDictionary *dic = arr.firstObject;
                    LikeUsersModel   *tempMode = [LikeUsersModel modelWithDictionary:dic];
                    [friendModel.clicks appendObject:tempMode];
                    model.isclicked = true;
                    [weakself.tableview reloadData];
                    
                    
                }else{
                    
                    __block NSInteger deleteIndex = 0;
                    
                    [model.clicks enumerateObjectsUsingBlock:^(LikeUsersModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.cuid isEqualToString:userDefaultUid]) {
                            deleteIndex = idx;
                            *stop = true;
                        }
                    }];
                    
                    [model.clicks removeObjectAtIndex:deleteIndex];
                    model.isclicked = NO;
                    [weakself.tableview reloadData];
                }
                
                
            }else{
                
//                NSLog(@"点赞失败");
            }
            
        }else{
            
            [weakself alertShowView:@"网络错误"];
        }
    }];
}
//点击评论
-(void)clickToComment:(FriendsterModel *)model{
//    ;

    
    _commentNameID = model.uid;
    _dynamicID = model.did;
    _inputTextView.inputView = nil;
    _keybordEmojiBtn.selected = NO;
    _resignFirstResponder.hidden = NO;
    _commentPlaceLabel.text = @"评论";
    _emojiKeybordView.hidden = NO;
    [_inputTextView becomeFirstResponder];
    
    
    _row = 0;
    _section = 0;
    for (int i = 0; i<_dataArray.count; i++) {
        FriendsterModel *model = _dataArray[i];
        if ([model.did isEqualToString:_dynamicID]) {
            
            _section = i;
        }
    }
    
    for (int i = 0; i< model.commets.count; i++) {
        DynamicMessageModel *dyModel = model.commets[i];
        if ([dyModel.cid isEqualToString:_reportRid]) {
            _row = i;
        }
    }
    
    _cellHeght = model.commets.count * kHvertical(50);
    _currentInadexpath = [NSIndexPath indexPathForRow:_row inSection:_section];
    [self adjuestTableviewHeaderToTop];
    
}

//跳转到评论人的个人中心
-(void)clickToOwnDetail:(UIButton *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableview indexPathForCell:cell];
    FriendsterModel *model = _dataArray[indexPath.section];
    DynamicMessageModel *dyModel = model.commets[indexPath.row-1];
    NSString *covNameID = dyModel.comuid;
    if (![covNameID isEqualToString:userDefaultUid]) {
        
        NewDetailViewController *VC = [[NewDetailViewController alloc]init];
        VC.nameID = covNameID;
        VC.hidesBottomBarWhenPushed = YES;
        [VC setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

// 跳转到被回复人的个人中心
-(void)clickToReplyDetail:(UIButton *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableview indexPathForCell:cell];
    FriendsterModel *model = _dataArray[indexPath.section];
    DynamicMessageModel *dyModel = model.commets[indexPath.row-1];
    NSString *mesNameID = dyModel.covuid;
    if ([mesNameID isEqualToString:userDefaultUid]) {
        
        NewDetailViewController *VC = [[NewDetailViewController alloc]init];
        VC.nameID = mesNameID;
        VC.hidesBottomBarWhenPushed = YES;
        [VC setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

//点击头像
-(void)clickToHeaderIconBtn:(FriendsterModel *)model{
    NewDetailViewController *VC = [[NewDetailViewController alloc]init];
    VC.nameID = model.uid;
    VC.hidesBottomBarWhenPushed = YES;
    [VC setBlock:^(BOOL isback) {
        
    }];
    [self.navigationController pushViewController:VC animated:YES];
}
//长按评论
-(void)longpressComment:(DynamicMessageModel *)model{
    
    _reportRid = model.cid;
    _reportType = @"2";
    _pastedStr = model.content;
    
    [self longpressGestureRecognizer];
}

//长按动态
-(void)longpressHeader:(FriendsterModel *)model{
    
    _reportRid = model.did;
    _reportType = @"1";
    _pastedStr = model.content;
    if ([model.content isEqualToString:@""]) {
        [self createActionSheet];
        
    }else{
        
        [self longpressGestureRecognizer];
    }
}
//长按头像
-(void)longpressHeaderImage:(FriendsterModel *)model{
    _reportRid = model.uid;
    _reportType = @"3";
    [self createActionSheet];
    
    [self createActionSheet];
}
//长按评论人的头像
-(void)pressCellHeader:(DynamicMessageModel *)model{
    
    _reportRid = model.covuid;
    _reportType = @"3";
    
    [self createActionSheet];
    
}

//删除
-(void)deleteDynamic:(DynamicMessageModel *)model{
    
    _commentID = model.cid;
    
    
    _deleteGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _deleteGroundView.hidden = NO;
    _deleteGroundView.backgroundColor = GPRGBAColor(.2, .2, .2, .3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHidden)];
    [_deleteGroundView addGestureRecognizer:tap];
    [self.view addSubview:_deleteGroundView];
    
    _deleteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, HScale(14.8))];
    _deleteView.hidden = NO;
    _deleteView.backgroundColor = GPColor(245, 245, 245);
    [_deleteGroundView addSubview:_deleteView];
    [[[UIApplication sharedApplication] .windows firstObject] addSubview:_deleteGroundView];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    confirmBtn.backgroundColor = [UIColor whiteColor];
    [confirmBtn addTarget:self action:@selector(clickToDelet) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"删除" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:GPColor(58, 56, 59) forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    [_deleteView addSubview:confirmBtn];
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    [cancel addTarget:self action:@selector(clickToHidden) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:GPColor(58, 56, 59) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    
    [_deleteView addSubview:cancel];
    
    [UIView animateWithDuration:0.4 animations:^{
        _deleteView.frame = CGRectMake(0, ScreenHeight - HScale(14.8), ScreenWidth, HScale(14.8));
    }];
    [UIView animateWithDuration:0.2 animations:^{
        confirmBtn.frame = CGRectMake(0, 0, ScreenWidth, HScale(6.9));
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        cancel.frame = CGRectMake(0, HScale(7.9), ScreenWidth, HScale(6.9));
    }];
    
    
}
-(void)clickToHidden{
    [_deleteView removeFromSuperview];
    [_deleteGroundView removeFromSuperview];
}
//删除评论
-(void)clickToDelet{
    __weak typeof(self) weakself = self;
    NSDictionary *parmaters = @{@"cid":_commentID,
                                @"name_id":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dyndelcommit",apiHeader120] parameters:parmaters complicate:^(BOOL success, id data) {
        if (success) {
            
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"1"]) {
                FriendsterModel *tempModel = weakself.dataArray[_sectionIndex];
                [tempModel.commets removeObjectAtIndex:weakself.rowIndex-1];
            }else{
                
                NSLog(@"删除失败");
            }
            
            [weakself clickToHidden];
            [weakself.tableview reloadData];
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
    
}
// 加关注
-(void)setFollowBtn:(FriendsterModel *)model{
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{
                                @"follow_name_id":userDefaultId,
                                @"cof_name_id":model.uid
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertFollow",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            NSString *strCode = data[@"data"][0][@"code"];
            
            if ([strCode isEqualToString:@"1"]) {
                
                [_dataArray removeAllObjects];
                [weakself requestRespondDetailData];
//                [weakself.tableview reloadData];
            }
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
}

#pragma mark ---- 请求数据
-(void)requestRespondDetailData{
    __weak typeof(self) weakself = self;
    NSDictionary *parmaters = @{@"name_id":userDefaultId,
                                @"did":_inquireDynamicID};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=getdynbydid",apiHeader120] parameters:parmaters complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *arr = data[@"data"];
            NSString *code = data[@"code"];
            for (int i = 0; i<arr.count; i++) {
                
                [weakself.picsArr addObject:arr[i][@"pics"]];
                
            }
            
            _layoutModelArr = [NSMutableArray array];
            for (int i = 0; i<_picsArr.count; i++) {
                
                PhotoBrowerLayoutModel *layoutModel = [[PhotoBrowerLayoutModel alloc] initWithPhotoUrlsArray:self.picsArr[i] andOrigin:CGPointMake(0, 0)];
                [weakself.layoutModelArr addObject:layoutModel];
                
            }
            
            for (NSDictionary *temp in arr) {
                weakself.friendModel = [FriendsterModel modelWithDictionary:temp];
                [weakself.dataArray addObject:weakself.friendModel];
                weakself.dynamicDataArr = weakself.friendModel.commets;
            }
            
            weakself.inquireNameid = weakself.friendModel.uid;
            if ([code isEqualToString:@"0"] || [code isEqualToString:@"506"]) {
                [weakself createNoneDynamic];
            }else{
                
            }
            
            [_tableview reloadData];

        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
}

-(void)refreshRespondDetailData{
    
    __weak typeof(self) weakself = self;
    NSDictionary *parmaters = @{@"name_id":userDefaultId,
                                @"did":_inquireDynamicID};
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=getdynbydid",apiHeader120] parameters:parmaters complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *arr = data[@"data"];
            [_dataArray removeAllObjects];
            for (NSDictionary *temp in arr) {
                weakself.friendModel = [FriendsterModel modelWithDictionary:temp];
                [weakself.dataArray addObject:weakself.friendModel];
                weakself.dynamicDataArr = weakself.friendModel.commets;
            }
            [weakself.tableview reloadData];
            
        }else{
            
            [weakself alertShowView:@"网络错误"];
        }
    }];
}
-(void)reportData{
    __weak typeof(self) weakself = self;
    //     report_type=举报内容，1为举报动态，2为举报评论，3为举报用户
    //    report_state=举报类型，1=色情信息,2=广告欺诈,3=不当发言,4=虚假消息
    NSDictionary *parameters = @{@"name_id":userDefaultId,
                                 @"rid":_reportRid,
                                 @"content":_reportState,
                                 @"type":_reportType};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dynreport",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        NSString *code = data[@"code"];
        if ([code isEqualToString:@"1"]) {
            [weakself alertSuccessShowView:@"提交成功"];
        }else{
            [weakself alertShowView:@"提交失败"];
        }
    }];
    
}

-(void)writhComment{
    __weak typeof(self) weakself = self;
    NSString *commentDesc = [NSMutableString stringWithFormat:@"%@",_inputTextView.text];
    NSMutableString *commentTest = [NSMutableString stringWithString:commentDesc];
    NSString *str2 = [commentTest stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (str2.length<1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提交内容不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"重新提交" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
        
        
    }else{
        if ([_commentPlaceLabel.text isEqualToString:@"评论"]) {
            NSDictionary *parameters = @{
                                         @"name_id":userDefaultId,    //评论人id
                                         @"did":_dynamicID,
                                         @"content":commentDesc
                                         };
            _resignFirstResponder.hidden = YES;
            [_inputTextView resignFirstResponder];
            _isEmojiBtn = NO;
            _emojiKeybordView.hidden = YES;
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dynaddcommit",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    NSString *code = data[@"code"];
                    NSArray *commets = data[@"commets"];
                    weakself.inputTextView.text = @"";
                    if ([code isEqualToString:@"1"]) {
                        
                        FriendsterModel *model = self.dataArray[self.sectionIndex];
                        NSDictionary *dic = commets.firstObject;
                        DynamicMessageModel *tempMode = [DynamicMessageModel modelWithDictionary:dic];
                        [model.commets appendObject:tempMode];
                        [weakself.tableview reloadData];
                        
                    }else{
                        [weakself alertShowView:@"提交失败"];
                    }
                    
                }else{
                    [weakself alertShowView:@"网络错误"];
                }
            }];
            
        }else{
            NSDictionary *parameters = @{
                                         @"name_id":userDefaultId,
                                         @"did":_dynamicID,
                                         @"content":commentDesc,
                                         @"replycid":_replyFirComID,
                                         };
            _resignFirstResponder.hidden = YES;
            _isEmojiBtn = NO;
            _emojiKeybordView.hidden = YES;
            [_inputTextView resignFirstResponder];
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dynaddcommit",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    
                    _inputTextView.text = @"";
                    NSString *code = data[@"code"];
                    NSArray *commets = data[@"commets"];
                    if ([code isEqualToString:@"1"]) {
                        
                        FriendsterModel *model = weakself.dataArray[weakself.sectionIndex];
                        NSDictionary *dic = commets.firstObject;
                        DynamicMessageModel *tempMode = [DynamicMessageModel modelWithDictionary:dic];
                        [model.commets appendObject:tempMode];
                        [weakself.tableview reloadData];
                        
                    }else{
                        [weakself alertShowView:@"提交失败"];
                    }
                }else{
                    [weakself alertShowView:@"网络错误"];
                }
            }];
            
        }
    }
}

#pragma mark ---- 键盘处理
-(void)createNotification{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [notificationCenter addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)showKeyboard:(NSNotification *)notication
{
    
    _commentPlaceLabel.hidden = NO;
    
    if (_inputTextView.text.length==0) {
        
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    NSDictionary *dic = notication.userInfo;
    CGSize kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _keyBoardHeight = kbSize.height;
    _keybordEmojiBtn.selected = NO;
    _emojiView.hidden = YES;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.emojiKeybordView.frame = CGRectMake(0, ScreenHeight - kHvertical(44) - _keyBoardHeight, ScreenWidth, kHvertical(44)+kHvertical(216));
        weakself.keybordEmojiBtn.frame = CGRectMake(ScreenWidth - kWvertical(44), _emojiKeybordView.height-kHvertical(216) - kWvertical(44), kWvertical(44), kWvertical(44));
    }];
    
}
- (void)hideKeyboard:(NSNotification *)notication
{
    
    if (self.isEmojiBtn == YES) {
        _isEmojiBtn = NO;
        _emojiKeybordView.hidden = NO;
    }else{
        _emojiKeybordView.hidden = YES;
        
    }
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.23 animations:^{
        weakself.emojiKeybordView.frame = CGRectMake(0, ScreenHeight-kHvertical(44)-kHvertical(216), ScreenWidth, kHvertical(44)+kHvertical(216));
        weakself.inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), HScale(4.5));
        weakself.keybordEmojiBtn.frame = CGRectMake(ScreenWidth - kWvertical(44),_emojiKeybordView.height - kHvertical(44)-kHvertical(216), kWvertical(44), kHvertical(44));
        weakself.limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), _emojiKeybordView.top, kWvertical(44), kWvertical(44));
    }];
    
//    CGPoint offset = self.tableview.contentOffset;
//    offset.y -= _tableViewKeyboardDelta;
//    [self.tableview setContentOffset:CGPointMake(0, offset.y) animated:YES];
}

//键盘切换
-(void)changeKeyboard:(UIButton *)btn{
    btn.selected = !btn.selected;
    _isEmojiBtn = YES;
    if (btn.selected == YES) {
        _emojiView.hidden = NO;
        [_inputTextView resignFirstResponder];
    }else{
        [_inputTextView becomeFirstResponder];
    }
}
//表情键盘操作
-(void)textViewChange:(NSString *)emojiStr{
    
    NSString *mStr = _inputTextView.text;
    if (mStr == 0) {
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    NSString *mStr1;
    //    NSString *mStr1 = [NSString string];
    BOOL isEmoji = NO;
    
    if ([emojiStr isEqualToString:@"EmojiDeleat"]) {
        if ([mStr length]==0) {
            return;
        }
        if ([mStr length]>=2) {
            mStr1 = [mStr substringWithRange:NSMakeRange(mStr.length-2, 2)];
            isEmoji = [self isEmoji:mStr1];
        }
        
        mStr = [mStr substringToIndex:mStr.length-1];
        if (isEmoji) {
            mStr = [mStr substringToIndex:mStr.length-1];
        }
        
    }else{
        mStr = [NSMutableString stringWithFormat:@"%@%@", _inputTextView.text,emojiStr];
    }
    _inputTextView.text = mStr;
    
    
    [self textViewDidChange:_inputTextView];
    
}
//判断Emoji
- (BOOL)isEmoji:(NSString *)emoji {
    const unichar high = [emoji characterAtIndex: 0];
    
    // Surrogate pair (U+1D000-1F77F)
    if (0xd800 <= high && high <= 0xdbff) {
        const unichar low = [emoji characterAtIndex: 1];
        const int codepoint = ((high - 0xd800) * 0x400) + (low - 0xdc00) + 0x10000;
        
        return (0x1d000 <= codepoint && codepoint <= 0x1f77f);
        
        // Not surrogate pair (U+2100-27BF)
    } else {
        return (0x2100 <= high && high <= 0x27bf);
    }
}

#pragma mark ---- UITextView代理
-(void)textViewDidChange:(UITextView *)textView{
    
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)self.inputTextView.text.length];
    int a = 200 - [len intValue];
    if (a<=0) {
        NSString *str = [textView.text substringToIndex:200];
        _inputTextView.text = str;
        a =0;
        /**超过200字符不能输入
         */
        [_alertView removeFromSuperview];
        [_alertView.contentLabel removeFromSuperview];
        
        _alertView = [[NewAlertView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2 - kHvertical(32), ScreenWidth, kHvertical(64))];
        _alertView.contentLabel.textColor = [UIColor whiteColor];
        [_alertView setContentWith:@"😅最多输入200字符"];
        [self.view addSubview:_alertView];
        [self.view addSubview:_alertView.contentLabel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_alertView removeFromSuperview];
            [_alertView.contentLabel removeFromSuperview];
        });
        
    }
    if(a <=50){
        _limitLabel.hidden = YES;
        _limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), _inputTextView.top, kWvertical(44), kWvertical(44));
        _limitLabel.text = [NSString stringWithFormat:@"%d",a];
    }
    
    if (textView.text.length == 0) {
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_inputTextView resignFirstResponder];
    _emojiKeybordView.hidden = YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self writhComment];
        
    }
    return YES;
}

#pragma mark ==== 评论或者回复的时候，让键盘往上移动
-(void)adjuestTableviewHeaderToTop{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *header = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_section]];
    //    NSLog(@"第%d段",_page);
    CGRect cellFrame = CGRectMake(header.origin.x, header.origin.y, header.width, header.height + _cellHeght+kHvertical(49));
    CGRect rect = [header.superview convertRect:cellFrame toView:window];
    [self adjustTableViewToFitKeybordWithRect:rect];
    
}
-(void)adjustTableViewToFitKeybord{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:_currentInadexpath];
    CGRect cellFrame = CGRectMake(cell.origin.x, cell.origin.y, cell.width, cell.height+kHvertical(49));
    CGRect rect = [cell.superview convertRect:cellFrame toView:window];
    [self adjustTableViewToFitKeybordWithRect:rect];
}

-(void)adjustTableViewToFitKeybordWithRect:(CGRect)rect{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat keyboardHeight;
    if (_keyBoardHeight == 0) {
        
        if (self.view.frame.size.height <= 568)
        {
            keyboardHeight = 251.5;
            
        }else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667){
            
            keyboardHeight = 258;
        }else{
            
            keyboardHeight = 292;
            
        }
    }else{
        
        keyboardHeight = _keyBoardHeight;
    }
//    NSLog(@"keyboardHeight:%f",keyboardHeight);
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - keyboardHeight);
    
    CGPoint offset = self.tableview.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableview setContentOffset:CGPointMake(0, offset.y) animated:YES];
    _tableViewKeyboardDelta = delta;
}

@end
