



//
//  PublicBenefitDetailViewController.m
//  podsGolvon
//
//  Created by SHL on 2016/11/14.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublicBenefitDetailViewController.h"

@interface PublicBenefitDetailViewController ()

@end

@implementation PublicBenefitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)createView{
    [self createNavigation];
    UILabel *title = [Factory createLabelWithFrame:CGRectMake(0, kHvertical(64+9), ScreenWidth, kHvertical(25)) textColor:rgba(0,0,0,1) fontSize:kHorizontal(18) Title:@"球童关爱基金"];
    [title setTextAlignment:NSTextAlignmentCenter];
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(0, 64 + 41, ScreenWidth, ScreenHeight-64-41)];
    textview.userInteractionEnabled = false;
    textview.font = [UIFont systemFontOfSize:kHorizontal(15)];
    textview.text = @"打球去球童关爱基金是由姚文刚先生和打球去平台倡导发起的一项捐助球童的公益活动。该活动宗旨在通过捐助活动，对有困难的球童以其家庭提供一定的经济帮助，并呼吁社会尊重与关爱球童，让球童的担忧成为过去式。\n \n【活动规则】\n您每上传一次记分卡就会自动捐出一份爱心给需要关爱的球童们\n\n【捐助金额计算规则】\n1. 根据记分卡体现的成绩数据计算出底金:小鸟球数量为B，老鹰球数量为E，底金为2+0.2×B+0.5×E(0.2为小鸟球基数，0.5为老鹰球基数）\n\n2. 杆数系数:  成绩低于58杆无效，58杆到79杆为1.4；  80杆到89杆为1.3;   90杆到99杆为1.2； 100杆以上系数为1\n\n3. 捐助金额=底金×杆数系数\n\n4. 例如：您上传的记分卡显示成绩为78杆，小鸟球数量是3，老鹰球是1，则捐助金额 =（2+0.2*3+0.5*1）*1.4=4.34（元）\n\n企业合作请致电：021-61280539";
    
    [self.view addSubview:title];
    [self.view addSubview:textview];
}

-(void)createNavigation{
    UIView *Uvc = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [Uvc setBackgroundColor:rgba(249,249,249,1)];
    
    UIButton *leftBtn = [Factory createButtonWithFrame:CGRectMake(0, 0, 64, 64) image:[UIImage imageNamed:@"BlackBack"] target:self selector:@selector(leftBtnClick) Title:nil];
    [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(33, 13, 13, 41)];
    
    UILabel *titlelabel = [Factory createLabelWithFrame:CGRectMake(0, 30, ScreenWidth, kHvertical(25)) textColor:BlackColor fontSize:18.f Title:@"详细规则"];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    UIView *lineView = [Factory createViewWithBackgroundColor:rgba(199,199,199,1) frame:CGRectMake(0, 63.5, ScreenWidth, 0.5)];
    
    [Uvc addSubview:leftBtn];
    [Uvc addSubview:titlelabel];
    [self.view addSubview:lineView];
    [self.view addSubview:Uvc];

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
