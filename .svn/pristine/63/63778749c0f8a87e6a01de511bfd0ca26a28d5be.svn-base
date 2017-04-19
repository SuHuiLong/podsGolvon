//
//  ScrollView.h
//  Golvon
//
//  Created by 李盼盼 on 16/3/30.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 遵循该代理就可以监控到网络滚动视图的index*/

@protocol WYScrollViewNetDelegate <NSObject>

@optional

/** 点中网络滚动视图后触发*/
-(void)didSelectedNetImageAtIndex:(NSInteger)index;

@end

/** 遵循该代理就可以监控到本地滚动视图的index*/

@protocol WYScrollViewLocalDelegate <NSObject>

@optional

/** 点中本地滚动视图后触发*/
-(void)didSelectedLocalImageAtIndex:(NSInteger)index;

@end

typedef void(^scollIndex)(NSInteger);

@interface CardScrollView : UIView

/** 选中网络图片的索引*/
@property (nonatomic, strong) id <WYScrollViewNetDelegate> netDelagate;

/** 选中本地图片的索引*/
@property (nonatomic, strong) id <WYScrollViewLocalDelegate> localDelagate;

/** 占位图*/
@property (nonatomic, strong) UIImage *placeholderImage;



/**
 *  加载网络图片
 */
- (instancetype) initWithFrame:(CGRect)frame WithImagesArry:(NSArray *)imageArray;


-(void)scrollToIndex:(NSInteger)index;


@property (nonatomic,copy)scollIndex indexBlock;

@end
