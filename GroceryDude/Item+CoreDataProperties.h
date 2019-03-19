//
//  Item+CoreDataProperties.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/19/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nonatomic) BOOL collected;
@property (nonatomic) BOOL listed;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSData *photoData;
@property (nonatomic) int32_t quantity;
@property (nullable, nonatomic, retain) LocationAtHome *locationAtHome;
@property (nullable, nonatomic, retain) LocationAtShop *locationAtShop;
@property (nullable, nonatomic, retain) Unit *unit;

@end

NS_ASSUME_NONNULL_END
