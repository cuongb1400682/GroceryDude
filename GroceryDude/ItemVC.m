#import "ItemVC.h"
#import "LocationAtHome+CoreDataProperties.h"
#import "LocationAtShop+CoreDataProperties.h"

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
  } else if ([self unitPickerTextField] == textField) {
    [[self unitPickerTextField] fetch];
    [[[self unitPickerTextField] picker] reloadAllComponents];
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
  [[self unitPickerTextField] setText:[[selectedItem unit] name]];
  [[self unitPickerTextField] setSelectedObjectID:[[selectedItem unit] objectID]];
}

- (void)viewDidLoad {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [super viewDidLoad];
  [self refreshInterface];
  [[self nameTextField] setDelegate:self];
  [[self quantityTextField] setDelegate:self];
  [[self unitPickerTextField] setDelegate:self];
  [[self unitPickerTextField] setPickerDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [super viewWillAppear:animated];
  [self ensureItemHomeLocationIsNotNull];
  [self ensureItemShopLocationIsNotNull];
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
  [self ensureItemHomeLocationIsNotNull];
  [self ensureItemShopLocationIsNotNull];
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  [cdh saveContext];
}

#pragma mark - DATA

- (void)ensureItemHomeLocationIsNotNull {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if (![self selectedItemID]) {
    return;
  }
  
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  Item *selectedItem = [[cdh context] existingObjectWithID:_selectedItemID error:nil];
  
  if (![selectedItem locationAtHome]) {
    return;
  }
  
  NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"UnknownLocationAtHome"];
  NSArray *homeLocations = [[cdh context] executeFetchRequest:request error:nil];
  
  if ([homeLocations count] > 0) {
    [selectedItem setLocationAtHome:[homeLocations objectAtIndex:0]];
  } else {
    LocationAtHome *location = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtHome"
                                                             inManagedObjectContext:[cdh context]];
    [location setStoredIn:@"..Unknown Location.."];
    
    if ([[cdh context] obtainPermanentIDsForObjects:@[location] error:nil]) {
      [selectedItem setLocationAtHome:location];
    } else {
#if DEBUG
      NSLog(@"Cannnot obtain permanent ids for "
            "new LocationAtHome with storedIn of UnknownLocation: %@",
            [location description]);
#endif
    }
  }
}

- (void)ensureItemShopLocationIsNotNull {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if (![self selectedItemID]) {
    return;
  }
  
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  Item *selectedItem = [[cdh context] existingObjectWithID:_selectedItemID error:nil];
  
  if ([selectedItem locationAtShop]) {
    return;
  }
  
  NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"UnknownLocationAtShop"];
  NSArray *shopLocations = [[cdh context] executeFetchRequest:request error:nil];
  
  if ([shopLocations count] > 0) {
    [selectedItem setLocationAtShop:[shopLocations objectAtIndex:0]];
  } else {
    LocationAtShop *location = [NSEntityDescription insertNewObjectForEntityForName:@"LocationAtShop"
                                                             inManagedObjectContext:[cdh context]];
    [location setAisle:@"..Unknown Location.."];
    
    if ([[cdh context] obtainPermanentIDsForObjects:@[location] error:nil]) {
      [selectedItem setLocationAtShop:location];
    } else {
#if DEBUG
      NSLog(@"Cannnot obtain permanent ids for "
            "new LocationAtHome with aisle of UnkownLocation: %@",
            [location description]);
#endif
    }
  }
}

#pragma mark - PICKERS

- (void)selectedObjectID:(NSManagedObjectID *)objectID
      changedForPickerTF:(CoreDataPickerTF *)pickerTF {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if (![self selectedItemID]) {
    return;
  }
  
  NSError *error = nil;
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  Item *selectedItem = [[cdh context] existingObjectWithID:[self selectedItemID]
                                                     error:&error];
  
  if (pickerTF == [self unitPickerTextField]) {
    Unit *selectedUnit = [[cdh context] existingObjectWithID:objectID
                                                       error:&error];
    
    if (!error) {
      [selectedItem setUnit:selectedUnit];
      [[self unitPickerTextField] setText:[selectedUnit name]];
    }
  }
  
  [self refreshInterface];

  if (error) {
    NSLog(@"Error select object: %@", [error description]);
  }
}

- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF *)pickerTF {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if (![self selectedItemID]) {
    return;
  }
  
  NSError *error = nil;
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  Item *item = [[cdh context] existingObjectWithID:[self selectedItemID]
                                             error:&error];
  
  if (error) {
    NSLog(@"Error selecte object: %@", [error description]);
    return;
  }
  
  if (pickerTF == [self unitPickerTextField]) {
    [item setUnit:nil];
    [[self unitPickerTextField] setText:@""];
  }
  
  [self refreshInterface];
}

@end
