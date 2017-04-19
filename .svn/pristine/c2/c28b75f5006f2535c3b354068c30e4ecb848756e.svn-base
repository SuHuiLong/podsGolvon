
//
//  PublishCollectionViewCell.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "PublishCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PublishCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            [self createView];
        }
    }
    return self;
}

-(void)createView{
    //图片
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:_imageView];
    //选中按钮
    _selectBtn = [Factory createButtonWithFrame:CGRectMake(self.contentView.width-kWvertical(27), kHvertical(6), kWvertical(21), kWvertical(21)) NormalImage:@"PublishAlbumsNormal" SelectedImage:@"PublishAlbumsSelect" target:self selector:nil];
    _selectBtn.selected = NO;
    _selectBtn.hidden = YES;
    [self.contentView addSubview:_selectBtn];
    //删除图标
    _deleatBtn = [Factory createButtonWithFrame:CGRectMake(self.contentView.frame.size.width-kWvertical(15), -6, kWvertical(21), kWvertical(21)) NormalImage:@"PublishPhotoDeleat" SelectedImage:@"" target:self selector:nil];
    _deleatBtn.hidden = YES;
    [self.contentView addSubview:_deleatBtn];
}


-(void)configName:(id)model{
    _deleatBtn.hidden = YES;
    if ([model isKindOfClass:[NSData class]]) {
        _deleatBtn.hidden = NO;
        [_imageView setImage:[UIImage imageWithData:model]];
    } else if ([model isEqualToString:@"PublishAdd"]) {
        [_imageView setImage:[UIImage imageNamed:model]];
    }else{
    _deleatBtn.hidden = NO;
    NSString *str = model;
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    NSURL *url=[NSURL URLWithString:str];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
        UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
        _imageView.image=image;
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }
     ];
    }
}

-(void)configImage:(id)model{
    _selectBtn.hidden = YES;
    if ([model isKindOfClass:[NSString class]]) {
        [_imageView setImage:[UIImage imageNamed:model]];
    }else{
        _selectBtn.selected = NO;
        _selectBtn.hidden = NO;
        
        TotalPhotoModel *Model = model;
        NSString *str = Model.url;
        BOOL isSelect = Model.isSelect;
        if (isSelect) {
            _selectBtn.selected = YES;
        }
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        NSURL *url=[NSURL URLWithString:str];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
            _imageView.image=image;
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }
       ];
    }
}


-(void)setSelectIndex{
        _selectBtn.selected = YES;
}


@end
