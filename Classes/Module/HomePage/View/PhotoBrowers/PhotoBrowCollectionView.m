//
//  PhotoBrowCollectionView.m
//  IN_picture
//
//  Created by 李盼盼 on 16/10/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "PhotoBrowCollectionView.h"
#import "PhotoBrowLayoutout.h"
#import "PhotoImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "PhotoBrowerLayoutModel.h"
#import "PhotoBrower.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

static NSString *const photoBrowsercellID = @"cellID";
@interface PhotoBrowCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,PhotoBrowerDeleagte>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) PhotoBrowLayoutout *layout;

@property (strong, nonatomic) NSMutableArray *photosArr;

@end

@implementation PhotoBrowCollectionView

-(instancetype)init{
    if (self = [super init]) {
        
        [self setSubviews];
    }
    return self;
}
-(void)setSubviews{
    PhotoBrowLayoutout *layout = [[PhotoBrowLayoutout alloc] init];
    self.layout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView registerClass:[PhotoImageCollectionViewCell class] forCellWithReuseIdentifier:photoBrowsercellID];
    
}
-(void)setLayoutModel:(PhotoBrowerLayoutModel *)layoutModel{
    _layoutModel = layoutModel;
    
    [self.layout setPhotoBrowserLayoutDelegate:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    self.frame = CGRectMake(layoutModel.origin.x, layoutModel.origin.y, layoutModel.contentWidth, layoutModel.contentHeight);
    
    [self.collectionView reloadData];
    [self.collectionView setFrame:CGRectMake(0, 0, layoutModel.contentWidth, layoutModel.contentHeight)];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return YES;
}
#pragma mark ---- 代理
-(UICollectionViewLayoutAttributes *)photoBrowerLayout:(PhotoBrowLayoutout *)layout andAttributesForItemAtIndexPath:(NSIndexPath *)indexPath andNumberOfCellsInsection:(NSInteger)numberofCellsInsection{
    
    UICollectionViewLayoutAttributes *attributes = [self.layoutModel layoutAttributesForItemAtIndexPath:indexPath andNumberOfCellsInSection:numberofCellsInsection];
    
    return attributes;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _layoutModel.photoUrlsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoBrowsercellID forIndexPath:indexPath];
    cell.photoUrl =self.layoutModel.photoUrlsArray[indexPath.row];
    cell.photoImageView.tag = indexPath.row + 100;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<self.layoutModel.photoUrlsArray.count; i++) {
        if (!self.layoutModel.photoUrlsArray[i][@"orgurl"]) {
            [arr addObject:self.layoutModel.photoUrlsArray[i][@"url"]];
        }else{
            [arr addObject:self.layoutModel.photoUrlsArray[i][@"orgurl"]];

        }
    }
    
    NSInteger count = arr.count;
    NSMutableArray *photoArrs = [NSMutableArray arrayWithCapacity:count];
    
    
    for (int i = 0; i<count; i++) {
        
        NSIndexPath *imageIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        PhotoImageCollectionViewCell *cell = (PhotoImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:imageIndexPath];
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        mjphoto.srcImageView = cell.photoImageView;
        mjphoto.url = [NSURL URLWithString:arr[i]];
        [photoArrs addObject:mjphoto];

    }
    
    
    //2、显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.item;
    browser.photos = photoArrs;
    browser.collection = self.collectionView;
    [browser show];
    
    
}

@end
