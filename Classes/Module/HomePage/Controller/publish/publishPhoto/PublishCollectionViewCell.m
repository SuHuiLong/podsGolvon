
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
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:_imageView];
    
    _selectBtn = [Factory createButtonWithFrame:CGRectMake(self.contentView.width-kWvertical(20), kHvertical(2.5), kWvertical(16), kWvertical(16)) NormalImage:@"PublishAlbumsNormal" SelectedImage:@"PublishAlbumsSelect" target:self selector:nil];
    _selectBtn.selected = NO;
    _selectBtn.hidden = YES;
    [self.contentView addSubview:_selectBtn];
}


-(void)configName:(NSString *)str{
    [_imageView setImage:[UIImage imageNamed:str]];
}

-(void)configImage:(id)model{
    _selectBtn.hidden = YES;
    if ([model isKindOfClass:[NSString class]]) {
        [_imageView setImage:[UIImage imageNamed:model]];
    }else{
        TotalPhotoModel *Model = model;
        NSString *str = Model.url;
        _selectBtn.selected = NO;
        _selectBtn.hidden = NO;
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
