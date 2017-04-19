
//
//  ImageTableViewCell.m
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "Header.h"
#import "UIImageView+WebCache.h"

@interface ImageTableViewCell()

//@property (strong, nonatomic)LPPeriscommentView *periscommentView;

@end

@implementation ImageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _picture = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.765)];
    [self.contentView addSubview:_picture];
}



-(void)relayOutWithDictionary:(ImageModel *)model{
    [_picture sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:[UIImage imageNamed:@"长方形照片加载图片"]];
    _viewCount.text = [NSString stringWithFormat:@"%@",model.viewCount];
}
@end
