//
//  RecomInteModel.h
//  podsGolvon
//
//  Created by apple on 2016/12/27.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecomInteModel : NSObject

@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *pic;
@property (copy, nonatomic) NSString *readnum;
@property (copy, nonatomic) NSString *vid;
@property (copy, nonatomic) NSString *clikenum;
@property (assign, nonatomic) BOOL likestatr;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *title;

+(RecomInteModel *)modelAddDictionary:(NSDictionary *)dic;
@end
