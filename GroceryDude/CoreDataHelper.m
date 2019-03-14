//
//  CoreDataHelper.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/10/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

#pragma mark - CONSTANTS

NSString *storeFileName = @"Grocery-Dude.sqlite";
NSString *migrationProgress = @"migrationProgress";

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

  if ([self isMigrationNecessaryForStore:[self storeURL]]) {
    [self performBackgroundManagedMigrationForStore:[self storeURL]];
  } else {
    NSDictionary *options = @{
                              @"journal_mode": @"DELETE",
                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES
                              };
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:options
                                                error:&error];
    
    if (!_store) {
      //    NSLog(@"Cannot add persistent store: %@", [error description]);
      NSLog(@"Cannot add persistent store");
      abort();
    } else {
#if DEBUG
      NSLog(@"Successfully loaded persistent store: %@", _store);
#endif
    }
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

#pragma mark - MIGRATION MANAGER

- (BOOL)isMigrationNecessaryForStore:(NSURL *)storeURL {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  
  if (![[NSFileManager defaultManager] fileExistsAtPath:[self storeURL].path]) {
#if DEBUG
    NSLog(@"SKIPPED MIGRATION: Source database does not exist");
#endif
    return NO;
  }
  
  NSError *error = nil;
  NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                            URL:storeURL
                                                                                        options:nil
                                                                                          error:&error];
  
  NSManagedObjectModel *destinationModel = [_coordinator managedObjectModel];
  
  if ([destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata]) {
#if DEBUG
    NSLog(@"SKIPPED MIGRATION: Source is already compatible");
#endif
    return NO;
  }
 
  return YES;
}

- (BOOL)migrateStore:(NSURL *)sourceStore {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  
  BOOL success = NO;
  NSError *error = nil;
  
  // STEP 1 - Gather the Source, Destination and Mapping Model
  NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                            URL:sourceStore
                                                                                        options:nil
                                                                                          error:&error];
  NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil
                                                                  forStoreMetadata:sourceMetadata];
  NSManagedObjectModel *destinModel = _model;
  NSMappingModel *mappingModel = [NSMappingModel mappingModelFromBundles:nil
                                                          forSourceModel:sourceModel
                                                        destinationModel:destinModel];
  
  // STEP 2 - Perform migration, assuming the mapping is not nil
  if (!mappingModel) {
    NSLog(@"FAILED MIGRATION: mapping model is nil");
    return NO;
  }
  
  NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel
                                                                        destinationModel:destinModel];
  
  [migrationManager addObserver:self
                     forKeyPath:migrationProgress
                        options:NSKeyValueObservingOptionNew
                        context:nil];
  
  NSURL *destinStoreURL = [[self applicationStoresDirectory] URLByAppendingPathComponent:@"Temp.sqlite"];
  
  success = [migrationManager migrateStoreFromURL:sourceStore
                                             type:NSSQLiteStoreType
                                          options:nil
                                 withMappingModel:mappingModel
                                 toDestinationURL:destinStoreURL
                                  destinationType:NSSQLiteStoreType
                               destinationOptions:nil
                                            error:&error];
  
  if (!success) {
#if DEBUG
    NSLog(@"FAILED MIGRATION: %@", [error description]);
#endif
    return NO;
  }
  
#if DEBUG
  NSLog(@"SUCCESSFULLY MIGRATED: %@ to the current model", [sourceStore path]);
#endif
  
  // STEP 3 - Replace the old store with the newly migrated one
  
  if ([self replaceStore:sourceStore withStore:destinStoreURL]) {
    [migrationManager removeObserver:self
                          forKeyPath:migrationProgress];
  }
  
  return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:migrationProgress]) {
    CoreDataHelper __weak *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      float progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];

      if (weakSelf) {
        [weakSelf.migrationVC.progressView setProgress:progress];
        [weakSelf.migrationVC.label setText:[NSString stringWithFormat:@"%i%%", (int)(progress * 100)]];
      }
    });
  }
}

- (BOOL)replaceStore:(NSURL *)old withStore:(NSURL *)new {
  NSError *error = nil;
 
  if (![[NSFileManager defaultManager] removeItemAtPath:[old path] error:&error]) {
#if DEBUG
    NSLog(@"REMOVE OLD STORE at %@ FAILED: %@", [old path], [error description]);
#endif
    return NO;
  }
    
  if (![[NSFileManager defaultManager] moveItemAtURL:new toURL:old error:&error]) {
#if DEBUG
    NSLog(@"MOVE STORE at %@ to %@ FAILED: %@", [new path], [old path], [error description]);
#endif
    return NO;
  }
  
  return YES;
}

-  (void)performBackgroundManagedMigrationForStore:(NSURL *)storeURL {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UIApplication *shareApplication = [UIApplication sharedApplication];
  UINavigationController *navigationController = (UINavigationController *)shareApplication.keyWindow.rootViewController;

  self.migrationVC = [storyboard instantiateViewControllerWithIdentifier:@"migration"];

  [navigationController presentViewController:self.migrationVC
                                     animated:NO
                                   completion:nil];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    if ([self migrateStore:storeURL]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                            configuration:nil
                                                      URL:[self storeURL]
                                                  options:nil
                                                    error:&error];
        
        if (!_store) {
#if DEBUG
          NSLog(@"Failed to add persistent store: %@", [error description]);
#endif
          abort();
        }
        
        NSLog(@"Succeeded to add persistent store");
        
        [self.migrationVC dismissViewControllerAnimated:YES
                                             completion:nil];
        _migrationVC = nil;
      });
    }
  });
}

@end

