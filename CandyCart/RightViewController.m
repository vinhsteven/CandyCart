//
//  RightViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 9/7/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController
@synthesize tbl;
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
	// Do any additional setup after loading the view.
     [self.view setNuiClass:@"ViewInit"];
    
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 200, 30)];
    title.text = @"Notifications";
    [title setNuiClass:@"Notification_title_lbl"];
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,30)];
    [iv addSubview:title];
    
     self.navigationItem.titleView = iv;
    
    tbl = [[UITableView alloc] initWithFrame:CGRectMake(70, 0, 250, [[DeviceClass instance] getResizeScreen:NO].size.height)];
    tbl.dataSource = self;
    tbl.delegate = self;
  
    
   
    
    [self.view addSubview:tbl];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tbl];
    [refreshControl addTarget:self action:@selector(refreshControl:) forControlEvents:UIControlEventValueChanged];
   
}


- (void)refreshControl:(ODRefreshControl *)refreshControl
{
    
    NSLog(@"Refreshed");
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        [[DataService instance] pushNotificationApi];
        [self setItems:[DataService instance].pushNotifications];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [tbl reloadData];
            
             [refreshControl endRefreshing];
        
        });
        
    });
    
}


-(void)valueChanged{
    
}

-(void)setItems:(NSDictionary*)items {
    fullInfo = items;
    menuItems = [fullInfo objectForKey:@"data"];
}

#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
    }
    
    
    
    
 
	cell.textLabel.text = [NSString stringWithFormat:@"%@",[[menuItems objectAtIndex:indexPath.row] objectForKey:@"ago"]];

    
    
    
	cell.textLabel.numberOfLines = ceilf([[[menuItems objectAtIndex:indexPath.row] objectForKey:@"pushed_message"] sizeWithFont:[UIFont fontWithName:BOLDFONT size:12] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height/20.0);
    
    
	cell.detailTextLabel.text = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"pushed_message"];

	cell.detailTextLabel.numberOfLines = ceilf([[[menuItems objectAtIndex:indexPath.row] objectForKey:@"pushed_message"] sizeWithFont:[UIFont fontWithName:PRIMARYFONT size:12] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height/10.0);
    
    return cell;

}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.font = [UIFont fontWithName:BOLDFONT size:12];
   cell.detailTextLabel.font = [UIFont fontWithName:PRIMARYFONT size:12];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *titleString = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"ago"];
	NSString *detailString = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"pushed_message"];
	CGSize titleSize = [titleString sizeWithFont:[UIFont fontWithName:BOLDFONT size:12] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
	CGSize detailSize = [detailString sizeWithFont:[UIFont fontWithName:PRIMARYFONT size:12] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
	
	return detailSize.height+titleSize.height+40;

}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    


NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
[data setValue:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"pushed_message"] forKey:@"body"];
[data setValue:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"objectID"] forKey:@"postID"];
[data setValue:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"type"] forKey:@"type"];

NSMutableDictionary *alert = [[NSMutableDictionary alloc] init];
[alert setObject:data forKey:@"alert"];


NSMutableDictionary *userinfo = [[NSMutableDictionary alloc] init];
[userinfo setObject:alert forKey:@"aps"];
    
    NSLog(@"user info : %@ ",userinfo);

    [[PushedMsgClass instance] getPushNotificationMessage:userinfo needReloadRightView:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
