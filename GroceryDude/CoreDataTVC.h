//
//  CoreDataTVC.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/14/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataTVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *frc;

- (void)performFetch;

@end

NS_ASSUME_NONNULL_END
