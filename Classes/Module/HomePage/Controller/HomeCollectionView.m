//
//  HomeCollectionView.m
//  podsGolvon
//
//  Created by suhuilong on 16/9/26.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "HomeCollectionView.h"
#import "CollectionCardModel.h"
#import "HomePageScrollViewCell.h"
@interface HomeCollectionView()<UIScrollViewDelegate>{
    CGFloat rateDistance;
    NSMutableArray *_imagetViewArr;
    CGFloat moverate;
    NSMutableArray *ImageXarr;
}

@end

@implementation HomeCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        rateDistance = 500;
        _imagetViewArr = [[NSMutableArray alloc]init];
        self.delegate = self;
        
        
    }
    return self;
}
-(void)setImagetViewArr:(NSMutableArray *)imageArray
{
    _imagetViewArr = imageArray;
    [self creatMainview];
}

-(void)creatMainview
{
    self.contentSize = CGSizeMake(self.frame.size.width * _imagetViewArr.count, self.frame.size.height);
    moverate = 0;

    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self SetImagerView];
    
}


-(void)SetImagerView
{
    ImageXarr = [[NSMutableArray alloc]init];
    
    int ii = (int)_imagetViewArr.count;
    for (int i = 0 ; i < ii; i++) {
        HomePageScrollViewCell * imageView = [[HomePageScrollViewCell alloc]initWithFrame:CGRectMake(self.frame.size.width / _imagetViewArr.count * i , HScale(2.2), kWvertical(197) , kHvertical(259))];
        imageView.center = CGPointMake((self.frame.size.width*0.54)/2 * (2 * i + 1.67) + (self.frame.size.width*0.03)/2 * (2  + 1.67), self.frame.size.height/2.0);
        //设置背景
        CALayer * layer = [imageView layer];
        layer.shadowColor = [[UIColor blackColor]CGColor];
        layer.shadowOffset = CGSizeMake(10, 5);
        layer.shadowRadius = 10;
        layer.shadowOpacity = 0.5;
        imageView.backgroundColor = [UIColor whiteColor];
        CollectionCardModel *model = _imagetViewArr[i];
        [imageView relayoutWithModel:model];
        imageView.tag = i + 100;
        [self addSubview:imageView];
    };
    self.contentOffset = CGPointMake(self.frame.size.width, 0);

    [self scrollViewDidScroll:self];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat rate;
    CGFloat reduce;
    
    reduce = moverate - scrollView.contentOffset.x;
    //NSLog(@"%f",reduce);
    for (int i = 0 ; i < _imagetViewArr.count; i++) {
        UIView * view = [self viewWithTag:100 + i];
        CGFloat distance = fabs(scrollView.contentOffset.x + self.frame.size.width/2  - view.center.x);
        CGFloat ratex = view.center.x - reduce * 0.46;
        
        view.center = CGPointMake(ratex,view.center.y);
        
        if (distance >= rateDistance)
            rate = 0.8;
        else
            rate =  (rateDistance - distance*0.2) / (rateDistance ) ;
        
        view.transform = CGAffineTransformMakeScale(rate, rate);
    }
    moverate = scrollView.contentOffset.x;
    
}
@end
