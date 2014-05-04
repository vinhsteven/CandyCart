//
//  ChooseSubCategoryController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/12/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ChooseSubCategoryController.h"
#import "BrowseDetailViewController.h"
@interface ChooseSubCategoryController ()

@end

@implementation ChooseSubCategoryController

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
    
    UIButton *allItems = [UIButton buttonWithType:UIButtonTypeCustom];
    allItems.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    allItems.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [allItems setTitle:NSLocalizedString(@"popover_view_popover_allitems_btn", nil) forState:UIControlStateNormal];
    [allItems addTarget:self
                 action:@selector(allItemBtnAction)
       forControlEvents:UIControlEventTouchDown];
    
    [allItems setNuiClass:@"UiBarButtonItem"];
    [allItems.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:allItems];
    self.navigationItem.rightBarButtonItem = button;

  
}

-(void)setCategoryParentID:(NSString*)parentID{
    categoryParentID = parentID;
    
}

-(void)allItemBtnAction{
    
    NSLog(@"Back to parent category");
    
    lblToSend.text = NSLocalizedString(@"browse_view_select_sub_category", nil);
    
    pop.view.hidden = YES;
    [brow subCategoryExe:categoryParentID];
}

-(void)setPopOverController:(FPPopoverController*)pops{
    
    pop = pops;
}

-(void)setArray:(NSArray*)ary{
    
    menuItems = ary;
}


-(void)setLabelToSend:(UILabel*)lbl{
    
    lblToSend = lbl;
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
    
    
    // Configure the cell...
    cell.textLabel.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *children = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"children"];
    if([children count] == 0)
    {
      return UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
    return UITableViewCellAccessoryDetailDisclosureButton;
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    ChooseSubCategoryController *detail = [[ChooseSubCategoryController alloc] init];
    detail.title = [[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [detail setPopOverController:pop];
    [detail setArray:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"children"]];
    [detail setLabelToSend:lblToSend];
    [detail setCategoryParentID:categoryParentID];
    [detail setParentController:brow];
    [self.navigationController pushViewController:detail animated:YES];
    NSLog(@"didSelect");
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

-(void)setParentController:(BrowseDetailViewController*)browse
{
    
    brow = browse;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    lblToSend.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"name"]];
   
    pop.view.hidden = YES;
    [brow subCategoryExe:[[menuItems objectAtIndex:indexPath.row] objectForKey:@"term_id"]];
}

@end
