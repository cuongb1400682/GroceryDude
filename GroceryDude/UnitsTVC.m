#import "UnitsTVC.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Unit+CoreDataProperties.h"
#import "UnitVC.h"

@implementation UnitsTVC

static NSString * const shopCellIdentifier = @"Unit Cell";

#pragma mark - DATA

- (void)configureFetch {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
  [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
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
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    [[cdh context] deleteObject:deletingObject];
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
  UnitVC *unitVC = (UnitVC *)[segue destinationViewController];
  NSString *const segueIdentifier = [segue identifier];
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSError *error = nil;
  
  if ([segueIdentifier isEqualToString:@"Add Object Segue"]) {
    Unit *newUnit = (Unit *)[NSEntityDescription insertNewObjectForEntityForName:@"Unit"
                                                          inManagedObjectContext:[cdh context]];
    if (![[cdh context] obtainPermanentIDsForObjects:@[newUnit] error:&error]) {
      NSLog(@"Couldn't obtain a permanent ID for object: %@", [error description]);
    }
    
    [unitVC setSelectedObjectID:[newUnit objectID]];
  } else if ([segueIdentifier isEqualToString:@"Edit Object Segue"]) {
    NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    NSManagedObjectID *selectedObjectID = [(Unit *)[[self frc] objectAtIndexPath:indexPath] objectID];
    [unitVC setSelectedObjectID:selectedObjectID];
  } else {
#if DEBUG
    NSLog(@"Unidentified Segue Attempted!: %@", segueIdentifier);
#endif
  }
}

@end
