//
//  TotalPhotoModel.h
//  podsGolvon
//
//  Created by suhuilong on 16/8/31.
//  Copyright © 2016年 suhuilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TotalPhotoModel : NSObject
@property(nonatomic,copy)NSString  *libName;  //当前分组名
@property(nonatomic,copy)NSString  *totalNum;//图片总数
@property(nonatomic,assign)BOOL     isSelect;//图片是否被选中
@property(nonatomic,copy)NSString  *indexStr;//图片位置
@property(nonatomic,copy)NSData   *imageData;//拍摄图片
@property(nonatomic,copy)NSDictionary  *url;//包含缩略图和大图的数据


@property(nonatomic,copy)UIImage *headerImage;//分组照片


@end
