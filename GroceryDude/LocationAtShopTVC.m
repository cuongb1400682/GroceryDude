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
  return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    LocationAtShop *deletingObject = [[self frc] objectAtIndexPath:indexPath];
    
    [[cdh context] deleteObject:deletingObject];
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
  }
}

#pragma mark - INTERACTION

- (IBAction)done:(id)sender {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [self dismissViewControllerAnimated:YES
                           completion:nil];
}

#pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  LocationAtShopVC *locationAtShopVC = (LocationAtShopVC *)[segue destinationViewController];
  NSString *const segueIdentifier = [segue identifier];
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSError *error = nil;
  
  if ([segueIdentifier isEqualToString:@"Add Object Segue"]) {
    LocationAtShop *newLocationAtShop = (LocationAtShop *)[NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop"
                                                                                        inManagedObjectContext:[cdh context]];
    if (![[cdh context] obtainPermanentIDsForObjects:@[newLocationAtShop] error:&error]) {
      NSLog(@"Couldn't obtain a permanent ID for object: %@", [error description]);
    }
    
    [locationAtShopVC setSelectedObjectID:[newLocationAtShop objectID]];
  } else if ([segueIdentifier isEqualToString:@"Edit Object Segue"]) {
    NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    NSManagedObjectID *selectedObjectID = [(LocationAtShop *)[[self frc] objectAtIndexPath:indexPath] objectID];
    [locationAtShopVC setSelectedObjectID:selectedObjectID];
  } else {
#if DEBUG
    NSLog(@"Unidentified Segue Attempted!: %@", segueIdentifier);
#endif
  }
}

@end
