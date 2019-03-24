//
//  CoreDataImporter.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/23/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataImporter : NSObject

@property (nonatomic, retain) NSDictionary *entitiesWithUniqueAttributes;

+ (void)saveContext:(NSManagedObjectContext *)context;
- (instancetype)initWithUniqueAttributes:(NSDictionary *)uniqueAttribues;
- (NSString *)uniqueAttributesForEntities:(NSString *)entity;

- (NSManagedObject *)insertUniqueObjectInTargetEntity:(NSString *)entity
                                 uniqueAttributeValue:(NSString *)uniqueAttributeValue
                                     attributesValues:(NSDictionary *)attributeValues
                                            inContext:(NSManagedObjectContext *)context;

- (NSManagedObject *)insertBasicObjectInTargetEntity:(NSString *)entity
                               targetEntityAttribute:(NSString *)targetEntityAttribute
                                  sourceXMLAttribute:(NSString *)xmlAttribute
                                       attributeDict:(NSDictionary *)attributeDict
                                             context:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END
