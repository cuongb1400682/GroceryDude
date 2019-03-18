#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnitVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectID *selectedObjectID;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@end

NS_ASSUME_NONNULL_END
