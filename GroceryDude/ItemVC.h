#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectID *selectedItemID;

@end

NS_ASSUME_NONNULL_END
