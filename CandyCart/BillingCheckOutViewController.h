//
//  BillingCheckOutViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/10/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountriesMenuViewController.h"
#import "ShippingCheckOutViewController.h"
@interface BillingCheckOutViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
{
    CGPoint initialContentOffset;
    CGPoint svos;
    CGRect currentRect;
    
    MBProgressHUD *HUD;
    NSMutableDictionary *userData;
    UIScrollView *scrollView;
    UITextField *billing_firstname;
    UITextField *billing_lastname;
    UITextField *billing_company;
    UITextField *billing_address_1;
    UITextField *billing_address_2;
    UITextField *billing_postcode;
    UITextField *billing_city;
    UITextField *billing_state;
    NSString *billing_state_code;
    BOOL billing_state_has_state;
    UITextField *billing_country;
    NSString *billing_country_code;
    UITextField *billing_phone;
    UITextField *billing_email;
    UIButton *billing_update;

    FPPopoverController *popover;
}
-(void)updateCountryTextField:(NSString*)countryName countryCode:(NSString*)countryCode;
-(void)updateCountryTextField:(NSString*)countryName countryCode:(NSString*)countryCode isDismissPopover:(BOOL)_isDismiss;
-(void)updateStateTextField:(NSString*)stateName stateCode:(NSString*)stateCode;
-(void)updateStateTextFieldNoState;
@end
