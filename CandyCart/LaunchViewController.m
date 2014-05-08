//
//  LaunchViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/19/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "LaunchViewController.h"

#import "PPRevealSideViewController.h"
@interface LaunchViewController ()
{
    PPRevealSideViewController *revealSideViewController;
}
@end

@implementation LaunchViewController

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
#ifdef BG_WHITE
    UIActivityIndicatorView *myActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
#else
    UIActivityIndicatorView *myActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
#endif
    //    myActivity.frame = CGRectMake(150, 329, 20, 20);
    myActivity.frame = CGRectMake(150, 399, 20, 20);
    
    //add progress bar
    UIProgressView *myProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    //    myProgressView.frame = CGRectMake(85, 301, 150, 2);
    myProgressView.frame = CGRectMake(85, 371, 150, 2); //cafeda
    
    UILabel *lbPoweredBy = [[UILabel alloc] initWithFrame:CGRectMake(0, 443, 320, 29)];
    
    if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        UIImageView *bgImgView;
        if(result.height == 1136) {
            lbPoweredBy.frame = CGRectMake(lbPoweredBy.frame.origin.x, lbPoweredBy.frame.origin.y+75,lbPoweredBy.frame.size.width,lbPoweredBy.frame.size.height);
            
            bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-568.png"]];
            bgImgView.frame = CGRectMake(0, 0, 320, 568);
        }
        else {
            bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
            bgImgView.frame = CGRectMake(0, 0, 320, 480);
            
            myActivity.frame = CGRectMake(150, 379, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351, 150, 2); //cafeda
        }
        
#ifdef ishop
        if(result.height == 1136) {
            myActivity.frame = CGRectMake(150, 379+80, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351+90, 150, 2);
        }
        else {
            myActivity.frame = CGRectMake(150, 379+40, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351+60, 150, 2);
        }
#endif
        
#ifdef ipub
        if(result.height == 1136) {
            myActivity.frame = CGRectMake(150, 379+80, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351+90, 150, 2);
        }
        else {
            myActivity.frame = CGRectMake(150, 379+40, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351+60, 150, 2);
        }
#endif
        
#ifdef tintincafe
        if(result.height == 1136) {
            myActivity.frame = CGRectMake(150, 379+80, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351+90, 150, 2);
        }
        else {
            myActivity.frame = CGRectMake(150, 379+40, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351+60, 150, 2);
        }
#endif
        
#ifdef khobom
        if(result.height == 1136) {
            myActivity.frame = CGRectMake(150, 379+50, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351+60, 150, 2);
        }
        else {
            myActivity.frame = CGRectMake(150, 379+20, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351+40, 150, 2);
        }
#endif
        
#ifdef highlandcafe
        if(result.height == 1136) {
            myActivity.frame = CGRectMake(150, 379-120, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351-120, 150, 2);
        }
        else {
            myActivity.frame = CGRectMake(150, 379-150, 20, 20);
            
            myProgressView.frame = CGRectMake(85, 351-150, 150, 2);
        }
#endif
        [self.view addSubview:bgImgView];
    }
    
    //add activity indicator
    [self.view addSubview:myActivity];
    [myActivity startAnimating];
    
    
    myProgressView.progressTintColor = [UIColor blueColor];
    [self.view addSubview:myProgressView];
    
    //add label Powered by
    [lbPoweredBy setNuiIsApplied:@0];
    lbPoweredBy.textAlignment = NSTextAlignmentCenter;
    lbPoweredBy.text = @"Powered by Nhuan Quang";
#ifdef BG_WHITE
    lbPoweredBy.textColor = [UIColor darkGrayColor];
#else
    lbPoweredBy.textColor = [UIColor whiteColor];
#endif
    lbPoweredBy.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:lbPoweredBy];
    
    [[TempVariables instance] setOnLounchProgress:myProgressView];
    
    [self initApplication];
}


-(void)initApplication{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Load Data Service In Background
        [[DataService instance] loadAllData];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Load UI After Data Service Loaded
            [[MyCartClass instance] initMyCart];
            [[MainViewClass instance] loadMainController];
            //[MainViewClass instance].tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:[MainViewClass instance].tabBarController];
            revealSideViewController.delegate = self;
            
            [revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
            [revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNavigationBar];
            
            LeftViewController *left = [[LeftViewController alloc] init];
            
            [left setMenuItems:[[[DataService instance] leftMenuData] objectForKey:@"menu"] hideNavBar:YES];
            UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:left];
            leftNav.navigationBar.translucent = NO;
            [revealSideViewController preloadViewController:leftNav forSide:PPRevealSideDirectionLeft];
            
            
            RightViewController *right = [[RightViewController alloc] init];
            [right setItems:[DataService instance].pushNotifications];
            UINavigationController *rightNav = [[UINavigationController alloc] initWithRootViewController:right];
            rightNav.navigationBar.translucent = NO;
            
            
            [revealSideViewController preloadViewController:rightNav forSide:PPRevealSideDirectionRight];
            
            [MainViewClass instance].rightView = right;
            
            revealSideViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[MainViewClass instance] setPPReavealController:revealSideViewController];
            
            [[MainViewClass instance] initNotification:[[MainViewClass instance] getCurrentMainWindow]];
            
            [self presentViewController:revealSideViewController animated:YES completion:^{
                
                NSDictionary* userInfo = [[[MainViewClass instance] getLaunchOption] valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
                NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
                
                
                NSString *messageBody = [[apsInfo objectForKey:@"alert"] objectForKey:@"body"];
                
                if([messageBody length] > 0)
                {
                    
                    [[PushedMsgClass instance] getPushNotificationMessage:userInfo needReloadRightView:NO];
                    
                }
                NSDictionary *setting = [[SettingDataClass instance] getSetting];
                
                if([[[setting objectForKey:@"store_notification"] objectForKey:@"isON"] isEqualToString:@"yes"])
                {
                    NSString * str = [NSString stringWithFormat:@"%@",[[setting objectForKey:@"store_notification"] objectForKey:@"notice"]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                                   message:str
                                                                  delegate: self
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:@"OK",nil];
                    
                    
                    [alert show];
                }
            }];
        });
    });
}
- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController {
    NSLog(@"Did Pop");
    
}
- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController {
    NSLog(@"Did Push");
    
}

- (NSArray *)customViewsToAddPanGestureOnPPRevealSideViewController:(PPRevealSideViewController *)controller{
    
    NSArray *arr = [NSArray arrayWithObjects:[MainViewClass instance].exploreViewController.navigationController.navigationBar,[MainViewClass instance].browseViewController.navigationController.navigationBar,[MainViewClass instance].profileViewController.navigationController.navigationBar,[MainViewClass instance].cartViewController.navigationController.navigationBar, nil];
    
    return arr;
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
