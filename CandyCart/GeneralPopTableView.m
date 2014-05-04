//
//  GeneralPopTableView.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/18/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "GeneralPopTableView.h"

@interface GeneralPopTableView ()

@end

@implementation GeneralPopTableView
@synthesize delegate;
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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initGeneralPopTableView:(NSString*)tblListTermName detailList:(NSString*)detailListTermName menuItem:(NSArray*)menuItemsArray{
    menuItems = menuItemsArray;
    termName = tblListTermName;
    detailTermName = detailListTermName;
    
    if(detailTermName == nil)
    {
        needDetail = NO;
    }
    else
    {
        needDetail = YES;
    }
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
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    tableView = tbl;
    
    NSString *statusString = [[menuItems objectAtIndex:indexPath.row] objectForKey:termName];
    if ([statusString isEqualToString:@"All"])
        statusString = NSLocalizedString(@"status_list.all", nil);
    else if ([statusString isEqualToString:@"pending"])
        statusString = NSLocalizedString(@"status_list.pending", nil);
    else if ([statusString isEqualToString:@"failed"])
        statusString = NSLocalizedString(@"status_list.failed", nil);
    else if ([statusString isEqualToString:@"on-hold"])
        statusString = NSLocalizedString(@"status_list.on-hold", nil);
    else if ([statusString isEqualToString:@"processing"])
        statusString = NSLocalizedString(@"status_list.processing", nil);
    else if ([statusString isEqualToString:@"completed"])
        statusString = NSLocalizedString(@"status_list.completed", nil);
    else if ([statusString isEqualToString:@"refunded"])
        statusString = NSLocalizedString(@"status_list.refunded", nil);
    else if ([statusString isEqualToString:@"cancelled"])
        statusString = NSLocalizedString(@"status_list.cancelled", nil);
    
    if(needDetail == YES)
    {
        // Configure the cell...
//        cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:termName]];
        cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:statusString];
        cell.detailTextLabel.text = [[menuItems objectAtIndex:indexPath.row] objectForKey:detailTermName];
    }
    else
    {
//        cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:termName]];
        cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:statusString];
    }
    // Configure the cell...
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [delegate didChooseGeneralPopTableView:[menuItems objectAtIndex:indexPath.row]];
    
}

@end
