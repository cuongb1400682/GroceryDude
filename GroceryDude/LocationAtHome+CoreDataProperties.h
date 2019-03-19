//
//  LocationAtHome+CoreDataProperties.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/19/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "LocationAtHome+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LocationAtHome (CoreDataProperties)

+ (NSFetchRequest<LocationAtHome *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *storedIn;
@property (nullable, nonatomic, retain) NSSet<Item *> *items;

@end

@interface LocationAtHome (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet<Item *> *)values;
- (void)removeItems:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
