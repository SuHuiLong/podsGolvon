//
//  SelectPoleView.h
//  Select
//
//  Created by shiyingdong on 16/8/9.
//  Copyright © 2016年 shiyingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPoleView : UIView
//数据源
@property(nonatomic,copy)NSDictionary  *dataDict;

typedef void(^scollIndex)(NSInteger);

@property (nonatomic,copy)scollIndex indexBlock;


-(instancetype)initWithFrame:(CGRect)frame dataDict:(NSDictionary *)dic;
@end
