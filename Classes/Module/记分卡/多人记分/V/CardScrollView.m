//
//  ScrollView.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/30.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "CardScrollView.h"

@interface CardScrollView() <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *imageArr;
@property (assign, nonatomic) NSInteger login_type;
@property (assign, nonatomic) NSInteger lastPosition;

@property (assign, nonatomic) BOOL BeginScroll;

@end

@implementation CardScrollView
{
    __weak UIImageView *_leftImage,*_centerImage,*_rightImage;
    __weak UIScrollView *_scrollView;
    __weak UIPageControl *_pageControl;
    
    
    NSInteger _currentIndex;
    NSTimer *_timer;
    NSInteger _numImage;
}

-(instancetype)initWithFrame:(CGRect)frame WithImagesArry:(NSArray *)imageArray{

    self = [super initWithFrame:frame];
    if (self) {
        /** 创建滚动view*/
        [self createScrollView];
        /** 加载view*/
        [self initImageView:imageArray];
        
        [self setMaxImageCount:_imageArr.count];
    }
    return self;
}
- (void)createScrollView
{
    _BeginScroll = NO;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    /** 复用，创建三个*/
    scrollView.contentSize = CGSizeMake(ScreenWidth * 18, 0);
    /** 开始显示的是第一个   前一个是最后一个   后一个是第二张*/
    _currentIndex = 0;
    _scrollView = scrollView;
    
    
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && _scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}


-(void)initImageView:(NSArray *)imageArry{
    _imageArr = imageArry;
    for (int i = 0; i<18; i++) {
        UIImageView *view = imageArry[i];
        [_scrollView addSubview:view];
    }
    _login_type = 0;
   NSDictionary *MatchDict = [userDefaults objectForKey:@"MatchDict"];
    NSString *loctionStr = [MatchDict objectForKey:@"退出时记分位置"];
    if (!loctionStr) {
        loctionStr = @"1";
    }
    CGFloat locationX = ScreenWidth * ([loctionStr integerValue]-1);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [_scrollView setContentOffset:CGPointMake(locationX, 0) animated:NO];
    });

}
-(void)setMaxImageCount:(NSInteger)NumImage{
    _numImage = NumImage;
    [self initImageView];

    [self changeImageLeft:_numImage - 1 center:0 right:1];
}
-(void)initImageView{
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,0, 0)];
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,0, 0)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,0, 0)];
    centerImageView.userInteractionEnabled = YES;
//    [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewDidTap)]];
    
    [_scrollView addSubview:leftImageView];
    [_scrollView addSubview:centerImageView];
    [_scrollView addSubview:rightImageView];
    
    _leftImage = leftImageView;
    _centerImage = centerImageView;
    _rightImage = rightImageView;
}

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    _leftImage = _imageArr[LeftIndex];
    _centerImage = _imageArr[centerIndex];
    _rightImage = _imageArr[rightIndex];
//    [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
}


//点击事件
-(void)imageViewDidTap{
//    [self.netDelagate didSelectedNetImageAtIndex:_currentIndex];

}



#pragma mark - 滚动代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"13");
    _BeginScroll = NO;

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _BeginScroll = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeImageWithOffset:scrollView.contentOffset.x];

    CGFloat indexFloat = scrollView.contentOffset.x/ScreenWidth;

    
    NSInteger index = scrollView.contentOffset.x/ScreenWidth;
    if (indexFloat>17) {
        index+=1;
    }

    if (index>18) {
        index = index -17;
    }

    if (_login_type==0) {
        _login_type++;
    }else{
        if (!index) {
            index = 0;
        }
        _indexBlock(index);
    }

}

- (void)changeImageWithOffset:(CGFloat)offsetX
{
    
    int currentPostion = offsetX;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        if (offsetX > ScreenWidth * 17)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_BeginScroll) {
                    _BeginScroll = NO;
                    [_scrollView setContentOffset:CGPointMake(-ScreenWidth, 0) animated:NO];
                }
            });
            
            return;
        }
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        if (offsetX < 0)
        {
            if (_BeginScroll) {
                _BeginScroll = NO;
                [_scrollView setContentOffset:CGPointMake(ScreenWidth*18, 0) animated:NO];
            }
        }
    }
   

}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"1");

}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    NSLog(@"122");


}


-(void)scrollToIndex:(NSInteger)index{
    
    [_scrollView setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];
}


@end
