//
//  CoreDataHelper.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/10/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MigrationVC.h";

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel * model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore *store;
@property (nonatomic, retain) MigrationVC *migrationVC;

- (void)setupCoreData;
- (void)saveContext;

@end

NS_ASSUME_NONNULL_END
