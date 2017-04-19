//
//  EmojiKeybordView.m
//  EmojiDemo
//
//  Created by suhuilong on 16/9/14.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "EmojiKeybordView.h"
#import "EmojiScrollView.h"

@interface EmojiKeybordView ()<UIScrollViewDelegate>{
    //pilist文件中数据
    NSMutableArray *dataArray;
}



//上部滚动图
@property(nonatomic,strong)UIScrollView *mainScrollView;

//scrollview包含内容
@property(nonatomic, strong) UIImageView *contentView;
//显示的数据
@property(nonatomic,strong)  NSMutableArray  *ReViewArray;

@property(nonatomic,strong)  UIPageControl *pageControlBottom;


@end
@implementation EmojiKeybordView




-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            [self createView];
        }
    }
    return self;
}

- (void)createView {
    self.backgroundColor = WhiteColor;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
//    NSLog(@"%@", [data objectForKey:@"People"]);//直接打印数据。
    
    
    dataArray = [NSMutableArray array];
    NSMutableArray *totalArray = [NSMutableArray array];
    
    [totalArray addObject:[data objectForKey:@"People"]];
    [totalArray addObject:[data objectForKey:@"Places"]];
    [totalArray addObject:[data objectForKey:@"Objects"]];
    [totalArray addObject:[data objectForKey:@"Nature"]];
    
    
    
    dataArray = [NSMutableArray arrayWithArray:totalArray];
    //分页控制器
    _pageControlBottom = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kHvertical(155), [UIScreen mainScreen].bounds.size.width, 10)];
    _pageControlBottom.currentPage = 0;
    _pageControlBottom.currentPageIndicatorTintColor = RGBA(102,109,118,1);
    _pageControlBottom.pageIndicatorTintColor = RGBA(216,216,216,1);
    //表情scrollView
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kHvertical(216))];
    [_mainScrollView setPagingEnabled:YES];
    _mainScrollView.delegate = self;
    
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    
    _ReViewArray = [[NSMutableArray alloc] init];
    NSInteger totalCount = 0;
    for (NSInteger x = 0; x<dataArray.count; x++) {
        NSMutableArray *EmojiArray = dataArray[x];
        NSInteger ArrayCount = EmojiArray.count/23;
        CGFloat Float =  EmojiArray.count%23;
        
        if (Float!=0) {
            ArrayCount+=1;
            for (NSInteger y = 0; y<23 - Float; y++) {
                [EmojiArray addObject:@" "];
            }
        }
        for (NSInteger z =0; z<ArrayCount; z++) {
            [EmojiArray insertObject:@"EmojiDeleat" atIndex:24*z];
        }
        
        [EmojiArray removeObjectAtIndex:0];
        [EmojiArray insertObject:@"EmojiDeleat" atIndex:EmojiArray.count];
        [_ReViewArray addObject:EmojiArray];
        totalCount += ArrayCount;
    }
    
    NSMutableArray *FristEmojiArray = [NSMutableArray arrayWithArray:_ReViewArray[0]];
    NSMutableArray *SecondEmojiArray = _ReViewArray[1];
    NSMutableArray *ThirdEmojiArray = _ReViewArray[2];
    NSMutableArray *FourthEmojiArray = _ReViewArray[3];
    _mainScrollView.contentSize = CGSizeMake(ScreenWidth * totalCount,kHvertical(216));
    _pageControlBottom.numberOfPages = FristEmojiArray.count/24;
    
    __weak __typeof(self)weakSelf = self;
    for (NSInteger i = 0; i<totalCount; i++) {
        
        EmojiScrollView * imageView = [[EmojiScrollView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, 216)];
        imageView.SlectIndex = ^(id select){
            weakSelf.selectEmoji(select);
        };
        imageView.userInteractionEnabled = YES;
        NSInteger FristCount = FristEmojiArray.count/24;
        NSInteger SecondCount = SecondEmojiArray.count/24+FristCount;
        NSInteger ThirdCount =  ThirdEmojiArray.count/24+SecondCount;
        
        if (i<FristCount) {
            NSMutableArray *reViewArray = [NSMutableArray arrayWithArray:FristEmojiArray];
            NSMutableArray *indexArray = [NSMutableArray arrayWithArray:[reViewArray subarrayWithRange:NSMakeRange(24*i,24)]];
            [imageView setContentViewWhith:indexArray];
            
        }else if (i<SecondCount){
            NSMutableArray *reViewArray = [NSMutableArray arrayWithArray:SecondEmojiArray];
            NSMutableArray *indexArray = [NSMutableArray arrayWithArray:[reViewArray subarrayWithRange:NSMakeRange(24*(i-FristCount),24)]];
            [imageView setContentViewWhith:indexArray];
            
        }else if (i<ThirdCount){
            NSMutableArray *reViewArray = [NSMutableArray arrayWithArray:ThirdEmojiArray];
            NSMutableArray *indexArray = [NSMutableArray arrayWithArray:[reViewArray subarrayWithRange:NSMakeRange(24*(i-SecondCount),24)]];
            [imageView setContentViewWhith:indexArray];
        }else {
            NSMutableArray *reViewArray = [NSMutableArray arrayWithArray:FourthEmojiArray];
            NSMutableArray *indexArray = [NSMutableArray arrayWithArray:[reViewArray subarrayWithRange:NSMakeRange(24*(i-ThirdCount),24)]];
            [imageView setContentViewWhith:indexArray];
        }
        
        [_mainScrollView addSubview:imageView];
    }
    [self addSubview:_mainScrollView];
    [self addSubview:_pageControlBottom];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kHvertical(180), ScreenWidth, kHvertical(36))];
    bottomView.backgroundColor = RGBA(248, 248, 248, 1);
    [self addSubview:bottomView];
    
    //底部选择按钮
    NSArray *titleArry = @[@"😀",@"🏠",@"🎍",@"🐶"];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *bootm = [UIButton buttonWithType:UIButtonTypeCustom];
        bootm.frame = CGRectMake(kWvertical(54)*i, kHvertical(180), kWvertical(54), kHvertical(36));
        [bootm addTarget:self action:@selector(selectClassify:) forControlEvents:UIControlEventTouchUpInside];
        [bootm setTitle:titleArry[i] forState:UIControlStateNormal];
        [bootm setBackgroundColor:ClearColor];
        bootm.tag = 1000 +i;
        if (i==0) {
            [bootm setBackgroundColor:RGBA(215,215,215,1)];
        }
        [self addSubview:bootm];
    }
    
    //发送按钮
    _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - kWvertical(82),  kHvertical(216)- kHvertical(36), kWvertical(82), kHvertical(36))];
    _sendBtn.backgroundColor = localColor;
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self addSubview:_sendBtn];
}


#pragma mark - scrollViewDeleate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contenOffset = scrollView.contentOffset.x;
    int page = contenOffset/scrollView.frame.size.width+((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
    
    UIButton *btn1 = (UIButton *)[self viewWithTag:1000];
    UIButton *btn2 = (UIButton *)[self viewWithTag:1001];
    UIButton *btn3 = (UIButton *)[self viewWithTag:1002];
    UIButton *btn4 = (UIButton *)[self viewWithTag:1003];
    
    btn1.backgroundColor = ClearColor;
    btn2.backgroundColor = ClearColor;
    btn3.backgroundColor = ClearColor;
    btn4.backgroundColor = ClearColor;
    
    NSMutableArray *FristEmojiArray = _ReViewArray[0];
    NSMutableArray *SecondEmojiArray = _ReViewArray[1];
    NSMutableArray *ThirdEmojiArray = _ReViewArray[2];
    NSMutableArray *FourthEmojiArray = _ReViewArray[3];
    NSInteger FristCount = FristEmojiArray.count/24;
    NSInteger SecondCount = SecondEmojiArray.count/24+FristCount;
    NSInteger ThirdCount =  ThirdEmojiArray.count/24+SecondCount;
    
    _pageControlBottom.numberOfPages = FristEmojiArray.count/24;
    _pageControlBottom.currentPage = page;
    
    if (page >=FristCount) {
        btn2.backgroundColor = RGBA(215,215,215,1);
        _pageControlBottom.numberOfPages = SecondEmojiArray.count/24;
        _pageControlBottom.currentPage = page-FristCount;
        if (page>=SecondCount){
            btn3.backgroundColor = RGBA(215,215,215,1);
            btn2.backgroundColor = ClearColor;
            
            _pageControlBottom.numberOfPages = ThirdEmojiArray.count/24;
            _pageControlBottom.currentPage = page-SecondCount;
            if (page>=ThirdCount){
                btn2.backgroundColor = ClearColor;
                btn3.backgroundColor = ClearColor;
                btn4.backgroundColor = RGBA(215,215,215,1);
                _pageControlBottom.numberOfPages = FourthEmojiArray.count/24;
                _pageControlBottom.currentPage = page-ThirdCount;
            }
        }
    }else{
        btn1.backgroundColor = RGBA(215,215,215,1);
    }
}



//底部按钮选择
-(void)selectClassify:(UIButton *)sender{
    
    if ([sender.backgroundColor isEqual:RGBA(215,215,215,1)] ) {
        return;
    }
    
    UIButton *btn1 = (UIButton *)[self viewWithTag:1000];
    UIButton *btn2 = (UIButton *)[self viewWithTag:1001];
    UIButton *btn3 = (UIButton *)[self viewWithTag:1002];
    UIButton *btn4 = (UIButton *)[self viewWithTag:1003];
    
    btn1.backgroundColor = ClearColor;
    btn2.backgroundColor = ClearColor;
    btn3.backgroundColor = ClearColor;
    btn4.backgroundColor = ClearColor;
    sender.backgroundColor = RGBA(215,215,215,1);
    
    
    NSMutableArray *FristEmojiArray = _ReViewArray[0];
    NSMutableArray *SecondEmojiArray = _ReViewArray[1];
    NSMutableArray *ThirdEmojiArray = _ReViewArray[2];
    NSInteger FristCount = FristEmojiArray.count/24;
    NSInteger SecondCount = SecondEmojiArray.count/24+FristCount;
    NSInteger ThirdCount =  ThirdEmojiArray.count/24+SecondCount;
    
    if (sender == btn1) {
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else if (sender == btn2){
        [_mainScrollView setContentOffset:CGPointMake(ScreenWidth*FristCount, 0) animated:NO];
    }else if (sender == btn3){
        [_mainScrollView setContentOffset:CGPointMake(ScreenWidth*SecondCount, 0) animated:NO];
    }else if (sender == btn4){
        [_mainScrollView setContentOffset:CGPointMake(ScreenWidth*ThirdCount, 0) animated:NO];
    }
    
}





@end
