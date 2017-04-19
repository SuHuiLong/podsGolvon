//
//  EmojiScrollView.m
//  EmojiDemo
//
//  Created by suhuilong on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "EmojiScrollView.h"
#import "EmojiCollectionViewCell.h"
@interface EmojiScrollView()<UICollectionViewDelegate, UICollectionViewDataSource>{

}
@property(nonatomic,strong)NSMutableArray  *dataArray;

@end
@implementation EmojiScrollView

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            [self createView];
        }
    }
    return self;
}

#pragma mark - View创建
-(void)createView{

    //添加图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.mainCollection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.mainCollection.alwaysBounceVertical = YES;
    self.mainCollection.backgroundColor = [UIColor clearColor];
    [self.mainCollection setScrollEnabled:NO];
    [self.mainCollection registerClass:[EmojiCollectionViewCell class] forCellWithReuseIdentifier:@"EmojiCollectionViewCell"];

    
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    [self addSubview:self.mainCollection];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.mainCollection.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}


-(void)setContentViewWhith:(NSMutableArray *)imageArray{
    _dataArray = imageArray;
    [_mainCollection reloadData];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger total = 24;
    total = _dataArray.count;
    return total;
}
//collectionDlegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiCollectionViewCell *cell = (EmojiCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCollectionViewCell" forIndexPath:indexPath];
    [cell config:_dataArray[indexPath.item]];
    cell.emojiLabel.font = [UIFont systemFontOfSize:kHorizontal(kHorizontal(27))];

//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCollectionViewCell" forIndexPath:indexPath];
//
//    
//    UILabel *emojiLabel = [[UILabel alloc] initWithFrame:cell.bounds];
//    emojiLabel.hidden = NO;
//    emojiLabel.textAlignment = NSTextAlignmentCenter;
//    emojiLabel.font = [UIFont systemFontOfSize:kHorizontal(kHorizontal(27))];
//    [cell addSubview:emojiLabel];
//    
//    UIImageView *deleatView = [[UIImageView alloc] init];
//    deleatView.frame = CGRectMake((ScreenWidth/8 - kWvertical(21))/2,(ScreenWidth/8 -  kHvertical(15))/2, kWvertical(21), kHvertical(15));
//    deleatView.hidden = YES;
//    [cell addSubview:deleatView];
//    
//    NSString *str = _dataArray[indexPath.item];
//    if ([str isEqualToString:@"EmojiDeleat"]) {
//        deleatView.hidden = NO;
//        emojiLabel.hidden = YES;
//        deleatView.image = [UIImage imageNamed:@"EmojiDeleat"];
//    }else{
//        deleatView.hidden = YES;
//        emojiLabel.hidden = NO;
//        [emojiLabel setText:str];
//        
//    }
//

    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((ScreenWidth-kWvertical(90))/8, (ScreenWidth-kWvertical(90))/8);
    return CGSizeMake(ScreenWidth/8, ScreenWidth/8);
}


//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake(kWvertical(17), kWvertical(14), kWvertical(14), kWvertical(14));
    return UIEdgeInsetsMake(0,0,0,0);

    
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
//    return kWvertical(4);
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
//    return kWvertical(10);
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.SlectIndex(_dataArray[indexPath.row]);
}


@end

