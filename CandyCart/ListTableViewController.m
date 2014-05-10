//
//  ListTableViewController.m
//  CandyCart
//
//  Created by Steven on 5/7/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import "ListTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController
@synthesize buyMethod;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    mainArray = [NSMutableArray arrayWithCapacity:1];
    
//    NSString *tableTitle[] = {
//        @"Bàn 1",
//        @"Bàn 2",
//        @"Bàn 3"
//    };
//    NSString *tableSlug[] = {
//        @"table-1",
//        @"table-2",
//        @"table-3"
//    };
//    for (int i=0;i < sizeof(tableTitle)/sizeof(tableTitle[0]);i++) {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:tableTitle[i],@"tableTitle",tableSlug[i],@"slug", nil];
//        [mainArray addObject:dict];
//    }
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self listAllTables];
    
    userData = [UserAuth instance].userData;
}

- (void) listAllTables {
    dispatch_queue_t myQueue = dispatch_queue_create("com.nhuanquang.shipping_update", NULL);
    dispatch_async(myQueue, ^(void) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-all-tables",[[AppDelegate instance] getUrl]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request startSynchronous];
        
        NSError *error = [request error];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!error) {
                NSString *response = [request responseString];
                NSDictionary *dict = [response JSONValue];
                
                if (dict != nil) {
                    mainArray = [dict objectForKey:@"list_tables"];
                    [self.tableView reloadData];
                }
            }
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [mainArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
//    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [dict objectForKey:@"tableTitle"];
    cell.textLabel.text = [mainArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
//    [[MyCartClass instance] setOrderNotes:[dict objectForKey:@"tableTitle"]];
    
    [[MyCartClass instance] setOrderNotes:[mainArray objectAtIndex:indexPath.row]];
    
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
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:BUY_METHOD] isEqualToString:@"guest"]) {
        dispatch_queue_t myQueue = dispatch_queue_create("com.nhuanquang.shipping_update", NULL);
        dispatch_async(myQueue, ^(void) {
            NSDictionary *status = [[DataService instance] shipping_update:GUEST_USER password:GUEST_PASS arg:dic];
            NSDictionary *reviewData = [[DataService instance] reviewCartWithCoupon:GUEST_USER password:GUEST_PASS productInJsonString:[[MyCartClass instance] productIDToJsonString] coupon:[[MyCartClass instance] couponToJsonString]];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[MyCartClass instance] setServerCart:reviewData];
                
                //Successful
                
                NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
                NSMutableDictionary *dic = [newUserData copy];
                [[UserAuth instance] setUserData:dic];
                userData = [[UserAuth instance] userData];
                
                ReviewCheckOutViewController *review = [[ReviewCheckOutViewController alloc] init];
                [self.navigationController pushViewController:review animated:YES];
                
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            });
        });
    }
    else {
        dispatch_queue_t myQueue = dispatch_queue_create("com.nhuanquang.shipping_update", NULL);
        dispatch_async(myQueue, ^(void) {
            NSDictionary *status = [[DataService instance] shipping_update:[UserAuth instance].username password:[UserAuth instance].password arg:dic];
            NSDictionary *reviewData = [[DataService instance] reviewCartWithCoupon:[UserAuth instance].username password:[UserAuth instance].password productInJsonString:[[MyCartClass instance] productIDToJsonString] coupon:[[MyCartClass instance] couponToJsonString]];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[MyCartClass instance] setServerCart:reviewData];
                
                [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                
                if([[status objectForKey:@"status"] intValue] == 0)
                {
                    //Successful
                    
                    NSDictionary *newUserData = [[status objectForKey:@"new_user_data"] objectForKey:@"user"];
                    NSMutableDictionary *dic = [newUserData copy];
                    [[UserAuth instance] setUserData:dic];
                    userData = [[UserAuth instance] userData];
                    
                    ReviewCheckOutViewController *review = [[ReviewCheckOutViewController alloc] init];
                    [self.navigationController pushViewController:review animated:YES];
                }
                else
                {
                    //Session Expired or Username & password wrong
                    
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_title", nil)
                                                                   message: NSLocalizedString(@"general_notification_error_loginwaschange", nil)
                                                                  delegate: nil
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                                          ,nil];
                    [alert show];
                    
                }
            });
        });
    }
}

@end
