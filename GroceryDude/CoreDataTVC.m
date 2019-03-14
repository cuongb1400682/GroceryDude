//
//  CoreDataTVC.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/14/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "CoreDataTVC.h"

@implementation CoreDataTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - FETCHING

- (void)performFetch {
  if (![self frc]) {
    NSLog(@"Failed to fetch, the fetched results controller is nil.");
  }
  
  [self.frc.managedObjectContext performBlockAndWait:^{
    NSError *error = nil;
    
    if (![self.frc performFetch:&error]) {
      NSLog(@"Failed to perform fetch: %@", [error description]);
    }
    
    [self.tableView reloadData];
  }];
}

#pragma mark - DATASOURCE: UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - DELEGATE: NSFetchedResultsControllers

@end
