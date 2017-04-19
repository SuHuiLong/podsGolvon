//
//  FansModel.h
//  Golvon
//
//  Created by 李盼盼 on 16/4/4.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FansModel : NSObject

@property (strong, nonatomic)NSString *headerImageName;
@property (strong, nonatomic)NSString *nickName;
@property (strong, nonatomic)NSString *signLabel;
@property (strong, nonatomic)NSString *nameid;

/**
 *  关注状态
 */
@property (strong, nonatomic)NSString *followState;
+(FansModel *)paresFromDictionary:(NSDictionary *)dic;
@end
