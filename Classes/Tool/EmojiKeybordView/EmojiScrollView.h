//
//  EmojiScrollView.h
//  EmojiDemo
//
//  Created by suhuilong on 16/9/13.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SlectIndex)(id);

@interface EmojiScrollView : UIView

//scrollView上展示的表情
@property(nonatomic, strong) UICollectionView *mainCollection;

//设置当前界面的表情图片
-(void)setContentViewWhith:(NSMutableArray *)imageArray;

@property(nonatomic,copy)SlectIndex SlectIndex;

@end
