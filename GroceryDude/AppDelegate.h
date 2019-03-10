//
//  AppDelegate.h
//  GroceryDude
//
//  Created by Nguyễn Tấn Cường on 3/10/19.
//  Copyright © 2019 Nguyễn Tấn Cường. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

