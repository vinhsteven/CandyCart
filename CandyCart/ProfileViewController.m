//
//  ProfileViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ProfileViewController.h"
#import "ListCameraViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"tabb_bar_profile", nil);
        self.tabBarItem.image = [UIImage imageNamed:NSLocalizedString(@"tabb_bar_profile_image", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setNuiClass:@"ViewInit"];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"Height Pro %f",[[DeviceClass instance] getResizeScreen:NO].size.height);
    scrollView = [[UIScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scrollView.alwaysBounceVertical = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    segmentControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"profile_tab_signin", nil),NSLocalizedString(@"profile_tab_signup", nil)]];
    segmentControl.frame = CGRectMake(10, 10, 300, 40);
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(valueChanged) forControlEvents: UIControlEventValueChanged];
   
    [scrollView addSubview:segmentControl];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    //Init
    [self autoLogin];
    [self.view setNeedsDisplay];
    
    //init button to add camera
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpButton.frame = CGRectMake(0, 0, 44, 44);
    [tmpButton setBackgroundImage:[UIImage imageNamed:@"icon-camera.png"] forState:UIControlStateNormal];
    [tmpButton addTarget:self action:@selector(tapCameraAction) forControlEvents:UIControlEventTouchUpInside];
    
    btnCamera = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
//    btnCamera = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"profileViewController.button-camera", nil) style:UIBarButtonItemStylePlain target:self action:@selector(tapCameraAction)];
//    self.navigationItem.rightBarButtonItem = btnCamera;
}

- (void) viewWillAppear:(BOOL)animated {
    [self listCameraOfMerchant];
}

- (void) listCameraOfMerchant {
    //get database URL of user by email or username
    NSString *decryptedUsername = [AppDelegate getDecryptedData:[AppDelegate getUsernameAuthorizeCouchDB]];
    NSString *decryptedPassword = [AppDelegate getDecryptedData:[AppDelegate getPasswordAuthorizeCouchDB]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@:3001/get_user",[AppDelegate getCouchDBUrl]];
    
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.listCameraOfMerchant", NULL);
    dispatch_async(queue, ^(void) {
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        request.requestMethod = @"POST";
        request.username = decryptedUsername;
        request.password = decryptedPassword;
        
        [request addPostValue:ROOT_ACCOUNT forKey:@"username"];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!error) {
                NSString *response = [request responseString];
                
                NSMutableDictionary *dict = [response JSONValue];
                
                //check status of this user
                BOOL status = [[dict objectForKey:@"status"] boolValue];
                
                if (status) {
                    BOOL isPublicCamera = NO;
                    NSMutableArray *cameraList = [dict objectForKey:@"cameralist"];
                    if ([cameraList isKindOfClass:[NSMutableArray class]]) {
                        for (int i=0;i < [cameraList count];i++) {
                            NSMutableDictionary *cameraDict = [cameraList objectAtIndex:i];
                            BOOL isPublic = [[cameraDict objectForKey:@"isCameraPublic"] boolValue];
                            if (isPublic) {
                                isPublicCamera = YES;
                                break;
                            }
                        }
                        if (isPublicCamera)
                            self.navigationItem.rightBarButtonItem = btnCamera;
                        else
                            self.navigationItem.rightBarButtonItem = nil;
                        
                    }
                    else
                        self.navigationItem.rightBarButtonItem = nil;
                }
            }
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

- (void) tapCameraAction {
    ListCameraViewController *controller = [[ListCameraViewController alloc] initWithNibName:@"ListCameraViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)handleSingleTap:(UITapGestureRecognizer*)tap{
    
    [account_new_password resignFirstResponder];
    [account_retype_password resignFirstResponder];
    [account_current_password resignFirstResponder];
    
    [usernameSignUp resignFirstResponder];
    [emailSignUp resignFirstResponder];
    [firstNameSignUp resignFirstResponder];
    [lastNameSignUp resignFirstResponder];
    [passwordSignUp resignFirstResponder];
    [retypepasswordSignUp resignFirstResponder];
    
    [username resignFirstResponder];
    [password resignFirstResponder];

    [usernameLogin resignFirstResponder];
    [emailLogin resignFirstResponder];
    [firstNameLogin resignFirstResponder];
    [lastNameLogin resignFirstResponder];
    [display_name resignFirstResponder];
    [emailLoggedLogin resignFirstResponder];
    
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

-(void)valueChanged{
    
    //For SignIn/SignUp
    
    if(segmentControl.selectedSegmentIndex == 0)
    {
        [usernameSignUp removeFromSuperview];
        [emailSignUp removeFromSuperview];
        [firstNameSignUp removeFromSuperview];
        [lastNameSignUp removeFromSuperview];
        [passwordSignUp removeFromSuperview];
        [retypepasswordSignUp removeFromSuperview];
        [signUpBtn removeFromSuperview];
       
        [self signInForm];
    }
    
    else
    {
         [lostPassword removeFromSuperview];
        [username removeFromSuperview];
        [password removeFromSuperview];
        [loginBtn removeFromSuperview];
        [self signUpForm];
    }
}

-(void)loginBtnAction{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.delegate = self;
	[HUD showWhileExecuting:@selector(loginBtnActionExe) onTarget:self withObject:nil animated:YES];
    
}


-(void)autoLogin{
    if([[UserAuth instance] checkUserAlreadyLogged] == YES)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(autoLoginExe) onTarget:self withObject:nil animated:YES];
    }
    else
    {
         [self signInForm];
    }
}


-(void)autoLoginExe{
    NSDictionary * user_data = [[DataService instance] user_login:[UserAuth instance].username password:[UserAuth instance].password];
    
    if([[user_data objectForKey:@"status"] intValue] == 0)
    {
        //Successful Logged
        [[UserAuth instance] setUserDatas:[user_data objectForKey:@"user"]];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        [[DataService instance] pushNotificationApi];
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            userData = [UserAuth instance].userData;
            
            [[UserAuth instance] setAlreadyLoggedIn:YES];
            [self loggedView];
            
            [[MainViewClass instance].rightView setItems:[DataService instance].pushNotifications];
            [[MainViewClass instance].rightView.tbl reloadData];
        });
    }
    else
    {
        //Not SuccessFull
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                           message: NSLocalizedString(@"general_notification_error_loginwaschange", nil)
                                                          delegate: nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
            
            
            [alert show];
            
            [[UserAuth instance] setAlreadyLoggedIn:NO];
            [self loggout];
            
        });
        
        
    }

}

-(void)loginBtnActionExe
{
    
    NSDictionary * user_data = [[DataService instance] user_login:username.text password:password.text];
    
    
    if([[user_data objectForKey:@"status"] intValue] == 0)
    {
        //Successful Logged
        
        
         [[UserAuth instance] setUserDatas:[user_data objectForKey:@"user"]];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            userData = [UserAuth instance].userData;
            [[UserAuth instance] saveAuthorizedStatus:username.text password:password.text];
             [[UserAuth instance] setAlreadyLoggedIn:YES];
            [self loggedView];
            
            [[DataService instance] pushNotificationApi];
            
            [[MainViewClass instance].rightView setItems:[DataService instance].pushNotifications];
            [[MainViewClass instance].rightView.tbl reloadData];
        });
    }
    else
    {
        //Not SuccessFull
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                           message: NSLocalizedString(@"profile_signin_error", nil)
                                                          delegate: nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK",nil];
            
            
            [alert show];
            
             [[UserAuth instance] setAlreadyLoggedIn:NO];
        });
    }
}


-(void)signUpBtnAction{
    
   
    
    if([usernameSignUp.text length] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)
                                                       message: NSLocalizedString(@"profile_signup_error_username_empty", nil)

                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([emailSignUp.text length] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_signup_error_email_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];

    }
    else if([[ToolClass instance] validateEmail:emailSignUp.text] == false)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_signup_error_email_invalid", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([firstNameSignUp.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_signup_error_firstname_empty", nil)                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([lastNameSignUp.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_signup_error_lastname_empty", nil)                                                        delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([passwordSignUp.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_signup_error_password_empty", nil)                                                        delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([passwordSignUp.text length] < 5)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_signup_error_password_atleast", nil) 
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([retypepasswordSignUp.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_signup_error_password_retype", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if(![passwordSignUp.text isEqualToString:retypepasswordSignUp.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_signup_error_password_unmatch", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else
    {
         NSLog(@"Sign Up");
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(signUpExe) onTarget:self withObject:nil animated:YES];
        
    }

}

-(void)signUpExe
{
    NSDictionary *status = [[DataService instance] user_registration:usernameSignUp.text email:emailSignUp.text firstname:firstNameSignUp.text lastname:lastNameSignUp.text password:passwordSignUp.text];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
     if([[status objectForKey:@"status"] intValue] == 1)
     {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                        message: NSLocalizedString(@"profile_signup_error_username_exist", nil)
                                                       delegate: nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK",nil];
         
         
         [alert show];
     }
     else if([[status objectForKey:@"status"] intValue] == 2)
     {
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                        message: NSLocalizedString(@"profile_signup_error_email_exist", nil)
                                                       delegate: nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK",nil];
         
         
         [alert show];
     }
    else
     {
         NSLog(@"Successful sign up");
         
         [[UserAuth instance] setUserDatas:[status objectForKey:@"user"]];
         
         
         [[UserAuth instance] saveAuthorizedStatus:usernameSignUp.text password:passwordSignUp.text];
         userData = [UserAuth instance].userData;
         [[UserAuth instance] setAlreadyLoggedIn:YES];
         [self loggedView];
         
        
      
     }
        
        
    });
    
}

-(void)loggedView{
    [scrollView removeFromSuperview];
    
    scrollView = [[UIScrollView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
    scrollView.alwaysBounceVertical = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];

    segmentControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"profile_tab_my_profile", nil),NSLocalizedString(@"profile_tab_my_account", nil),NSLocalizedString(@"profile_tab_my_order", nil),NSLocalizedString(@"profile_tab_logout", nil)]];
    segmentControl.frame = CGRectMake(10, 10, 300, 40);
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(segmentLoggedChange) forControlEvents: UIControlEventValueChanged];
    
    [scrollView addSubview:segmentControl];
    
    
    [self myProfile];
   
   // scrollView.opaque = YES;
    
}

-(void)removeMyProfile
{
    [profileImg removeFromSuperview];
    [firstNameLogin removeFromSuperview];
     [lastNameLogin removeFromSuperview];
    [display_name removeFromSuperview];
    [emailLoggedLogin removeFromSuperview];
    [profileUpdate removeFromSuperview];
    
    [lblBillingLbl removeFromSuperview];
    [billing_firstname removeFromSuperview];
    [billing_lastname removeFromSuperview];
    [billing_company removeFromSuperview];
    [billing_address_1 removeFromSuperview];
    [billing_address_2 removeFromSuperview];
    [billing_postcode removeFromSuperview];
    [billing_city removeFromSuperview];
    [billing_state removeFromSuperview];
    [billing_country removeFromSuperview];
    [billing_phone removeFromSuperview];
    [billing_email removeFromSuperview];
    [billing_update removeFromSuperview];
}

-(void)segmentLoggedChange{
   
    if(segmentControl.selectedSegmentIndex == 0)
    {
         NSLog(@"My Profile");
        [self removeAccountForm];
        [self myProfile];
    }
    else if(segmentControl.selectedSegmentIndex == 1)
    {
        NSLog(@"Account");
        [self removeMyProfile];
        [self acccountForm];
    }
    else if(segmentControl.selectedSegmentIndex == 2)
    {
         NSLog(@"My Order");
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(goToMyOrderViewExe) onTarget:self withObject:nil animated:YES];

    }
    else if(segmentControl.selectedSegmentIndex == 3)
    {
        NSLog(@"Logout");
        [self loggout];
    }
}


-(void)removeAccountForm{
    
    [account_username removeFromSuperview];
    [account_current_password removeFromSuperview];
    [account_new_password removeFromSuperview];
    [account_retype_password removeFromSuperview];
    [account_update removeFromSuperview];
}

-(void)acccountForm{
    [self removeAccountForm];
   scrollView.contentSize = CGSizeMake(320, 504);
    
    account_username = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, 300, 40)];
    account_username.placeholder = NSLocalizedString(@"profile_account_placeholder_username", nil);
    account_username.delegate = self;
    account_username.enabled = NO;
    [account_username setNuiClass:@"TextFieldDisable"];
   
    account_username.text = [userData objectForKey:@"user_login"];
    [scrollView addSubview:account_username];
    
    
    account_current_password = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, 300, 40)];
    account_current_password.secureTextEntry = YES;
    account_current_password.placeholder = NSLocalizedString(@"profile_account_placeholder_currentpassword", nil);
    account_current_password.delegate = self;

    [scrollView addSubview:account_current_password];
    
    
    account_new_password = [[UITextField alloc] initWithFrame:CGRectMake(10, 170, 300, 40)];
     account_new_password.secureTextEntry = YES;
    account_new_password.placeholder =NSLocalizedString(@"profile_account_placeholder_newpassword", nil);
    account_new_password.delegate = self;
   
    [scrollView addSubview:account_new_password];
    
    account_retype_password = [[UITextField alloc] initWithFrame:CGRectMake(10, 220, 300, 40)];
    account_retype_password.secureTextEntry = YES;
    account_retype_password.placeholder = NSLocalizedString(@"profile_account_placeholder_retypepassword", nil);
    account_retype_password.delegate = self;
    
    [scrollView addSubview:account_retype_password];
    
    
    account_update = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [account_update addTarget:self
                       action:@selector(updateAccExe)
             forControlEvents:UIControlEventTouchDown];
    [account_update setNuiClass:@"LargeButton"];
    [account_update setTitle:NSLocalizedString(@"profile_account_update_btn_title", nil) forState:UIControlStateNormal];
    account_update.frame = CGRectMake(10, 270, 300, 40.0);
    [scrollView addSubview:account_update];
    
}

-(void)updateAccExe{
    
    NSLog(@"Update Account ");
    if([account_current_password.text length] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_account_error_current_password_empty", nil)

                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([account_new_password.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_account_error_password_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([account_new_password.text length] < 5)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_account_error_password_atleast", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if([account_retype_password.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_account_error_password_retype", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
    }
    else if(![account_new_password.text isEqualToString:account_retype_password.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_account_error_password_unmatch", nil)
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
        [HUD showWhileExecuting:@selector(changePasswordExe) onTarget:self withObject:nil animated:YES];
    }
}

-(void)changePasswordExe
{
    NSDictionary *status = [[DataService instance] change_password:[UserAuth instance].username password:account_current_password.text newpassword:account_new_password.text];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        if([[status objectForKey:@"status"] intValue] == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                           message: NSLocalizedString(@"profile_account_error_current_password_wrong", nil)
                                                          delegate: nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
            
            
            [alert show];
        }
        else
        {
        
           
            
        HUD.customView = [[UIImageView alloc] initWithImage:  [[ToolClass instance] changeImageColor:NSLocalizedString(@"image_checkmark", nil) withColor:[UIColor greenColor]]];
          
        // Set custom view mode
        HUD.mode = MBProgressHUDModeCustomView;
        
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"profile_account_successfull_message", nil);
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
            
            account_current_password.text = @"";
            account_new_password.text = @"";
            account_retype_password.text = @"";

        }
        
    });
    sleep(1);
}

-(void)goToMyOrderViewExe
{
    
    NSDictionary *getListOfMyOrder = [[DataService instance] get_my_order:[UserAuth instance].username password:[UserAuth instance].password filter:@"All"];
       [[MyOrderClass instance] setListOfMyOrder:getListOfMyOrder];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
     
        
        MyOrderViewController *myOder = [[MyOrderViewController alloc] init];
        [self.navigationController pushViewController:myOder animated:YES];
        
    });
    
}

-(void)loggout{
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)

                                                   message: NSLocalizedString(@"profile_logout_confirmation", nil)
                                                  delegate: self
                                         cancelButtonTitle:NSLocalizedString(@"general_notification_cancel_btn_title", nil)
                                         otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
    
    
    [alert show];
    
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed Button Indexed 0");
        // Any action can be performed here
    }
    else
    {
        NSLog(@"user pressed Button Indexed 1");
        // Any action can be performed here
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate = self;
        [HUD showWhileExecuting:@selector(logoutAction) onTarget:self withObject:nil animated:YES];
        
        
      
    }
}

-(void)logoutAction
{
    
    [[DataService instance] user_logout];
    
    [segmentControl removeFromSuperview];
    
    [self removeMyProfile];
    [self removeAccountForm];
    segmentControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"profile_tab_signin", nil),NSLocalizedString(@"profile_tab_signup", nil)]];
    segmentControl.frame = CGRectMake(10, 10, 300, 40);
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl addTarget:self action:@selector(valueChanged) forControlEvents: UIControlEventValueChanged];
    
    [scrollView addSubview:segmentControl];
    [[UserAuth instance] deleteArrayFile];
    scrollView.contentSize = CGSizeMake(320, 504);
    [self signInForm];
    
    [UserAuth instance].username = @"";
    [UserAuth instance].password = @"";
    
    [[DataService instance] pushNotificationApi];
    
    [[MainViewClass instance].rightView setItems:[DataService instance].pushNotifications];
    [[MainViewClass instance].rightView.tbl reloadData];
}

-(void)profileUpdateAction{
    if([firstNameLogin.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message:NSLocalizedString(@"profile_mygeneral_notification_error_title_firstname_empty", nil)

                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];

    }
    else if([lastNameLogin.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_mygeneral_notification_error_title_lastname_empty", nil)                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([display_name.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_mygeneral_notification_error_title_displayname_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([emailLoggedLogin.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_mygeneral_notification_error_title_email_empty", nil)
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
    }
    else if([[ToolClass instance] validateEmail:emailLoggedLogin.text] == false)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                       message: NSLocalizedString(@"profile_mygeneral_notification_error_title_email_invalid", nil)
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
	[HUD showWhileExecuting:@selector(profileUpdateActionExe) onTarget:self withObject:nil animated:YES];
    }
}

-(void)profileUpdateActionExe{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:firstNameLogin.text forKey:@"first_name"];
    [dic setValue:lastNameLogin.text forKey:@"last_name"];
    [dic setValue:display_name.text forKey:@"display_name"];
    [dic setValue:emailLoggedLogin.text forKey:@"email"];
    
    NSDictionary *status = [[DataService instance] profile_update:[UserAuth instance].username password:[UserAuth instance].password arg:dic];
    
    if([[status objectForKey:@"status"] intValue] == 0)
    {
    //Successful
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       
        HUD.customView = [[UIImageView alloc] initWithImage:  [[ToolClass instance] changeImageColor:NSLocalizedString(@"image_checkmark", nil) withColor:[UIColor greenColor]]];
        
        // Set custom view mode
        HUD.mode = MBProgressHUDModeCustomView;
        
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"profile_myprofile_successful_msg", nil);
        
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        
        NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
        NSMutableDictionary *dic = [newUserData copy];
        [[UserAuth instance] setUserData:dic];
        userData = [[UserAuth instance] userData];
    });
        sleep(1);
    }
    else if([[status objectForKey:@"status"] intValue] == 2)
    {
        //Session Expired or Username & password wrong
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)

                                                           message: NSLocalizedString(@"profile_mygeneral_notification_error_title_email_exist", nil)
                                                          delegate: nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
            
            
            [alert show];
            
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
                                                 otherButtonTitles:@"OK",nil];
            
            
            [alert show];
            
        });

        
    }
}

-(void)myProfile{
    
    [self removeMyProfile];
    
    
    [[NSThread mainThread] setName:@"Form Thread"];
    
    
    scrollView.contentSize = CGSizeMake(320, 840);
    
    
    profileImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, 80, 80)];
    UIImageView *img2 = [[UIImageView alloc] init];
    
    [profileImg setImageWithURL:[NSURL URLWithString:[userData objectForKey:@"avatar"]]
               placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                          
                          img2.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(100, 100) source:image];
                          
                      }];
    profileImg.image = img2.image;
    [profileImg setNuiClass:@"profileLoggedProfileImg"];
    profileImg.layer.masksToBounds = YES;
    profileImg.userInteractionEnabled = YES;
    [scrollView addSubview:profileImg];
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.frame = CGRectMake(0, 0, 80, 80);
    spinner.hidesWhenStopped = YES;
    spinner.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [profileImg addSubview:spinner];
    [spinner stopAnimating];
    
    
    
    UITapGestureRecognizer *profilePic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicTapAction:)];
    [profileImg addGestureRecognizer:profilePic];
    
    
    firstNameLogin = [[UITextField alloc] initWithFrame:CGRectMake(100, 70, 210, 40)];
    firstNameLogin.placeholder = NSLocalizedString(@"profile_myprofile_placeholder_firstname", nil);
    firstNameLogin.text = [userData objectForKey:@"first_name"];
    firstNameLogin.delegate = self;
    [scrollView addSubview:firstNameLogin];
    
    
    lastNameLogin = [[UITextField alloc] initWithFrame:CGRectMake(100, 120, 210, 40)];
    lastNameLogin.placeholder = NSLocalizedString(@"profile_myprofile_placeholder_lastname", nil);
;
    lastNameLogin.text = [userData objectForKey:@"last_name"];
    lastNameLogin.delegate = self;
    [scrollView addSubview:lastNameLogin];
    
    
    display_name = [[UITextField alloc] initWithFrame:CGRectMake(10, 170, 300, 40)];
    display_name.placeholder = NSLocalizedString(@"profile_myprofile_placeholder_displayname", nil);
    display_name.text = [userData objectForKey:@"user_nickname"];
    display_name.delegate = self;
    [scrollView addSubview:display_name];
    
    emailLoggedLogin = [[UITextField alloc] initWithFrame:CGRectMake(10, 220, 300, 40)];
    emailLoggedLogin.text = [userData objectForKey:@"email"];
    emailLoggedLogin.placeholder = NSLocalizedString(@"profile_myprofile_placeholder_email", nil);

    emailLoggedLogin.delegate = self;
    [scrollView addSubview:emailLoggedLogin];
    
    
    profileUpdate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [profileUpdate addTarget:self
                      action:@selector(profileUpdateAction)
            forControlEvents:UIControlEventTouchDown];
    [profileUpdate setNuiClass:@"LargeButton"];
    [profileUpdate setTitle:NSLocalizedString(@"profile_myprofile_update_btn_title", nil) forState:UIControlStateNormal];
    profileUpdate.frame = CGRectMake(10, 270, 300, 40.0);
    [scrollView addSubview:profileUpdate];
    
    
    lblBillingLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, 300, 40.0)];
    [lblBillingLbl setNuiClass:@"profileLoggedLbl2"];
    lblBillingLbl.text = NSLocalizedString(@"profile_billing_lbl", nil);
    [scrollView addSubview:lblBillingLbl];
    
    
    
    billing_firstname = [[UITextField alloc] initWithFrame:CGRectMake(10, 360, 145, 40)];
    billing_firstname.placeholder = NSLocalizedString(@"profile_billing_placeholder_firstname", nil);
    billing_firstname.delegate = self;
    billing_firstname.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_first_name"];
    [scrollView addSubview:billing_firstname];
    
    billing_lastname = [[UITextField alloc] initWithFrame:CGRectMake(165, 360, 145, 40)];
    billing_firstname.delegate = self;
    billing_lastname.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_last_name"];
    billing_lastname.placeholder = NSLocalizedString(@"profile_billing_placeholder_lastname", nil);
    [scrollView addSubview:billing_lastname];
    
    
    billing_company = [[UITextField alloc] initWithFrame:CGRectMake(10, 410, 300, 40)];
    billing_company.placeholder = NSLocalizedString(@"profile_billing_placeholder_company", nil);
    billing_company.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_company"];
    billing_company.delegate = self;
    [scrollView addSubview:billing_company];
    
    billing_address_1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 460, 300, 40)];
    billing_address_1.placeholder = NSLocalizedString(@"profile_billing_placeholder_addressline1", nil);
    billing_address_1.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_address_1"];
    billing_address_1.delegate = self;
    [scrollView addSubview:billing_address_1];
    
    billing_address_2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 510, 300, 40)];
    billing_address_2.placeholder = NSLocalizedString(@"profile_billing_placeholder_addressline2", nil);
    billing_address_2.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_address_2"];
    billing_address_2.delegate = self;
    [scrollView addSubview:billing_address_2];
    
    
    billing_postcode = [[UITextField alloc] initWithFrame:CGRectMake(10, 560, 145, 40)];
    billing_postcode.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_postcode"];
    billing_postcode.delegate = self;
     [billing_postcode setKeyboardType:UIKeyboardTypeNumberPad];
    billing_postcode.placeholder = NSLocalizedString(@"profile_billing_placeholder_poscode", nil);
    [scrollView addSubview:billing_postcode];
    
    billing_city = [[UITextField alloc] initWithFrame:CGRectMake(165, 560, 145, 40)];
    billing_city.placeholder = NSLocalizedString(@"profile_billing_placeholder_city", nil);
    billing_city.delegate = self;
    billing_city.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_city"];
    [scrollView addSubview:billing_city];
    
    
    
    
    billing_country = [[UITextField alloc] initWithFrame:CGRectMake(10, 610, 300, 40)];
    billing_country.placeholder = NSLocalizedString(@"profile_billing_placeholder_country", nil);
    
    
    billing_country.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_country"];
    billing_country.delegate = self;
    billing_country.enabled = NO;
   
    
    billing_country_code = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_country_code"];
   
    
    [scrollView addSubview:billing_country];
    
    UILabel *transparentCountry = [[UILabel alloc] initWithFrame:CGRectMake(10, 610, 300, 40)];
    transparentCountry.userInteractionEnabled = YES;
    transparentCountry.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:transparentCountry];
    
    UITapGestureRecognizer *transparentCountryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transparentCountryTapAction:)];
    [transparentCountry addGestureRecognizer:transparentCountryTap];
    
    
    
    
    
    billing_state = [[UITextField alloc] initWithFrame:CGRectMake(10, 660, 300, 40)];
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
    
    
    billing_phone = [[UITextField alloc] initWithFrame:CGRectMake(10, 710, 145, 40)];
    billing_phone.placeholder = NSLocalizedString(@"profile_billing_placeholder_phone", nil);
    billing_phone.delegate = self;
    [billing_phone setKeyboardType:UIKeyboardTypePhonePad];
    billing_phone.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_phone"];
    [scrollView addSubview:billing_phone];
    
    billing_email = [[UITextField alloc] initWithFrame:CGRectMake(165, 710, 145, 40)];
    [billing_email setKeyboardType:UIKeyboardTypeEmailAddress];
    billing_email.placeholder = NSLocalizedString(@"profile_billing_placeholder_email", nil);
    billing_email.delegate = self;
    billing_email.text = [[userData objectForKey:@"billing_address"] objectForKey:@"billing_email"];
    [scrollView addSubview:billing_email];
    
    billing_update = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [billing_update addTarget:self
                       action:@selector(updateBillingAction)
             forControlEvents:UIControlEventTouchDown];
    [billing_update setNuiClass:@"LargeButton"];
    [billing_update setTitle:NSLocalizedString(@"profile_billing_update_btn", nil) forState:UIControlStateNormal];
    billing_update.frame = CGRectMake(10, 760, 300, 40.0);
    [scrollView addSubview:billing_update];

    
    
}
-(void)transparentCountryTapAction:(UITapGestureRecognizer*)tap{
    
    NSLog(@"Country PopOver");
    
    
    CountriesMenuViewController *menu = [[CountriesMenuViewController alloc] init];
    menu.title = NSLocalizedString(@"popover_countries_title", nil);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menu];
    [menu setProfileController:self];
    
    popover = [[FPPopoverController alloc] initWithViewController:nav];
    popover.border = NO;
    popover.contentSize = CGSizeMake(300,400);
    [popover.view setNuiClass:@"DropDownView"];
   
    [popover presentPopoverFromView:billing_country];
    
}

-(void)profilePicTapAction:(UITapGestureRecognizer*)tap{
    
    NSString *actionSheetTitle = NSLocalizedString(@"profile_upload_avatar_title", nil); //Action Sheet Title
    NSString *destructiveTitle = NSLocalizedString(@"profile_upload_avatar_cancel_btn", nil); //Action Sheet Button Titles
    NSString *other1 = NSLocalizedString(@"profile_upload_avatar_take_a_photo", nil);
    NSString *other2 = NSLocalizedString(@"profile_upload_avatar_use_gallery", nil);
   
  
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, other2, nil];
    [actionSheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if  (buttonIndex == 0) {
        
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"Take a Photo");
        
        
        
        if([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }

 
    }
    else
    {
        NSLog(@"Choose from Library");
        if([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
        
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    CGSize size = CGSizeMake(500, 500);
    UIImage *croppedImage = [[ToolClass instance] imageByScalingAndCroppingForSize:size source:image];
     NSData *cropimageData = UIImageJPEGRepresentation(croppedImage, 0.5);
    
    profileImg.image = croppedImage;
    
    
    [spinner startAnimating];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    NSDictionary *status = [[DataService instance] profileImageUpdate:[UserAuth instance].username password:[UserAuth instance].password imageData:cropimageData];
        
     dispatch_async(dispatch_get_main_queue(), ^(void){
        
         [spinner stopAnimating];
         
         NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
         NSMutableDictionary *dic = [newUserData copy];
         [[UserAuth instance] setUserData:dic];
           userData = [[UserAuth instance] userData];
     });
        
    });
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)updateBillingAction{
    
    if([billing_email.text length] > 0)
    {
        if([[ToolClass instance] validateEmail:billing_email.text] == false)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)

                                                           message:  NSLocalizedString(@"profile_billing_error_email_not_valid", nil)

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
    
    NSDictionary *status = [[DataService instance] billing_update:[UserAuth instance].username password:[UserAuth instance].password arg:dic];
    
    if([[status objectForKey:@"status"] intValue] == 0)
    {
        //Successful
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
             HUD.customView = [[UIImageView alloc] initWithImage:  [[ToolClass instance] changeImageColor:NSLocalizedString(@"image_checkmark", nil) withColor:[UIColor greenColor]]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            HUD.labelText = NSLocalizedString(@"profile_billing_update_successful_msg", nil);
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            
            NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
            NSMutableDictionary *dic = [newUserData copy];
            [[UserAuth instance] setUserData:dic];
              userData = [[UserAuth instance] userData];
            
        });
        sleep(1);
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

-(void)signUpForm{
    
    usernameSignUp = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    usernameSignUp.placeholder = NSLocalizedString(@"profile_signup_placeholder_username", nil);
     usernameSignUp.delegate = self;
    [scrollView addSubview:usernameSignUp];
    
    emailSignUp = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    emailSignUp.placeholder = NSLocalizedString(@"profile_signup_placeholder_email", nil);
    emailSignUp.delegate = self;
    [scrollView addSubview:emailSignUp];
    
    
    firstNameSignUp = [[UITextField alloc] initWithFrame:CGRectMake(10, 160, 300, 40)];
    firstNameSignUp.placeholder = NSLocalizedString(@"profile_signup_placeholder_firstname", nil);
    firstNameSignUp.delegate = self;
    [scrollView addSubview:firstNameSignUp];
    
    
    lastNameSignUp = [[UITextField alloc] initWithFrame:CGRectMake(10, 210, 300, 40)];
    lastNameSignUp.placeholder = NSLocalizedString(@"profile_signup_placeholder_lastname", nil);
    lastNameSignUp.delegate = self;
    [scrollView addSubview:lastNameSignUp];
    
    passwordSignUp = [[UITextField alloc] initWithFrame:CGRectMake(10, 260, 300, 40)];
    passwordSignUp.secureTextEntry = YES;
    passwordSignUp.placeholder = NSLocalizedString(@"profile_signup_placeholder_password", nil);
    passwordSignUp.delegate = self;
    [scrollView addSubview:passwordSignUp];
    
    retypepasswordSignUp = [[UITextField alloc] initWithFrame:CGRectMake(10, 310, 300, 40)];
    retypepasswordSignUp.secureTextEntry = YES;
    retypepasswordSignUp.placeholder = NSLocalizedString(@"profile_signup_placeholder_repassword", nil);
    retypepasswordSignUp.delegate = self;
    [scrollView addSubview:retypepasswordSignUp];
    
    signUpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signUpBtn addTarget:self
                 action:@selector(signUpBtnAction)
       forControlEvents:UIControlEventTouchDown];
    [signUpBtn setNuiClass:@"LargeButton"];
    [signUpBtn setTitle:NSLocalizedString(@"profile_signup_btn", nil) forState:UIControlStateNormal];
    signUpBtn.frame = CGRectMake(10, 400, 300, 40.0);
    [scrollView addSubview:signUpBtn];

}

-(void)signInForm{
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    username.placeholder = NSLocalizedString(@"profile_signin_placeholder_usernameoremail", nil);
    username.delegate = self;
    [scrollView addSubview:username];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    password.placeholder = NSLocalizedString(@"profile_signin_placeholder_password", nil);
    password.secureTextEntry = YES;
    password.delegate = self;
    [scrollView addSubview:password];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn addTarget:self
                 action:@selector(loginBtnAction)
       forControlEvents:UIControlEventTouchDown];
    [loginBtn setNuiClass:@"LargeButton"];
    [loginBtn setTitle:NSLocalizedString(@"profile_signin_btn", nil) forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(10, 180, 300, 40.0);
    [scrollView addSubview:loginBtn];
    
    
    lostPassword = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [lostPassword addTarget:self
                 action:@selector(lostPasswordAction)
       forControlEvents:UIControlEventTouchDown];
    [lostPassword setNuiClass:@"LargeButton"];
    [lostPassword setTitle:NSLocalizedString(@"profile_signin_lostpassword", nil) forState:UIControlStateNormal];
    lostPassword.frame = CGRectMake(10, 230, 300, 40.0);
    [scrollView addSubview:lostPassword];
    
    
}

-(void)lostPasswordAction
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[[SettingDataClass instance] getSetting] objectForKey:@"page"] objectForKey:@"lost_password"]]];

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
    NSLog(@"Warning Memory Low");
}



@end
