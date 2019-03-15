#import "PrepareTVC.h"
#import "CoreDataHelper.h"
#import "Unit+CoreDataProperties.h"
#import "AppDelegate.h"

@implementation PrepareTVC

static NSString * const cellIdentifier = @"ItemCell";

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
  [self.clearConfirmActionSheet setTransitioningDelegate:self];
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

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                          forIndexPath:indexPath];
  [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
  
  NSMutableString *title = [NSMutableString stringWithFormat:@"%d%@ %@", [item quantity], [[item unit] name], [item name]];
  [title replaceOccurrencesOfString:@"(null)"
                         withString:@""
                            options:0
                              range:NSMakeRange(0, [title length])];
  [[cell textLabel] setText:title];
  
  if ([item listed]) {
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Neue" size:18]];
    [[cell textLabel] setTextColor:[UIColor orangeColor]];
  } else {
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
    [[cell textLabel] setTextColor:[UIColor grayColor]];
  }
  
  return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif

  return nil;
}

#pragma mark - INTERACTION

@end
