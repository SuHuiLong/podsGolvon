//
//  ViewModel.h
//  ZhuanFang
//
//  Created by 李盼盼 on 16/4/6.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject

@property (strong, nonatomic) NSString *headerImage;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *timeLabel;
@property (strong, nonatomic) NSString *state;


+(ViewModel *)pareWithDictionary:(NSDictionary *)dic;

@end
