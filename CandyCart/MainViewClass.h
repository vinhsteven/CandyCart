//
//  MainViewClass.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/14/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPRevealSideViewController.h"

#import "ExploreViewController.h"
#import "BrowseViewController.h"
#import "ProfileViewController.h"
#import "CartViewController.h"
#import "OrderViewController.h"
#import "PaymentWebViewController.h"
#import "LaunchViewController.h"

#import "LeftViewController.h"
#import "RightViewController.h"

@class ExploreViewController;
@class BrowseViewController;
@class ProfileViewController;
@class CartViewController;
@class OrderViewController;
@class PPRevealSideViewController;
@class LeftViewController;
@interface MainViewClass : NSObject<MBProgressHUDDelegate>
{
    
    UIViewController *rootViewController;
    PPRevealSideViewController *revealSideViewController;
    UIWindow *window;
    NSDictionary *launchOption;
    MBProgressHUD *HUD;
}

@property(nonatomic,retain) SimpleNotificationView *notification;

@property(nonatomic,retain) RightViewController *rightView;

@property(nonatomic,retain) ExploreViewController *exploreViewController;
@property(nonatomic,retain) UINavigationController *exploreNav;

@property(nonatomic,retain) BrowseViewController *browseViewController;
@property(nonatomic,retain) UINavigationController *browseNav;

@property(nonatomic,retain) ProfileViewController *profileViewController;
@property(nonatomic,retain) UINavigationController *profileNav;

@property(nonatomic,retain) CartViewController *cartViewController;
@property(nonatomic,retain) UINavigationController *cartNav;

@property(nonatomic,retain) OrderViewController *orderViewController;
@property(nonatomic,retain) UINavigationController *orderNav;

@property (strong, nonatomic) UITabBarController *tabBarController;;


@property (strong, nonatomic) LeftViewController *leftViewController;
+ (MainViewClass *) instance;
-(void)loadMainController;
-(void)initNotification:(UIView*)inView;
-(void)setMainWindow:(UIWindow*)currentWindow;
-(void)popupOrderViewController;
-(void)countCartTabbarBadge;
-(void)openOrderViewController;
-(void)setRootViewController:(UIViewController*)root;
-(UIViewController*)getRoot;
-(void)setPPReavealController:(PPRevealSideViewController*)root;
-(PPRevealSideViewController*)getPPReavealController;
-(UIWindow*)getCurrentMainWindow;
-(void)setLaunchOption:(NSDictionary*)option;
-(NSDictionary*)getLaunchOption;
@end
