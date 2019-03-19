//
//  LocationAtShopTVC.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/18/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "LocationAtShopTVC.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "LocationAtShop+CoreDataProperties.h"
#import "LocationAtShopVC.h"

@implementation LocationAtShopTVC

static NSString * const locationAtShopIdentifier = @"LocationAtShop Cell";

#pragma mark - DATA

- (void)configureFetch {
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtShop"];
  [request setFetchBatchSize:50];
  [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"aisle"
                                                              ascending:YES]]];
  [self setFrc:[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:[cdh context]
                                                     sectionNameKeyPath:nil
                                                              cacheName:nil]];
  [[self frc] setDelegate:self];
}

#pragma mark - VIEW

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configureFetch];
  [self performFetch];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(performFetch)
                                               name:@"SomethingChanged"
                                             object:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationAtShopIdentifier
                                                          forIndexPath:indexPath];
  LocationAtShop *locationAtShop = [[self frc] objectAtIndexPath:indexPath];
  [[cell textLabel] setText:[locationAtShop aisle]];
}

#pragma mark - SEGUE

@end





















