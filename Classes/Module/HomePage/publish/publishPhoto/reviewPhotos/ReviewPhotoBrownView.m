//
//  ReviewPhotoBrownView.m
//  podsGolvon
//
//  Created by suhuilong on 16/8/30.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "ReviewPhotoBrownView.h"
@interface ReviewPhotoBrownView ()<UIScrollViewDelegate>{

    CGFloat maxScale;
    CGFloat minScale;
    CGFloat zoomScaleFromInit;
    BOOL isBigScale;
    BOOL isNotFirst;
    UIImage *_imageViewImage;
}
@end

@implementation ReviewPhotoBrownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    @synchronized (self) {
        if (self) {
            self.delegate = self;
            self.minimumZoomScale = 1;
    
            self.showsHorizontalScrollIndicator = NO;
            self.showsVerticalScrollIndicator = NO;
            //添加图片
            self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.imageView setUserInteractionEnabled:YES];
            [self addSubview:self.imageView];
            
            //添加手势
            _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            [doubleTap setNumberOfTapsRequired:2];
            [_singleTap setNumberOfTapsRequired:1];
            
            [self addGestureRecognizer:_singleTap];
            [self addGestureRecognizer:doubleTap];
            [_singleTap requireGestureRecognizerToFail:doubleTap];//如果双击了，则不响应单击事件
            [self setZoomScale:1];
        }
    }
    return self;
}

//设置图片
-(void)setImage:(UIImage *)image{
    

    [self.imageView setImage:image];
    CGFloat Width = image.size.width;
    CGFloat Height = image.size.height;
    CGFloat scale = 1.0;
    self.maximumZoomScale = 4;
    if (Width/ScreenWidth == Height/ScreenHeight) {
        self.maximumZoomScale = 2;
        self.imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }else{
        
        if (Width>=ScreenWidth) {
            scale = ScreenWidth/Width;
            Width = image.size.width*scale;
            Height = image.size.height*scale;
            self.imageView.frame = CGRectMake(0, (ScreenHeight-Height)/2, ScreenWidth, Height);
        }else if (Height>=ScreenHeight) {
            if (scale>ScreenHeight/Height) {
                scale = ScreenHeight/Height;
                Width = image.size.width*scale;
                Height = image.size.height*scale;
                self.imageView.frame = CGRectMake((ScreenWidth-Width)/2, 0, Width, ScreenHeight);
            }
        }else {
            scale = ScreenWidth/Width;
            Width = image.size.width*scale;
            Height = image.size.height*scale;
            self.imageView.frame = CGRectMake(0, (ScreenHeight-Height)/2, ScreenWidth, Height);
        }
    }
}
//网络图片
-(void)setImageWithUrl:(NSString *)str{
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat Width = image.size.width;
        CGFloat Height = image.size.height;
        CGFloat scale = 1.0;
        self.maximumZoomScale = 4;
        if (Width/ScreenWidth == Height/ScreenHeight) {
            self.maximumZoomScale = 2;
            self.imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        }else{
            
            if (Width>=ScreenWidth) {
                scale = ScreenWidth/Width;
                Width = image.size.width*scale;
                Height = image.size.height*scale;
                self.imageView.frame = CGRectMake(0, (ScreenHeight-Height)/2, ScreenWidth, Height);
            }else if (Height>=ScreenHeight) {
                if (scale>ScreenHeight/Height) {
                    scale = ScreenHeight/Height;
                    Width = image.size.width*scale;
                    Height = image.size.height*scale;
                    self.imageView.frame = CGRectMake((ScreenWidth-Width)/2, 0, Width, ScreenHeight);
                }
            }else {
                scale = ScreenWidth/Width;
                Width = image.size.width*scale;
                Height = image.size.height*scale;
                self.imageView.frame = CGRectMake(0, (ScreenHeight-Height)/2, ScreenWidth, Height);
            }
        }

        
    }];
}

#pragma mark - UIScrollViewDelegate
//scroll view处理缩放和平移手势，必须需要实现委托下面两个方法,另外 maximumZoomScale和minimumZoomScale两个属性要不一样
//1.返回要缩放的图片
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
    return self.imageView;
}
//2.重新确定缩放完后的缩放倍数
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
    
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}


#pragma mark - 图片的点击，touch事件
//单击
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.numberOfTapsRequired == 1) {
        NSLog(@"11");
    }
}
//双击
-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.numberOfTapsRequired == 2) {

        if(self.zoomScale == 1){
            CGFloat newScale = [self setNewScale];
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [self zoomToRect:zoomRect animated:YES];
        }else{
            float newScale = [self zoomScale]/10;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [self zoomToRect:zoomRect animated:YES];
        }
    }
}

//根据原图片大小设置缩放系数
-(CGFloat)setNewScale{
    CGFloat Width = self.imageView.frame.size.width;
    CGFloat Height = self.imageView.frame.size.height;
    float newScale = 0.0;
    if (Width==ScreenWidth) {
        if (Height/ScreenHeight>0.8) {
        newScale = [self zoomScale] *2;
        }else{
        newScale = [self zoomScale] *ScreenHeight/Height;
        }
    }
    if (Height==ScreenHeight) {
        newScale = [self zoomScale] *ScreenWidth/Width;
    }
    if (Width==ScreenWidth&&Height==ScreenHeight) {
        newScale = 2.0f;
    }
    
    return newScale;
}

/**
 *  根据缩放系数返回缩放后的Frame
 *
 *  @param scale  缩放系数
 *  @param center 缩放中心
 *
 *  @return 缩放后的Frame
 */
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}



@end
