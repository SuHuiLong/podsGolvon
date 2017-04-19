//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>
//包含的View
@property (nonatomic, weak) UIView *sourceImagesContainerView;

@property (nonatomic, strong) UIImageView  *MatteView;
//选中照片的位置
@property (nonatomic, assign) NSInteger currentImageIndex;
//照片数量
@property (nonatomic, assign) NSInteger imageCount;
//需要展示的View在点击界面的位置
@property (nonatomic, assign) NSInteger addTager;


@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

- (void)show;

@end
