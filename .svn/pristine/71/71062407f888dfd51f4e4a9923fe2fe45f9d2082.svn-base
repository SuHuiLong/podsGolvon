//
//  PhotoViewController.m
//  Golvon
//
//  Created by pk on 16/4/7.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "PhotoModel.h"
//#import "SelfPhotoModel.h"

@interface PhotoViewController (){
    NSInteger _selectIndex;
    NSArray* _dataArray;
    UIScrollView* _scrollView;
    NSArray *_dataDicArry;
    NSString *_type;
}

@end

@implementation PhotoViewController

- (instancetype)initWithArray:(NSArray *)array index:(NSInteger)index{
    if (self = [super init]) {
        _selectIndex = index;
        _dataArray = array;
    }
    return self;
}

- (instancetype)initWithDictArry:(NSArray *)arry index:(NSInteger)index Addtype:(NSString *)type{
    if (self = [super init]) {
        _selectIndex = index;
        _dataArray = arry;
        _type = type;
    }
    return self;
}

- (void)makeView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 300)];
    _scrollView.contentSize = CGSizeMake(ScreenWidth * _dataArray.count, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(ScreenWidth * _selectIndex, 0);
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < _dataArray.count; i++){
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, _scrollView.frame.size.height)];
        if (_type) {
            NSDictionary *selfDict = _dataArray[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[selfDict objectForKey:@"picture_url"]]];
        }else{
        PhotoModel* model = _dataArray[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.photoName]];

        }
        [_scrollView addSubview:imageView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    self.view.backgroundColor = [UIColor blackColor];
    [self makeView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}


@end
