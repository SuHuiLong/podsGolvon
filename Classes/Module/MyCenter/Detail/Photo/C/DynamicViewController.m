//
//  DynamicViewController.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/19.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "DynamicViewController.h"
#import "DownLoadDataSource.h"
#import "RulesTableViewCell.h"
#import "FriendsterModel.h"
#import "FriendsterTableViewCell.h"
#import "ShlTextView.h"
#import "ReviewPhotosViewController.h"
#import "EmojiKeybordView.h"
#import "FriendsImageTableViewCell.h"



@interface DynamicViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    UILabel                 *content;//朋友圈发布内容
    UIButton                *commentBtn;//评论按钮
    UIButton                *resignFirstResponder;//点击取消键盘的第一响应者
    UIPageControl           *pageControl;
    BOOL                    autoLoadData;
    MBProgressHUD *_HUD;
    CGFloat _PICWIDHT;
    CGFloat _PICHEIGTH;
    /**
     *  访问量
     */
    NSInteger   _viewString;
    FriendsterModel *friendsterModelmdoel;
    //超出文字提示语
    NewAlertView *_alertView;
}
@property (strong, nonatomic) UITableView    *tableView;
@property (strong, nonatomic) DownLoadDataSource   *loadData;
/***  页*/
@property (assign, nonatomic) int    currpage;
/***  页*/
@property (assign, nonatomic) int    allpage;
/***  显示限制字数*/
@property (strong, nonatomic) UILabel    *limitLabel;
/**
 *
 dynamicID=动态id
 covComNameID=被评论人id
 replyFirComID=没回复的评论id，如果为一级评论，传0
 */
/***  回复*/
@property (copy, nonatomic) NSString    *dynamicID;
@property (copy, nonatomic) NSString    *covComNameID;
@property (copy, nonatomic) NSString    *replyFirComID;
/**
 *  评论
 
 covComNameID=被评论人id
 */
@property (copy, nonatomic) NSString    *commentNameID;
/***  删除的ID*/
@property (copy, nonatomic) NSString    *deleteID;
/***  删除的评论ID*/
@property (copy, nonatomic) NSString    *commentID;


/***  发布朋友圈的人的个人信息*/
@property (strong, nonatomic) NSMutableArray  *friendsterDataArr;
@property (strong, nonatomic) NSMutableArray *layoutModelArr;

@property (strong, nonatomic) NSMutableArray      *picsDataArr;

/***  点赞人的人的个人信息*/
@property (strong, nonatomic) NSArray         *likeDataArr;
@property (assign, nonatomic) CGFloat         keyBoardHeight;

@property (assign, nonatomic) BOOL    isEmojiBtn;

/**
 *  删除的背景
 */
@property (strong, nonatomic) UIView          *deleteGroundView;
/**
 *  删除的view
 */
@property (strong, nonatomic) UIView          *deleteView;

/***  输入框*/
@property (strong, nonatomic) UITextView      *inputTextView;
/***  键盘等待文字*/
@property (strong, nonatomic) UILabel         *commentPlaceLabel;


//表情键盘
@property (strong, nonatomic) EmojiKeybordView *emojiView;
//切换键盘按钮背景
@property (strong, nonatomic) UIView          *emojiKeybordView;
/***  表情按钮*/
@property (strong, nonatomic) UIButton    *emojiBtn;

/**
 *  0 直接隐藏
 1 键盘切换至表情
 2 表情切换至键盘
 */
@property(nonatomic,assign)NSInteger hidnKeybordType;

/***  添加菊花的页面*/
@property (strong, nonatomic) UIView    *placeView;
/***  定时*/
@property (strong, nonatomic) NSTimer    *timer;
/***  刷新要用的did*/
@property (assign, nonatomic) int    did;
/***  评论后刷新要的数据*/
@property (assign, nonatomic) int    oneDid;


@property (strong, nonatomic) UIActionSheet      *longpressActionSheet;

@property (strong, nonatomic) UIActionSheet      *reportActionSheet;

@property (strong, nonatomic) UIActionSheet      *reportSheet;

@property (copy, nonatomic) NSString    *pastedStr;              //要复制的内容

@property (copy, nonatomic) NSString    *reportType;            //举报类型
@property (copy, nonatomic) NSString    *reportState;            //举报类型
@property (copy, nonatomic) NSString    *reportRid;             //如果举报用户就是uid , 举报动态就是动态的 did, 举报 评论就是评论的cid
@property (strong, nonatomic) UILabel *noneDataLabel;

@property (assign, nonatomic) CGFloat tableViewKeyboardDelta;
@property (strong, nonatomic) UIView *noneDataView;

@end

static NSString *cellID = @"RulesTableView";
static NSString *identifierTableview  = @"FriendsterTableViewCell";
static NSString *FriendsImageTableViewCellIdentifier = @"FriendsImageTableViewCell";

@implementation DynamicViewController

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(NSMutableArray *)friendsterDataArr{
    if (!_friendsterDataArr) {
        _friendsterDataArr = [[NSMutableArray alloc] init];
    }
    return _friendsterDataArr;
}
-(NSMutableArray *)picsDataArr{
    if (!_picsDataArr) {
        _picsDataArr = [[NSMutableArray alloc] init];
    }
    return _picsDataArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    _currpage = 0;
    _oneDid = 0;
    _operateIndex = 0;
    _sectionIndex = 0;
    [self createUI];
    [self requestDynamicData];
    [self createNav];
    [self createRefresh];
    
    _tableViewKeyboardDelta = 0;
    //让tableView从顶部加载
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self ReseavNotification];
    [self testNetState];
    
    [self createTextView];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    _emojiKeybordView.hidden = YES;
    [_inputTextView removeFromSuperview];
}

-(void)testNetState{
    
    __weak typeof(self) weakself = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        appdele.reachAbilety = status > 0;
        
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
            //                [weakself alertShowView:@"网络连接失败"];
            weakself.tableView.hidden = YES;
            [weakself createNoInternet];
        }else{
            
            
        }
    }];
    [manager.reachabilityManager startMonitoring];
}

#pragma mark ---- UI

-(void)createNoInternet{
    
    [_noneDataView removeFromSuperview];
    _noneDataView = [[UIView alloc] init];
    _noneDataView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64-49);
    _noneDataView.backgroundColor = GPColor(252, 252, 252);
    [self.view addSubview:_noneDataView];
    
    UIImageView *noInternetImage = [[UIImageView alloc] init];
    noInternetImage.image = [UIImage imageNamed:@"noInternetImage"];
    noInternetImage.frame = CGRectMake((ScreenWidth - kWvertical(149))/2, kHvertical(143), kWvertical(149), kHvertical(99));
    [_noneDataView addSubview:noInternetImage];
    
    
    UILabel *noInternetLabel = [[UILabel alloc] init];
    noInternetLabel.frame = CGRectMake(0, noInternetImage.bottom+kHvertical(10), ScreenWidth, kHvertical(17));
    noInternetLabel.text = @"网络出错啦，点击按钮重新加载";
    noInternetLabel.textAlignment = NSTextAlignmentCenter;
    noInternetLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    noInternetLabel.textColor = mostTintColor;
    [_noneDataView addSubview:noInternetLabel];
    
    
    UIButton *noInternetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noInternetBtn.frame = CGRectMake((ScreenWidth - kWvertical(131))/2, noInternetLabel.bottom + kHvertical(10), kWvertical(131), kHvertical(32));
    noInternetBtn.layer.borderColor = TINTLINCOLOR.CGColor;
    noInternetBtn.layer.masksToBounds = YES;
    noInternetBtn.layer.cornerRadius = 2;
    noInternetBtn.layer.borderWidth = 0.5;
    noInternetBtn.backgroundColor = WhiteColor;
    [noInternetBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    noInternetBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [noInternetBtn setTitleColor:GPColor(58, 60, 72) forState:UIControlStateNormal];
    [noInternetBtn addTarget:self action:@selector(headerRefresn) forControlEvents:UIControlEventTouchUpInside];
    [_noneDataView addSubview:noInternetBtn];
    
}
-(void)createTextView{
//    边框
    _emojiKeybordView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, ScreenHeight, ScreenWidth, kHvertical(44))];
    _emojiKeybordView.backgroundColor = GPColor(243, 245, 249);
    [self.view addSubview:_emojiKeybordView];
    
//    输入框
    _inputTextView = [[UITextView alloc]init];
    
    _inputTextView.frame = CGRectMake(0, HScale(1.1), ScreenWidth-WScale(14.3), HScale(4.5));
    _inputTextView.font = [UIFont boldSystemFontOfSize:kHorizontal(14)];
    _inputTextView.delegate = self;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.backgroundColor = [UIColor whiteColor];
    [_emojiKeybordView addSubview:_inputTextView];
    
//    等待文字
    _commentPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(WScale(1.2), HScale(1.1), WScale(70), HScale(2.7))];
    _commentPlaceLabel.text = @"评论";
    _commentPlaceLabel.font = [UIFont systemFontOfSize:13.f];
    _commentPlaceLabel.textColor = [UIColor lightGrayColor];
    [_inputTextView addSubview:_commentPlaceLabel];
    
    
//    表情键盘
    _emojiView = [[EmojiKeybordView alloc] initWithFrame:CGRectMake(0, _inputTextView.bottom + HScale(1.1), ScreenWidth, kHvertical(216))];
    __weak __typeof(self)weakSelf = self;
    _emojiView.selectEmoji = ^(id select){
        [weakSelf textViewChange:select];
    };
    [_emojiKeybordView addSubview:_emojiView];
    
//    发送按钮
    _emojiBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - kWvertical(44), 0,kWvertical(44), kHvertical(44))];
    [_emojiBtn addTarget:self action:@selector(changeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [_emojiBtn setImage:[UIImage imageNamed:@"EmojiKeybord"] forState:UIControlStateNormal];
    [_emojiBtn setImage:[UIImage imageNamed:@"KeybordEmojiIcon"] forState:UIControlStateSelected];
    _emojiBtn.imageEdgeInsets = UIEdgeInsetsMake(kWvertical(10), kHvertical(10), kWvertical(10), kHvertical(10));
    _emojiBtn.selected  = NO;
    [_emojiKeybordView addSubview:_emojiBtn];
    [_emojiView.sendBtn addTarget:self action:@selector(writhComment) forControlEvents:UIControlEventTouchUpInside];
    
    
    _limitLabel = [[UILabel alloc] init];
    _limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), 0, kWvertical(44), kWvertical(44));
    _limitLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _limitLabel.hidden = YES;
    _limitLabel.textAlignment = NSTextAlignmentCenter;
    _limitLabel.textColor = [UIColor lightGrayColor];
    [_emojiKeybordView addSubview:_limitLabel];


    
}
-(void)alertShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"失败" descStr:str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
-(void)alertSuccessShowView:(NSString *)str{
    
    SucessView *sView = [[SucessView alloc] initWithFrame:CGRectMake(WScale(37.1), HScale(44.7), WScale(26.1), HScale(10.8)) imageImageName: @"成功" descStr:str];
    [self.view addSubview:sView];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [sView removeFromSuperview];
    });
    
}
-(void)createNav{
    
    self.navigationItem.title = @"动态";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kHorizontal(18)],NSForegroundColorAttributeName:deepColor}];

    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    leftBarbutton.tintColor = [UIColor blackColor];
    [leftBarbutton setImage:[UIImage imageNamed:@"返回"]];
    self.navigationItem.leftBarButtonItem = leftBarbutton;
    
    //取消键盘第一响应者
    [resignFirstResponder removeFromSuperview];
    resignFirstResponder                 = [UIButton buttonWithType:UIButtonTypeCustom];
    resignFirstResponder.hidden          = YES;
    resignFirstResponder.backgroundColor = [UIColor clearColor];
    resignFirstResponder.frame           = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [resignFirstResponder addTarget:self action:@selector(clickResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignFirstResponder];
    
}
-(void)createNoneView{
    _tableView.hidden = YES;
    [_noneDataLabel removeFromSuperview];
    _noneDataLabel = [[UILabel alloc] init];
    if ([_nameid isEqualToString:userDefaultUid]) {
        _noneDataLabel.text = @"您还没有动态 赶快发布吧！";
    }else{
        _noneDataLabel.text = @"对方还未发布动态";
    }
    _noneDataLabel.textColor = textTintColor;
    _noneDataLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    _noneDataLabel.frame = CGRectMake(0, kHvertical(123), ScreenWidth, kHvertical(27));
    _noneDataLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_noneDataLabel];
}
-(void)createUI{
    _tableView                 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle  = NO;
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = WhiteColor;
    _tableView.sectionHeaderHeight = CGFLOAT_MIN;
    _tableView.sectionFooterHeight = CGFLOAT_MIN;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_tableView registerClass:[FriendsterTableViewCell class] forCellReuseIdentifier:identifierTableview];
    
    [_tableView registerClass:[FriendsImageTableViewCell class] forCellReuseIdentifier:FriendsImageTableViewCellIdentifier];
    
    [self.view addSubview:_tableView];
}

-(void)deleteComment:(DynamicMessageModel *)model{
    
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
    [self.view addSubview:_deleteView];
    
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    confirmBtn.backgroundColor = [UIColor whiteColor];
    [confirmBtn addTarget:self action:@selector(clickToDeletComment) forControlEvents:UIControlEventTouchUpInside];
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
    
    [UIView animateWithDuration:0.3 animations:^{
        _deleteView.frame = CGRectMake(0, ScreenHeight - HScale(14.8), ScreenWidth, HScale(14.8));
        confirmBtn.frame = CGRectMake(0, 0, ScreenWidth, HScale(6.9));
        cancel.frame = CGRectMake(0, HScale(7.9), ScreenWidth, HScale(6.9));
    }];

}
//删除动态
-(void)deleteDynamic:(FriendsterModel *)model{
    _deleteID = model.did;
    _deleteGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _deleteGroundView.hidden = NO;
    _deleteGroundView.backgroundColor = GPRGBAColor(.2, .2, .2, .3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHidden)];
    [_deleteGroundView addGestureRecognizer:tap];
    [self.view addSubview:_deleteGroundView];
    
    _deleteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, HScale(14.8))];
    _deleteView.hidden = NO;
    _deleteView.backgroundColor = GPColor(245, 245, 245);
    [self.view addSubview:_deleteView];
    
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    confirmBtn.backgroundColor = [UIColor whiteColor];
    [confirmBtn addTarget:self action:@selector(clickToDeletDynamic) forControlEvents:UIControlEventTouchUpInside];
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

-(void)createActionSheet{
    
    _reportSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
    _reportSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_reportSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
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
    //    [_inputTextView textViewDidChange:mStr];
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


#pragma mark ---- 请求数据
-(void)createRefresh{
    
    //    头部刷新
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresn)];
    self.tableView.mj_header = refreshHeader;
    
    //    尾部刷新
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.tableView.mj_footer = refreshFooter;
    
}
-(void)requestDynamicData{

    _placeView = [[UIView alloc] init];
    _placeView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    _placeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_placeView];
    
    _HUD = [MBProgressHUD showHUDAddedTo:_placeView animated:YES];
    _HUD.alpha = 0.5;
    _HUD.mode = MBProgressHUDModeIndeterminate;
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{
                                @"name_id":userDefaultId,
                                @"dyn_name_id":_nameid,
                                @"page":@(0)
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=getuserdyn",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        
        _HUD = nil;
        [weakself.placeView removeFromSuperview];
        if (success) {
            
            
            NSArray *timeLineDicts = data[@"data"];
            
            if ([timeLineDicts count] == 0) {
                [weakself createNoneView];
            }
            _allpage = [data[@"pages"] intValue];
            for (int i = 0; i<timeLineDicts.count; i++) {
                
                [weakself.picsDataArr addObject:timeLineDicts[i][@"pics"]];
                
            }
            
            _layoutModelArr = [NSMutableArray array];
            
            for (int i = 0; i<_picsDataArr.count; i++) {
                
                PhotoBrowerLayoutModel *layoutModel = [[PhotoBrowerLayoutModel alloc] initWithPhotoUrlsArray:self.picsDataArr[i] andOrigin:CGPointMake(0, 0)];
                [weakself.layoutModelArr addObject:layoutModel];
                
            }
            [self.friendsterDataArr removeAllObjects];
            for (NSDictionary *timeLineDict in timeLineDicts) {
                friendsterModelmdoel = [FriendsterModel modelWithDictionary:timeLineDict];
                [weakself.friendsterDataArr addObject:friendsterModelmdoel];
  
            }
            
            FriendsterModel *model = [_friendsterDataArr lastObject];
            weakself.oneDid = [model.did intValue];
            weakself.allpage = [data[@"pages"] intValue];
            
            [weakself.tableView reloadData];
            
            
        }else{
            
            [weakself alertShowView:@"网络错误"];
        }

        
    }];
    
}
-(void)headerRefresn{
    _currpage =0;
    [self.tableView.mj_footer resetNoMoreData];
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{
                                @"name_id":userDefaultId,
                                @"dyn_name_id":_nameid,
                                @"page":@(0)
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=getuserdyn",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        [self.tableView.mj_header endRefreshing];
        if (success) {
            
            NSArray *timeLineDicts = data[@"data"];
            for (int i = 0; i<timeLineDicts.count; i++) {
                
                [weakself.picsDataArr addObject:timeLineDicts[i][@"pics"]];
                
            }
            
            _layoutModelArr = [NSMutableArray array];
            for (int i = 0; i<_picsDataArr.count; i++) {
                
                PhotoBrowerLayoutModel *layoutModel = [[PhotoBrowerLayoutModel alloc] initWithPhotoUrlsArray:self.picsDataArr[i] andOrigin:CGPointMake(0, 0)];
                [weakself.layoutModelArr addObject:layoutModel];
                
            }
            [self.friendsterDataArr removeAllObjects];
            for (NSDictionary *timeLineDict in timeLineDicts) {
                friendsterModelmdoel = [FriendsterModel modelWithDictionary:timeLineDict];
                [weakself.friendsterDataArr addObject:friendsterModelmdoel];
                
            }
            
            FriendsterModel *model = [_friendsterDataArr lastObject];
            _oneDid = [model.did intValue];
            _allpage = [data[@"pages"] intValue];
            weakself.tableView.hidden = NO;
            [weakself.tableView reloadData];
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }
        
    }];
    

}
-(void)footerRefresh{
    _currpage++;
    if (_currpage>_allpage) {
        _currpage--;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    __weak typeof(self) weakself = self;
    NSDictionary *parameter = @{
                                @"name_id":userDefaultId,
                                @"dyn_name_id":_nameid,
                                @"page":@(_currpage)
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=getuserdyn",apiHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        [weakself.tableView.mj_footer endRefreshing];
        if (success) {
            
            NSArray *timeLineDicts = data[@"data"];
            for (int i = 0; i<timeLineDicts.count; i++) {
                
                [weakself.picsDataArr addObject:timeLineDicts[i][@"pics"]];
                
            }
            
            weakself.layoutModelArr = [NSMutableArray array];
            for (int i = 0; i<_picsDataArr.count; i++) {
                
                PhotoBrowerLayoutModel *layoutModel = [[PhotoBrowerLayoutModel alloc] initWithPhotoUrlsArray:self.picsDataArr[i] andOrigin:CGPointMake(0, 0)];
                [weakself.layoutModelArr addObject:layoutModel];
                
            }

            for (NSDictionary *timeLineDict in timeLineDicts) {
                friendsterModelmdoel = [FriendsterModel modelWithDictionary:timeLineDict];
                [weakself.friendsterDataArr addObject:friendsterModelmdoel];
                
            }
            
            FriendsterModel *model = [_friendsterDataArr lastObject];
            weakself.oneDid = [model.did intValue];
            weakself.allpage = [data[@"pages"] intValue];
            [weakself.tableView reloadData];
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }
        
        
    }];
    
}
//提交评论及回复
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
            resignFirstResponder.hidden = YES;
            [_inputTextView resignFirstResponder];
            _isEmojiBtn = NO;
            _emojiKeybordView.hidden = YES;
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dynaddcommit",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    NSString *code = data[@"code"];
                    weakself.inputTextView.text = @"";
                    NSArray *commets = data[@"commets"];
                    if ([code isEqualToString:@"1"]) {
                        FriendsterModel *model = _friendsterDataArr[self.sectionIndex];
                        NSDictionary *dic = commets.firstObject;
                        DynamicMessageModel *tempMode = [DynamicMessageModel modelWithDictionary:dic];
                        [model.commets appendObject:tempMode];
                        [weakself.tableView reloadData];
                        
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
            resignFirstResponder.hidden = YES;
            _isEmojiBtn = NO;
            _emojiKeybordView.hidden = YES;
            [_inputTextView resignFirstResponder];
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dynaddcommit",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    
                    weakself.inputTextView.text = @"";
                    NSString *code = data[@"code"];
                    NSArray *commets = data[@"commets"];
                    
                    if ([code isEqualToString:@"1"]) {
                        FriendsterModel *model = _friendsterDataArr[self.sectionIndex];
                        NSDictionary *dic = commets.firstObject;
                        DynamicMessageModel *tempMode = [DynamicMessageModel modelWithDictionary:dic];
                        [model.commets appendObject:tempMode];
                        [weakself.tableView reloadData];
                        
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

-(void)reportData{
    //     report_type=举报内容，1为举报动态，2为举报评论，3为举报用户
    //    report_state=举报类型，1=色情信息,2=广告欺诈,3=不当发言,4=虚假消息
    __weak typeof(self) weakself = self;
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

#pragma mark ---- 键盘通知
-(void)ReseavNotification{

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:self selector:@selector(showDynaimeKeyboard:) name:UIKeyboardWillShowNotification object:nil];

    [notificationCenter addObserver:self selector:@selector(hideDynaimeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)showDynaimeKeyboard:(NSNotification *)notice
{
    
    _commentPlaceLabel.hidden = NO;
    
    if (_inputTextView.text.length==0) {
        
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    NSDictionary *dic = notice.userInfo;
    CGSize kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _keyBoardHeight = kbSize.height;
    _emojiBtn.selected = NO;
    _emojiView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _emojiKeybordView.frame = CGRectMake(0, ScreenHeight - kHvertical(44) - _keyBoardHeight, ScreenWidth, kHvertical(44)+kHvertical(216));
        _emojiBtn.frame = CGRectMake(ScreenWidth - kWvertical(44), _emojiKeybordView.height-kHvertical(216) - kWvertical(44), kWvertical(44), kWvertical(44));
    }];
    
}
- (void)hideDynaimeKeyboard:(NSNotification *)notice
{
    if (_isEmojiBtn == YES) {
        _emojiKeybordView.hidden = NO;
        _isEmojiBtn = NO;
    }else{
        _emojiKeybordView.hidden = YES;
    }
    [UIView animateWithDuration:0.23 animations:^{
        _emojiKeybordView.frame = CGRectMake(0, ScreenHeight-kHvertical(44)-kHvertical(216), ScreenWidth, kHvertical(44)+kHvertical(216)+kHvertical(49));
        
        _inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), HScale(4.5));
        _emojiBtn.frame = CGRectMake(ScreenWidth - kWvertical(44),_emojiKeybordView.height - kHvertical(44)-kHvertical(216) - kHvertical(49), kWvertical(44), kHvertical(44));
        
        _limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), _emojiKeybordView.top, kWvertical(44), kWvertical(44));
    }];
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y -= _tableViewKeyboardDelta;
    [self.tableView setContentOffset:CGPointMake(0, offset.y) animated:YES];
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
#pragma mark ---- 点击事件
-(void)clickResignFirstResponder{
    
    resignFirstResponder.hidden = YES;
    _isEmojiBtn = NO;
    _emojiKeybordView.hidden = YES;
    [_inputTextView resignFirstResponder];
    
}
-(void)popBack{
    
    [self.navigationController popViewControllerAnimated:YES];
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
                    
                    FriendsterModel *friendModel = _friendsterDataArr[self.sectionIndex];
                    NSDictionary *dic = arr.firstObject;
                    LikeUsersModel   *tempMode = [LikeUsersModel modelWithDictionary:dic];
                    [friendModel.clicks appendObject:tempMode];
                    model.isclicked = true;
                    [weakself.tableView reloadData];
                    
                    
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
                    [weakself.tableView reloadData];
                }
                
            }else{
                
//                NSLog(@"点赞失败");
            }
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
}


// 评论
-(void)clickToComment:(FriendsterModel *)model{
    _commentNameID = model.uid;
    _dynamicID = model.did;
    _inputTextView.inputView = nil;
    resignFirstResponder.hidden = NO;
    _emojiBtn.selected = NO;
    _emojiKeybordView.hidden = NO;
    _commentPlaceLabel.text = @"评论";
    [self.inputTextView becomeFirstResponder];
    
    
    
    _row = 0;
//    _section = 0;
//    for (int i = 0; i<_friendsterDataArr.count; i++) {
//        FriendsterModel *model = _friendsterDataArr[i];
//        if ([model.did isEqualToString:_dynamicID]) {
//            
//            _section = i;
//        }
//    }
    
    for (int i = 0; i< model.commets.count; i++) {
        DynamicMessageModel *dyModel = model.commets[i];
        if ([dyModel.cid isEqualToString:_reportRid]) {
            _row = i;
        }
    }
    _cellHeght = model.commets.count * kHvertical(50);
    _currentInadexpath = [NSIndexPath indexPathForRow:_row inSection:_sectionIndex];
//    [self adjuestTableviewHeaderToTop];
    [self adjustTableViewToFitKeybord];

}

-(void)clickToHidden{
    _deleteGroundView.hidden = YES;
    _deleteView.hidden = YES;
}
//删除评论
-(void)clickToDeletComment{
    __weak typeof(self) weakself = self;
    NSDictionary *parmaters = @{@"cid":_commentID,
                                @"name_id":userDefaultId};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=dyndelcommit",apiHeader120] parameters:parmaters complicate:^(BOOL success, id data) {
        if (success) {
            
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"1"]) {
                FriendsterModel *tempModel = _friendsterDataArr[_sectionIndex];
                [tempModel.commets removeObjectAtIndex:_operateIndex-1];
            }else{
                
//                NSLog(@"删除失败");
            }
            
            [weakself clickToHidden];
            [weakself.tableView reloadData];
            
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];

}
//删除动态
-(void)clickToDeletDynamic{
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@cofapi.php?func=deldyn",apiHeader120] parameters:@{@"did":_deleteID,@"name_id":userDefaultId} complicate:^(BOOL success, id data) {
        
        if (success) {
            
            if ([data[@"code"] isEqualToString:@"1"]) {
                [_layoutModelArr removeObjectAtIndex:_sectionIndex];
                [_friendsterDataArr removeObjectAtIndex:_sectionIndex];
                [weakself clickToHidden];
                
            }else{
                [weakself alertShowView:@"删除失败"];
            }
            [weakself.tableView reloadData];
        }else{
            [weakself alertShowView:@"网络错误"];
        }
    }];
}

//跳转到评论人的个人中心
-(void)clickToOwnDetail:(UIButton *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    FriendsterModel *model = _friendsterDataArr[indexPath.section];
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

//跳转到被回复人的个人中心
-(void)clickToReplyDetail:(UIButton *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    FriendsterModel *model = _friendsterDataArr[indexPath.section];
    DynamicMessageModel *dyModel = model.commets[indexPath.row-1];
    NSString *mesNameID = dyModel.covuid;
    if (![mesNameID isEqualToString:userDefaultUid]) {
        
        NewDetailViewController *VC = [[NewDetailViewController alloc]init];
        VC.nameID = mesNameID;
        VC.hidesBottomBarWhenPushed = YES;
        [VC setBlock:^(BOOL isback) {
            
        }];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

#pragma mark ---- 代理
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
-(void)createReportView{
    _reportActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情信息",@"广告欺诈",@"不当发言",@"虚假信息", nil];
    
    _reportActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_reportActionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
-(void)createPastedboard{
    
    [UIPasteboard generalPasteboard].string = _pastedStr;
    
    [self alertSuccessShowView:@"复制成功"];
}
-(void)longpressGestureRecognizer{
    
    _longpressActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制",@"举报", nil];
    _longpressActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [_longpressActionSheet showFromRect:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight) inView:self.view animated:YES];
}
-(void)longpressComment:(DynamicMessageModel *)model{
    
    _reportRid = model.cid;
    _reportType = @"2";
    _pastedStr = model.content;
    
    [self longpressGestureRecognizer];
}
-(void)longpressHeader:(FriendsterModel *)model{
    
    _reportRid = model.did;
    _reportType = @"1";
    _pastedStr = model.content;
    if ([_pastedStr isEqualToString:@""]) {
        [self createActionSheet];
        
    }else{
        
        [self longpressGestureRecognizer];
    }
}
-(void)pressCellHeader:(DynamicMessageModel *)model{
    
    _reportRid = model.covuid;
    _reportType = @"3";
    
    [self createActionSheet];
}
#pragma mark ---- tableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:FriendsImageTableViewCellIdentifier configuration:^(id cell) {
            
            FriendsImageTableViewCell *tempCell = (FriendsImageTableViewCell*)cell;
            tempCell.fd_enforceFrameLayout = true;
            
            FriendsterModel *model = _friendsterDataArr[indexPath.section ];
            PhotoBrowerLayoutModel *layoutModel = self.layoutModelArr[indexPath.section];
            
            [tempCell setModel:model];
            [tempCell setLayoutModel:layoutModel];
            
        }];
        
    }
    
    FriendsterModel *friendsterModel = _friendsterDataArr[indexPath.section];
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
 
//    return [tableView fd_heightForCellWithIdentifier:identifierTableview cacheByKey:[NSString stringWithFormat:@"ROWCACHE_%ld_%ld",(long)indexPath.section, (long)indexPath.row] configuration:^(id cell) {
//        FriendsterTableViewCell *tempCell = (FriendsterTableViewCell*)cell;
//        tempCell.fd_enforceFrameLayout = true;
//        [tempCell relayoutWithModel:model];
//        
//    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _friendsterDataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    FriendsterModel *model = _friendsterDataArr[section];
    return model.commets.count+1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        FriendsImageTableViewCell *tempCell = (FriendsImageTableViewCell*)cell;
        [tempCell setDataWithModel:_friendsterDataArr[indexPath.section]];
        [tempCell setLayoutModel:self.layoutModelArr[indexPath.section]];
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsterModel *model = _friendsterDataArr[indexPath.section];

    if (indexPath.row == 0) {
        FriendsImageTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier: FriendsImageTableViewCellIdentifier forIndexPath:indexPath];
        
        if ([_nameid isEqualToString:userDefaultUid]) {
            if ([model.did isEqualToString:@"0"]) {
                
                tempCell.deleBtn.hidden = YES;
            }else{
                tempCell.deleBtn.hidden = NO;

            }
            
        }else{
            
            tempCell.deleBtn.hidden = YES;

        }
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        tempCell.commentBlock = ^(FriendsterModel *model){
            
            _sectionIndex = indexPath.section;
            [weakSelf clickToComment:model];
        };
        
        tempCell.likeBlock = ^(FriendsterModel *model){
            _sectionIndex = indexPath.section;
            [weakSelf clickToLike:model];
        };
        tempCell.deleBlock = ^(FriendsterModel *model){
            
            _sectionIndex = indexPath.section;
            [weakSelf deleteDynamic:model];
        };
        
        return tempCell;
        
    }
    
    FriendsterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierTableview];
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
 
    _sectionIndex = indexPath.section;
    [self.tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    if (indexPath.row > 0 ) {
        
        FriendsterModel *model = _friendsterDataArr[indexPath.section];
        DynamicMessageModel *model1 = model.commets[indexPath.row-1];
        
        _operateIndex = indexPath.row;
        _covComNameID = model1.covuid;
        _replyFirComID = model1.cid;
        _dynamicID = model.did;
        if ([model1.comuid isEqualToString:userDefaultUid]) {
            
            [self deleteComment:model1];
            
        }else{
            
            _currentInadexpath = indexPath;
            [self adjustTableViewToFitKeybord];
            
            _commentPlaceLabel.text = [NSString stringWithFormat:@"回复：%@",model1.nickname];
            resignFirstResponder.hidden = NO;
            _emojiKeybordView.hidden = NO;
            _inputTextView.inputView = nil;
            _emojiBtn.selected = NO;
            [self.inputTextView becomeFirstResponder];

        }
        
    }else{
        
        return;
    }
    
}

#pragma mark ---- textView代理
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self writhComment];
    }
    return YES;

}
-(void)textViewDidChange:(UITextView *)textView{
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)self.inputTextView.text.length];
    int a = 200 - [len intValue];
    NSLog(@"%d",a);
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
    
//    if (textView.contentSize.height>HScale(3.9)) {
//        if (textView.contentSize.height>HScale( 16.2)) {
//            _emojiKeybordView.frame = CGRectMake(0, HScale(97.9) - _keyBoardHeight - HScale(16.2), ScreenWidth,  HScale(16.2)+HScale(2.1));
//            _inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), HScale(16.2));
//        }else{
//            
//            _emojiKeybordView.frame = CGRectMake(0, HScale(97.9) - _keyBoardHeight - textView.contentSize.height, ScreenWidth,  textView.contentSize.height+HScale(2.1));
//            
//            _inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth - WScale(14.3), textView.contentSize.height);
//            
//        }
//    }
    
//    _emojiBtn.frame = CGRectMake(ScreenWidth - kWvertical(44),_emojiKeybordView.height - kHvertical(44), kWvertical(44), kHvertical(44));
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_inputTextView resignFirstResponder];
    
    _isEmojiBtn = NO;
}
#pragma mark ==== 评论或者回复的时候，让键盘往上移动
-(void)adjuestTableviewHeaderToTop{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewHeaderFooterView *header = [_tableView headerViewForSection:_section];
    CGRect cellFrame = CGRectMake(header.origin.x, header.origin.y, header.width, header.height + _cellHeght+kHvertical(49));
    CGRect rect = [header.superview convertRect:cellFrame toView:window];
    [self adjustTableViewToFitKeybordWithRect:rect];
    
}
-(void)adjustTableViewToFitKeybord{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentInadexpath];
    CGRect cellFrame = CGRectMake(cell.origin.x, cell.origin.y, cell.width, cell.height +kHvertical(49));
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
    NSLog(@"keyboardHeight:%f",keyboardHeight);
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - keyboardHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:CGPointMake(0, offset.y) animated:YES];
    _tableViewKeyboardDelta = delta;
}



@end
