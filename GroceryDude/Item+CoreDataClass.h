//
//  Item+CoreDataClass.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/19/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationAtHome, LocationAtShop, Unit;

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
