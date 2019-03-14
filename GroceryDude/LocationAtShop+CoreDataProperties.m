//
//  LocationAtShop+CoreDataProperties.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/14/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "LocationAtShop+CoreDataProperties.h"

@implementation LocationAtShop (CoreDataProperties)

+ (NSFetchRequest<LocationAtShop *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"LocationAtShop"];
}

@dynamic aisle;
@dynamic items;

@end
