//
//  CoreDataPickerTF.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/19/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "CoreDataPickerTF.h"

@implementation CoreDataPickerTF

#pragma mark - DELEGATE + DATASOURCE
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  return [[self pickerData] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  return 280.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  return [[self pickerData] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  NSManagedObject *object = [[self pickerData] objectAtIndex:row];
  [[self pickerDelegate] selectedObjectID:[object objectID]
                       changedForPickerTF:self];
}

#pragma mark - INTERACTION

- (void)done {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [self resignFirstResponder];
}

- (void)clear {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [[self pickerDelegate] selectedObjectClearedForPickerTF:self];
  [self resignFirstResponder];
}

#pragma mark - DATA

- (void)fetch {
  [NSException raise:NSInternalInconsistencyException
              format:@"Method %@ must be overriden before being invoked", NSStringFromSelector(_cmd)];
}

- (void)selectDefaultRow {
  [NSException raise:NSInternalInconsistencyException
              format:@"Method %@ must be overriden before being invoked", NSStringFromSelector(_cmd)];
}

#pragma mark - VIEW

- (UIView *)createInputView {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [self setPicker:[[UIPickerView alloc] initWithFrame:CGRectZero]];
  [[self picker] setShowsSelectionIndicator:YES];
  [[self picker] setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
  [[self picker] setDelegate:self];
  [[self picker] setDataSource:self];
  [self fetch];
  return [self picker];
}

- (UIView *)createInputAccessaryView {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [self setShowToolbar:YES];
  if (![self toolbar] && [self showToolbar]) {
    [self setToolbar:[[UIToolbar alloc] init]];
    [[self toolbar] setBarStyle:UIBarStyleBlackTranslucent];
    [[self toolbar] setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [[self toolbar] sizeToFit];
    CGRect frame = [[self toolbar] frame];
    frame.size.height = 44.0f;
    [[self toolbar] setFrame:frame];
    UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(clear)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(done)];
    NSArray *buttonsArray = @[clearBtn, spacer, doneButton];
    [[self toolbar] setItems:buttonsArray];
  }
  return [self toolbar];
}

- (instancetype)initWithFrame:(CGRect)frame {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if (self = [super initWithFrame:frame]) {
    [self setInputView:[self createInputView]];
    [self setInputAccessoryView:[self createInputAccessaryView]];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  if (self = [super initWithCoder:coder]) {
    [self setInputView:[self createInputView]];
    [self setInputAccessoryView:[self createInputAccessaryView]];
  }
  return self;
}

- (void)deviceDidRotate:(NSNotification *)notification {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  [[self picker] setNeedsLayout];
}

@end
