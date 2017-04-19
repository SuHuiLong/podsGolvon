//
//  PhotoImageCollectionViewCell.m
//  IN_picture
//
//  Created by 李盼盼 on 16/10/25.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "PhotoImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface PhotoImageCollectionViewCell ()

@end

@implementation PhotoImageCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self loadViews];
    }
    return self;
}
-(NSString *)isChange{
    if (!_isChange) {
        _isChange = [[NSString alloc] init];
    }
    return _isChange;
}
-(void)loadViews{
    UIImageView *photoImage = [[UIImageView alloc] init];
    photoImage.layer.masksToBounds = YES;
    photoImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:photoImage];
    _photoImageView = photoImage;
}

-(void)setPhotoUrl:(NSDictionary *)photoUrl{
    [_photoImageView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photoUrl[@"url"]]] placeholderImage:[UIImage imageNamed:@"动态等待图"]];
}
@end
