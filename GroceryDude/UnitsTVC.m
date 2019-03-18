#import "UnitsTVC.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Unit+CoreDataProperties.h"

@implementation UnitsTVC

static NSString * const shopCellIdentifier = @"Unit Cell";

#pragma mark - DATA

- (void)configureFetch {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
  [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
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
                                               name:@"somethingChanged"
                                             object:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellIdentifier
                                                          forIndexPath:indexPath];
  Unit *unit = [[self frc] objectAtIndexPath:indexPath];
  [[cell textLabel] setText:[unit name]];
  return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Unit *deletingObject = [[self frc] objectAtIndexPath:indexPath];
    
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

@end
