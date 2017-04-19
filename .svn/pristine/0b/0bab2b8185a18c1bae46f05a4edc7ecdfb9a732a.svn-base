
//
//  TotalPhotoCell.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/31.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "TotalPhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation TotalPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}


-(void)createView{
//照片
    _photoView = [Factory createImageViewWithFrame:CGRectMake(kWvertical(5.5), 0, kHvertical(53.5), kHvertical(53.5)) Image:[UIImage imageNamed:@"PublishCamera"]];
//名称
    _nameLabel = [Factory createLabelWithFrame:CGRectMake(kHvertical(53.5) + kWvertical(15), kHvertical(20), kWvertical(250), kHvertical(15)) textColor:BlackColor fontSize:kHorizontal(14.5) Title:@"相册胶卷  ( 890 )"];
    [self addSubview:_nameLabel];
//箭头
    UIImageView *arrowView = [Factory createImageViewWithFrame:CGRectMake(ScreenWidth - kWvertical(14), kHvertical(20), kWvertical(7), kHvertical(11.5)) Image:[UIImage imageNamed:@"PublishArrow"]];
    [self addSubview:arrowView];
//下划线
    UIView *line = [Factory createViewWithBackgroundColor:GPColor(223, 223, 223) frame:CGRectMake(0, kHvertical(53.5)-0.5, ScreenWidth - kWvertical(16), 0.5)];
    [self addSubview:line];
//照片背景
    UIView *photoBackView = [Factory createViewWithBackgroundColor:WhiteColor frame:CGRectMake(0, 0, kWvertical(5.5), kHvertical(53.5))];
    [self addSubview:photoBackView];
    [self addSubview:_photoView];

}


-(void)configModel:(TotalPhotoModel *)model{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    NSURL *url=[NSURL URLWithString:model.url];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
            _photoView.image=image;
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }
     ];
    NSString *libName = model.libName;
    NSString *totalNum = model.totalNum;
    _nameLabel.text = [NSString stringWithFormat:@"%@  (%@)",libName,totalNum];

}

@end
