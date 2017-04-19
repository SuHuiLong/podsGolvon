//
//  Photo_CollectionViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/16.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Photo_CollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation Photo_CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.328, ScreenHeight * 0.184)];
    [_image setUserInteractionEnabled:YES];
    [self.contentView addSubview:_image];
}


-(void)relayoutWithModel:(PhotoModel *)model{

    [_image sd_setImageWithURL:[NSURL URLWithString:model.photoName] placeholderImage:[UIImage imageNamed:@"照片加载图片"]];
}

@end
