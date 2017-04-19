//
//  huiFuModel.h
//  Golvon
//
//  Created by 李盼盼 on 16/4/13.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface huiFuModel : NSObject


/** 1为专访评论，2为评论回复，3为朋友圈评论,4为朋友圈回复  * */
@property (copy, nonatomic) NSString    *type;

@property (copy, nonatomic) NSString    *time;

@property (copy, nonatomic) NSString    *avator;

@property (copy, nonatomic) NSString    *nickname;

@property (copy, nonatomic) NSString    *uid;

@property (copy, nonatomic) NSString    *content;

@property (copy, nonatomic) NSString    *cuvid;

@property (copy, nonatomic) NSString    *cid;


//type = 1或2时
@property (copy, nonatomic) NSString    *vid;
//type = 3或4时
@property (copy, nonatomic) NSString    *did;
//type =4 特有
@property (copy, nonatomic) NSString    *orgdcid;

@property (copy, nonatomic) NSString    *orgcontent;        //回复的内容


@end
