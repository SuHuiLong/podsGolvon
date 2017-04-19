//
//  Fans_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/14.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Fans_TableViewCell.h"
#import "Fans_CollectionViewCell.h"
#import "DownLoadDataSource.h"
//#import "DetailView.h"


@interface Fans_TableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation Fans_TableViewCell



- (instancetype)initWithNameID:(NSString *)nameID longInType:(NSString *)longInType{
    if (self = [super init]) {

        [self createUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}




-(void)createUI{
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.itemSize = CGSizeMake(ScreenWidth * 0.341, ScreenHeight * 0.312);
    _layout.minimumInteritemSpacing = ScreenHeight * 0.015;
    _layout.minimumLineSpacing = ScreenHeight * 0.015;
    
    _fansView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.349) collectionViewLayout:_layout];
    _fansView.backgroundColor = [UIColor whiteColor];
    [_fansView registerClass:[Fans_CollectionViewCell class] forCellWithReuseIdentifier:@"Fans_CollectionViewCell"];
    _fansView.showsHorizontalScrollIndicator = NO;
    _fansView.showsVerticalScrollIndicator = NO;
    _fansView.dataSource = self;
    _fansView.delegate = self;
    
    [self.contentView addSubview:_fansView];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _fansData.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Fans_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Fans_CollectionViewCell" forIndexPath:indexPath];
    
    //  cell阴影
    cell.layer.cornerRadius = 3;
    cell.contentView.layer.cornerRadius = 3.0f;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.layer.shadowColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowRadius =2.5f;
    cell.layer.shadowOpacity = 0.5;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    [cell realodDataWith:_fansData[indexPath.row]];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(HScale(1.8), WScale(3.2), ScreenHeight * 0.019,0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

   
}

@end
