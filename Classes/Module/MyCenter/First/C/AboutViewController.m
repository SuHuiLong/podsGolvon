//
//  AboutViewController.m
//  Golvon
//
//  Created by 李盼盼 on 16/4/27.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "AboutViewController.h"
#import "UserDetailViewController.h"
#import "WXApi.h"
#import "RegistViewController.h"
#import "UIView+Size.h"
#import "SDImageCache.h"
#import "LoginViewController.h"

@interface AboutViewController(){

    NSString *kLinkURL;
    NSString *kLinkTitle;
    NSString *kLinkDescription;
    NSString *kImage;
    
    UIView *_backGround;
    UIView *_view;
    UIButton *_cancer;
    
}

/**
 *  logo
 */
@property (strong, nonatomic)UIImageView *logoImage;
/**
 *  版本信息
 */
@property (strong, nonatomic)UILabel *edition;
@property (strong, nonatomic)NSString *editionText;

/**
 *  关于我们
 */
@property (strong, nonatomic)UIButton *aboutBtn;

/**
 *  推荐
 */
@property (strong, nonatomic)UIButton *recommendBtn;
/**
 *  清楚缓存
 */
@property (strong, nonatomic) UIButton      *clearMemoryBtn;
/**
 *  缓存大小
 */
@property (strong, nonatomic) UILabel      *memoryNum;
/**
 *  缓存
 */
@property (strong, nonatomic) NSString      *num;
/**
 *  清除缓存的背景
 */
@property (strong, nonatomic) UIView      *memoryGround;

/**
 *  清除缓存的view
 */
@property (strong, nonatomic) UIView      *memoryView;

@end

@implementation AboutViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244/256.0f green:244/256.0f blue:244/256.0f alpha:1];
    [self createNav];
    [self createUI];
    [self loadShareData];

}


-(void)loadShareData{
    
    DownLoadDataSource *manager = [[DownLoadDataSource alloc] init];
    
    NSDictionary *dict = @{
                           @"interview_id":@"-1"
                           };
    [manager downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_share_user",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSArray *dataArry = data[@"data"];
            if (dataArry.count>0) {
                NSDictionary *dataDic = dataArry[0];
                kLinkURL = [dataDic objectForKey:@"share_url"];
                kLinkTitle = [dataDic objectForKey:@"interview_title"];
                kLinkDescription = [dataDic objectForKey:@"share_describe"];
                kImage = [dataDic objectForKey:@"share_picture_url"];
            }else{
            }
            
        }
        
    }];
}




#pragma mark ---- 创建视图
-(void)createNav{
    _groundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _groundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_groundView];
    _back = [UIButton buttonWithType:UIButtonTypeCustom];
    _back.frame = CGRectMake(0, 20, 44, 44);
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
    backImage.image = [UIImage imageNamed:@"返回"];
    [_back addSubview:backImage];
    [_back addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:_back];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, 15)];
    titleLabel.text = @"关于";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.view.frame.size.height <= 568)
    {
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(20)];
        
    }
    else if (self.view.frame.size.height > 568 && self.view.frame.size.height <= 667)
    {
        
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(18)];
    }else{
        
        titleLabel.font = [UIFont boldSystemFontOfSize:kHorizontal(17)];
        
    }
    [_groundView addSubview:titleLabel];
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    _line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_line];
}
-(void)createUI{
    _logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(WScale(41.3), HScale(11.9), ScreenWidth * 0.173, ScreenHeight * 0.097)];
    _logoImage.image = [UIImage imageNamed:@"Logo_about"];
    [self.view addSubview:_logoImage];
    
    
    _edition = [[UILabel alloc]init];
//    打印版本信息
    _editionText = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _edition.frame = CGRectMake((ScreenWidth * 0.5)/2, HScale(22.6), ScreenWidth *0.5, ScreenHeight * 0.03);
    _edition.text = [NSString stringWithFormat:@"打球去 Golvon %@",_editionText];
    _edition.textAlignment = NSTextAlignmentCenter;
    _edition.textColor = [UIColor grayColor];
    _edition.font = [UIFont systemFontOfSize:kHorizontal(14)];
    [self.view addSubview:_edition];

    
//    关于我们
    _aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _aboutBtn.frame = CGRectMake(0, HScale(26.8)-1, ScreenWidth, ScreenHeight * 0.085);
    [_aboutBtn setBackgroundImage:[UIImage imageNamed:@"关于我们默认"] forState:UIControlStateNormal];
    [_aboutBtn setBackgroundImage:[UIImage imageNamed:@"关于我们选中"] forState:UIControlStateHighlighted];
    [_aboutBtn addTarget:self action:@selector(clickToAbout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aboutBtn];
   

//    缓存
    _clearMemoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearMemoryBtn.frame = CGRectMake(0, _aboutBtn.frame.origin.y + _aboutBtn.frame.size.height-1, ScreenWidth, HScale(8.5));
    [_clearMemoryBtn setBackgroundImage:[UIImage imageNamed:@"清除缓存底色"] forState:UIControlStateNormal];
    [_clearMemoryBtn setBackgroundImage:[UIImage imageNamed:@"清除缓存底色－点击"] forState:UIControlStateHighlighted];
    [_clearMemoryBtn addTarget:self action:@selector(clearMemory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearMemoryBtn];
    [self loadMemorySize];
    
    
    
    UIButton *signOut = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut.frame = CGRectMake(0, _clearMemoryBtn.frame.origin.y + _clearMemoryBtn.frame.size.height + HScale(3), ScreenWidth, HScale(6));
    [signOut setBackgroundColor:WhiteColor];
    [signOut setTitleColor:localColor forState:UIControlStateNormal];
    [signOut setTitle:@"账号退出" forState:UIControlStateNormal];
    signOut.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(15)];
    [signOut addTarget:self action:@selector(cilcksignOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signOut];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, signOut.bottom, ScreenWidth, 0.5)];
    line.backgroundColor = NAVLINECOLOR;
    [self.view addSubview:line];
    
}
/**
 *  计算缓存大小
 */
-(void)loadMemorySize{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGFloat memory = [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            _memoryNum = [[UILabel alloc]init];
            _memoryNum.frame = CGRectMake(ScreenWidth - WScale(7.2)-WScale(20), HScale(2.8), WScale(20), HScale(3));
            _memoryNum.text = [NSString stringWithFormat:@"%.2fMB",memory];
            _memoryNum.textAlignment = NSTextAlignmentRight;
            _memoryNum.textColor = GPColor(44, 44, 44);
            _memoryNum.font = [UIFont systemFontOfSize:kHorizontal(14)];
            [_clearMemoryBtn addSubview:_memoryNum];
            
        });
    });

}
#pragma mark ---- 清除缓存
-(void)clearMemory{
    _memoryGround = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _memoryGround.hidden = NO;
    _memoryGround.backgroundColor = GPRGBAColor(.2, .2, .2, .3);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHidden)];
    [_memoryGround addGestureRecognizer:tap];
    [self.view addSubview:_memoryGround];
    
    _memoryView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, HScale(14.8))];
    _memoryView.hidden = NO;
    _memoryView.backgroundColor = GPColor(245, 245, 245);
    [self.view addSubview:_memoryView];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    confirmBtn.backgroundColor = [UIColor whiteColor];
    [confirmBtn addTarget:self action:@selector(clickToConfirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:GPColor(58, 56, 59) forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    
    [_memoryView addSubview:confirmBtn];
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HScale(6.9));
    [cancel addTarget:self action:@selector(clickToHidden) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:GPColor(58, 56, 59) forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(16)];
    
    [_memoryView addSubview:cancel];
    
    [UIView animateWithDuration:0.4 animations:^{
        _memoryView.frame = CGRectMake(0, ScreenHeight - HScale(14.8), ScreenWidth, HScale(14.8));
    }];
    [UIView animateWithDuration:0.27 animations:^{
        confirmBtn.frame = CGRectMake(0, 0, ScreenWidth, HScale(6.9));
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        cancel.frame = CGRectMake(0, HScale(7.9), ScreenWidth, HScale(6.9));
    }];

    
    
}
-(void)clickToHidden{
    _memoryGround.hidden = YES;
    _memoryView.hidden = YES;
}

#pragma mark ---- 清除缓存
-(void)clickToConfirm{
    [self clickToHidden];
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    [_memoryNum removeFromSuperview];
    [self loadMemorySize];
}

#pragma mark ---- 返回上个界面
-(void)pushBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cilcksignOut{
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
//
//    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
//    [userDefaults setValue:@"0" forKey:@"name_id"];
//    
//    NSString *versionKey = @"CFBundleVersion";

    //当前使用的版本
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
//    [userDefaults setObject:currentVersion forKey:versionKey];
    
    LoginViewController *regist = [[LoginViewController alloc] init];
    regist.headerStr = [userDefaults objectForKey:@"pic"];
    regist.phoneNum = [userDefaults objectForKey:@"phone"];
//    [userDefaults setObject:@"0" forKey:@"name_id"];
    [self.navigationController pushViewController:regist animated:YES];
    
}


#pragma mark ---- 推荐给朋友
-(void)cilckToShare{
    _backGround = [[UIView alloc]init];
    _backGround.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _backGround.backgroundColor = GPRGBAColor(.2, .2, .2, .5);
    _backGround.hidden = NO;
    _backGround.userInteractionEnabled = YES;
    [self.view addSubview:_backGround];
    
    
    _view = [[UIView alloc]init];
    _view.frame = CGRectMake(WScale(15.5), HScale(32), ScreenWidth * 0.691, ScreenHeight *0.298);
    _view.layer.cornerRadius = 8;
    _view.tag = 101;
    _view.hidden = NO;
    _view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view];
    
    UIButton *haoYou = [UIButton buttonWithType:UIButtonTypeCustom];
    [haoYou setBackgroundImage:[UIImage imageNamed:@"推荐给微信好友"] forState: UIControlStateNormal];
    [haoYou addTarget:self action:@selector(clickToHaoYou) forControlEvents:UIControlEventTouchUpInside];
    haoYou.frame = CGRectMake(WScale(10.8), HScale(6.3), ScreenWidth * 0.181, ScreenHeight * 0.102);
    [_view addSubview:haoYou];
    UILabel *haoyouLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(13.6), HScale(17.4), WScale(16), HScale(2.5))];
    haoyouLabel.text = @"微信好友";
    haoyouLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    haoyouLabel.textColor = [UIColor blackColor];
    [_view addSubview:haoyouLabel];
    
    UIButton *pengYouQuan = [UIButton buttonWithType:UIButtonTypeCustom];
    [pengYouQuan setBackgroundImage:[UIImage imageNamed:@"推荐到微信朋友圈"] forState: UIControlStateNormal];
    [pengYouQuan addTarget:self action:@selector(clickToPengYouQuan) forControlEvents:UIControlEventTouchUpInside];
    pengYouQuan.frame = CGRectMake(WScale(40.3), HScale(6.3), ScreenWidth * 0.181, ScreenHeight * 0.102);
    [_view addSubview:pengYouQuan];
    UILabel *pengyouLabel = [[UILabel alloc]initWithFrame:CGRectMake(WScale(41.3), HScale(17.4), WScale(18), HScale(2.5))];
    pengyouLabel.font = [UIFont systemFontOfSize:kHorizontal(12)];
    pengyouLabel.text = @"微信朋友圈";
    pengyouLabel.textColor = [UIColor blackColor];
    [_view addSubview:pengyouLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, HScale(23.4), ScreenWidth * 0.691, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_view addSubview:line];
    
    _cancer = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancer.tag = 102;
    _cancer.hidden = NO;
    [_cancer setTitle:@"取消" forState:UIControlStateNormal];
    _cancer.frame = CGRectMake(WScale(15.5), HScale(55.4)+1, WScale(69.1), ScreenHeight *0.064);
    [_cancer setTitleColor:[UIColor colorWithRed:11/255.0f green:177/255.0f blue:172/255.0f alpha:1] forState:UIControlStateNormal];
    [_cancer addTarget:self action:@selector(clickToCancer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancer];
    
    
}
-(void)clickToHaoYou{

    [self clickToCancer];
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = kLinkTitle;//分享标题
    urlMessage.description = kLinkDescription;//分享描述
    urlMessage.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kImage]];

    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = kLinkURL;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    
#pragma 创建大图
//    WXMediaMessage *message = [WXMediaMessage message];
//    WXImageObject *ext = [WXImageObject object];
//    
//    NSString *userImage = [userDefaults objectForKey:@"picture_url"];
//    
//    ext.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImage]];
//    message.mediaObject = ext;
//    message.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kImage]];
//    
//    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
//    resp.message = message;
//    resp.bText = NO;
//    
//    [WXApi sendResp:resp];
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
    urlMessage.title = kLinkTitle;//分享标题
    urlMessage.description = kLinkDescription;//分享描述
    urlMessage.thumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kImage]];
    
    
    //    [urlMessage setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kImage]]]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    //    [urlMessage setThumbData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kImage]]];
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = kLinkURL;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}
-(void)clickToCancer{
        _backGround.hidden = YES;
        _view.hidden = YES;
        _cancer.hidden = YES;

}

#pragma mark ---- 关于我们
-(void)clickToAbout{
    UserDetailViewController *user = [[UserDetailViewController alloc]init];
    user.urlStr = @"http://www.golvon.com/GolvonImage/HTML/about_we.html";
    user.titleStr = @"打球去";
    [self.navigationController pushViewController:user animated:YES];
}

//- (BOOL) shouldAutorotateToInterfaceOrientation:
//(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}
//
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}




@end
