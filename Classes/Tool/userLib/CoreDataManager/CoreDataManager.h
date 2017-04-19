//
//  CoreDataManager.h
//  CoreData
//
//  Created by Jone ji on 15/4/21.
//  Copyright (c) 2015年 Jone ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define ManagerObjectModelFileName @"CoreDataModel"

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *perStoreCoordinator;

+ (instancetype) sharedCoreDataManager;

- (void)saveContext;


/**
 *  增
 *
 *  @param fileName 文件名
 */
- (void)insertObjectWithFileName:(NSString *)fileName;
/**
 *  删
 *
 *  @param predicate <#predicate description#>
 */
- (void)removeObjectsWithPredicate:(NSString *)predicate;

/**
 *  查
 *
 *  @param name 查询的名称
 *
 *  @return 查询到的数组
 */
-(NSArray *)selectFrom:(NSString *)name;








@end
