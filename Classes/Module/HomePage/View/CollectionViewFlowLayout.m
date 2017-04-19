//
//  CollectionViewFlowLayout.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/9/9.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(kWvertical(197), kHvertical(259));
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = kWvertical(14);
    }
    return self;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
//    CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height * 0.5;
    
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attr in array) {
        // 获取每个cell的中心点的x值
        CGFloat cell_centerX = attr.center.x;
        
        // 计算这两个中心点的x值的偏移（距离）
        CGFloat distance = ABS(cell_centerX - centerX);
        
        // 缩放系数
        CGFloat factor = 0.0005;
        
        // 记录缩放比
        CGFloat scale = 1 / (1 + distance * factor);
        
        attr.size = CGSizeMake(self.itemSize.width, self.itemSize.height * 1);
        
        attr.transform = CGAffineTransformMakeScale(scale, scale);

    }
    return array;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
