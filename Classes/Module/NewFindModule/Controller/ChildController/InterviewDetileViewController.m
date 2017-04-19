//
//  InterviewDetileViewController.m
//  podsGolvon
//
//  Created by apple on 2016/12/28.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "InterviewDetileViewController.h"
#import "InterviewWebviewCell.h"
#import "DetailComment.h"
#import "InterviewMessageModel.h"
#import "CustomeLabel.h"
#import "ChildCommentModel.h"
#import "EmojiKeybordView.h"
#import "NewAlertView.h"
#import "WXApi.h"

@interface InterviewDetileViewController ()<UITableViewDelegate,UITableViewDataSource,InterviewWebviewDelegate,UITextViewDelegate>
{
    NewAlertView *_alertView;//超出文字提示界面
    UIView *baseView;
    CGSize   headerTitleSize;
}
@property (nonatomic, strong) NSMutableArray   *messageArr;
@property (nonatomic, strong) NSMutableArray   *commentArr;
@property (nonatomic, strong) DownLoadDataSource   *loadData;
@property (nonatomic, strong) UITableView   *tableview;


//段头部分
@property (nonatomic, strong) UIView   *tableViewHeaderView;
@property (nonatomic, strong) UILabel   *messageLabel;
@property (nonatomic, strong) UILabel   *nicknameLabel;
@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UIImageView   *maskImageView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *timeLabel;


//底部栏
@property (nonatomic, strong) UIView     *bottomView;
@property (nonatomic, strong) CustomeLabel    *palceholdLabel;
@property (nonatomic, strong) UIButton   *commentBtn;
@property (nonatomic, strong) UIButton   *likeBtn;
@property (nonatomic, strong) UIButton   *shareBtn;
@property (nonatomic, assign) CGFloat    oldY;


//关注
@property (nonatomic, strong) UIButton   *addFocusBtn;
@property (copy, nonatomic) NSString *UID;

//键盘
@property (assign, nonatomic) CGFloat keyBoardHeight;//当前键盘的高度
@property (assign, nonatomic) BOOL    isEmojiBtn;
@property (strong, nonatomic) UITextView *inputTextView;//输入框*
@property (strong, nonatomic) UIButton   *KeybordEmojiIcon;//选择图标
@property (strong, nonatomic) UILabel    *commentPlaceLabel;//键盘等待文字
@property (strong, nonatomic) EmojiKeybordView    *emojiView;//表情键盘
@property (strong, nonatomic) UILabel    *limitLabel;//显示限制字数
@property (strong, nonatomic) UIView     *emojiKeybordView;//切换键盘按钮背景

//评论
@property (copy, nonatomic) NSString *commentID;
@property (copy, nonatomic) NSString *replyUID;

//分享
@property (nonatomic, strong) UIButton   *cancelBtn;
@property (nonatomic, strong) UIView   *backgroundView;
@property (copy, nonatomic) NSString *sharepic;
@property (copy, nonatomic) NSString *shareContent;


@property (assign, nonatomic) UIEdgeInsets insets;


@end

static NSString *webView = @"InterviewWebviewCell";
static NSString *comment = @"DetailComment";
static CGFloat webViewHeight = 100;

@implementation InterviewDetileViewController

-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc] init];
    }
    return _loadData;
}
-(NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}
-(NSMutableArray *)messageArr {
    if (!_messageArr) {
        _messageArr = [NSMutableArray array];
    }
    return _messageArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    _block(YES);

    if ([_type isEqualToString:@"2"]) {
        [self requestMessageData];
    }}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createTextView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestCommentData];
    [self requestShareData];
    [self createTableView];
    [self createBottomView];
    [self createNavigationBar];
    [self createNotification];
    
    self.insets = UIEdgeInsetsMake(0, kWvertical(15), 0, kWvertical(15));

}
-(void)viewDidDisappear:(BOOL)animated{
    [_inputTextView resignFirstResponder];
    [_inputTextView removeFromSuperview];
    [_emojiKeybordView removeFromSuperview];
}
-(void)viewDidLayoutSubviews{
    
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:self.insets];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableview setLayoutMargins:self.insets];
    }
}
#pragma mark ---- LoadData
-(void)requestMessageData{
    NSDictionary *parameters = @{@"uid":userDefaultUid,
                                 @"vid":_ID};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=getinte",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *temp = data;
            InterviewMessageModel *model = [InterviewMessageModel modelWithDic:temp];
            [self.messageArr addObject:model];
            if ([_type isEqualToString:@"2"]) {
                [self relayoutData:model];
            }
            [_tableview reloadData];
        }
    }];
}
-(void)relayoutData:(InterviewMessageModel *)model{
    [_maskImageView sd_setImageWithURL:[NSURL URLWithString:model.coverpic] placeholderImage:[UIImage imageNamed:@""]];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:[UIImage imageNamed:@""]];
    _messageLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@",model.age,model.pole,model.city,model.job];
    _nicknameLabel.text = model.nickname;
    _UID = model.UID;
    _isFollow = model.isFocus;
    _addFocusBtn.selected = _isFollow;

}
-(void)requestCommentData{
    
    NSDictionary *parameters = @{@"id":_ID,
                                 @"type":_type};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=getfindcomm",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
       
        if (success) {
            NSArray *tempArr = data;
            [self.commentArr removeAllObjects];
            for (NSDictionary *tempDic in tempArr) {
                ChildCommentModel *model = [ChildCommentModel modelWithDictionary:tempDic];
                [self.commentArr addObject:model];
            }
            [_commentBtn setTitle:[NSString stringWithFormat:@"%ld",_commentArr.count] forState:UIControlStateNormal];
            [_tableview reloadData];
        }
        
    }];
}

-(void)requestShareData{
    NSDictionary *dic = @{@"type":_type,
                          @"id":_ID};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=share",apiHeader120] parameters:dic complicate:^(BOOL success, id data) {
        if (success) {
            
            _sharepic = data[@"sharepic"];
            _shareContent = data[@"sharecont"];
        }
    }];
}
#pragma mark ---- UI


-(void)createHeaderView{
    
    headerTitleSize = [_titleStr boundingRectWithSize:CGSizeMake(ScreenWidth-kWvertical(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(23)]} context:nil].size;
    
    
    _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, kHvertical(146)+kHvertical(99)+headerTitleSize.height)];
    _tableViewHeaderView.backgroundColor = WhiteColor;
    
    _maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(178))];
    _maskImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (![_type isEqualToString:@"2"]) {
        [_maskImageView setFindImageStr:_maskPic];
    }
    [_tableViewHeaderView addSubview:_maskImageView];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - kWvertical(78))/2, kHvertical(47), kWvertical(78), kWvertical(78))];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = kWvertical(39);
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatarImageView.bottom+3, ScreenWidth, kHvertical(21))];
    _nicknameLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    _nicknameLabel.textColor = WhiteColor;
    _nicknameLabel.textAlignment = NSTextAlignmentCenter;
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _nicknameLabel.bottom+3, ScreenWidth, kHvertical(16))];
    _messageLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _messageLabel.textColor = WhiteColor;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    if ([_type isEqualToString:@"2"]) {
        
        [_tableViewHeaderView addSubview:_avatarImageView];
        [_tableViewHeaderView addSubview:_nicknameLabel];
        [_tableViewHeaderView addSubview:_messageLabel];
    }

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(15), _maskImageView.bottom+kHvertical(21), ScreenWidth-kWvertical(30), headerTitleSize.height)];
    _titleLabel.textColor = deepColor;
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(23)];
    _titleLabel.text = _titleStr;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_tableViewHeaderView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom + kHvertical(14), ScreenWidth, kHvertical(17))];
    _timeLabel.textColor = textTintColor;
    _timeLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = [NSString stringWithFormat:@"/ 打球去 / %@",_addTimeStr];
    [_tableViewHeaderView addSubview:_timeLabel];
    
}
-(void)createTableView{
    [self createHeaderView];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight + 20)];
    [_tableview setDelegate:self];
    [_tableview setDataSource:self];
    [_tableview setTableHeaderView:_tableViewHeaderView];
    [_tableview registerClass:[InterviewWebviewCell class] forCellReuseIdentifier:webView];
    [_tableview registerClass:[DetailComment class] forCellReuseIdentifier:comment];
    [self.view addSubview:_tableview];
    
}

-(void)createNavigationBar{
    
    UIImageView *maskTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    maskTop.image = [UIImage imageNamed:@"蒙板固定_上"];
    [self.view addSubview:maskTop];

    UIButton *turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnBtn.frame = CGRectMake(0, 20, 40, 40);
    [turnBtn setImage:[UIImage imageNamed:@"白色统一返回"] forState:UIControlStateNormal];
    [turnBtn addTarget:self action:@selector(ClickToBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:turnBtn];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"findShareIcon"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(ScreenWidth-40, 20, 40, 40);
    [shareBtn addTarget:self action:@selector(ClickToShare) forControlEvents:UIControlEventTouchUpInside];
    
    
    _addFocusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addFocusBtn.frame = CGRectMake(ScreenWidth-55, 20, 40, 40);
    [_addFocusBtn setImage:[UIImage imageNamed:@"findAddFocusIcon"] forState:UIControlStateNormal];
    [_addFocusBtn setImage:[UIImage imageNamed:@"findAlreadyFocusIcon"] forState:UIControlStateSelected];
    [_addFocusBtn addTarget:self action:@selector(clickAddFocus) forControlEvents:UIControlEventTouchUpInside];
    if ([_type isEqualToString:@"2"] && ![_name_id isEqualToString:userDefaultUid]) {
        [self.view addSubview:_addFocusBtn];
    }else{
        if ( [WXApi isWXAppInstalled]) {
            [self.view addSubview:shareBtn];

        }
    }
    
}

-(void)createBottomView{
    
    _bottomView = [[UIView alloc] init];
    _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(46), ScreenWidth, kHvertical(46));
    _bottomView.backgroundColor = WhiteColor;
    [self.view addSubview:_bottomView];
    
    _palceholdLabel = [[CustomeLabel alloc] initWithFrame:CGRectMake(kWvertical(10), kHvertical(7), kWvertical(194), kHvertical(30))];
    _palceholdLabel.layer.masksToBounds = YES;
    _palceholdLabel.layer.cornerRadius = 15;
    _palceholdLabel.backgroundColor = GPColor(235, 235, 237);
    _palceholdLabel.textColor = textTintColor;
    _palceholdLabel.text = @"说说你的看法吧...";
    _palceholdLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _palceholdLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _palceholdLabel.userInteractionEnabled = YES;
    [_bottomView addSubview:_palceholdLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickText)];
    [_palceholdLabel addGestureRecognizer:tap];
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(_palceholdLabel.right + kWvertical(11), 0, kWvertical(55), kHvertical(46));
    [_commentBtn setImage:[UIImage imageNamed:@"findDetailCommenticon"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(clickText) forControlEvents:UIControlEventTouchUpInside];
    [_commentBtn setTitle:[NSString stringWithFormat:@"%ld",_commentArr.count] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:textTintColor forState:UIControlStateNormal];
    [_commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(-kHvertical(10), kHvertical(10), 0, 0)];
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    [_bottomView addSubview:_commentBtn];
    
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(_commentBtn.right , 0, kWvertical(55), kHvertical(46));
    [_likeBtn setImage:[UIImage imageNamed:@"findDetailLikeicon"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"findDetailAlreadyLikeicon"] forState:UIControlStateSelected];
    [_likeBtn setTitle:_likeStr forState:UIControlStateNormal];
    [_likeBtn setTitleColor:textTintColor forState:UIControlStateNormal];
    [_likeBtn setTitleColor:GPColor(233, 111, 112) forState:UIControlStateSelected];
    [_likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(-kHvertical(10), kHvertical(10), 0, 0)];
    _likeBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    _likeBtn.selected = _isLike;
    [_likeBtn addTarget:self action:@selector(clickLikeBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_likeBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(_likeBtn.right , 0, kWvertical(55), kHvertical(46));
    [_shareBtn setImage:[UIImage imageNamed:@"findDetailShareicon"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(ClickToShare) forControlEvents:UIControlEventTouchUpInside];

    if ( [WXApi isWXAppInstalled]) {
        [_bottomView addSubview:_shareBtn];
        
    }
}
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
    [[[UIApplication sharedApplication].windows firstObject] addSubview:_emojiKeybordView];
    
    
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
    _KeybordEmojiIcon = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - kWvertical(44), 0, kWvertical(44), kHvertical(44))];
    [_KeybordEmojiIcon addTarget:self action:@selector(changeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [_KeybordEmojiIcon setImage:[UIImage imageNamed:@"EmojiKeybord"] forState:UIControlStateNormal];
    [_KeybordEmojiIcon setImage:[UIImage imageNamed:@"KeybordEmojiIcon"] forState:UIControlStateSelected];
    
    _KeybordEmojiIcon.imageEdgeInsets = UIEdgeInsetsMake(kWvertical(10), kHvertical(10), kWvertical(10), kHvertical(10));
    _KeybordEmojiIcon.selected  = NO;
    [_emojiKeybordView addSubview:_KeybordEmojiIcon];
    
    [_emojiView.sendBtn addTarget:self action:@selector(writhComment) forControlEvents:UIControlEventTouchUpInside];
    
    
    _limitLabel = [[UILabel alloc] init];
    _limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), 0, kWvertical(44), kWvertical(44));
    _limitLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    _limitLabel.hidden = YES;
    _limitLabel.textAlignment = NSTextAlignmentCenter;
    _limitLabel.textColor = [UIColor lightGrayColor];
    [_emojiKeybordView addSubview:_limitLabel];
    
}

-(void)createShareView{
    _backgroundView = [[UIView alloc]init];
    _backgroundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.5;
    _backgroundView.hidden = NO;
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToCancer)];
    [_backgroundView addGestureRecognizer:tap];
    [self.view addSubview:_backgroundView];
    
    
    baseView = [[UIView alloc]init];
    baseView.frame = CGRectMake(WScale(15.5), HScale(32), ScreenWidth * 0.691, ScreenHeight *0.298);
    baseView.layer.cornerRadius = 8;
    baseView.tag = 101;
    baseView.hidden = NO;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UIButton *haoYou = [UIButton buttonWithType:UIButtonTypeCustom];
    [haoYou setBackgroundImage:[UIImage imageNamed:@"推荐给微信好友"] forState: UIControlStateNormal];
    [haoYou addTarget:self action:@selector(clickToHaoYou) forControlEvents:UIControlEventTouchUpInside];
    haoYou.frame = CGRectMake(WScale(10.8), HScale(6.3), ScreenWidth * 0.181, ScreenHeight * 0.102);
    [baseView addSubview:haoYou];
    
    UILabel *haoyouLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(13.6), HScale(17.4), WScale(16), HScale(2.5))];
    haoyouLabel.text = @"微信好友";
    haoyouLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    haoyouLabel.textColor = deepColor;
    [baseView addSubview:haoyouLabel];
    
    UIButton *pengYouQuan = [UIButton buttonWithType:UIButtonTypeCustom];
    [pengYouQuan setBackgroundImage:[UIImage imageNamed:@"推荐到微信朋友圈"] forState: UIControlStateNormal];
    [pengYouQuan addTarget:self action:@selector(clickToPengYouQuan) forControlEvents:UIControlEventTouchUpInside];
    pengYouQuan.frame = CGRectMake(WScale(40.3), HScale(6.3), ScreenWidth * 0.181, ScreenHeight * 0.102);
    [baseView addSubview:pengYouQuan];
    
    UILabel *pengyouLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(41.3), HScale(17.4), WScale(18), HScale(2.5))];
    pengyouLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    pengyouLabel.text = @"微信朋友圈";
    pengyouLabel.textColor = deepColor;
    [baseView addSubview:pengyouLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(23.4), ScreenWidth * 0.691, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [baseView addSubview:line];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.tag = 102;
    _cancelBtn.hidden = NO;
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.frame = CGRectMake(WScale(15.5), HScale(55.4)+1, WScale(69.1), ScreenHeight *0.064);
    [_cancelBtn setTitleColor:localColor forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(clickToCancer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    

}
#pragma mark ---- 点击事件

-(void)ClickToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ClickToShare{
    
    [self createShareView];
    
}
-(void)clickToCancer{
    _backgroundView.hidden = YES;
    _cancelBtn.hidden = YES;
    baseView.hidden = YES;
}

-(void)clickToHaoYou{
    [self clickToCancer];
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = _titleStr;//分享标题
    urlMessage.description = _shareContent;//分享描述
    urlMessage.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_sharepic]];
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString *HtmlStr = [NSString stringWithFormat:@"%@?type=1",_htmlStr];

    webObj.webpageUrl = HtmlStr;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}
-(void)clickToPengYouQuan{
    [self clickToCancer];
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;
    sendReq.scene = 1;
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = _titleStr;
    urlMessage.description = _shareContent;
    urlMessage.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_sharepic]];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString *HtmlStr = [NSString stringWithFormat:@"%@?type=1",_htmlStr];
    webObj.webpageUrl = HtmlStr;//分享链接
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    [WXApi sendReq:sendReq];
}

-(void)clickLikeBtn{
    
    NSDictionary *par = @{@"uid":userDefaultUid,
                          @"id":_ID,
                          @"type":_type};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=likediscovery",apiHeader120] parameters:par complicate:^(BOOL success, id data) {
        if (success) {
            NSString *code = data[@"code"];
            if ([code isEqualToString:@"1"]) {
                if (_isLike == YES) {
                    _isLike = NO;
                    
                    NSInteger liknum = [_likeStr integerValue];
                    liknum--;
                    _likeStr = [NSString stringWithFormat:@"%ld",(long)liknum];
                    [self.tableview reloadData];
                    
                }else{
                    
                    _isLike = YES;
                    
                    NSInteger liknum = [_likeStr integerValue];
                    liknum++;
                    _likeStr = [NSString stringWithFormat:@"%ld",(long)liknum];
                    [self.tableview reloadData];
                }
            }
            [_likeBtn setTitle:_likeStr forState:UIControlStateNormal];

            if ([self.likeDelegate respondsToSelector:@selector(likeBtnSelected:withLikeNum:)]) {
                [self.likeDelegate likeBtnSelected:_isLike withLikeNum:_likeStr];
            }

            _likeBtn.selected = _isLike;
            [_tableview reloadData];
        }
    }];
}
-(void)clickAddFocus{
    
    NSDictionary *parameter = @{
                                @"follow_name_id":userDefaultId,
                                @"cof_name_id":_UID
                                };
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/InsertFollow",urlHeader120] parameters:parameter complicate:^(BOOL success, id data) {
        if (success) {
            
            NSString *strCode = data[@"data"][0][@"code"];
            NSString *implementCode = data[@"data"][0][@"implementCode"];
            if ([strCode isEqualToString:@"1"]) {
                if ([implementCode isEqualToString:@"1"]) {
                    //关注
                    _addFocusBtn.selected = true;
                }else{
                    //取消关注
                    _addFocusBtn.selected = false;

                }
            }
            
        }
    }];
}
-(void)clickText{
//    _bottomView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(46), ScreenWidth, kHvertical(46));
        _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(40), ScreenWidth, kHvertical(46));
        _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(36), ScreenWidth, kHvertical(46));
        _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(30), ScreenWidth, kHvertical(46));
        _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(16), ScreenWidth, kHvertical(46));
        _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(0), ScreenWidth, kHvertical(46));


    }];
    _KeybordEmojiIcon.selected = NO;
    _inputTextView.inputView = nil;
    _emojiKeybordView.hidden = NO;
    _commentPlaceLabel.text = @"评论";
    [_inputTextView becomeFirstResponder];
}
#pragma mark ---- UITableViewDelegate && UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableview.separatorColor = GPColor(242, 242, 242);

    if (indexPath.row == 0) {
        
        InterviewWebviewCell *webCell = [tableView dequeueReusableCellWithIdentifier:webView];
        webCell.delegate = self;
        return webCell;
        
    }else{
        
        DetailComment *commentCell = [tableView dequeueReusableCellWithIdentifier:comment];
        [commentCell realoadDataWith:self.commentArr[indexPath.row-1]];
        return commentCell;
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.insets];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:self.insets];
    }

    if (indexPath.row == 0) {
        
        InterviewWebviewCell *web = (InterviewWebviewCell *)cell;
        web.htmlString = _htmlStr;
        web.thumbUp.text = [NSString stringWithFormat:@"点赞 %@",_likeStr];
        web.readNum.text = [NSString stringWithFormat:@"阅读 %@",_readStr];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArr.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return webViewHeight+50;
    }else{
    
        ChildCommentModel *model = _commentArr[indexPath.row-1];
        if ([model.statr isEqualToString:@"0"]) {
            
            CGSize TitleSize= [model.content boundingRectWithSize:CGSizeMake(WScale(75), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
            return HScale(11) + TitleSize.height;
        }else{

            NSString *contenText = [NSString stringWithFormat:@"回复  %@ : %@",model.replynickname,model.content];
            CGSize TitleSize= [contenText boundingRectWithSize:CGSizeMake(WScale(96.7)-WScale(16.6), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(13)]} context:nil].size;
            return HScale(11) + TitleSize.height;
        }

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return;
    }else{
        [self.tableview deselectRowAtIndexPath:[_tableview indexPathForSelectedRow] animated:YES];
        ChildCommentModel *model = self.commentArr[indexPath.row - 1];
        if ([model.comuid isEqualToString:userDefaultUid]) {
//            [self deleteDynamic:model1];
        }else{
            _commentID = model.comm_id;
            _KeybordEmojiIcon.selected = NO;
            _emojiKeybordView.hidden = NO;
            _commentPlaceLabel.text = [NSString stringWithFormat:@"回复：%@",model.comnickname];
            [self.inputTextView becomeFirstResponder];
        }
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldY = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;
    if (scrollView == _tableview) {

        
        if (offSetY>_oldY) {
            
//            _bottomView.hidden = true;
            [UIView animateWithDuration:0.3 animations:^{
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(46), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(40), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(36), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(30), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(16), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(0), ScreenWidth, kHvertical(46));
                
                
            }];

            [_inputTextView resignFirstResponder];
            
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(0), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(16), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(30), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(36), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(40), ScreenWidth, kHvertical(46));
                _bottomView.frame = CGRectMake(0, ScreenHeight - kHvertical(46), ScreenWidth, kHvertical(46));
            }];

            [_inputTextView resignFirstResponder];

        }

    }

}

#pragma mark ---- webViewDetegate
-(void)webViewCell:(InterviewWebviewCell *)webViewCell loadedHTMLWithHeight:(CGFloat)contentHeight{
    webViewHeight = contentHeight;
    webViewCell.thumbUp.frame = CGRectMake(kWvertical(14), contentHeight +kHvertical(23), kWvertical(79), kHvertical(23));
    webViewCell.readNum.frame = CGRectMake(kWvertical(79), contentHeight +kHvertical(23), kWvertical(120), kHvertical(23));

    [_tableview reloadData];
}
#pragma mark ---- 管理键盘
//表情键盘操作
-(void)textViewChange:(NSString *)emojiStr{
    
    NSString *mStr = _inputTextView.text;
    if (mStr == 0) {
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    BOOL isEmoji = NO;
    
    if ([emojiStr isEqualToString:@"EmojiDeleat"]) {
        if ([mStr length]==0) {
            return;
        }
        if ([mStr length]>=2) {
            NSString *mStr1 = [mStr substringWithRange:NSMakeRange(mStr.length-2, 2)];
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
-(void)createNotification{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [notificationCenter addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

// 接收弹出键盘通知
-(void)showKeyboard:(NSNotification *)notification{
    NSString *textViewStr = _inputTextView.text;
    if (textViewStr.length==0) {
        _commentPlaceLabel.hidden = NO;
    }else{
        _commentPlaceLabel.hidden = YES;
    }
    
    
    NSDictionary *dic = notification.userInfo;
    CGSize kbSize = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _keyBoardHeight = kbSize.height;
    _KeybordEmojiIcon.selected = NO;
    _emojiView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _emojiKeybordView.frame = CGRectMake(0, ScreenHeight - kHvertical(44) - _keyBoardHeight, ScreenWidth, kHvertical(44)+kHvertical(216));
        _KeybordEmojiIcon.frame = CGRectMake(ScreenWidth - kWvertical(44), _emojiKeybordView.height-kHvertical(216) - kWvertical(44), kWvertical(44), kWvertical(44));
    }];
    
}
// 接收隐藏键盘的通知
-(void)hideKeyboard:(NSNotification *)notification{
    
    if (self.isEmojiBtn == YES) {
        _emojiKeybordView.hidden = NO;
        _isEmojiBtn = NO;
    }else{
        _emojiKeybordView.hidden = YES;
    }
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.23 animations:^{
        
        weakself.emojiKeybordView.frame = CGRectMake(0, ScreenHeight-kHvertical(44)-kHvertical(216), ScreenWidth, kHvertical(44)+kHvertical(216)+kHvertical(49));
        
        weakself.inputTextView.frame = CGRectMake(WScale(1.9), HScale(1.1), ScreenWidth-WScale(14.3), HScale(4.5));
        weakself.KeybordEmojiIcon.frame = CGRectMake(ScreenWidth - kWvertical(44),_emojiKeybordView.height - kHvertical(44)-kHvertical(216) - kHvertical(49), kWvertical(44), kHvertical(44));
        
        weakself.limitLabel.frame = CGRectMake(ScreenWidth - kWvertical(44), _emojiKeybordView.top, kWvertical(44), kWvertical(44));
    }];
    
}
//键盘切换
-(void)changeKeyboard:(UIButton *)btn{
    _isEmojiBtn = YES;
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        _emojiView.hidden = NO;
        [_inputTextView resignFirstResponder];
    }else{
        
        [_inputTextView becomeFirstResponder];
    }
}
#pragma mark ---- textView代理
//提交评论及回复
-(void)writhComment{
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
                                         @"cnameid":userDefaultUid,    //评论人id
                                         @"id":_ID,
                                         @"content":commentDesc,
                                         @"type":_type
                                         };
            [_inputTextView resignFirstResponder];
            _isEmojiBtn = NO;
            _emojiKeybordView.hidden = YES;
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=addfindcomm",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    NSString *code = data[@"code"];
                    _inputTextView.text = @"";
                    if ([code isEqualToString:@"1"]) {
                        [self requestCommentData];
                        
                    }
                }else{
                    NSLog(@"失败");
                }
            }];
        }else{
            NSDictionary *parameters = @{
                                         @"cnameid":userDefaultUid,
                                         @"content":commentDesc,
                                         @"fcommid":_commentID,
                                         @"type":_type
                                         };
            _isEmojiBtn = NO;
            _emojiKeybordView.hidden = YES;
            [_inputTextView resignFirstResponder];
            [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=addfindcomm",apiHeader120] parameters:parameters complicate:^(BOOL success, id data) {
                if (success) {
                    
                    _inputTextView.text = @"";
                    NSString *code = data[@"code"];
                    if ([code isEqualToString:@"1"]) {
                        [self requestCommentData];
                        
                    }else{

                    }
                }
            }];

            
        }
    }
}
//textView改变
-(void)textViewDidChange:(UITextView *)textView{
    
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)self.inputTextView.text.length];
    int a = 200 - [len intValue];
    //    NSLog(@"%d",a);
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
    
    _isEmojiBtn = NO;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self writhComment];
        
    }
    return YES;
}

@end
