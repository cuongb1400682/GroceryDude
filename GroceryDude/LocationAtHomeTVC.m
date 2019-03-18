//
//  LocationAtHomeTVC.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/18/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "LocationAtHomeTVC.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "LocationAtHome+CoreDataProperties.h"
#import "LocationAtHomeVC.h"

@implementation LocationAtHomeTVC

static NSString * const locationAtHomeIdentifier = @"LocationAtHome Cell";

#pragma mark - DATA

- (void)configureFetch {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocationAtHome"];
  [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"storedIn"
                                                              ascending:YES]]];
  [request setFetchBatchSize:50];
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationAtHomeIdentifier
                                                          forIndexPath:indexPath];
  LocationAtHome *locationAtHome = [[self frc] objectAtIndexPath:indexPath];
  [[cell textLabel] setText:[locationAtHome storedIn]];
  return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    LocationAtHome *deletingObject = [[self frc] objectAtIndexPath:indexPath];
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
  LocationAtHomeVC *locationAtHomeVC = (LocationAtHomeVC *)[segue destinationViewController];
  NSString * const segueIdentifier = [segue identifier];
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSError *error = nil;
  
  if ([segueIdentifier isEqualToString:@"Add Object Segue"]) {
    LocationAtHome *newLocationAtHome = (LocationAtHome *)[NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome"
                                                                                        inManagedObjectContext:[cdh context]];
    
    if (![[cdh context] obtainPermanentIDsForObjects:@[newLocationAtHome]
                                               error:&error]) {
      NSLog(@"Cannot obtain permanent ID for object: %@", [error description]);
    }
    
    NSManagedObjectID *objectID = [newLocationAtHome objectID];
    [locationAtHomeVC setSelectedObjectID:objectID];
  } else if ([segueIdentifier isEqualToString:@"Edit Object Segue"]) {
    NSIndexPath *selectedIndexPath = [[self tableView] indexPathForSelectedRow];
    LocationAtHome *selectedLocationAtHome = [[self frc] objectAtIndexPath:selectedIndexPath];
    [locationAtHomeVC setSelectedObjectID:[selectedLocationAtHome objectID]];
  } else {
    NSLog(@"Unidentified Segue Attempted!: %@", segueIdentifier);
  }
}

@end
