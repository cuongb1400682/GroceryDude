//
//  LocationAtHome+CoreDataClass.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/14/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "LocationAtHome+CoreDataProperties.h"
#import "Location+CoreDataProperties.h"

@class Item;

NS_ASSUME_NONNULL_BEGIN

@interface LocationAtHome : Location

@property (strong, nonatomic) NSManagedObjectID *selectedObjectID;

@end

NS_ASSUME_NONNULL_END

