//
//  CoreDataManager.m
//  CoreData
//
//  Created by Jone ji on 15/4/21.
//  Copyright (c) 2015年 Jone ji. All rights reserved.
//

#import "CoreDataManager.h"

#import "ViewHistoryData.h"


@implementation CoreDataManager

@synthesize managedObjContext = _managedObjContext;
@synthesize managedObjModel = _managedObjModel;
@synthesize perStoreCoordinator = _perStoreCoordinator;

static CoreDataManager *coredataManager;

+ (instancetype) sharedCoreDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coredataManager = [[self alloc] init];
    });
    return coredataManager;
}

//被管理的对象模型
- (NSManagedObjectModel *)managedObjModel
{
    if (_managedObjModel != nil) {
        return _managedObjModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ManagerObjectModelFileName withExtension:@"momd"];
    _managedObjModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjModel;
}

//被管理的上下文:操作实际内容
-(NSManagedObjectContext *)managedObjContext
{
    if (_managedObjContext != nil) {
        return _managedObjContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self perStoreCoordinator];
    if (coordinator != nil) {
        _managedObjContext = [[NSManagedObjectContext alloc] init];
        [_managedObjContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjContext;
}

//持久化存储助理:相当于数据库的连接器
-(NSPersistentStoreCoordinator *)perStoreCoordinator
{
//    if (_perStoreCoordinator != nil) {
//        return _perStoreCoordinator;
//    }
//    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",ManagerObjectModelFileName]];
//    
//    NSLog(@"path = %@",storeURL.path);
//    NSError *error = nil;
//    _perStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjModel]];
//    if (![_perStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
//    {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = @"There was an error creating or loading the application's saved data.";
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"your error domain" code:999 userInfo:dict];
//        
//        NSLog(@"error: %@,%@",error,[error userInfo]);
//        abort();
//    }
//    return _perStoreCoordinator;
//    
    
    
    
    
    NSError *error = nil;
    if (_perStoreCoordinator != nil) {
        return _perStoreCoordinator;
    }
    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",ManagerObjectModelFileName]];

    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _perStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjModel]];
    if (![_perStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle error
    }
    
    return _perStoreCoordinator;

}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//保存数据
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


//删
- (void)removeObjectsWithPredicate:(NSString *)predicate

{
    predicate = @"homeTableView";
    // 1. 实例化查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ManagerObjectModelFileName];
    // 2. 设置谓词条件
    request.predicate = [NSPredicate predicateWithFormat:predicate];
    // 3. 由上下文查询数据
    NSArray *result = [self.managedObjContext executeFetchRequest:request error:nil];
    // 4. 输出结果
    for (ViewHistoryData *ViewData in result) {
        // 删除一条记录
        [self.managedObjContext deleteObject:ViewData];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:ViewData.homeTableView];
    }
    if ([self.managedObjContext save:nil]) {
        NSLog(@"删除%lu文件成功",(unsigned long)[result count]);
    } else {
        NSLog(@"删除失败");
    }
}

//查
-(NSArray *)selectFrom:(NSString *)name{

    NSError *error = nil;
    //    创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ViewHistoryData" inManagedObjectContext:self.managedObjContext];
    //    设置请求实体
    [request setEntity:entity];
//    //    指定对结果的排序方式
//        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"HomeCollectionView" ascending:NO];
//        NSArray *sortDescriptions = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//        [request setSortDescriptors:sortDescriptions];
    //    执行获取数据请求，返回数组
    NSArray *fetchResult = [self.managedObjContext executeFetchRequest:request error:&error];
    if (!fetchResult)
    {
        NSLog(@"保存失败error:%@,%@",error,[error userInfo]);
    }else{
        NSLog(@"保存失败");
    }
    return fetchResult;
}
//改
- (void)editObjectsWithPredicate:(NSPredicate *)predicate withState:(NSNumber *)state

{
    // 1. 实例化一个查询(Fetch)请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ManagerObjectModelFileName];
    // 2. 条件查询，通过谓词来实现的
    
    request.predicate = predicate;
    
    // 在谓词中CONTAINS类似于数据库的 LIKE '%王%'
    
    //    request.predicate = [NSPredicate predicateWithFormat:@"phoneNo CONTAINS '1'"];
    
    // 如果要通过key path查询字段，需要使用%K
    
    //    request.predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS '1'", @"phoneNo"];
    
    // 直接查询字表中的条件
    // 3. 让_context执行查询数据
    NSArray *array = [self.managedObjContext executeFetchRequest:request error:nil];
        for (ViewHistoryData *pdf in array) {
            // 3.1修改公文阅读状态
            pdf.homeTableView = nil;
            pdf.homeCollectionView = nil;
            pdf.rankTableview = nil;
            pdf.findListView = nil;
//            pdf. = state;
//            // 3.2修改公文最新打开日期
//            NSFileManager* fileMngr = [NSFileManager defaultManager];
//            NSDictionary* attributes = [fileMngr attributesOfItemAtPath:pdf.fileURL error:nil];
//            pdf.lastOpen = (NSDate *)[attributes objectForKey:NSFileModificationDate];
//            // 3.3获取并保存，该文件的首页缩略图
//            UIImage *thumbImage = [pdf imageFromPDFWithDocumentRef:pdf.fileURL];
//            pdf.thumbImage = UIImagePNGRepresentation(thumbImage);
            break;
        }
    // 4. 通知_context修改数据是否成功
    if ([self.managedObjContext save:nil]) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
}

//改
//    for (ReaderDocument *pdf in array) {
//        // 3.1修改公文阅读状态
//        pdf.fileTag = state;
//        // 3.2修改公文最新打开日期
//        NSFileManager* fileMngr = [NSFileManager defaultManager];
//        NSDictionary* attributes = [fileMngr attributesOfItemAtPath:pdf.fileURL error:nil];
//        pdf.lastOpen = (NSDate *)[attributes objectForKey:NSFileModificationDate];
//        // 3.3获取并保存，该文件的首页缩略图
//        UIImage *thumbImage = [pdf imageFromPDFWithDocumentRef:pdf.fileURL];
//        pdf.thumbImage = UIImagePNGRepresentation(thumbImage);
//        break;
//    }


@end
