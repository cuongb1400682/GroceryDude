//
//  Amount+CoreDataProperties.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/12/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "Amount+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Amount (CoreDataProperties)

+ (NSFetchRequest<Amount *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *xyz;

@end

NS_ASSUME_NONNULL_END
