//
//  ListCameraViewController.m
//  ShopManager
//
//  Created by Steven on 3/23/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "ListCameraViewController.h"
#import "AddNewCameraViewController.h"
#import "DFUViewController.h"

@interface ListCameraViewController ()

@end

@implementation ListCameraViewController
@synthesize mainArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    
    self.title = NSLocalizedString(@"cameraViewController.title", nil);
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (mainArray == nil)
        mainArray = [NSMutableArray arrayWithCapacity:1];
    
    //test
//    NSMutableDictionary *tmpCameraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Cashier",@"cameraName",@"192.168.1.10",@"domain",@"1",@"channel",@"admin",@"username",@"",@"password", nil];
//    [mainArray addObject:tmpCameraDict];
    
//    UIBarButtonItem *btnAdd = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"listCameraVC.btn-add-title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addNewCamera)];
//    self.navigationItem.rightBarButtonItem = btnAdd;
    [self listCameraOfMerchant];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        
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
                    NSMutableArray *cameraList = [dict objectForKey:@"cameralist"];
                    if ([cameraList isKindOfClass:[NSMutableArray class]]) {
                        for (int i=0;i < [cameraList count];i++) {
                            NSMutableDictionary *cameraDict = [cameraList objectAtIndex:i];
                            BOOL isPublic = [[cameraDict objectForKey:@"isCameraPublic"] boolValue];
                            if (isPublic) {
                                [mainArray addObject:cameraDict];
                            }
                        }
                    }
                }
            }
            
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

- (void) addNewCamera {
    AddNewCameraViewController *controller = [[AddNewCameraViewController alloc] initWithNibName:@"AddNewCameraViewController" bundle:nil parent:self];
    [self.navigationController pushViewController:controller animated:YES];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSMutableDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"cameraName"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableDictionary *cameraDict = [mainArray objectAtIndex:indexPath.row];
    
    // Create the next view controller.
    DFUViewController *controller = [[DFUViewController alloc] initWithNibName:@"DFUViewController_iPhone" bundle:nil];
    controller.cameraArray = mainArray;
    controller.cameraIndex = indexPath.row;
    
    // Push the view controller.
    [self.navigationController pushViewController:controller animated:YES];
}

@end
