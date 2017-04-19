//
//  DownLoadDataSource.h
//
//  Created by 李盼盼 on 15/11/10.
//  Copyright (c) 2015年 lipan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;
typedef void(^Complicate)(BOOL success , id data);

//起别名
typedef NSString *  MYString;

@interface DownLoadDataSource : NSObject

@property(nonatomic,strong)AFHTTPSessionManager * manager;

-(void)downloadWithUrl:(MYString)urlStr parameters:(NSDictionary *)dic complicate:(Complicate) complicate;



@end
