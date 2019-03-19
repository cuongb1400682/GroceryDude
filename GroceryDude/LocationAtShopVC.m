//
//  LocationAtShopVC.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/18/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "LocationAtShopVC.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"

@implementation LocationAtShopVC

#pragma mark - VIEW

- (void)refreshInterface {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if ([self selectedObjectID]) {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    LocationAtShop *locationAtShop = (LocationAtShop *)[[cdh context] existingObjectWithID:[self selectedObjectID]
                                                       error:nil];
    [[self nameTextField] setText:[locationAtShop aisle]];
  }
}

- (void)viewDidLoad {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
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
  LocationAtShop *locationAtShop = (LocationAtShop *)[[cdh context] existingObjectWithID:[self selectedObjectID]
                                                                                   error:nil];
  if (textField == [self nameTextField]) {
    [locationAtShop setAisle:[[self nameTextField] text]];
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
