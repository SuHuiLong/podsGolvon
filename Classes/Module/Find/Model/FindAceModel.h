//
//  FindAceModel.h
//  Golvon
//
//  Created by 李盼盼 on 16/6/23.
//  Copyright © 2016年 苏辉龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindAceModel : NSObject
@property (strong, nonatomic) NSString      *aceTime;       //专访时间
@property (strong, nonatomic) NSString      *commentNum;    //评论数
@property (strong, nonatomic) NSString      *likeNum;       //点赞数
@property (strong, nonatomic) NSString      *grongImage;    //照片
@property (strong, nonatomic) NSString      *interViewerID; //专访者ID
@property (strong, nonatomic) NSString      *interViewID;   //专访ID
@property (strong, nonatomic) NSString      *describeLabel; //描述
/**
 *  专访者的名字
 */
@property (strong, nonatomic) NSString      *nickname;           //专访者的名字
/**
 *  访问量
 */
@property (strong, nonatomic) NSString      *red_number;
@property (strong, nonatomic) NSString      *htmlStr;


+(FindAceModel *)pareFromWithDictionary:(NSDictionary *)dic;
@end
