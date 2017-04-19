//
//  Self_Photo_TableViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/17.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_Photo_TableViewCell.h"
#import "Self_photo_CollectionViewCell.h"
@interface Self_Photo_TableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation Self_Photo_TableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
        
    }
    return self;
}

-(void)createUI{
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.itemSize = CGSizeMake(ScreenWidth * 0.328, ScreenHeight * 0.187);
    _layout.minimumLineSpacing = ScreenWidth * 0.008;
    
    _imageCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.187) collectionViewLayout:_layout];
    [_imageCollection registerClass:[Self_photo_CollectionViewCell class] forCellWithReuseIdentifier:@"Self_photo_CollectionViewCell"];
    _imageCollection.backgroundColor = [UIColor whiteColor];
    _imageCollection.showsHorizontalScrollIndicator = NO;
    _imageCollection.showsVerticalScrollIndicator = NO;
    _imageCollection.bounces = NO;
    _imageCollection.dataSource = self;
    _imageCollection.delegate = self;
    [self.contentView addSubview:_imageCollection];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViewData:) name:@"UploadPhotoArry" object:nil];
    
}

-(void)reloadViewData:(NSNotification *)data{
    [_imageCollection reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.PhotoArr.count>2) {
        return 3;
    }else{
        return self.PhotoArr.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Self_photo_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Self_photo_CollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    if (indexPath.row == 0) {
        itemImage.image = [UIImage imageNamed:@"UploadPhoto1"];
    }else{
        [itemImage sd_setImageWithURL:self.PhotoArr[indexPath.row-1] placeholderImage:[UIImage imageNamed:@"headerDefault_S"]];

    }
    [cell.contentView addSubview:itemImage];
    return cell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(ScreenHeight * 0.006, 0, 0, 0 );
}



@end
