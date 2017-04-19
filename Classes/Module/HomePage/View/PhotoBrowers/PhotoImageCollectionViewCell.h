//
//  PhotoImageCollectionViewCell.h
//  IN_picture
//
//  Created by 李盼盼 on 16/10/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSDictionary *photoUrl;

@property (nonatomic, weak, readonly) UIImageView *photoImageView;

@property (copy, nonatomic) NSString *isChange;
@end
