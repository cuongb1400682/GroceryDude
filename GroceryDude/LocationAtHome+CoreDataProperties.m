//
//  LocationAtHome+CoreDataProperties.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/14/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "LocationAtHome+CoreDataProperties.h"

@implementation LocationAtHome (CoreDataProperties)

+ (NSFetchRequest<LocationAtHome *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"LocationAtHome"];
}

@dynamic storedIn;
@dynamic items;

@end
