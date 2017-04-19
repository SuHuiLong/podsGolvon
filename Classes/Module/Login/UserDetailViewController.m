//
//  UserDetailViewController.m
//  Golvon
//
//  Created by shiyingdong on 16/4/19.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "UserDetailViewController.h"
#import "WXApi.h"

@interface UserDetailViewController ()<UIWebViewDelegate>{
    
    BOOL _loadedHtml;
    UIButton  *_share;
    UIView    *_backGround2;
    UIView    *_View;
    UIButton  *_cancer;
}

@property(nonatomic,copy)UIActivityIndicatorView *loadingView;

@end

@implementation UserDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    [self createBack];
}

-(void)createBack{

    UIView *Navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Navi setBackgroundColor: [UIColor whiteColor]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WScale(15), 64)];
    [button addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *DissMiss = [[UIImageView alloc] initWithFrame:CGRectMake(9, 33, 19, 19)];
    DissMiss.image = [UIImage imageNamed:@"返回"];
    [button addSubview:DissMiss];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(WScale(17), 35, WScale(66.1), 15)];
    title.font = [UIFont boldSystemFontOfSize:17.f];
    title.text = _titleStr;
    title.textAlignment = NSTextAlignmentCenter;
    
    _share = [UIButton buttonWithType:UIButtonTypeCustom];
    [_share setImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
    _share.frame = CGRectMake(ScreenWidth-64, 10, 64, 64);
    [_share addTarget:self action:@selector(clickToShare) forControlEvents:UIControlEventTouchUpInside];
    if (![_isShare isEqualToString:@"1"]) {
        
        if ([WXApi isWXAppInstalled]) {
            
            [Navi addSubview:_share];
            
        }

    }

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63, ScreenWidth, 1)];
    line.backgroundColor = GPColor(212, 213, 214);
    
    [Navi addSubview:line];
    [Navi addSubview:title];
    [Navi addSubview:button];
    
    [self.view addSubview:Navi];
    
}

-(void)dissMissView{
    if ([_loginStyle isEqualToString:@"1"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createWebView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-44)];
    [self.view addSubview:backView];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44)];
    if ([_loginStyle isEqualToString:@"1"]) {
        backView.frame = CGRectMake(0, 64, ScreenWidth, ScreenWidth-64);
        _webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    }
    
    [_webView loadHTMLString:_urlStr baseURL:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_urlStr copy]]];
    [_webView loadRequest:request];
    
    
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = YES;
    _webView.userInteractionEnabled = YES;
    _webView.scalesPageToFit = YES;
    // 使用AutoLayout布局
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [backView addSubview:_webView];
}


#pragma mark ---- 推荐给朋友
-(void)clickToShare{
    _backGround2 = [[UIView alloc]init];
    _backGround2.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _backGround2.backgroundColor = [UIColor blackColor];
    _backGround2.alpha = 0.5;
    _backGround2.hidden = NO;
    _backGround2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToCancer)];
    [_backGround2 addGestureRecognizer:tap];
    [self.view addSubview:_backGround2];
    
    
    _View = [[UIView alloc]init];
    _View.frame = CGRectMake(WScale(15.5), HScale(32), ScreenWidth * 0.691, ScreenHeight *0.298);
    _View.layer.cornerRadius = 8;
    _View.tag = 101;
    _View.hidden = NO;
    _View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_View];
    
    UIButton *haoYou = [UIButton buttonWithType:UIButtonTypeCustom];
    [haoYou setBackgroundImage:[UIImage imageNamed:@"推荐给微信好友"] forState: UIControlStateNormal];
    [haoYou addTarget:self action:@selector(clickToHaoYou) forControlEvents:UIControlEventTouchUpInside];
    haoYou.frame = CGRectMake(WScale(10.8), HScale(6.3), ScreenWidth * 0.181, ScreenHeight * 0.102);
    [_View addSubview:haoYou];
    UILabel *haoyouLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(13.6), HScale(17.4), WScale(16), HScale(2.5))];
    haoyouLabel.text = @"微信好友";
    haoyouLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    haoyouLabel.textColor = [UIColor blackColor];
    [_View addSubview:haoyouLabel];
    
    UIButton *pengYouQuan = [UIButton buttonWithType:UIButtonTypeCustom];
    [pengYouQuan setBackgroundImage:[UIImage imageNamed:@"推荐到微信朋友圈"] forState: UIControlStateNormal];
    [pengYouQuan addTarget:self action:@selector(clickToPengYouQuan) forControlEvents:UIControlEventTouchUpInside];
    pengYouQuan.frame = CGRectMake(WScale(40.3), HScale(6.3), ScreenWidth * 0.181, ScreenHeight * 0.102);
    [_View addSubview:pengYouQuan];
    UILabel *pengyouLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(41.3), HScale(17.4), WScale(18), HScale(2.5))];
    pengyouLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    pengyouLabel.text = @"微信朋友圈";
    pengyouLabel.textColor = [UIColor blackColor];
    [_View addSubview:pengyouLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(23.4), ScreenWidth * 0.691, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_View addSubview:line];
    
    _cancer = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancer.tag = 102;
    _cancer.hidden = NO;
    [_cancer setTitle:@"取消" forState:UIControlStateNormal];
    _cancer.frame = CGRectMake(WScale(15.5), HScale(55.4)+1, WScale(69.1), ScreenHeight *0.064);
    [_cancer setTitleColor:localColor forState:UIControlStateNormal];
    [_cancer addTarget:self action:@selector(clickToCancer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancer];
    
    
}
-(void)clickToCancer{
    _backGround2.hidden = YES;
    _View.hidden = YES;
    _cancer.hidden = YES;
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
    urlMessage.description = _despStr;//分享描述
    [urlMessage setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picUrl]]]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    [urlMessage setThumbData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picUrl]]];
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = _urlStr;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}
-(void)clickToPengYouQuan{
    [self clickToCancer];
    
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = _titleStr;//分享标题
    urlMessage.description = _despStr;//分享描述
    [urlMessage setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picUrl]]]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    [urlMessage setThumbData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picUrl]]];
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = _urlStr;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
