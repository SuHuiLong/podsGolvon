//
//  RecomInformModel.h
//  podsGolvon
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildRecomModel.h"
#import "RecomInteModel.h"

@interface RecomInformModel : NSObject

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *pic;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *addts;
@property (copy, nonatomic) NSString *clikenum;
@property (assign, nonatomic) BOOL likestatr;
@property (copy, nonatomic) NSString *readnum;

+(RecomInformModel *)modelAddDictionary:(NSDictionary *)dic;
@end

