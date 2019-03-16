//
//  PrepareTVC.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/15/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreDataTVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrepareTVC : CoreDataTVC <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIAlertController *clearConfirmAlertVC;

@end

NS_ASSUME_NONNULL_END
