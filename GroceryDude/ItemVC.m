#import "ItemVC.h"

@implementation ItemVC

#pragma mark - DELEGATE

- (void)textFieldDidBeginEditing:(UITextField *)textField {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if ([self nameTextField] == textField) {
    if ([[[self nameTextField] text] isEqualToString:@"New Item"]) {
      [[self nameTextField] setText:@""];
    }
  }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  Item *item = [[cdh context] existingObjectWithID:[self selectedItemID] error:nil];
  
  if ([self nameTextField] == textField) {
    if ([[textField text] isEqualToString:@""]) {
      [textField setText:@"New Item"];
    }
    
    [item setName:[textField text]];
  } else if ([self quantityTextField] == textField) {
    [item setQuantity:[[textField text] intValue]];
  }
}

#pragma mark - VIEW

- (void)refreshInterface {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if (![self selectedItemID]) {
    return;
  }
  
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  Item *selectedItem = [[cdh context] existingObjectWithID:_selectedItemID
                                                     error:nil];
  [[self nameTextField] setText:[selectedItem name]];
  NSString * const quantityString = [NSString stringWithFormat:@"%d", [selectedItem quantity]];
  [[self quantityTextField] setText:quantityString];
}

- (void)viewDidLoad {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [super viewDidLoad];
  [self refreshInterface];
  [[self nameTextField] setDelegate:self];
  [[self quantityTextField] setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [super viewWillAppear:animated];
  [self refreshInterface];
  
  if ([[[self nameTextField] text] isEqualToString:@"New Item"]) {
    [[self nameTextField] setText:@""];
    [[self nameTextField] becomeFirstResponder];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  [cdh saveContext];
}

@end
