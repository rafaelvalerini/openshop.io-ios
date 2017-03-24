//
//  InsertCardManuallyViewController.h
//  Created by Marcos Lacerda
//

#import "InsertCardManuallyViewController.h"

@interface InsertCardManuallyViewController ()

@end

@implementation InsertCardManuallyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self initCaptions];
    
    if (_cardInfo) {
        [self populateCardInfo];
    } else {
        [self loadImages:nil];
    }
}

#pragma mark - UICustomizations

-(void)configureNavigationBar {
    self.title = @"Add New Card";
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAddNewCard)];
    
    self.navigationItem.leftBarButtonItem = btCancel;
}

-(void)loadImages:(NSString *)cardNumber {
    cardFlag.image = nil;
    
    if (cardNumber) {
        cardFlag.layer.borderWidth = 1.0;
        cardFlag.layer.borderColor = [UIColor blackColor].CGColor;
    }
}

-(void)populateCardInfo {
    NSString *cardNumber = _cardInfo[@"cardNumber"];
    
    // Load Flag Card
    [self loadImages:cardNumber];
    
    // Populate card Number Fields
    if (![cardNumber isEqualToString:@""]) {
        cardNumber_block_1.text = [cardNumber substringToIndex:4];
        cardNumber_block_2.text = [cardNumber substringWithRange:(NSRange) {4, 4}];
        cardNumber_block_3.text = [cardNumber substringWithRange:(NSRange) {8, 4}];
        cardNumber_block_4.text = [cardNumber substringFromIndex:12];
    }
    
    // Month & Year Expires
    if ([_cardInfo[@"expireMonth"] intValue] > 0) {
        expireDateMonth.text = [NSString stringWithFormat:@"%02d", [_cardInfo[@"expireMonth"] intValue]];
    }
    
    if ([_cardInfo[@"expireYear"] intValue] > 0) {
        expireDateYear.text = [NSString stringWithFormat:@"%02d", [_cardInfo[@"expireYear"] intValue]];
    }
    
    // Name in Card
    cardName.text = _cardInfo[@"name"];
}

#pragma mark - Internationalization

-(void)initCaptions {
    cardNumberLabel.text = @"Card Number";
    expireDateLabel.text = @"Expiration Date";
    cardNameLabel.text = @"Name Printed on Card";
    
    NSString *placeHolder = @"XXXX";
    
    cardNumber_block_1.placeholder = placeHolder;
    cardNumber_block_2.placeholder = placeHolder;
    cardNumber_block_3.placeholder = placeHolder;
    cardNumber_block_4.placeholder = placeHolder;
    
    cardName.placeholder = @"Name";
    
    [btAddNewCard setTitle:@"Save" forState:UIControlStateNormal];
}

#pragma mark - Actions

-(void)cancelAddNewCard {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)addNewCardClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *cardNumber = [NSString stringWithFormat:@"%@%@%@%@", cardNumber_block_1.text, cardNumber_block_2.text, cardNumber_block_3.text, cardNumber_block_4.text];
    
    if (_delegate) {
        NSDictionary *cardInfo = @{@"cardNumber" : cardNumber, @"expireMonth" : [NSString stringWithFormat:@"%@", expireDateMonth.text], @"expireYear" : [NSString stringWithFormat:@"%@", expireDateYear.text]};
        
        [_delegate cardScanned:cardInfo];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (fieldActive != cardNumber_block_1 && fieldActive != cardNumber_block_2 && fieldActive != cardNumber_block_3 && fieldActive != cardNumber_block_4) {
        [self animateTextField:fieldActive up:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    
    numberToolbar.barStyle = UIBarStyleDefault;
    fieldActive = textField;
    
    if (![textField.text isEqualToString:@""] && textField != cardName) {
        [textField selectAll:self];
    }
    
    if (textField == cardNumber_block_1) {
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:nil],
                               
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               
                               [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(next)],
                               nil];
    } else if (textField == cardNumber_block_2 || textField == cardNumber_block_3) {
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previous)],
                               
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               
                               [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(next)],
                               nil];
    } else if (textField == cardNumber_block_4 || textField == expireDateYear) {
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previous)],
                               
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               
                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)],
                               nil];
    } else if (textField == expireDateMonth) {
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:nil],
                               
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               
                               [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(next)],
                               nil];
    }
    
    [numberToolbar sizeToFit];
    textField.inputAccessoryView = numberToolbar.items && numberToolbar.items.count > 0 ? numberToolbar : nil;
    
    if (fieldActive != cardNumber_block_1 && fieldActive != cardNumber_block_2 && fieldActive != cardNumber_block_3 && fieldActive != cardNumber_block_4) {
        [self animateTextField:fieldActive up:YES];
    }
}

-(void)previous {
    if (fieldActive == cardNumber_block_4) {
        [cardNumber_block_3 becomeFirstResponder];
    } else if (fieldActive == cardNumber_block_3) {
        [cardNumber_block_2 becomeFirstResponder];
    } else if (fieldActive == cardNumber_block_2) {
        [cardNumber_block_1 becomeFirstResponder];
    } else if (fieldActive == expireDateYear) {
        [expireDateMonth becomeFirstResponder];
    }
}

-(void)next {
    if (fieldActive == cardNumber_block_1) {
        [cardNumber_block_2 becomeFirstResponder];
    } else if (fieldActive == cardNumber_block_2) {
        [cardNumber_block_3 becomeFirstResponder];
    } else if (fieldActive == cardNumber_block_3) {
        [cardNumber_block_4 becomeFirstResponder];
    } else if (fieldActive == expireDateMonth) {
        [expireDateYear becomeFirstResponder];
    }
}

-(void)done {
    if (fieldActive == cardNumber_block_4) {
        [cardNumber_block_4 endEditing:YES];
    } else if (fieldActive == expireDateYear) {
        [expireDateYear endEditing:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == cardName) {
        return YES;
    }
    
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == expireDateMonth || textField == expireDateYear) {
        if (newLength == 2) {
            UIResponder *nextResponder = [textField.superview viewWithTag:textField.tag + 1];
            
            if (nextResponder) {
                [nextResponder performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
            } else {
                [textField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.1];
            }
        }
    } else if (newLength == 4) {
        UIResponder *nextResponder = [textField.superview viewWithTag:textField.tag + 1];
        
        if (nextResponder && textField.tag < 3) {
            [nextResponder performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
        } else {
            [textField performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.1];
        }
    }
    
    return newLength <= 4;
}

#pragma mark - View methods

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Keyboard methods

-(void)animateTextField:(UITextField*)textField up:(BOOL)up {
    const int movementDistance = -110;
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
