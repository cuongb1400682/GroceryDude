//
//  CoreDataPickerTF.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/19/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreDataHelper.h"

@class CoreDataPickerTF;

NS_ASSUME_NONNULL_BEGIN

@protocol CoreDataPickerTFDelegate <NSObject>
- (void)selectedObjectID:(NSManagedObjectID *)objectID
      changedForPickerTF:(CoreDataPickerTF *)pickerTF;
@optional
- (void)selectedObjectClearedForPickerTF:(CoreDataPickerTF *)pickerTF;
@end

@interface CoreDataPickerTF : UITextField <UIKeyInput, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id <CoreDataPickerTFDelegate> pickerDelegate;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic) BOOL showToolbar;
@property (nonatomic, strong) NSManagedObjectID *selectedObjectID;

@end

NS_ASSUME_NONNULL_END
