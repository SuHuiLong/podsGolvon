//
//  BeginCollectionViewCell.h
//  podsGolvon
//
//  Created by 李盼盼 on 16/11/1.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeginCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView      *imageView;

@property (strong, nonatomic) UILabel      *titleLabel;

@property (strong, nonatomic) UILabel      *contentLabel;


@property (strong, nonatomic) UIButton      *registBtn;

-(void)relayoutImageWithName:(NSString *)imageName andTitle:(NSString *)title andContent:(NSString *)content;

@end
