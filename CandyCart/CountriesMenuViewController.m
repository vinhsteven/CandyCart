//
//  CountriesMenuViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/4/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "CountriesMenuViewController.h"
#import "ProfileViewController.h"
#import "BillingCheckOutViewController.h"
#import "ShippingCheckOutViewController.h"
@interface CountriesMenuViewController ()

@end

@implementation CountriesMenuViewController

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
    
    citiesInSection = [NSMutableArray arrayWithCapacity:1];
    
    menuItems = [[DataService instance] countries];
    
    for(int i=0;i<[menuItems count];i++){
        if([selectedCountry isEqualToString:[[menuItems objectAtIndex:i] objectForKey:@"code"]])
        {
            NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:i inSection:0];
            [tbl selectRowAtIndexPath:selectedCellIndexPath animated:false scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
    }
    
    //reload country by alphabet
    [self reloadCountries];
}

- (void) reloadCountries {
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
            NSMutableArray *tempCountriesArray = [NSMutableArray arrayWithCapacity:1];
            for (int j=0;j < [menuItems count];j++) {
                NSMutableDictionary *tmpCountry = [menuItems objectAtIndex:j];
                NSString *str = [[tmpCountry objectForKey:@"country"] substringToIndex:1];
                if ([str isEqualToString:alphabet]) {
                    found = TRUE;
                    [tempCountriesArray addObject:tmpCountry];
                }
            }
            //if this title has at least a city
            if (found) {
                NSDictionary *countryWithAlphabet = [NSDictionary dictionaryWithObjectsAndKeys:alphabet,@"sectionTitle",tempCountriesArray,@"arrayObject",nil];
                [citiesInSection addObject:countryWithAlphabet];
            }
        }
    }
}

-(void)selectedCountry:(NSString*)country_code
{
    
    selectedCountry = country_code;
    
    
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


#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *countryWithAlphabet = [citiesInSection objectAtIndex:section];
    return [countryWithAlphabet objectForKey:@"sectionTitle"];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
   
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0;i < [citiesInSection count];i++) {
        //get first character of cities,eg: A,B...,C
        NSDictionary *countryWithAlphabet = [citiesInSection objectAtIndex:i];
        [array addObject:[countryWithAlphabet objectForKey:@"sectionTitle"]];
    }
    return array;
   
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    for (int i=0;i < [citiesInSection count];i++) {
        //get first character of cities,eg: A,B...,C
        NSDictionary *countryWithAlphabet = [citiesInSection objectAtIndex:i];
        //if match with title being chosed
        if ([title isEqualToString:[countryWithAlphabet objectForKey:@"sectionTitle"]]) {
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
    NSDictionary *countryWithAlphabet = [citiesInSection objectAtIndex:section];
    NSMutableArray *tempCountriesArray = [countryWithAlphabet objectForKey:@"arrayObject"];
    return [tempCountriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    tableView = tbl;
    
    NSDictionary *countryWithAlphabet = [citiesInSection objectAtIndex:indexPath.section];
    NSMutableArray *tempCountriesArray = [countryWithAlphabet objectForKey:@"arrayObject"];

    cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"country"]];
    cell.detailTextLabel.text = [[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"code"];
    // Configure the cell...
//    cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"country"]];
//    cell.detailTextLabel.text = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"code"];
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *countryWithAlphabet = [citiesInSection objectAtIndex:indexPath.section];
    NSMutableArray *tempCountriesArray = [countryWithAlphabet objectForKey:@"arrayObject"];
    NSArray *children = [[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"states"];
    if([children count] == 0)
    {
        return UITableViewCellAccessoryNone;
    }
    else
    {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
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
    

//    NSArray *children = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"states"];
    
    NSDictionary *countryWithAlphabet = [citiesInSection objectAtIndex:indexPath.section];
    NSMutableArray *tempCountriesArray = [countryWithAlphabet objectForKey:@"arrayObject"];
    
    NSArray *children = [[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"states"];
    if([children count] == 0)
    {
        if(chooseController == 1)
        {
            [profileController updateStateTextFieldNoState];
            
            [profileController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"code"] isDismissPopover:YES];
        }
        else if(chooseController == 2){
            [billingController updateStateTextFieldNoState];
            
            [billingController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"code"] isDismissPopover:YES];
        }
        else if(chooseController == 3){
            [shippingController updateStateTextFieldNoState];
            
            [shippingController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"code"] isDismissPopover:YES];
        }
    }
    else
    {
        DynamicTableViewController *dynamic = [[DynamicTableViewController alloc] init];
        [dynamic setStateArray:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"states"]];
         dynamic.title = @"States";
        if(chooseController == 1)
        {
            [dynamic setProfileController:profileController];
            [profileController updateStateTextFieldNoState];
            
            [profileController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"code"] isDismissPopover:NO];
        }
        else if(chooseController == 2)
        {
            [dynamic setBillingController:billingController];
            [billingController updateStateTextFieldNoState];
            
            [billingController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"code"] isDismissPopover:NO];
        }
        else if(chooseController == 3)
        {
            [dynamic setShippingController:shippingController];
            [shippingController updateStateTextFieldNoState];
            
            [shippingController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[tempCountriesArray objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"code"] isDismissPopover:NO];
        }
        
        [self.navigationController pushViewController:dynamic animated:YES];
    }
  
//    if(chooseController == 1)
//    {
//        [profileController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"code"]];
//    }
//    else if( chooseController == 2)
//    {
//       [billingController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"code"]];
//        
//    }
//    else if( chooseController == 3)
//    {
//        [shippingController updateCountryTextField:[[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"country"]] countryCode:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"code"]];
//        
//    }
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //for example [activityIndicator stopAnimating];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
