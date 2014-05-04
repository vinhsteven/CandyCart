//
//  DynamicTableViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/4/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "DynamicTableViewController.h"
#import "ProfileViewController.h"
#import "BillingCheckOutViewController.h"
#import "ShippingCheckOutViewController.h"
@interface DynamicTableViewController ()

@end

@implementation DynamicTableViewController

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
}

- (void) reloadStates {
    citiesInSection = [NSMutableArray arrayWithCapacity:1];
    
    if ([menuItems count] > 0) {
        //Let’s start by establishing our sections:
        // Loop through the cities and create our keys
        NSArray *title = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",
                          @"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
        
        //loop all alphabet
        for (int i=0;i < [title count];i++) {
            NSString *alphabet = [title objectAtIndex:i];
            BOOL found = FALSE;
            //temp array to store all cities with alphabet
            NSMutableArray *tempStatesArray = [NSMutableArray arrayWithCapacity:1];
            for (int j=0;j < [menuItems count];j++) {
                NSMutableDictionary *tmpState = [menuItems objectAtIndex:j];
                NSString *str = [[tmpState objectForKey:@"state"] substringToIndex:1];
                if ([str isEqualToString:alphabet]) {
                    found = TRUE;
                    [tempStatesArray addObject:tmpState];
                }
            }
            //if this title has at least a city
            if (found) {
                NSDictionary *stateWithAlphabet = [NSDictionary dictionaryWithObjectsAndKeys:alphabet,@"sectionTitle",tempStatesArray,@"arrayObject",nil];
                [citiesInSection addObject:stateWithAlphabet];
            }
        }
    }
}

-(void)setStateArray:(NSArray*)ary{
    menuItems = ary;
    
    [self reloadStates];
}

-(void)setProfileController:(ProfileViewController*)pro{
    
    profileController = pro;
    chooseController = 1;
}

-(void)setBillingController:(BillingCheckOutViewController*)pro{
    
    billingController = pro;
    chooseController = 2;
}

-(void)setShippingController:(ShippingCheckOutViewController*)pro{
    
    shippingController = pro;
    chooseController = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *stateWithAlphabet = [citiesInSection objectAtIndex:section];
    return [stateWithAlphabet objectForKey:@"sectionTitle"];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0;i < [citiesInSection count];i++) {
        //get first character of cities,eg: A,B...,C
        NSDictionary *stateWithAlphabet = [citiesInSection objectAtIndex:i];
        [array addObject:[stateWithAlphabet objectForKey:@"sectionTitle"]];
    }
    return array;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    for (int i=0;i < [citiesInSection count];i++) {
        //get first character of cities,eg: A,B...,C
        NSDictionary *stateWithAlphabet = [citiesInSection objectAtIndex:i];
        //if match with title being chosed
        if ([title isEqualToString:[stateWithAlphabet objectForKey:@"sectionTitle"]]) {
            CGRect sectionRect = [tableView rectForSection:i];
            sectionRect.size.height = tableView.frame.size.height;
            [tableView setContentOffset:CGPointMake(sectionRect.origin.x, sectionRect.origin.y)];
            break;
        }
    }
    return index;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
//    return 1;
    return [citiesInSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
//    return [menuItems count];
    NSDictionary *stateWithAlphabet = [citiesInSection objectAtIndex:section];
    NSMutableArray *tempStatesArray = [stateWithAlphabet objectForKey:@"arrayObject"];
    return [tempStatesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    NSDictionary *countryWithAlphabet = [citiesInSection objectAtIndex:indexPath.section];
    NSMutableArray *tempCountriesArray = [countryWithAlphabet objectForKey:@"arrayObject"];
    
    cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"state"]];
    cell.detailTextLabel.text = [[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"state_code"];
    
    // Configure the cell...
//    cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"state"]];
//    cell.detailTextLabel.text = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"state_code"];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NSDictionary *stateWithAlphabet = [citiesInSection objectAtIndex:indexPath.section];
    NSMutableArray *tempStatesArray = [stateWithAlphabet objectForKey:@"arrayObject"];
    
    if(chooseController ==1)
    {
     [profileController updateStateTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempStatesArray objectAtIndex:indexPath.row] objectForKey:@"state"]] stateCode:[[tempStatesArray objectAtIndex:indexPath.row] objectForKey:@"state_code"]];
        
    }
    else if(chooseController == 2)
    {
         [billingController updateStateTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempStatesArray objectAtIndex:indexPath.row] objectForKey:@"state"]] stateCode:[[tempStatesArray objectAtIndex:indexPath.row] objectForKey:@"state_code"]];
        
    }
    else if(chooseController == 3)
    {
        [shippingController updateStateTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempStatesArray objectAtIndex:indexPath.row] objectForKey:@"state"]] stateCode:[[tempStatesArray objectAtIndex:indexPath.row] objectForKey:@"state_code"]];
        
    }
}

@end
