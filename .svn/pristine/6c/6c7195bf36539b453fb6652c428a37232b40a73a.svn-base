//
//  Photo_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/14.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Photo_TableViewCell.h"
#import "Photo_CollectionViewCell.h"
#import "DownLoadDataSource.h"
#import "PhotoViewController.h"
#import "Self_P_ViewController.h"

@interface Photo_TableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) DownLoadDataSource *loadData;

@end

@implementation Photo_TableViewCell
-(DownLoadDataSource *)loadData{
    if (!_loadData) {
        _loadData = [[DownLoadDataSource alloc]init];
    }
    return _loadData;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        
        [self createUI];
        
    }
    return self;
}

- (instancetype)initWithNameID:(NSString *)nameID{
    if (self = [super init]) {
        self.nameID = nameID;
//        [self downLoad];
        [self createUI];
        
    }
    return self;
}

-(void)downLoad{
    NSDictionary *dict = @{
                           @"name_id":_nameID
                           };
    
    [self.loadData downloadWithUrl:[NSString stringWithFormat:@"%@Golvon/select_picture_all_user",urlHeader120] parameters:dict complicate:^(BOOL success, id data) {
        if (success) {
            NSDictionary *dic = data;
            for (NSDictionary *temp in dic[@"data"]) {
                PhotoModel *model = [PhotoModel pareFromDictionary:temp];

                [self.dataArr insertObject:model atIndex:0];
                //                [self.dataArr addObject:model];
            }
            [_imageCollection reloadData];
        }
    }];
}
-(void)createUI{
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.itemSize = CGSizeMake(ScreenWidth * 0.328, ScreenHeight * 0.184);
    _layout.minimumLineSpacing = 3;
    _layout.minimumInteritemSpacing = 0;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    _layout.
    _imageCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,ScreenHeight * 0.006, ScreenWidth, ScreenHeight * 0.187) collectionViewLayout:_layout];
    [_imageCollection registerClass:[Photo_CollectionViewCell class] forCellWithReuseIdentifier:@"Photo_CollectionViewCell"];
    _imageCollection.backgroundColor = [UIColor whiteColor];
    _imageCollection.showsHorizontalScrollIndicator = NO;
    _imageCollection.showsVerticalScrollIndicator = NO;
    _imageCollection.bounces = NO;
    _imageCollection.dataSource = self;
    _imageCollection.delegate = self;
    [self.contentView addSubview:_imageCollection];
    
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    [more setTitle:@"更多照片 >" forState:UIControlStateNormal];
    [more addTarget:self action:@selector(clickAllPhoto) forControlEvents:UIControlEventTouchUpInside];
    [more setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    more.frame = CGRectMake(0, HScale(18.7), ScreenWidth, ScreenHeight * 0.055);
    more.titleLabel.font = [UIFont systemFontOfSize:kHorizontal(13)];
    [self.contentView addSubview:more];
    
    
}
-(void)clickAllPhoto{
    Self_P_ViewController *photo = [[Self_P_ViewController alloc]initWithNameID:self.nameID];
    
    [self.fatherVC presentViewController:photo animated:NO completion:^{
        
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataArr.count>3) {
        return 3;
    }else{
        return _dataArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Photo_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Photo_CollectionViewCell" forIndexPath:indexPath];
    [cell relayoutWithModel:_dataArr[indexPath.row]];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(HScale(0.2), 0, 0, 0);
    
}


@end
