//
//  Amount+CoreDataProperties.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/12/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "Amount+CoreDataProperties.h"

@implementation Amount (CoreDataProperties)

+ (NSFetchRequest<Amount *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Amount"];
}

@dynamic xyz;

@end
