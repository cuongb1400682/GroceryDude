//
//  AppDelegate.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/10/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "AppDelegate.h"
#import "Item+CoreDataProperties.h"
#import "Item+CoreDataClass.h"
//#import "Measurement+CoreDataClass.h"
//#import "Measurement+CoreDataProperties.h"
//#import "Amount+CoreDataClass.h"
//#import "Amount+CoreDataProperties.h"
#import "Unit+CoreDataClass.h"
#import "Unit+CoreDataProperties.h"

@implementation AppDelegate

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[self cdh] saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[self cdh] saveContext];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  
  [self cdh];
  [self demo];
}

- (CoreDataHelper *)cdh {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif

  if (!_coreDataHelper) {
    _coreDataHelper = [CoreDataHelper new];
    [_coreDataHelper setupCoreData];
  }
  
  return _coreDataHelper;
}

- (void)demo {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif

//  NSArray *newItemNames = [NSArray arrayWithObjects:@"Orange", @"Apple", @"Kiwi", @"Banana", @"Teapot", @"Toothbrush", @"Sticker", @"Magnet", @"Glue", nil];
//
//  for (NSString *itemName in newItemNames) {
//    Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
//                                                  inManagedObjectContext:_coreDataHelper.context];
//    newItem.name = itemName;
//    NSLog(@"Inserted new item for: %@", newItem.name);
//  }
  
//  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
//  [request setPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"name", @"a"]];
  
//  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
//                                                                 ascending:NO];
  
//  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name != %@", @"Teapot"];
  
//  [request setPredicate:predicate];
//  [request setSortDescriptors:@[sortDescriptor]];
  
//  NSArray *result = [[self.coreDataHelper context] executeFetchRequest:request
//                                                                 error:nil];
//
//  for (Item *item in result) {
//    NSLog(@"Fetch Object = %@", [item name]);
//  }
  
//  for (int i = 0; i < 50; i++) {
//    Measurement *newMeasurement = [NSEntityDescription insertNewObjectForEntityForName:@"Measurement"
//                                                                inManagedObjectContext:_coreDataHelper.context];
//
//    newMeasurement.abc = [NSString stringWithFormat:@"--->> LOST OF TEST DATA x%i", i];
//  }
//  [_coreDataHelper saveContext];
//
//  NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Measurement"];
//
//  NSArray *result = [_coreDataHelper.context executeFetchRequest:request error:nil];
//  for (Measurement *item in result) {
//    NSLog(@"%@", [item abc]);
//  }
  
//  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Amount"];
//  [request setFetchLimit:50];
//  NSError *error = nil;
//  NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request
//                                                                  error:&error];
//
//  if (error) {
//    NSLog(@"%@", [error description]);
//  } else {
//    for (Amount *amount in fetchedObjects) {
//      NSLog(@"Fetched Object = %@", [amount xyz]);
//    }
//  }
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
  [request setFetchLimit:50];
  NSError *error = nil;
  NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request
                                                                   error:&error];
  
  if (error) {
    NSLog(@"%@", [error description]);
  } else {
    for (Unit *unit in fetchedObjects) {
      NSLog(@"Fetched Objects = %@", [unit name]);
    }
  }
}

@end
