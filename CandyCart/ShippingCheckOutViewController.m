//
//  BillingCheckOutViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/10/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ShippingCheckOutViewController.h"

@interface ShippingCheckOutViewController ()

@end

@implementation ShippingCheckOutViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.view setNuiClass:@"ViewInit"];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"checkout_shipping_title", nil);
    userData = [UserAuth instance].userData;
    scrollView = [[UIScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scrollView.alwaysBounceVertical = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(320, 560);
    scrollView.alwaysBounceVertical = YES;
    [self shippingForm];
    
    
    UIButton *clearForm = [UIButton buttonWithType:UIButtonTypeCustom];
    clearForm.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    clearForm.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [clearForm setTitle:NSLocalizedString(@"checkout_shipping_clear_btn", nil) forState:UIControlStateNormal];
    [clearForm addTarget:self
             action:@selector(clearForm)
   forControlEvents:UIControlEventTouchDown];
    
    [clearForm setNuiClass:@"UiBarButtonItem"];
    [clearForm.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:clearForm];
    self.navigationItem.rightBarButtonItem = button;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
}

-(void)clearForm{
    purchaseNote.text = @"";
    shipping_firstname.text = @"";
    shipping_lastname.text = @"";
    shipping_company.text = @"";
    shipping_address_1.text = @"";
    shipping_address_2.text = @"";
    shipping_postcode.text = @"";
    shipping_city.text = @"";
    shipping_state.text = @"";
    shipping_country.text = @"";
    
    
}

-(void)handleSingleTap:(UITapGestureRecognizer*)tap{
   
    [purchaseNote resignFirstResponder];
    [shipping_firstname resignFirstResponder];
    [shipping_lastname resignFirstResponder];
    [shipping_company resignFirstResponder];
    [shipping_address_1 resignFirstResponder];
    [shipping_address_2 resignFirstResponder];
    [shipping_postcode resignFirstResponder];
    [shipping_city resignFirstResponder];
    [shipping_state resignFirstResponder];
    [shipping_country resignFirstResponder];
    
}


-(void)shippingForm
{
    
    shipping_update_same_as_billing = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shipping_update_same_as_billing addTarget:self
                        action:@selector(sameAsBillingAction)
              forControlEvents:UIControlEventTouchDown];
    [shipping_update_same_as_billing setNuiClass:@"LargeButton"];
    [shipping_update_same_as_billing setTitle:NSLocalizedString(@"checkout_shipping_next_same_as_billing_btn", nil) forState:UIControlStateNormal];
    shipping_update_same_as_billing.frame = CGRectMake(10, 10, 300, 40);
    [scrollView addSubview:shipping_update_same_as_billing];
    
    
    
    purchaseNote = [[SZTextView alloc] initWithFrame:CGRectMake(10, 60, 300, 90)];
    purchaseNote.placeholder = NSLocalizedString(@"checkout_shipping_note_order", nil);
    
    purchaseNote.placeholderTextColor = [UIColor lightGrayColor];
    purchaseNote.font = [UIFont fontWithName:PRIMARYFONT size:12.0];
    purchaseNote.layer.cornerRadius = 8;
    purchaseNote.layer.borderWidth = 0.5;
    purchaseNote.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [scrollView addSubview:purchaseNote];
    
    shipping_firstname = [[UITextField alloc] initWithFrame:CGRectMake(10, 160, 145, 40)];
    shipping_firstname.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_firstname", nil);
    shipping_firstname.delegate = self;
    shipping_firstname.text = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_first_name"];
    [scrollView addSubview:shipping_firstname];
    
    shipping_lastname = [[UITextField alloc] initWithFrame:CGRectMake(165, 160, 145, 40)];
    shipping_lastname.delegate = self;
    shipping_lastname.text = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_last_name"];
    shipping_lastname.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_lastname", nil);
    [scrollView addSubview:shipping_lastname];
    
    
    shipping_company = [[UITextField alloc] initWithFrame:CGRectMake(10, 210, 300, 40)];
    shipping_company.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_company", nil);
    shipping_company.text = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_company"];
    shipping_company.delegate = self;
    [scrollView addSubview:shipping_company];
    
    shipping_address_1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 260, 300, 40)];
    shipping_address_1.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_addressline1", nil);
    shipping_address_1.text = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_address_1"];
    shipping_address_1.delegate = self;
    [scrollView addSubview:shipping_address_1];
    
    shipping_address_2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 310, 300, 40)];
    shipping_address_2.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_addressline2", nil);
    shipping_address_2.text = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_address_2"];
    shipping_address_2.delegate = self;
    [scrollView addSubview:shipping_address_2];
    
    
    shipping_postcode = [[UITextField alloc] initWithFrame:CGRectMake(10, 360, 145, 40)];
    shipping_postcode.text = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_postcode"];
    shipping_postcode.delegate = self;
    [shipping_postcode setKeyboardType:UIKeyboardTypeNumberPad];
    shipping_postcode.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_poscode", nil);
    [scrollView addSubview:shipping_postcode];
    
    shipping_city = [[UITextField alloc] initWithFrame:CGRectMake(165, 360, 145, 40)];
    shipping_city.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_city", nil);
    shipping_city.delegate = self;
    shipping_city.text = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_city"];
    [scrollView addSubview:shipping_city];
    
    
    
    
    shipping_country = [[UITextField alloc] initWithFrame:CGRectMake(10, 410, 300, 40)];
    shipping_country.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_country", nil);
    
    
    shipping_country.text = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_country"];
    shipping_country.delegate = self;
    shipping_country.enabled = NO;
    
    
    shipping_country_code = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_country_code"];
    
    
    [scrollView addSubview:shipping_country];
    
    UILabel *transparentCountry = [[UILabel alloc] initWithFrame:CGRectMake(10, 410, 300, 40)];
    transparentCountry.userInteractionEnabled = YES;
    transparentCountry.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:transparentCountry];
    
    UITapGestureRecognizer *transparentCountryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transparentCountryTapAction:)];
    [transparentCountry addGestureRecognizer:transparentCountryTap];
    
    
    
    
    
    shipping_state = [[UITextField alloc] initWithFrame:CGRectMake(10, 460, 300, 40)];
    shipping_state.placeholder = NSLocalizedString(@"checkout_shipping_placeholder_state", nil);
    shipping_state.delegate = self;
    shipping_state.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_state"]];
    [scrollView addSubview:shipping_state];
    
    NSNumber *has_state = (NSNumber *)[[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_has_state"];
    shipping_state_has_state = [has_state boolValue];
    
    shipping_state_code = [[userData objectForKey:@"shipping_address"] objectForKey:@"shipping_state_code"];
    
    
    if(shipping_state_has_state == true)
    {
        shipping_state.enabled = false;
    }
    else
    {
        shipping_state.enabled = true;
    }
    
        
    
    shipping_update = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shipping_update addTarget:self
                       action:@selector(updateshippingAction)
             forControlEvents:UIControlEventTouchDown];
    [shipping_update setNuiClass:@"LargeButton"];
    [shipping_update setTitle:NSLocalizedString(@"checkout_shipping_next_btn", nil) forState:UIControlStateNormal];
    shipping_update.frame = CGRectMake(10, 510, 300, 40.0);
    [scrollView addSubview:shipping_update];
    
}

-(void)sameAsBillingAction{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(sameAsBillingActionExe) onTarget:self withObject:nil animated:YES];
    
}

-(void)sameAsBillingActionExe{
    
    //Set Order Notes
    [[MyCartClass instance] setOrderNotes:purchaseNote.text];
    
    //Set Shipping Detail same as billing
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_first_name"] forKey:@"shipping_first_name"];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_last_name"] forKey:@"shipping_last_name"];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_company"] forKey:@"shipping_company"];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_address_1"] forKey:@"shipping_address_1"];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_address_2"] forKey:@"shipping_address_2"];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_city"] forKey:@"shipping_city"];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_postcode"] forKey:@"shipping_postcode"];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_state_code"] forKey:@"shipping_state"];
    [dic setValue:[[userData objectForKey:@"billing_address"] objectForKey:@"billing_country_code"] forKey:@"shipping_country"];
    
    
    NSDictionary *status = [[DataService instance] shipping_update:[UserAuth instance].username password:[UserAuth instance].password arg:dic];
    
    
    NSDictionary *reviewData = [[DataService instance] reviewCartWithCoupon:[UserAuth instance].username password:[UserAuth instance].password productInJsonString:[[MyCartClass instance] productIDToJsonString] coupon:[[MyCartClass instance] couponToJsonString]];
    
    
    [[MyCartClass instance] setServerCart:reviewData];
    
    if([[status objectForKey:@"status"] intValue] == 0)
    {
        //Successful
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
            NSMutableDictionary *dic = [newUserData copy];
            [[UserAuth instance] setUserData:dic];
            userData = [[UserAuth instance] userData];
            
            ReviewCheckOutViewController *review = [[ReviewCheckOutViewController alloc] init];
            [self.navigationController pushViewController:review animated:YES];
            
        });
        
    }
    else
    {
        //Session Expired or Username & password wrong
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                           message: NSLocalizedString(@"general_notification_error_loginwaschange", nil)
                                                          delegate: nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil)
,nil];
            
            
            [alert show];
            
        });
    }
}

-(void)updateshippingAction
{
    
    if([shipping_firstname.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)

                                                       message: NSLocalizedString(@"checkout_shipping_error_firstname_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }else if([shipping_lastname.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)

                                                       message: NSLocalizedString(@"checkout_shipping_error_lastname_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];

    }
    else if([shipping_address_1.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)

                                                       message: NSLocalizedString(@"checkout_shipping_error_addressline1_empty", nil)                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([shipping_postcode.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)

                                                       message: NSLocalizedString(@"checkout_shipping_error_poscode_empty", nil) 
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([shipping_city.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)

                                                       message: NSLocalizedString(@"checkout_shipping_error_city_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([shipping_country.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)

                                                       message: NSLocalizedString(@"checkout_shipping_error_country_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([shipping_state.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                              
                                                       message: NSLocalizedString(@"checkout_shipping_error_state_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(updateshippingActionExe) onTarget:self withObject:nil animated:YES];
        
    }

}

-(void)updateshippingActionExe{
    
    
    if(shipping_state.enabled == true)
    {
        shipping_state_code = shipping_state.text;
    }
    else
    {
        
    }
    
    //Set Order Notes
    [[MyCartClass instance] setOrderNotes:purchaseNote.text];
    
    //Update Shipping
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:shipping_firstname.text forKey:@"shipping_first_name"];
    [dic setValue:shipping_lastname.text forKey:@"shipping_last_name"];
    [dic setValue:shipping_company.text forKey:@"shipping_company"];
    [dic setValue:shipping_address_1.text forKey:@"shipping_address_1"];
    [dic setValue:shipping_address_2.text forKey:@"shipping_address_2"];
    [dic setValue:shipping_city.text forKey:@"shipping_city"];
    [dic setValue:shipping_postcode.text forKey:@"shipping_postcode"];
    [dic setValue:shipping_state_code forKey:@"shipping_state"];
    [dic setValue:shipping_country_code forKey:@"shipping_country"];
    
    
    NSDictionary *status = [[DataService instance] shipping_update:[UserAuth instance].username password:[UserAuth instance].password arg:dic];
    
    
    NSDictionary *reviewData = [[DataService instance] reviewCartWithCoupon:[UserAuth instance].username password:[UserAuth instance].password productInJsonString:[[MyCartClass instance] productIDToJsonString] coupon:[[MyCartClass instance] couponToJsonString]];
    
    
    [[MyCartClass instance] setServerCart:reviewData];
    
    NSLog(@"Review Data %@",reviewData);
    if([[status objectForKey:@"status"] intValue] == 0)
    {
        //Successful
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
            NSMutableDictionary *dic = [newUserData copy];
            [[UserAuth instance] setUserData:dic];
            userData = [[UserAuth instance] userData];
            
            
            ReviewCheckOutViewController *review = [[ReviewCheckOutViewController alloc] init];
            [self.navigationController pushViewController:review animated:YES];

            
        });
       
    }
    else
    {
        //Session Expired or Username & password wrong
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                  
                                                           message: NSLocalizedString(@"general_notification_error_loginwaschange", nil)
                                                          delegate: nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
            
            
            [alert show];
            
        });
        
        
    }

    
}

-(void)transparentCountryTapAction:(UITapGestureRecognizer*)tap{
    
    NSLog(@"Country PopOver");
    
    CountriesMenuViewController *menu = [[CountriesMenuViewController alloc] init];
     menu.title = NSLocalizedString(@"popover_countries_title", nil);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu];
    [menu setShippingController:self];
    
    popover = [[FPPopoverController alloc] initWithViewController:nav];
    popover.border = NO;
    popover.contentSize = CGSizeMake(300,400);
    [popover.view setNuiClass:@"DropDownView"];
    
    [popover presentPopoverFromView:shipping_country];
    
}

-(void)updateCountryTextField:(NSString*)countryName countryCode:(NSString*)countryCode {
    
    shipping_country.text = countryName;
    shipping_country_code= countryCode;
    
    [popover dismissPopoverAnimated:YES];
}

-(void)updateCountryTextField:(NSString*)countryName countryCode:(NSString*)countryCode isDismissPopover:(BOOL)_isDismiss {
    shipping_country.text = countryName;
    shipping_country_code= countryCode;
    
    if (_isDismiss)
        [popover dismissPopoverAnimated:YES];
}


-(void)updateStateTextFieldNoState{
    shipping_state.text = @"";
    shipping_state_code = @"";
    shipping_state.enabled = true;
}

-(void)updateStateTextField:(NSString*)stateName stateCode:(NSString*)stateCode{
    
    shipping_state.text = stateName;
    shipping_state_code= stateCode;
    shipping_state.enabled = false;
    
    [popover dismissPopoverAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViews
{
    initialContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViews
{
    
    [[SettingDataClass instance] autoHideGlobal:scrollView navigationView:self.navigationController contentOffset:initialContentOffset];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    svos = scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [scrollView setContentOffset:pt animated:YES];
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
