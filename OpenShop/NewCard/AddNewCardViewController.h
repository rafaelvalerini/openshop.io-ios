//
//  AddNewCardViewController.h
//  Created by Marcos Lacerda
//

#import <CardIO/CardIO.h>

@protocol RegisterCardDelegate <NSObject>

@required

-(void)cardScanned:(NSDictionary *)cardNumber;

@end

@interface AddNewCardViewController : UIViewController<CardIOViewDelegate> {
    IBOutlet CardIOView *cardIOView;
    IBOutlet UIButton *btInsertManual;
    
    NSDictionary *cardInfo;
}

@property (strong, nonatomic) id<RegisterCardDelegate> delegate;
@property (strong, nonatomic) UINavigationController *nav;

@end
