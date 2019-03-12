//
//  Measurement+CoreDataProperties.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/11/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "Measurement+CoreDataProperties.h"

@implementation Measurement (CoreDataProperties)

+ (NSFetchRequest<Measurement *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Measurement"];
}

@dynamic abc;

@end
