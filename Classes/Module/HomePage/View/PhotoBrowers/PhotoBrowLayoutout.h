//
//  PhotoBrowLayoutout.h
//  IN_picture
//
//  Created by 李盼盼 on 16/10/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoBrowLayoutout;
@protocol PhotoBrowerDeleagte <NSObject>

-(UICollectionViewLayoutAttributes *)photoBrowerLayout:(PhotoBrowLayoutout *)layout andAttributesForItemAtIndexPath:(NSIndexPath *)indexPath andNumberOfCellsInsection:(NSInteger)numberofCellsInsection;

@end

@interface PhotoBrowLayoutout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<PhotoBrowerDeleagte> photoBrowserLayoutDelegate;

@end
