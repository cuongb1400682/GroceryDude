//
//  Location+CoreDataProperties.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/14/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "Location+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *summary;

@end

NS_ASSUME_NONNULL_END
