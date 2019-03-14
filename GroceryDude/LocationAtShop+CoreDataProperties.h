//
//  LocationAtShop+CoreDataProperties.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/14/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "LocationAtShop+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LocationAtShop (CoreDataProperties)

+ (NSFetchRequest<LocationAtShop *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *aisle;
@property (nullable, nonatomic, retain) NSSet<Item *> *items;

@end

@interface LocationAtShop (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet<Item *> *)values;
- (void)removeItems:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
