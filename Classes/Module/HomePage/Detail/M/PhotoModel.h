//
//  PhotoModel.h
//  Golvon
//
//  Created by 李盼盼 on 16/4/4.
//  Copyright © 2016年 李盼盼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property (strong, nonatomic) NSString *photoName;
@property (strong, nonatomic) NSString *name_id;

@property (strong, nonatomic) NSString *photoNametO;
@property (strong, nonatomic) NSString *name_idO;

@property (strong, nonatomic) NSString *photoNameT;
@property (strong, nonatomic) NSString *name_idT;

+(PhotoModel *)pareFromDictionary:(NSDictionary *)dic;
@end
