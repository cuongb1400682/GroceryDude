//
//  CoreDataImporter.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/23/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "CoreDataImporter.h"

@implementation CoreDataImporter

+ (void)saveContext:(NSManagedObjectContext *)context {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  NSError *__block error = nil;
  
  [context performBlockAndWait:^{
    if ([context hasChanges]) {
      if ([context save:&error]) {
        NSLog(@"Save context successfully");
      } else {
        NSLog(@"Failed to save context: %@", [error description]);
      }
    }
  }];
}

- (instancetype)initWithUniqueAttributes:(NSDictionary *)uniqueAttribues {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if (self = [super init]) {
    [self setEntitiesWithUniqueAttributes:uniqueAttribues];
    
    if ([self entitiesWithUniqueAttributes]) {
      return self;
    }
  }
  
  return nil;
}

- (NSString *)uniqueAttributesForEntities:(NSString *)entity {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  return [[self entitiesWithUniqueAttributes] objectForKey:entity];
}

- (NSManagedObject *)existingObjectIntContext:(NSManagedObjectContext *)context
                                    forEntity:(NSString *)entity
                        withUniqueEntityValue:(NSString *)value {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  NSString *attribute = [self uniqueAttributesForEntities:entity];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:entity
                                      inManagedObjectContext:context]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", attribute, value];
  [fetchRequest setPredicate:predicate];
  [fetchRequest setFetchLimit:1];
  
  NSError *error = nil;
  NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
                                                   error:&error];
  if ([fetchedObjects count] > 0) {
    return [fetchedObjects lastObject];
  } else {
    NSLog(@"Error perform fetch request: %@", [error description]);
  }
  
  return nil;
}

- (NSManagedObject *)insertUniqueObjectInTargetEntity:(NSString *)entity
                                 uniqueAttributeValue:(NSString *)uniqueAttributeValue
                                     attributesValues:(NSDictionary *)attributeValues
                                            inContext:(NSManagedObjectContext *)context {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  NSString *uniqueAttribute = [self uniqueAttributesForEntities:entity];
  if ([uniqueAttribute length] == 0) {
    NSLog(@"There is no unique attribue for %@", entity);
    return nil;
  }
  
  NSManagedObject *existingObject = [self existingObjectIntContext:context
                                                         forEntity:entity
                                             withUniqueEntityValue:uniqueAttributeValue];
  
  if (existingObject) {
    return existingObject;
  }
  
  NSManagedObject *newlyInsertedObject = [NSEntityDescription insertNewObjectForEntityForName:entity
                                                                       inManagedObjectContext:context];
  [newlyInsertedObject setValuesForKeysWithDictionary:attributeValues];
  return newlyInsertedObject;
}

- (NSManagedObject *)insertBasicObjectInTargetEntity:(NSString *)entity
                               targetEntityAttribute:(NSString *)targetEntityAttribute
                                  sourceXMLAttribute:(NSString *)xmlAttribute
                                       attributeDict:(NSDictionary *)attributeDict
                                             context:(NSManagedObjectContext *)context {
  NSArray *attributes = @[targetEntityAttribute];
  NSArray *values = @[[attributeDict objectForKey:xmlAttribute]];
  return [self insertUniqueObjectInTargetEntity:entity
                           uniqueAttributeValue:[attributeDict valueForKey:xmlAttribute]
                               attributesValues:[NSDictionary dictionaryWithObjects:values
                                                                            forKeys:attributes]
                                      inContext:context];
}

@end
