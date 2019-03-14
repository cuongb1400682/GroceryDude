//
//  Unit+CoreDataProperties.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/14/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "Unit+CoreDataProperties.h"

@implementation Unit (CoreDataProperties)

+ (NSFetchRequest<Unit *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
}

@dynamic name;
@dynamic items;

@end
