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

  NSArray *newItemNames = [NSArray arrayWithObjects:@"Orange", @"Apple", @"Kiwi", @"Banana", @"Teapot", @"Toothbrush", @"Sticker", @"Magnet", @"Glue", nil];

  for (NSString *itemName in newItemNames) {
    Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                  inManagedObjectContext:_coreDataHelper.context];
    newItem.name = itemName;
    NSLog(@"Inserted new item for: %@", newItem.name);
  }
  
  [[self cdh] saveContext];
  
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
  
//  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
//  [request setFetchLimit:50];
//  NSError *error = nil;
//  NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request
//                                                                   error:&error];
//
//  if (error) {
//    NSLog(@"%@", [error description]);
//  } else {
//    for (Unit *unit in fetchedObjects) {
//      NSLog(@"Fetched Objects = %@", [unit name]);
//    }
//  }
  
//  Unit *kg = [NSEntityDescription insertNewObjectForEntityForName:@"Unit"
//                                           inManagedObjectContext:[[self cdh] context]];
//  Item *oranges = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
//                                                inManagedObjectContext:[[self cdh] context]];
//  Item *bananas = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
//                                                inManagedObjectContext:[[self cdh] context]];
//
//  [kg setName:@"Kg"];
//  [oranges setName:@"Oranges"];
//  [bananas setName:@"Bananas"];
//  [oranges setQuantity:[NSNumber numberWithInt:1]];
//  [bananas setQuantity:[NSNumber numberWithInt:4]];
//  [oranges setListed:[NSNumber numberWithBool:YES]];
//  [oranges setListed:[NSNumber numberWithBool:YES]];
//  [oranges setUnit:kg];
//  [oranges setUnit:kg];
//
//  NSLog(@"Inserted %d%@ %@", [oranges quantity], [[oranges unit] name], [oranges name]);
//  NSLog(@"Inserted %d%@ %@", [bananas quantity], [[bananas unit] name], [bananas name]);
//  [[self cdh] saveContext];
  
  NSLog(@"Before deletion of the unit entity:");
  [self showUnitAndItemCount];
  
  NSError *error = nil;
  NSFetchRequest *request = [Unit fetchRequest];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Kg"];
  [request setPredicate:predicate];
  NSArray *kgUnit = [[[self cdh] context] executeFetchRequest:request error:&error];
  for (Unit *unit in kgUnit) {
    if ([unit validateForDelete:&error]) {
      [[[self cdh] context] deleteObject:unit];
      NSLog(@"A Kg u nit object has been deleted");
    } else {
      NSLog(@"Failed to delete: %@", [error localizedDescription]);
    }
  }
  
  NSLog(@"After deletion of the unit enity");
  [self showUnitAndItemCount];
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
    
  }
}

@end
