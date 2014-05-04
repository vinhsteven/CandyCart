//
//  CountriesMenuViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/4/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicTableViewController.h"
@class ProfileViewController;
@class BillingCheckOutViewController;
@class ShippingCheckOutViewController;
@interface CountriesMenuViewController : UITableViewController{
    UITableView *tblView;
    NSArray *menuItems;
    NSString *selectedCountry;
    UITableView *tbl;
    ProfileViewController *profileController;
    BillingCheckOutViewController *billingController;
    ShippingCheckOutViewController *shippingController;
    int chooseController;
    
    NSMutableArray *citiesInSection;
}
-(void)selectedCountry:(NSString*)country_code;
-(void)setProfileController:(ProfileViewController*)pro;
-(void)setBillingController:(BillingCheckOutViewController*)pro;
-(void)setShippingController:(ShippingCheckOutViewController*)pro;
@end
