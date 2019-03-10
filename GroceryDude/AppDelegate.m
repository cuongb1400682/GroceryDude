//
//  AppDelegate.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/10/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[self cdh] saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[self cdh] saveContext];
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

@end
