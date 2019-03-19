//
//  Location+CoreDataProperties.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/19/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "Location+CoreDataProperties.h"

@implementation Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Location"];
}

@dynamic summary;

@end
