//
//  ProfileViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountriesMenuViewController.h"
#import "MyOrderViewController.h"
@interface ProfileViewController : UIViewController<MBProgressHUDDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGPoint initialContentOffset;
    CGPoint svos;
    CGRect currentRect;
    
    
    UISegmentedControl *segmentControl;
    UIScrollView *scrollView;
    MBProgressHUD *HUD;
    //Sign In
    UIView *loginForm;
    UITextField *username;
    UITextField *password;
    UIButton *lostPassword;
    UIButton *loginBtn;
    
    //Sign Up
    UIView *signUpForm;
    UITextField *usernameSignUp;
    UITextField *emailSignUp;
    UITextField *firstNameSignUp;
    UITextField *lastNameSignUp;
    UITextField *passwordSignUp;
    UITextField *retypepasswordSignUp;
    UIButton *signUpBtn;
    
    
    //Logged
    UIView *myProfileForm;
    NSMutableDictionary *userData;
    UIImageView *profileImg;
    
    UITextField *usernameLogin;
    UITextField *emailLogin;
    UITextField *firstNameLogin;
    UITextField *lastNameLogin;
    UITextField *display_name;
    UITextField *emailLoggedLogin;
    UIButton *profileUpdate;
    
    
    UIView *billingForm;
    UILabel *lblBillingLbl;
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
    
    
    UIActivityIndicatorView *spinner;
    
    
    UITextField *account_username;
    UITextField *account_current_password;
    UITextField *account_new_password;
    UITextField *account_retype_password;
    UIButton *account_update;
    
    FPPopoverController *popover;
    
    UIBarButtonItem *btnCamera;
}
-(void)updateCountryTextField:(NSString*)countryName countryCode:(NSString*)countryCode;
-(void)updateCountryTextField:(NSString*)countryName countryCode:(NSString*)countryCode isDismissPopover:(BOOL)_isDismiss;
-(void)updateStateTextField:(NSString*)stateName stateCode:(NSString*)stateCode;
-(void)updateStateTextFieldNoState;
@end
