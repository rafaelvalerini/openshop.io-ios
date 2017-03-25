//
//  AddNewCardViewController.m
//  Created by Marcos Lacerda
//

#import "AddNewCardViewController.h"
#import "InsertCardManuallyViewController.h"

@interface AddNewCardViewController ()

@end

@implementation AddNewCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCaptions];
}

-(void)viewWillAppear:(BOOL)animated {
    [self configureCardIO];
    [self configureNavigationBar];
    [super viewWillAppear:animated];
    
    cardInfo = nil;
}

#pragma mark - UI Customization

-(void)configureNavigationBar {
    self.title = @"Card Scan";
}

-(void)configureCardIO {
    if ([CardIOUtilities canReadCardWithCamera]) {
        [CardIOUtilities preload];
        
        cardIOView.delegate = self;
        cardIOView.languageOrLocale = @"pt";
        cardIOView.guideColor = [UIColor blackColor];
        cardIOView.hideCardIOLogo = YES;
        cardIOView.scanInstructions = @"";
        cardIOView.detectionMode = CardIODetectionModeCardImageAndNumber;
        cardIOView.scannedImageDuration = 0.0;
        cardIOView.scanExpiry = YES;
        cardIOView.hidden = NO;
    } else {
        cardIOView.hidden = YES;
    }
}

#pragma mark - CardIOViewDelegate 

- (void)cardIOView:(CardIOView *)view didScanCard:(CardIOCreditCardInfo *)info {
    if (info) {
        NSLog(@"Number: %@ \nExpiry: %02lu/%lu \nCVV: %@", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv);
        
        cardInfo = @{@"cardNumber" : info.cardNumber, @"expireMonth" : [NSString stringWithFormat:@"%li", info.expiryMonth], @"expireYear" : [NSString stringWithFormat:@"%li", info.expiryYear]};
        
        [self insertManuallyCardClick:nil];

        cardIOView.hidden = YES;
    }
}

#pragma mark - Internationalizations

-(void)initCaptions {
    [btInsertManual setTitle:@"Insert Manually" forState:UIControlStateNormal];
}

#pragma mark - Actions

-(IBAction)insertManuallyCardClick:(id)sender {
    InsertCardManuallyViewController *insertCardManuallyController = [[InsertCardManuallyViewController alloc] init];
    UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:insertCardManuallyController];
    
    insertCardManuallyController.cardInfo = cardInfo;
    insertCardManuallyController.inEditMode = NO;
    insertCardManuallyController.delegate = _delegate;
    
    [self.navigationController presentViewController:rootController animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
