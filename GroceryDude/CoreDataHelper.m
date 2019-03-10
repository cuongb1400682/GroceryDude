//
//  CoreDataHelper.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/10/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

#pragma mark - FILES

NSString *storeFileName = @"Grocery-Dude.sqlite";

#pragma mark - PATHS

- (NSString *)applicationDocumentDirectory {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSURL *)applicationStoresDirectory {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  
  NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentDirectory]] URLByAppendingPathComponent:@"Stores"];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
    NSError *error = nil;
    if ([fileManager createDirectoryAtURL:storesDirectory
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&error]) {
#if DEBUG
      NSLog(@"Directory has been created");
#endif
    } else {
      NSLog(@"Failed to create stores directory: %@", [error description]);
    }
  }
  
  return storesDirectory;
}

- (NSURL *)storeURL {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif

  return [[self applicationStoresDirectory] URLByAppendingPathComponent:storeFileName];
}

#pragma mark - SETUPS

- (instancetype)init {
  self = [super init];
  if (self) {
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
  }
  return self;
}

- (void)loadStore {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  
  if (_store) {
    return;
  }

  NSDictionary *options = @{@"journal_mode": @"DELETE"};
  NSError *error = nil;
  _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                      configuration:nil
                                                URL:[self storeURL]
                                            options:options
                                              error:&error];
  
  if (!_store) {
    NSLog(@"Cannot add persistent store: %@", [error description]);
    abort();
  } else {
#if DEBUG
    NSLog(@"Successfully loaded persistent store: %@", _store);
#endif
  }
}

- (void)setupCoreData {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  
  [self loadStore];
}

#pragma mark - SAVING

- (void)saveContext {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif

  if ([_context hasChanges]) {
    NSError *error = nil;
    if ([_context save:&error]) {
#if DEBUG
      NSLog(@"Data saving successfully");
#endif
    } else {
      NSLog(@"Error saving context: %@\n", [error description]);
    }
  }
  
}

@end

