//
//  PhotoBrowLayoutout.m
//  IN_picture
//
//  Created by 李盼盼 on 16/10/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "PhotoBrowLayoutout.h"

@interface PhotoBrowLayoutout ()

@end

@implementation PhotoBrowLayoutout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numberOfCellsInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            UICollectionViewLayoutAttributes *attributes;
            
            if ([self.photoBrowserLayoutDelegate respondsToSelector:@selector(photoBrowerLayout:andAttributesForItemAtIndexPath:andNumberOfCellsInsection:)]) {
                attributes = [self.photoBrowserLayoutDelegate photoBrowerLayout:self andAttributesForItemAtIndexPath:indexPath andNumberOfCellsInsection:numberOfCellsInSection];
                
                if (CGRectIntersectsRect(rect, attributes.frame)) {
                    [attributesArray addObject:attributes];
                }
            }
            
        }
    }
    return  attributesArray;
}

@end
