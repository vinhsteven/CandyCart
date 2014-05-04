//
//  MainViewClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/14/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MainViewClass.h"

@implementation MainViewClass
@synthesize exploreNav,exploreViewController;
@synthesize browseNav,browseViewController;
@synthesize profileNav,profileViewController;
@synthesize cartNav,cartViewController;
@synthesize orderNav,orderViewController;
@synthesize tabBarController,notification,rightView;
+ (MainViewClass *) instance {
    static MainViewClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


-(void)loadMainController{
    
    [self setExploreViewController];
    [self setBrowseViewController];
    [self setProfileViewController];
    [self setCartViewController];
    
    [self setTabbarController];
    
    
    [self setOrderViewController];
}


-(void)initNotification:(UIView*)inView
{
    
    if([[DeviceClass instance] getOSVersion] == iOS7)
    {
        notification = [[SimpleNotificationView alloc] initWithFrame:CGRectMake(0, -64, 320, 64) andView:inView];
    }
    else
    {
        notification = [[SimpleNotificationView alloc] initWithFrame:CGRectMake(0, -44, 320, 44) andView:inView];
    }
    
}


-(void)setExploreViewController{
//    [[RevMobAds session] showBanner];
    
    exploreViewController = [[ExploreViewController alloc] init];
    exploreNav = [[UINavigationController alloc] initWithRootViewController:exploreViewController];
    
    exploreNav.navigationBar.translucent = NO;
    
    //exploreNav.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)setBrowseViewController{
    
    browseViewController = [[BrowseViewController alloc] init];
    browseNav = [[UINavigationController alloc] initWithRootViewController:browseViewController];
    browseNav.navigationBar.translucent = NO;
    //browseNav.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)setProfileViewController{
    
    profileViewController = [[ProfileViewController alloc] init];
    profileNav = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    profileNav.navigationBar.translucent = NO;
    //profileNav.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)setCartViewController{
    
    cartViewController = [[CartViewController alloc] init];
    cartNav = [[UINavigationController alloc] initWithRootViewController:cartViewController];
    cartNav.navigationBar.translucent = NO;
    //cartNav.navigationBar.tintColor = [UIColor whiteColor];
}


-(void)setOrderViewController{
    
    orderViewController = [[OrderViewController alloc] init];
    orderNav = [[UINavigationController alloc] initWithRootViewController:orderViewController];
    orderNav.navigationBar.translucent = NO;
    //orderNav.navigationBar.tintColor = [UIColor whiteColor];
    
}




-(void)countCartTabbarBadge
{
    int count = [[MyCartClass instance] countProduct];
    
    if(count > 0)
    {
        [[cartViewController navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d",count];
    }
    else
    {
        [[cartViewController navigationController] tabBarItem].badgeValue = nil;
    }
}

-(void)setTabbarController{
    tabBarController = [[UITabBarController alloc] init];
    
    
    tabBarController.viewControllers = @[exploreNav,browseNav,profileNav,cartNav];
    
    
    
}

-(void)setPPReavealController:(PPRevealSideViewController*)root{
    revealSideViewController = root;
    
    //[revealSideViewController popViewControllerWithNewCenterController:exploreNav animated:YES];
    
}






-(PPRevealSideViewController*)getPPReavealController
{
    return revealSideViewController;
    
}

-(void)setMainWindow:(UIWindow*)currentWindow{
    
    window = currentWindow;
}

-(UIWindow*)getCurrentMainWindow{
    
    return window;
}

-(void)setRootViewController:(UIViewController*)root{
    rootViewController = root;
}

-(UIViewController*)getRoot
{
    return rootViewController;
    
}
-(void)popupOrderViewController{
    NSDictionary *dic = [[DataService instance] getSinglePaymentGatewayMetaKey:[[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"]];
    
    int safari = [[dic objectForKey:@"safari"] intValue];
    
    if([[[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"] isEqualToString:@"authorize_net_cim"])
    {
        [revealSideViewController presentViewController:orderNav animated:YES completion:^{
            
            
            HUD = [[MBProgressHUD alloc] initWithView:orderViewController.view];
            [orderViewController.view addSubview:HUD];
            HUD.delegate = self;
            HUD.labelText = @"Processing";
            [HUD showWhileExecuting:@selector(processAutPayment) onTarget:self withObject:nil animated:YES];
            
            
            
        }];
    }
    else
    {
        if(safari == 0)
        {
            [revealSideViewController presentViewController:orderNav animated:YES completion:^{
                
                PaymentWebViewController *payment = [[PaymentWebViewController alloc] init];
                [payment setOrderViewController:orderViewController];
                UINavigationController *paymentNav = [[UINavigationController alloc] initWithRootViewController:payment];
                paymentNav.navigationBar.translucent = NO;
                NSLog(@"%@",[NSString stringWithFormat:@"%@/?candycart=json-api&type=mobile-payment-redirect-api&orderKey=%@&orderID=%@&paymentMethodID=%@",[[AppDelegate instance] getUrl],
                             [[[MyOrderClass instance] getMyOrder] objectForKey:@"order_key"],
                             [[[MyOrderClass instance] getMyOrder] objectForKey:@"orderID"],
                             [[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"]
                             ]);
                [payment loadUrlInWebView:[NSString stringWithFormat:@"%@/?candycart=json-api&type=mobile-payment-redirect-api&orderKey=%@&orderID=%@&paymentMethodID=%@",[[AppDelegate instance] getUrl],
                                           [[[MyOrderClass instance] getMyOrder] objectForKey:@"order_key"],
                                           [[[MyOrderClass instance] getMyOrder] objectForKey:@"orderID"],
                                           [[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"]
                                           ]];
                [orderNav presentViewController:paymentNav animated:YES completion:nil];
                
            }];
            
        }
        else
        {
            [[[MainViewClass instance] cartNav] popToRootViewControllerAnimated:YES];
            sleep(1);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@/?candycart=json-api&type=mobile-payment-redirect-api&orderKey=%@&orderID=%@&paymentMethodID=%@",[[AppDelegate instance] getUrl],
                                                                              [[[MyOrderClass instance] getMyOrder] objectForKey:@"order_key"],
                                                                              [[[MyOrderClass instance] getMyOrder] objectForKey:@"orderID"],
                                                                              [[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"]
                                                                              ]]];
            
        }
    }
}

-(void)processAutPayment
{
    NSDictionary *payment_process = [[DataService instance] process_payment_aut_dot_net:[[[MyOrderClass instance] getMyOrder] objectForKey:@"order_key"] orderNo:[[[MyOrderClass instance] getMyOrder] objectForKey:@"orderID"] methodID:[[[MyOrderClass instance] getMyOrder] objectForKey:@"payment_method_id"] credit_card_number:[[TempVariables instance] credit_card_aut] expire_date_year:[[TempVariables instance] credit_card_year_aut] expire_date_month:[[TempVariables instance] credit_card_month_aut] cvv:[[TempVariables instance] credit_card_cvv_aut] profileID:[[TempVariables instance] credit_card_profile_id_aut]];
    
    NSLog(@"%@",payment_process);
    
    int status = [[payment_process objectForKey:@"Status"] intValue];
    NSString* reason = @"Your credit card has been declined.";
    if(status == 0)
    {
        
        
        
        [orderViewController refreshOrderPaymentSuccessful];
        
    }
    else
    {
        //payment Failed
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                              
                                                       message: reason
                                                      delegate: nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
        
        
        [alert show];
        
        [orderViewController refreshOrderFailed];
    }
    
}

-(void)openOrderViewController{
    [revealSideViewController presentViewController:orderNav animated:YES completion:^{
        
        
        
    }];
    
}

-(void)setLaunchOption:(NSDictionary*)option
{
    
    launchOption = option;
}

-(NSDictionary*)getLaunchOption{
    return launchOption;
}

@end
