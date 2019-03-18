#import "AppDelegate.h"
#import "PrepareTVC.h"
#import "CoreDataHelper.h"
#import "Unit+CoreDataProperties.h"
#import "ItemVC.h"

@implementation PrepareTVC

static NSString * const itemCellIdentifier = @"ItemCell";

#pragma mark - DATA

- (void)configureFetch {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
  NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"locationAtHome.storedIn"
                                                             ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                             ascending:YES]];
  [request setSortDescriptors:sortDescriptors];
  [request setFetchBatchSize:50];
  
  self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                 managedObjectContext:[cdh context]
                                                   sectionNameKeyPath:@"locationAtHome.storedIn"
                                                            cacheName:nil];
  [[self frc] setDelegate:self];
}

#pragma mark - VIEW

- (void)viewDidLoad {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif

  [super viewDidLoad];
  [self configureFetch];
  [self performFetch];
  [self.clearConfirmAlertVC setTransitioningDelegate:self];
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
  Item *item = [self.frc objectAtIndexPath:indexPath];

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier
                                                          forIndexPath:indexPath];
  [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
  
  NSMutableString *title = [NSMutableString stringWithFormat:@"%d%@ %@",
                            [item quantity],
                            [[item unit] name],
                            [item name]];
  [title replaceOccurrencesOfString:@"(null)"
                         withString:@""
                            options:0
                              range:NSMakeRange(0, [title length])];
  [[cell textLabel] setText:title];
  
  if ([item listed]) {
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Neue"
                                              size:18]];
    [[cell textLabel] setTextColor:[UIColor orangeColor]];
  } else {
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Neue"
                                              size:16]];
    [[cell textLabel] setTextColor:[UIColor grayColor]];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Item *deleteTarget = [self.frc objectAtIndexPath:indexPath];
    [self.frc.managedObjectContext deleteObject:deleteTarget];
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  NSManagedObjectID *objectID = [[self.frc objectAtIndexPath:indexPath] objectID];
  Item *item = (Item *)[self.frc.managedObjectContext existingObjectWithID:objectID
                                                                     error:nil];
  
  if ([item listed]) {
    [item setListed:![item listed]];
    [item setCollected:NO];
  }
  
  [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                        withRowAnimation:UITableViewRowAnimationNone];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif

  return nil;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [[[[self frc] sections] objectAtIndex:section] numberOfObjects];
}

#pragma mark - INTERACTION

- (IBAction)clear:(id)sender {
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"ShoppingList"];
  NSArray *shoppingList = [[cdh context] executeFetchRequest:request
                                                       error:nil];
  
  if ([shoppingList count] > 0) {
    _clearConfirmAlertVC = [UIAlertController alertControllerWithTitle:@"Clear the Entire Shopping List?"
                                                                   message:@"Press \"Cancel\" to close this."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionClear = [UIAlertAction actionWithTitle:@"Clear All"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                          [self actionClearSelected:action];
                                                        }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [_clearConfirmAlertVC addAction:actionClear];
    [_clearConfirmAlertVC addAction:actionCancel];
  } else {
    _clearConfirmAlertVC = [UIAlertController alertControllerWithTitle:@"Nothing to be cleared"
                                                               message:@"Please click (+) button to add item."
                                                        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionClose = [UIAlertAction actionWithTitle:@"Close"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [_clearConfirmAlertVC addAction:actionClose];
  }
  
  [self presentViewController:_clearConfirmAlertVC animated:YES completion:nil];
}

- (void)actionClearSelected:(UIAlertAction *)action {
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"ShoppingList"];
  NSArray *shoppingItems = [[cdh context] executeFetchRequest:request error:nil];
  
  for (Item *item in shoppingItems) {
    [item setListed:NO];
  }
}

#pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if ([[segue identifier] isEqualToString:@"Add Item Segue"]) {
    ItemVC *itemVC = [segue destinationViewController];
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                  inManagedObjectContext:[cdh context]];
    [[cdh context] obtainPermanentIDsForObjects:@[newItem]
                                          error:nil];
    [itemVC setSelectedItemID:[newItem objectID]];
  }
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  ItemVC *itemVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"ItemVC"];
  Item *selectedItem = [[self frc] objectAtIndexPath:indexPath];
  [itemVC setSelectedItemID:[selectedItem objectID]];
  [[self navigationController] pushViewController:itemVC
                                         animated:TRUE];
}

@end
