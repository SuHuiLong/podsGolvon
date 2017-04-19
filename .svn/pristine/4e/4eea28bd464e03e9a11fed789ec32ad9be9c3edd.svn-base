//
//  PublishTextViewController.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublishTextViewController.h"
#import "ShlTextView.h"


@interface PublishTextViewController ()<UITextViewDelegate,UIScrollViewDelegate>{
    ShlTextView *_textView;
    UIScrollView *_scrollView;
}

@end

@implementation PublishTextViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 创建View
-(void)createView{
    [self createNavigationView];
    [self createScrollView];
    [self createTextView];
    [self createLocationView];
}
//创建上导航
-(void)createNavigationView{
    UserTopNavigation *vc = [[UserTopNavigation alloc] init];
    UILabel *cancelLel = [Factory createLabelWithFrame:CGRectMake(kWvertical(11.5), kHvertical(35), kWvertical(30), kHvertical(14.5)) textColor:GPColor(20, 21, 22) fontSize:kHorizontal(15) Title:@"取消"];

    UILabel *sendLabel = [Factory createLabelWithFrame:CGRectMake(WScale(15) - kWvertical(41.5), kHvertical(35),  kWvertical(30), kHvertical(14.5))  textColor:GPColor(122, 179, 23) fontSize:kHorizontal(15) Title:@"发送"];
    [vc.leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [vc.leftBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];

    [vc createLeftWithImage:cancelLel];
    [vc createRightWithImage:sendLabel];
    [vc createTitleWith:@"发表文字"];
    [self.view addSubview:vc];
}
//创建ScrollView
-(void)createScrollView{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
}

//创建TextView
-(void)createTextView{
    _textView = [[ShlTextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:kHorizontal(13)];
    _textView.frame = CGRectMake(kWvertical(14), kHvertical(73.5)-64, ScreenWidth - kWvertical(28), kHvertical(110));
    _textView.delegate = self;
    _textView.placeStr = @"这一刻你的想法...";
    CGRect rect = CGRectMake(kWvertical(7), 0, ScreenWidth*2/3, 20);
    _textView.placeLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [_textView setPlaceLableFrame:rect];
    [_scrollView addSubview:_textView];
}

//创建位置
-(void)createLocationView{
    
    
    UIView *line = [Factory createViewWithBackgroundColor:GPColor(223, 223, 223) frame:CGRectMake(kWvertical(21), kHvertical(198)-64, ScreenWidth - kWvertical(42), 1)];

    [_scrollView addSubview:line];
    
    UIImageView *locationView =[Factory createImageViewWithFrame:CGRectMake(kWvertical(5.5), line.frame.origin.y + 1 +kHvertical(16), kWvertical(12), kHvertical(16)) Image:[UIImage imageNamed:@"PublishLocation"]];
    [_scrollView addSubview:locationView];
    
    UILabel *loactionLabel = [Factory createLabelWithFrame:CGRectMake(kWvertical(27), line.frame.origin.y + 1 + kHvertical(17), ScreenWidth - kWvertical(54), kHvertical(15)) textColor:BlackColor fontSize:kHorizontal(14) Title:@"所在位置"];
    [_scrollView addSubview:loactionLabel];
    
    
    UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth - kWvertical(14), line.frame.origin.y + 1 + kHvertical(17), kWvertical(7), kHvertical(11.5)) Image:[UIImage imageNamed:@"PublishArrow"]];
    [_scrollView addSubview:arrowView];
    
}


#pragma mark - 点击事件
//返回
-(void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发送
-(void)sendClick{
}




#pragma mark - Delegate
//textView字数改变
-(void)textViewDidChange:(UITextView *)textView{
    [_textView textViewDidChange:textView.text];
    
}

//隐藏键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        [_textView resignFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
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
