//
//  ViewHistoryData+CoreDataProperties.h
//  podsGolvon
//
//  Created by suhuilong on 16/9/29.
//  Copyright © 2016年 suhuilong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ViewHistoryData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewHistoryData (CoreDataProperties)

@property (nullable, nonatomic, retain) id findListView;
@property (nullable, nonatomic, retain) id homeCollectionView;
@property (nullable, nonatomic, retain) id homeTableView;
@property (nullable, nonatomic, retain) id rankTableview;

@end

NS_ASSUME_NONNULL_END
