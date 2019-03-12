//
//  Measurement+CoreDataProperties.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/11/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//
//

#import "Measurement+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Measurement (CoreDataProperties)

+ (NSFetchRequest<Measurement *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *abc;

@end

NS_ASSUME_NONNULL_END
