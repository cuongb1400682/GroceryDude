#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Item+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemVC : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;

@property (strong, nonatomic) NSManagedObjectID *selectedItemID;

@end

NS_ASSUME_NONNULL_END
