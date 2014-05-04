//
//  DynamicTableViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/4/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileViewController;
@class BillingCheckOutViewController;
@class ShippingCheckOutViewController;
@interface DynamicTableViewController : UITableViewController
{
    
    NSArray *menuItems;
    ProfileViewController *profileController;
    BillingCheckOutViewController *billingController;
    ShippingCheckOutViewController *shippingController;
    int chooseController;
    
    NSMutableArray *citiesInSection;
}
-(void)setStateArray:(NSArray*)ary;
-(void)setProfileController:(ProfileViewController*)pro;
-(void)setBillingController:(BillingCheckOutViewController*)pro;
-(void)setShippingController:(ShippingCheckOutViewController*)pro;
@end
