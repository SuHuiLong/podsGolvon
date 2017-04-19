//
//  CharityViewController.m
//  JiFenKaDemo
//
//  Created by 李盼盼 on 16/6/27.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import "CharityViewController.h"
#import "DownLoadDataSource.h"
#import "CharityModel.h"
#import "UIImageView+WebCache.h"
#import "SaveScoreView.h"

@interface CharityViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) DownLoadDataSource     *loadData;
@property (strong, nonatomic) NSMutableArray         *dataArr;

@property (strong, nonatomic) UIScrollView           *scrollView;
/**捐赠人数*/
@property (strong, nonatomic) UILabel                *peopleNum;
/**总金额*/
@property (strong, nonatomic) UILabel                *allMoney;
/**总场次*/
@property (strong, nonatomic) UILabel                *allChangci;
/**头像*/
@property (strong, nonatomic) UIImageView            *headerView;
/**shuoming*/
@property (strong, nonatomic) UIImageView            *explainImage;
/**说明背景*/
@property (strong, nonatomic) UIView                 *explainView;
/**说明图片*/
@property (strong, nonatomic) UIView                 *groundView;
/**知道了按钮*/
@property (strong, nonatomic) UIButton               *button;

@end

@implementation CharityViewController

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestWithData];
}
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    
    [self createUI];
    [self createNavi];
}
-(void)createNavi{
    
    UIView *navi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navi.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, ScreenWidth, 15)];
    titleLabel.text = @"打球去公益";
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
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navi addSubview:titleLabel];
    
    //pop返回
    UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BackBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    BackBtn.backgroundColor = [UIColor clearColor];
    BackBtn.frame = CGRectMake(0, 20, 44, 44);
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 13, 19, 19)];
    backImage.image = [UIImage imageNamed:@"返回"];
    [BackBtn addSubview:backImage];
    
    [navi addSubview:BackBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, navi.frame.size.height-1, ScreenWidth, 1)];
    line.backgroundColor = GPColor(223, 224, 225);
    
    [self.view addSubview:navi];
    [self.view addSubview:line];
}
-(void)pressBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight+20)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+20);
    [self.view addSubview:_scrollView];
    
//    球童图片
    UIImageView *groundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HScale(46.2))];
    groundImage.userInteractionEnabled = YES;
    groundImage.image = [UIImage imageNamed:@"banner"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToBanner)];
    [groundImage addGestureRecognizer:tap];
    
    [_scrollView addSubview:groundImage];
    
    
    /**头像*/
    UILabel *groundLabel = [[UILabel alloc]init];
    groundLabel.frame = CGRectMake((ScreenWidth - WScale(13.3))/ 2, HScale(42.7), WScale(13.3), HScale(7.5));
    groundLabel.backgroundColor = [UIColor whiteColor];
    groundLabel.layer.masksToBounds = YES;
    groundLabel.layer.cornerRadius = HScale(7.5)/2;
    [_scrollView addSubview:groundLabel];
    
    _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(((ScreenWidth - WScale(13.3))/ 2)+2, HScale(42.7)+2, WScale(13.3)-4, HScale(7.5)-4)];
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = (HScale(7.5)-4)/2;
    [_scrollView addSubview:_headerView];
    
//    打球去logo
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(15.5))/2, HScale(54), WScale(15.7), HScale(2.8))];
    logo.image = [UIImage imageNamed:@"打球去"];
    [_scrollView addSubview:logo];
    
//
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(58), ScreenWidth, HScale(2.7))];
    label.text = @"打球去将出资捐助该项目";
    label.textColor = GPColor(64, 64, 64);
    label.font = [UIFont systemFontOfSize:kHorizontal(13)];
    label.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:label];
    
//    关爱基金
    UIImageView *lineMoney = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(81.3))/2, HScale(65.2), WScale(81.3), HScale(2.4))];
    lineMoney.image = [UIImage imageNamed:@"关爱基金"];
    [_scrollView addSubview:lineMoney];
    
//    捐赠
    NSArray *arr = @[@"捐赠人数",@"捐赠总金额",@"捐赠总场次"];
    for (int i = 0; i<3; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*i/3, HScale(69.3), ScreenWidth/3, HScale(2.7))];
        titleLabel.text = arr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = GPColor(64, 64, 64);
        titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
        [_scrollView addSubview:titleLabel];
    }
    
//     口号
    UIImageView *slogan = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(67.2))/2, HScale(82.5), WScale(67.2), HScale(2.4))];
    slogan.image = [UIImage imageNamed:@"口号"];
    [_scrollView addSubview:slogan];
    
//    慈善记录
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((ScreenWidth - WScale(22.7))/2, HScale(91.8), WScale(22.7), HScale(2.3));
    [button setBackgroundImage:[UIImage imageNamed:@"慈善记录"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickToCharity) forControlEvents:UIControlEventTouchUpInside];;
    [_scrollView addSubview:button];
    
//
    UIImageView *charityImage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - WScale(25.1))/2, HScale(95.8), WScale(25.1), HScale(2.2))];
    charityImage.image = [UIImage imageNamed:@"打球去和大城小爱"];
    [_scrollView addSubview:charityImage];
    
//    问题
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1 .frame = CGRectMake(ScreenWidth-60, HScale(92.3), 60, 40);
    [button1 setImage:[UIImage imageNamed:@"慈善规则"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickToCharityRule) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button1];
}

-(void)requestWithData{
    __weak typeof(self) weakself = self;
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_user_gongyi",urlHeader120] parameters:@{@"name_id":userDefaultId} complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data;
            for (NSDictionary *temp in dic[@"data"]) {
                CharityModel *model = [CharityModel pareFromWithDictionary:temp];
                [weakself.dataArr addObject:model];
                
                [weakself setModel:model];
            }
        }
    }];
}
-(void)setModel:(CharityModel *)model{
    [_headerView sd_setImageWithURL:[NSURL URLWithString:model.picture_url]placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
    //    人数，金额，场次
    
    _peopleNum = [[UILabel alloc]initWithFrame:CGRectMake(0, HScale(73.5), ScreenWidth/3, HScale(2.7))];
    _peopleNum.textAlignment = NSTextAlignmentCenter;
    _peopleNum.textColor = GPColor(238, 108, 33);
    NSString *str = [NSString stringWithFormat:@"%@ %@",model.allUserNumber,@"人"];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributed.length-1, 1)];
    _peopleNum.attributedText = attributed;
    [_scrollView addSubview:_peopleNum];
    
    
    _allMoney = [[UILabel alloc]initWithFrame:CGRectMake(_peopleNum.frame.origin.x + _peopleNum.frame.size.width, HScale(73.5), ScreenWidth/3, HScale(2.7))];
    _allMoney.textAlignment = NSTextAlignmentCenter;
    _allMoney.textColor = GPColor(238, 108, 33);
    NSString *str1 = [NSString stringWithFormat:@"%@ %@",model.allCiShan,@"元"];
    NSMutableAttributedString *attributed1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [attributed1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributed1.length-1, 1)];
    _allMoney.attributedText = attributed1;
    [_scrollView addSubview:_allMoney];
    
    
    _allChangci = [[UILabel alloc]initWithFrame:CGRectMake(_allMoney.frame.origin.x + _allMoney.frame.size.width, HScale(73.5), ScreenWidth/3, HScale(2.7))];
    _allChangci.textAlignment = NSTextAlignmentCenter;
    _allChangci.textColor = GPColor(238, 108, 33);
    NSString *str2 = [NSString stringWithFormat:@"%@ %@",model.allChangShu,@"次"];
    NSMutableAttributedString *attributed2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [attributed2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(attributed2.length-1, 1)];
    _allChangci.attributedText = attributed2;
    [_scrollView addSubview:_allChangci];

}
-(void)clickToCharity{
    SaveScoreView *save = [[SaveScoreView alloc]init];
    save.name_id = userDefaultId;
//    CATransition *animation = [CATransition animation];
//    [animation setDuration:0.3f];
//    [animation setTimingFunction:[CAMediaTimingFunction
//                                  functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype: kCATransitionFromRight];
//    [self.view.layer addAnimation:animation forKey:@"Reveal"];
//    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:save animated:YES];
}
-(void)clickToCharityRule{
    
        [self createRuleView];
}

-(void)clickToBanner{
    
    _groundView = [[UIView alloc]init];
    _groundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _groundView.backgroundColor = [UIColor blackColor];
    _groundView.alpha = 0.5;
    _groundView.hidden = NO;
    _groundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToBack)];
    [self.view addSubview:_groundView];
    [_groundView addGestureRecognizer:tap];
    
    _explainView = [[UIView alloc]init];
    _explainView.frame = CGRectMake((ScreenWidth - WScale(75.5))/2, HScale(29.2), WScale(75.5), HScale(41.7));
    _explainView.layer.cornerRadius = 8;
    _explainView.hidden = NO;
    _explainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_explainView];
    
    _explainImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WScale(75.5), HScale(45))];
    _explainImage.image = [UIImage imageNamed:@"球童关爱基金icon"];
    [_explainView addSubview:_explainImage];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake((WScale(75.5) - kWvertical(198))/2, HScale(36.9), kWvertical(198), kHvertical(37));
    [_button setBackgroundImage:[UIImage imageNamed:@"知道了"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    _button.adjustsImageWhenHighlighted = NO;
    [_explainView addSubview:_button];
    
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
    [butn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    butn.frame = CGRectMake(_explainView.width - kWvertical(14), -kHvertical(12), kWvertical(24), kWvertical(24));
    [butn setBackgroundImage:[UIImage imageNamed:@"选择关闭"] forState:UIControlStateNormal];
    [_explainView addSubview:butn];
    
}
-(void)createRuleView{
    _groundView = [[UIView alloc]init];
    _groundView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _groundView.backgroundColor = [UIColor blackColor];
    _groundView.alpha = 0.5;
    _groundView.hidden = NO;
    _groundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToBack)];
    [self.view addSubview:_groundView];
    [_groundView addGestureRecognizer:tap];
    
    
    _explainView = [[UIView alloc]init];
    _explainView.frame = CGRectMake((ScreenWidth - kWvertical(318))/2, kHvertical(127), kWvertical(318), kHvertical(425));
    _explainView.layer.cornerRadius = 8;
    _explainView.hidden = NO;
    _explainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_explainView];
    
    _explainImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWvertical(318), kHvertical(425))];
    _explainImage.image = [UIImage imageNamed:@"说明底图"];
    [_explainView addSubview:_explainImage];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake((WScale(84.8) - kWvertical(198))/2, kHvertical(370), kWvertical(198), kHvertical(37));
    [_button setBackgroundImage:[UIImage imageNamed:@"知道了"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    _button.adjustsImageWhenHighlighted = NO;
    [_explainView addSubview:_button];
    
    
    UIButton *butn = [UIButton buttonWithType:UIButtonTypeCustom];
    [butn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    butn.frame = CGRectMake(_explainView.width - kWvertical(14), -kHvertical(12), kWvertical(24), kWvertical(24));
    [butn setBackgroundImage:[UIImage imageNamed:@"选择关闭"] forState:UIControlStateNormal];
    [_explainView addSubview:butn];
    
}
-(void)clickToBack{
    _groundView.hidden = YES;
    _explainView.hidden = YES;
    _explainImage.hidden = YES;
    _button.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
