//
//  LocationAtShopVC.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/18/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationAtShop+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationAtShopVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectID *selectedObjectID;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@end

NS_ASSUME_NONNULL_END
