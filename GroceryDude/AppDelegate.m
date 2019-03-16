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
#import "LocationAtHome+CoreDataProperties.h"
#import "LocationAtShop+CoreDataProperties.h"

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
  //[self demo];
}

- (CoreDataHelper *)cdh {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif

  if (!_coreDataHelper) {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
      self->_coreDataHelper = [CoreDataHelper new];
    });
    [_coreDataHelper setupCoreData];
  }
  
  return _coreDataHelper;
}

- (void)demo {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [self cdh];
  NSArray *homeLocations = [NSArray arrayWithObjects:
                            @"Fruit Bowl",@"Pantry",@"Nursery",@"Bathroom",@"Fridge",nil]; NSArray *shopLocations = [NSArray arrayWithObjects: @"Produce",@"Aisle 1",@"Aisle 2",@"Aisle 3", @"Deli",nil]; NSArray *unitNames = [NSArray arrayWithObjects: @"g",@"pkt",@"box",@"ml",@"kg",nil];
  NSArray *itemNames = [NSArray arrayWithObjects: @"Grapes",@"Biscuits",@"Nappies",@"Shampoo",@"Sausages",nil];
  int i = 0;
  for (NSString *itemName in itemNames) {
    LocationAtHome *locationAtHome = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"LocationAtHome"
                                      inManagedObjectContext:cdh.context]; LocationAtShop *locationAtShop =
    [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop"
                                  inManagedObjectContext:cdh.context];
    Unit *unit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit"
                                               inManagedObjectContext:cdh.context];
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                               inManagedObjectContext:cdh.context];
    locationAtHome.storedIn = [homeLocations objectAtIndex:i];
    locationAtShop.aisle = [shopLocations objectAtIndex:i];
    unit.name = [unitNames objectAtIndex:i];
    item.name = [itemNames objectAtIndex:i];
    item.locationAtHome = locationAtHome; item.locationAtShop = locationAtShop; item.unit = unit;
    i++;
  }
  [cdh saveContext];
  
}

- (void)showUnitAndItemCount {
  NSFetchRequest *items = [Item fetchRequest];
  NSError *itemsError = nil;
  NSArray *fetchedItems = [[[self cdh] context] executeFetchRequest:items
                                                              error:&itemsError];
  
  if (!fetchedItems && itemsError) {
    NSLog(@"Failed to fetch items: %@", [itemsError description]);
    return;
  }
  
  NSLog(@"Found %lu items", [fetchedItems count]);
  
  NSFetchRequest *units = [Unit fetchRequest];
  NSError *unitError = nil;
  NSArray *fetchedUnits = [[[self cdh] context] executeFetchRequest:units
                                                              error:&unitError];
  if (!fetchedUnits && unitError) {
    NSLog(@"Failed to fetch units: %@", [unitError description]);
    return;
  }
  
  NSLog(@"Found %lu units", [fetchedUnits count]);
}

#pragma mark - VALIDATION ERROR HANDLING

- (void)showValidationError:(NSError *)error {
  if (!error) {
    return;
  }
  
  if ([[error domain] isEqualToString:NSCocoaErrorDomain]) {
    // Skip this
  }
}

@end
