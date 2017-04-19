//
//  ActivityDetailViewController.m
//  podsGolvon
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ApplyViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityFooterTableViewCell.h"
#import "ActivityDetailModel.h"
#import "WXApi.h"

static CGFloat webViewHeight = 100;

@interface ActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ActivityDelegate>
{
    UIView *backView;
    UIView *baseView;
}
@property (nonatomic, strong) UITableView   *tableview;

@property (nonatomic, strong) UIImageView   *pictureImage;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *otherLabel;

@property (nonatomic, strong) UILabel   *moneyLabel;
@property (nonatomic, strong) UILabel   *peopleLabel;

@property (nonatomic, strong) NSMutableArray   *activityDetailDataArr;
@property (nonatomic, strong) DownLoadDataSource   *loadData;

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *starTime;
@property (copy, nonatomic) NSString *linkman;
@property (copy, nonatomic) NSString *cost;


@property (assign, nonatomic) UIEdgeInsets insets;



//分享
@property (copy, nonatomic) NSString *sharePic;
@property (copy, nonatomic) NSString *shareHtml;
@property (copy, nonatomic) NSString *shareTitle;
@property (copy, nonatomic) NSString *shareContent;
@property (nonatomic, strong) UIButton   *cancelBtn;
@property (nonatomic, strong) UIView   *backgroundView;

@end


static NSString *cellID = @"ActivityTableViewCell";
static NSString *footerID = @"ActivityFooterTableViewCell";

@implementation ActivityDetailViewController
-(NSMutableArray *)activityDetailDataArr{
    if (!_activityDetailDataArr) {
        _activityDetailDataArr = [NSMutableArray array];
    }
    return _activityDetailDataArr;
}
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _block(YES);
    
    
    [self createUI];
    [self createBottomView];
    [self createNavugationBar];
    [self requestShareData];
    self.insets = UIEdgeInsetsMake(0, kWvertical(15), 0, kWvertical(15));

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
-(void)requestData{
    NSDictionary *dic = @{@"id":_ID,
                          @"uid":userDefaultUid};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=getdiscovery",apiHeader120] parameters:dic complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *tempDic = data;
            ActivityDetailModel *model = [ActivityDetailModel modelWithDictionary:tempDic];
            [self.activityDetailDataArr addObject:model];
            [self relayoutDataWith:model];
            [_tableview reloadData];
        }
    }];
}
-(void)relayoutDataWith:(ActivityDetailModel *)model{
    _moneyLabel.text = model.cost;
    [_moneyLabel sizeToFitSelf];
    _peopleLabel.x = _moneyLabel.x_width+kWvertical(3);
    _peopleLabel.text = [NSString stringWithFormat:@"元／%@人已报名",model.joinnum];
    _starTime = model.startts;
    _address = model.address;
    _cost = model.cost;
    _linkman = [NSString stringWithFormat:@"%@：%@", model.contacts,model.phone];
    
    UILabel *applyLabel = [[UILabel alloc] init];
    applyLabel.frame = CGRectMake(kWvertical(251), kHvertical(9), kWvertical(97), kHvertical(29));
    applyLabel.backgroundColor = localColor;
    applyLabel.font = [UIFont systemFontOfSize:kHorizontal(14)];
    applyLabel.textAlignment = NSTextAlignmentCenter;
    applyLabel.textColor = WhiteColor;
    applyLabel.layer.masksToBounds = YES;
    applyLabel.layer.cornerRadius = 2;
    [backView addSubview:applyLabel];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(ScreenWidth - kWvertical(140), 0, kWvertical(140), kHvertical(46));
    [applyBtn addTarget:self action:@selector(clickToApplyBtn) forControlEvents:UIControlEventTouchUpInside];
    if ([_endTimeStr isEqualToString:@"活动已经结束！"]) {
        applyLabel.text = @"活动已结束";
        
    }else{
        
        if (model.joinstatr == YES) {
            applyLabel.text = @"您已报名";
        }else{
            applyLabel.text = @"我要报名";
            [backView addSubview:applyBtn];
        }

    }
}
-(void)requestShareData{
    NSDictionary *dic = @{@"type":@"4",
                          @"id":_ID};
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@findapi.php?findkey=share",apiHeader120] parameters:dic complicate:^(BOOL success, id data) {
        if (success) {
            _sharePic = data[@"sharepic"];
            _shareHtml = data[@"shareurl"];
            _shareTitle = data[@"title"];
            _shareContent = data[@"sharecont"];
        }
    }];
}

#pragma mark ---- UI
-(void)createNavugationBar{
    
    
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
    if ( [WXApi isWXAppInstalled]) {
        [self.view addSubview:shareBtn];
        
    }


}
-(void)createUI{
    CGSize titleSize = [_titleStr boundingRectWithSize:CGSizeMake(ScreenWidth-kWvertical(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHorizontal(23)]} context:nil].size;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, -20, ScreenWidth,  kHvertical(146)+kHvertical(99)+titleSize.height);
    headerView.backgroundColor = WhiteColor;
    
    _pictureImage = [[UIImageView alloc] init];
    [_pictureImage setFindImageStr:_maskPic];
    _pictureImage .frame = CGRectMake(0, 0, ScreenWidth, kHvertical(178));
    [headerView addSubview:_pictureImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(kWvertical(15), _pictureImage.bottom + kHvertical(21), ScreenWidth-kWvertical(30),titleSize.height);
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:kHorizontal(23)];
    _titleLabel.text = _titleStr;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_titleLabel];
    
    _otherLabel = [[UILabel alloc] init];
    _otherLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    _otherLabel.frame = CGRectMake(0 ,_titleLabel.bottom + kHvertical(14), ScreenWidth, kHvertical(17));
    _otherLabel.textColor = textTintColor;
    _otherLabel.textAlignment = NSTextAlignmentCenter;
    _otherLabel.text = [NSString stringWithFormat:@"打球去／%@／阅读 %@",_addTimeStr,_readStr];
    [headerView addSubview:_otherLabel];
    
    
    _tableview = [[UITableView alloc] init];
    _tableview.frame = CGRectMake(0, -20, ScreenWidth, ScreenHeight+20-kHvertical(46));
    [_tableview setDataSource:self];
    [_tableview setDelegate:self];
    _tableview.tableHeaderView = headerView;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableview registerClass:[ActivityTableViewCell class] forCellReuseIdentifier:cellID];
    [_tableview registerClass:[ActivityFooterTableViewCell class] forCellReuseIdentifier:footerID];
    [self.view addSubview:_tableview];
}
-(void)createBottomView{
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-kHvertical(46), ScreenWidth, kHvertical(46))];
    backView.backgroundColor = WhiteColor;
    [self.view addSubview:backView];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWvertical(22), kHvertical(4), kWvertical(47), kHvertical(37))];
    _moneyLabel.textColor = localColor;
    _moneyLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(26)];
    [backView addSubview:_moneyLabel];
    
    _peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_moneyLabel.right + kWvertical(3), kHvertical(19), kWvertical(150), kHvertical(16))];
    _peopleLabel.textColor = textTintColor;
    _peopleLabel.font = [UIFont systemFontOfSize:kHorizontal(11)];
    [backView addSubview:_peopleLabel];

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
-(void)clickToApplyBtn{
    
    ApplyViewController *VC = [[ApplyViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    VC.ID = _ID;
    VC.addTimes = _addTimeStr;
    [self.navigationController pushViewController:VC animated:YES];
}
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
    urlMessage.title = _shareTitle;//分享标题
    urlMessage.description = _shareContent;//分享描述
    urlMessage.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_sharePic]];
    WXWebpageObject *webObj = [WXWebpageObject object];
    NSString *HtmlStr = [NSString stringWithFormat:@"%@?type=1",_shareHtml];
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
    urlMessage.title = _shareTitle;
    urlMessage.description = _shareContent;
    urlMessage.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_sharePic]];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    
    NSString *HtmlStr = [NSString stringWithFormat:@"%@?type=1",_shareHtml];
    webObj.webpageUrl = HtmlStr;//分享链接
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    [WXApi sendReq:sendReq];
}


#pragma mark ---- 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return webViewHeight + kHvertical(44);
    }
    return kHvertical(38);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableview.separatorColor = GPColor(242, 242, 242);

    if (indexPath.row == 4) {
        
        ActivityFooterTableViewCell *footer = [tableView dequeueReusableCellWithIdentifier:footerID];
        footer.htmlDelegate = self;
        return footer;
        
    }else{
        
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                cell.describeLabel.text = @"活动时间";
                cell.contentLabel.text = _starTime;
                break;
                
            case 1:
                cell.describeLabel.text = @"举办地址";
                cell.contentLabel.text = _address;
                
                break;
                
                
            case 2:
                cell.describeLabel.text = @"费用";
                cell.contentLabel.text = _cost;
                
                break;
                
                
            case 3:
                cell.describeLabel.text = @"联系人";
                cell.contentLabel.text = _linkman;
                
                break;
                
                
            default:
                break;
        }
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.insets];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:self.insets];
    }
    
    if (indexPath.row == 4) {
        
        ActivityFooterTableViewCell *web = (ActivityFooterTableViewCell *)cell;
        web.htmlString = _htmlStr;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableview deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)webViewCell:(ActivityFooterTableViewCell *)webViewCell loadedHtmlWithHeight:(CGFloat)contentHeight{
    webViewHeight = contentHeight;
    
    [_tableview reloadData];
}
@end
