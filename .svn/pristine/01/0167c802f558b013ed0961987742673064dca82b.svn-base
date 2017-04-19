//
//  MyCodeViewController.m
//  podsGolvon
//
//  Created by apple on 2016/10/11.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "MyCodeViewController.h"

@interface MyCodeViewController ()

@end

@implementation MyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgba(238,239,241,1);
    // Do any additional setup after loading the view.
}

-(void)createView{
    [self createNavagationView];
    [self createContentView];
}

//创建navagation
-(void)createNavagationView{
    UIView *Uvc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Uvc setBackgroundColor:WhiteColor];
    
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"BlackBack"] target:self selector:@selector(leftBtnClick) Title:nil];
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 41)];
    
    UILabel *titlelabel = [Factory createLabelWithFrame:CGRectMake(0, 30, ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:18.f Title:@"我的二维码"];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(179,179,179,1) frame:CGRectMake(0, 64, ScreenWidth, 0.5)];
    
    [Uvc addSubview:leftBtn];
    [Uvc addSubview:titlelabel];
    [self.view addSubview:lineView];
    [self.view addSubview:Uvc];
}

-(void)createContentView{
    UIView *backView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(kWvertical(19),64 + kHvertical(12), ScreenWidth - kWvertical(38), kHvertical(427))];
    
    UIImageView *headerView = [Factory createImageViewWithFrame:CGRectMake(backView.width/2 - kWvertical(37), kHvertical(21), kWvertical(74), kWvertical(74)) Image:nil];
    [headerView sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"pic"]]];
    headerView.layer.masksToBounds = YES;
    headerView.layer.cornerRadius = kWvertical(37);
    
    UILabel *nameLabel = [Factory createLabelWithFrame:CGRectMake(20, headerView.y_height + kHvertical(7), backView.width - kWvertical(40), kHvertical(24)) textColor:BlackColor fontSize:kHorizontal(17.0f) Title:[userDefaults objectForKey:@"nickname"]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *addAlert = [Factory createLabelWithFrame:CGRectMake(0, nameLabel.y_height + kHvertical(5), backView.width, kHvertical(21)) textColor:rgba(171,171,171,1) fontSize:kHorizontal(15) Title:@"扫一扫二维码，加入我的队伍"];
    addAlert.textAlignment = NSTextAlignmentCenter;

    UIImageView *QRCodeView = [Factory createImageViewWithFrame:CGRectMake(backView.width/2 - kHvertical(203)/2, addAlert.y_height + kHvertical(26), kHvertical(203), kHvertical(203)) Image:nil];
    
    [QRCodeView setBackgroundColor:RandomColor];
    [self.view addSubview:backView];
    [backView addSubview:headerView];
    [backView addSubview:nameLabel];
    [backView addSubview:addAlert];
    [backView addSubview:QRCodeView];
}

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
