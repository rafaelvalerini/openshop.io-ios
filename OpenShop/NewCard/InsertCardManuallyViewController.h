//
//  InsertCardManuallyViewController.h
//  Created by Marcos Lacerda
//

#import "AddNewCardViewController.h"

@interface InsertCardManuallyViewController : UIViewController<UITextFieldDelegate> {
    IBOutlet UIImageView *cardFlag;
    IBOutlet UILabel *cardNumberLabel;
    IBOutlet UITextField *cardNumber_block_1;
    IBOutlet UITextField *cardNumber_block_2;
    IBOutlet UITextField *cardNumber_block_3;
    IBOutlet UITextField *cardNumber_block_4;
    IBOutlet UILabel *expireDateLabel;
    IBOutlet UITextField *expireDateMonth;
    IBOutlet UITextField *expireDateYear;
    IBOutlet UILabel *cardNameLabel;
    IBOutlet UITextField *cardName;
    IBOutlet UIButton *btAddNewCard;
    
    UITextField *fieldActive;
}

@property (assign, nonatomic) BOOL inEditMode;
@property (strong, nonatomic) NSDictionary *cardInfo;
@property (strong, nonatomic) id<RegisterCardDelegate> delegate;

@end
