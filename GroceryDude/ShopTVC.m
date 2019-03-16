#import "ShopTVC.h"
#import "Item+CoreDataProperties.h"
#import "AppDelegate.h"

@implementation ShopTVC

#pragma mark - DATA

NSString * const cellIdentifier = @"ShopCell";

- (void)configureFetch {
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *request = [[[cdh model] fetchRequestTemplateForName:@"ShoppingList"] copy];
  [request setFetchLimit:50];
  [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"locationAtShop.aisle" ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
  [self setFrc: [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                    managedObjectContext:[cdh context]
                                                      sectionNameKeyPath:@"locationAtShop.aisle"
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                          forIndexPath:indexPath];
  Item *item = [[self frc] objectAtIndexPath:indexPath];
  NSMutableString *title = [NSMutableString stringWithFormat:@"%d%@ %@",
                            [item quantity],
                            [[item unit] name],
                            [item name]];
  [title replaceOccurrencesOfString:@"(null)"
                         withString:@""
                            options:NSCaseInsensitiveSearch
                              range:NSMakeRange(0, [title length])];
  [[cell textLabel] setText:title];
  
  if ([item collected]) {
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Nueu"
                                              size:16]];
    [[cell textLabel] setTextColor:[UIColor colorWithRed:0.3
                                                   green:0.7
                                                    blue:0.3
                                                   alpha:1]];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  } else {
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica Nueu"
                                              size:18]];
    [[cell textLabel] setTextColor:[UIColor orangeColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
  }
  
  return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return nil;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  Item *selectedItem = [[self frc] objectAtIndexPath:indexPath];
  [selectedItem setCollected:![selectedItem collected]];
  [[self tableView] reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

@end
