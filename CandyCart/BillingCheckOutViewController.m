//
//  BillingCheckOutViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/10/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//  Edit by Steven Pham

#import "BillingCheckOutViewController.h"

@interface BillingCheckOutViewController ()

@end

@implementation BillingCheckOutViewController

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
    
    self.title = NSLocalizedString(@"checkout_billing_title", nil);
    userData = [UserAuth instance].userData;
    scrollView = [[UIScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scrollView.alwaysBounceVertical = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(320, 490);
    scrollView.alwaysBounceVertical = YES;
    [self billingForm];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = NSLocalizedString(@"checkout_billing_title", nil);
    [self.view setNeedsDisplay];
    
}

-(void)handleSingleTap:(UITapGestureRecognizer*)tap{
   
    
    [billing_firstname resignFirstResponder];
    [billing_lastname resignFirstResponder];
    [billing_company resignFirstResponder];
    [billing_address_1 resignFirstResponder];
    [billing_address_2 resignFirstResponder];
    [billing_postcode resignFirstResponder];
    [billing_city resignFirstResponder];
    [billing_state resignFirstResponder];
    [billing_country resignFirstResponder];
    [billing_phone resignFirstResponder];
    [billing_email resignFirstResponder];
}


-(void)billingForm
{
    
    billing_firstname = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 145, 40)];
    billing_firstname.placeholder = NSLocalizedString(@"profile_billing_placeholder_firstname", nil);
    billing_firstname.delegate = self;
    billing_firstname.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_first_name"];
    [scrollView addSubview:billing_firstname];
    
    billing_lastname = [[UITextField alloc] initWithFrame:CGRectMake(165, 10, 145, 40)];
    billing_lastname.delegate = self;
    billing_lastname.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_last_name"];
    billing_lastname.placeholder = NSLocalizedString(@"profile_billing_placeholder_lastname", nil);
    [scrollView addSubview:billing_lastname];
    
    
    billing_company = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    billing_company.placeholder = NSLocalizedString(@"profile_billing_placeholder_company", nil);
    billing_company.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_company"];
    billing_company.delegate = self;
    [scrollView addSubview:billing_company];
    
    billing_address_1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    billing_address_1.placeholder = NSLocalizedString(@"profile_billing_placeholder_addressline1", nil);
    billing_address_1.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_address_1"];
    billing_address_1.delegate = self;
    [scrollView addSubview:billing_address_1];
    
    billing_address_2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 160, 300, 40)];
    billing_address_2.placeholder = NSLocalizedString(@"profile_billing_placeholder_addressline2", nil);
    billing_address_2.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_address_2"];
    billing_address_2.delegate = self;
    [scrollView addSubview:billing_address_2];
    
    
    billing_postcode = [[UITextField alloc] initWithFrame:CGRectMake(10, 210, 145, 40)];
    billing_postcode.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_postcode"];
    billing_postcode.delegate = self;
    [billing_postcode setKeyboardType:UIKeyboardTypeNumberPad];
    billing_postcode.placeholder =  NSLocalizedString(@"profile_billing_placeholder_poscode", nil);
    [scrollView addSubview:billing_postcode];
    
    billing_city = [[UITextField alloc] initWithFrame:CGRectMake(165, 210, 145, 40)];
    billing_city.placeholder = NSLocalizedString(@"profile_billing_placeholder_city", nil);
    billing_city.delegate = self;
    billing_city.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_city"];
    [scrollView addSubview:billing_city];
    
    billing_country = [[UITextField alloc] initWithFrame:CGRectMake(10, 260, 300, 40)];
    billing_country.placeholder = NSLocalizedString(@"profile_billing_placeholder_country", nil);
    
    
    billing_country.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_country"];
    billing_country.delegate = self;
    billing_country.enabled = NO;
    
    
    billing_country_code = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_country_code"];
    
    
    [scrollView addSubview:billing_country];
    
    UILabel *transparentCountry = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, 300, 40)];
    transparentCountry.userInteractionEnabled = YES;
    transparentCountry.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:transparentCountry];
    
    UITapGestureRecognizer *transparentCountryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transparentCountryTapAction:)];
    [transparentCountry addGestureRecognizer:transparentCountryTap];
    
    billing_state = [[UITextField alloc] initWithFrame:CGRectMake(10, 310, 300, 40)];
    billing_state.placeholder = NSLocalizedString(@"profile_billing_placeholder_state", nil);
    billing_state.delegate = self;
    billing_state.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_state"];
    [scrollView addSubview:billing_state];
    
    NSNumber *has_state = (NSNumber *)[[userData objectForKey:@"billing_address"] objectForKey:@"billing_has_state"];
    billing_state_has_state = [has_state boolValue];
    
    billing_state_code = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_state_code"];
    
    
    if(billing_state_has_state == true)
    {
        billing_state.enabled = false;
    }
    else
    {
        billing_state.enabled = true;
    }
    
    billing_phone = [[UITextField alloc] initWithFrame:CGRectMake(10, 360, 145, 40)];
    billing_phone.placeholder = NSLocalizedString(@"profile_billing_placeholder_phone", nil);
    billing_phone.delegate = self;
    [billing_phone setKeyboardType:UIKeyboardTypePhonePad];
    billing_phone.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_phone"];
    [scrollView addSubview:billing_phone];
    
    billing_email = [[UITextField alloc] initWithFrame:CGRectMake(165, 360, 145, 40)];
    [billing_email setKeyboardType:UIKeyboardTypeEmailAddress];
    billing_email.placeholder = NSLocalizedString(@"profile_billing_placeholder_email", nil);
    billing_email.delegate = self;
    billing_email.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_email"];
    [scrollView addSubview:billing_email];
    
//    billing_update = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [billing_update addTarget:self
//                       action:@selector(updateBillingAction)
//             forControlEvents:UIControlEventTouchDown];
//    [billing_update setNuiClass:@"LargeButton"];
//    [billing_update setTitle:NSLocalizedString(@"checkout_next_btn_title", nil) forState:UIControlStateNormal];
//    billing_update.frame = CGRectMake(10, 410, 50, 40.0);
//    [scrollView addSubview:billing_update];
//    UIBarButtonItem *btnNext = [[UIBarButtonItem alloc] initWithCustomView:billing_update];
    UIBarButtonItem *btnNext = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"checkout_next_btn_title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(updateBillingAction)];
    self.navigationItem.rightBarButtonItem = btnNext;
}


-(void)updateBillingAction
{
    if([billing_firstname.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message:  NSLocalizedString(@"checkout_billing_error_firstname_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([billing_lastname.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_lastname_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];

    }
    else if([billing_address_1.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_addressline1_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([billing_postcode.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_poscode_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([billing_city.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_city_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([billing_country.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_country_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([billing_state.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_state_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([billing_phone.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_phone_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([billing_email.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_email_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([[ToolClass instance] validateEmail:billing_email.text] == false)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                       message: NSLocalizedString(@"checkout_billing_error_email_invalid", nil)
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
        [HUD showWhileExecuting:@selector(updateBillingActionExe) onTarget:self withObject:nil animated:YES];
        
    }

}

-(void)updateBillingActionExe{
    
    
    if(billing_state.enabled == true)
    {
        billing_state_code = billing_state.text;
    }
    else
    {
        
    }
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:billing_firstname.text forKey:@"billing_first_name"];
    [dic setValue:billing_lastname.text forKey:@"billing_last_name"];
    [dic setValue:billing_company.text forKey:@"billing_company"];
    [dic setValue:billing_address_1.text forKey:@"billing_address_1"];
    [dic setValue:billing_address_2.text forKey:@"billing_address_2"];
    [dic setValue:billing_city.text forKey:@"billing_city"];
    [dic setValue:billing_postcode.text forKey:@"billing_postcode"];
    [dic setValue:billing_state_code forKey:@"billing_state"];
    [dic setValue:billing_country_code forKey:@"billing_country"];
    [dic setValue:billing_phone.text forKey:@"billing_phone"];
    [dic setValue:billing_email.text forKey:@"billing_email"];
    
    NSDictionary *status;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:BUY_METHOD] isEqualToString:@"guest"]) {
        status = [[DataService instance] billing_update:GUEST_USER password:GUEST_PASS arg:dic];
        //Successful
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
            NSMutableDictionary *dic = [newUserData copy];
            [[UserAuth instance] setUserData:dic];
            userData = [[UserAuth instance] userData];
            
            self.title = @"Back";
            
            ShippingCheckOutViewController *shipController = [[ShippingCheckOutViewController alloc] init];
            [self.navigationController pushViewController:shipController animated:YES];
            
        });
    }
    else {
        status = [[DataService instance] billing_update:[UserAuth instance].username password:[UserAuth instance].password arg:dic];
        if([[status objectForKey:@"status"] intValue] == 0)
        {
            //Successful
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
                NSMutableDictionary *dic = [newUserData copy];
                [[UserAuth instance] setUserData:dic];
                userData = [[UserAuth instance] userData];
                
                self.title = @"Back";
                
                ShippingCheckOutViewController *shipController = [[ShippingCheckOutViewController alloc] init];
                [self.navigationController pushViewController:shipController animated:YES];
                
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
}

-(void)transparentCountryTapAction:(UITapGestureRecognizer*)tap{
    
    NSLog(@"Country PopOver");
    
    CountriesMenuViewController *menu = [[CountriesMenuViewController alloc] init];
    menu.title = NSLocalizedString(@"popover_countries_title", nil);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu];
    [menu setBillingController:self];
    popover = [[FPPopoverController alloc] initWithViewController:nav];
    popover.border = NO;
    popover.contentSize = CGSizeMake(300,400);
    [popover.view setNuiClass:@"DropDownView"];
    
    [popover presentPopoverFromView:billing_country];
    
}

-(void)updateCountryTextField:(NSString*)countryName countryCode:(NSString*)countryCode{
    
    billing_country.text = countryName;
    billing_country_code= countryCode;
    
    [popover dismissPopoverAnimated:YES];
}

-(void)updateCountryTextField:(NSString*)countryName countryCode:(NSString*)countryCode isDismissPopover:(BOOL)_isDismiss {
    billing_country.text = countryName;
    billing_country_code= countryCode;
    
    if (_isDismiss)
        [popover dismissPopoverAnimated:YES];
}


-(void)updateStateTextFieldNoState{
    
    billing_state.text = @"";
    billing_state_code = @"";
    billing_state.enabled = true;
}

-(void)updateStateTextField:(NSString*)stateName stateCode:(NSString*)stateCode{
    
    billing_state.text = stateName;
    billing_state_code= stateCode;
    billing_state.enabled = false;
    
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
