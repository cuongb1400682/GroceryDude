#import "LocationAtHomeVC.h"
#import "LocationAtHome+CoreDataProperties.h"
#import "AppDelegate.h"

@implementation LocationAtHomeVC

#pragma mark - VIEW

- (void)refreshInterface {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if ([self selectedObjectID]) {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    LocationAtHome *locationAtHome = [[cdh context] existingObjectWithID:[self selectedObjectID]
                                                                   error:nil];
    [[self nameTextField] setText:[locationAtHome storedIn]];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self hideKeyboardWhenBackgroundIsTapped];
  [[self nameTextField] setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [self refreshInterface];
  [[self nameTextField] becomeFirstResponder];
}

#pragma mark - TEXTFIELD

- (void)textFieldDidEndEditing:(UITextField *)textField {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  LocationAtHome *locationAtHome = [[cdh context] objectWithID:[self selectedObjectID]];
  
  if (textField == [self nameTextField]) {
    [locationAtHome setStoredIn:[[self nameTextField] text]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged"
                                                        object:nil];
  }
}

#pragma mark - INTERACTION

- (IBAction)done:(id)sender {
  [self hideKeyboard];
  [[self navigationController] popViewControllerAnimated:YES];
}

- (void)hideKeyboardWhenBackgroundIsTapped {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  UITapGestureRecognizer *recogniser = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(hideKeyboard)];
  [recogniser setCancelsTouchesInView:NO];
  [[self view] addGestureRecognizer:recogniser];
}

- (void)hideKeyboard {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [[self view] endEditing:YES];
}

@end
