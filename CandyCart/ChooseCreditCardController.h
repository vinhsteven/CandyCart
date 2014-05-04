//
//  ChooseCreditCardController.h
//  Mindful Minerals
//
//  Created by Dead Mac on 1/29/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "MyCartBox.h"
#import "ReviewCheckOutViewController.h"
#import "CreditCardController.h"

@interface ChooseCreditCardController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
{
     MGScrollView *scroller;
    NSArray *user_payment;
    UILabel *paymentMethodLabel;
    ReviewCheckOutViewController *review;
    BOOL returnCustomer;
}
-(void)use_as_return_customer;
-(void)getPaymentMethodLabel:(UILabel*)lbl;
@end
