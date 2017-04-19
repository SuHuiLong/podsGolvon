//
//  Self_photo_CollectionViewCell.m
//  Golvon
//
//  Created by 李盼盼 on 16/3/17.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "Self_photo_CollectionViewCell.h"

@implementation Self_photo_CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.328, ScreenHeight * 18.7)];
    [_image setUserInteractionEnabled:YES];
    [self.contentView addSubview:_image];
}
-(void)relayoutDataWithImageName:(NSString *)name{
    _image.image = [UIImage imageNamed:name];
}
@end
