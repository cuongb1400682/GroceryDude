#import "UnitVC.h"
#import "Unit+CoreDataProperties.h"
#import "AppDelegate.h"

@implementation UnitVC

#pragma mark - VIEW

- (void)refreshInterface {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if ([self selectedObjectID]) {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Unit *unit = (Unit *)[[cdh context] existingObjectWithID:[self selectedObjectID]
                                                       error:nil];
    [[self nameTextField] setText:[unit name]];
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
  Unit *unit = (Unit *)[[cdh context] existingObjectWithID:[self selectedObjectID]
                                                     error:nil];
  if (textField == [self nameTextField]) {
    [unit setName:[[self nameTextField] text]];
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
