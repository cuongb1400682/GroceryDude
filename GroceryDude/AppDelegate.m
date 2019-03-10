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
  
  NSArray *newItemNames = [NSArray arrayWithObjects:@"Orange", @"Apple", @"Kiwi", @"Banana", @"Teapot", @"Toothbrush", @"Sticker", @"Magnet", @"Glue", nil];
  
  for (NSString *itemName in newItemNames) {
    Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                  inManagedObjectContext:_coreDataHelper.context];
    newItem.name = itemName;
    NSLog(@"Inserted new item for: %@", newItem.name);
  }
}

@end
