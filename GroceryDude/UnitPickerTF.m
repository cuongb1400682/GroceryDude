//
//  UnitPickerTF.m
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/22/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import "UnitPickerTF.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Unit+CoreDataProperties.h"

@implementation UnitPickerTF

- (void)fetch {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Unit"];
  NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  [fetchRequest setSortDescriptors:@[descriptor]];
  [fetchRequest setFetchBatchSize:50];
  NSError *error = nil;
  [self setPickerData:[[cdh context] executeFetchRequest:fetchRequest
                                                   error:&error]];
  if (error) {
    NSLog(@"Error populating picker: %@, %@", error, [error localizedDescription]);
  }
  [self selectedDefaultRow];
}

- (void)selectedDefaultRow {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  if ([self selectedObjectID] && [[self pickerData] count] > 0) {
    NSError *error = nil;
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    Unit *selectedObject = [[cdh context] existingObjectWithID:[self selectedObjectID]
                                                         error:&error];
    if (error) {
      NSLog(@"Unit with id %@ not exist.", [error description]);
      return;
    }
    
    [[self pickerData] enumerateObjectsUsingBlock:^(Unit *unit, NSUInteger index, BOOL * _Nonnull stop) {
      if ([[unit name] compare:[selectedObject name]] == NSOrderedSame) {
        [[self picker] selectRow:index
                     inComponent:0
                        animated:NO];
        [[self pickerDelegate] selectedObjectID:[self selectedObjectID]
                             changedForPickerTF:self];
        *stop = YES;
      }
    }];
  }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
#if DEBUG
  NSLog(@"Running %@, '%@'", [self class], NSStringFromSelector(_cmd));
#endif
  Unit *unit = [[self pickerData] objectAtIndex:row];
  return [unit name];
}

@end
