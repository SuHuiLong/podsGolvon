//
//  FriendsterModel.m
//  podsGolvon
//
//  Created by 李盼盼 on 16/8/30.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import "FriendsterModel.h"

@implementation FriendsterModel
// YY_Model_替换属性名
+(NSDictionary *)modelCustomPropertyMapper{
    return @{@"isclicked" : @"isclicked",
             @"isfocused" : @"isfocused"};
}


// YY_Model_指定NSArray中元素类型
+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"commets":DynamicMessageModel.class,
             @"clicks":LikeUsersModel.class,
             @"pics":PictureModel.class};
}
@end

