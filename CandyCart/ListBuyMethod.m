//
//  ListBuyMethod.m
//  CandyCart
//
//  Created by Steven on 5/4/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import "ListBuyMethod.h"
#import "CartViewController.h"

@interface ListBuyMethod ()

@end

@implementation ListBuyMethod
@synthesize parent;
@synthesize mainSegment;

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
    
    NSString *titleStr[] = {
        NSLocalizedString(@"cart_review_buy_as_guest", nil),
        NSLocalizedString(@"cart_review_buy_as_user", nil)
    };
    NSString *typeStr[] = {
        @"guest",
        @"user",
    };
    
    for (int i=0;i < sizeof(titleStr)/sizeof(titleStr[0]);i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:titleStr[i],@"title",typeStr[i],@"type", nil];
        [mainArray addObject:dict];
    }
    
    NSArray *segmentItems = [NSArray arrayWithObjects:NSLocalizedString(@"cart_review_buy_at_shop", nil),NSLocalizedString(@"cart_review_take_away", nil), nil];
    mainSegment = [[UISegmentedControl alloc] initWithItems:segmentItems];
    mainSegment.frame = CGRectMake(0, 0, 200, 40);
    mainSegment.selectedSegmentIndex = 0;
    
#ifdef TEST
    [mainArray insertObject:mainSegment atIndex:0];
#endif
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
    
#ifndef TEST
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.text = [dict objectForKey:@"title"];
#else
    if (indexPath.row != 0) {
        NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
        // Configure the cell...
        cell.textLabel.text = [dict objectForKey:@"title"];
    }
    else {
        [cell.contentView addSubview:mainSegment];
    }
#endif
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef TEST
    if (indexPath.row != 0) {
        NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
        [(CartViewController*)parent didSelectBuyMethod:[dict objectForKey:@"type"] andType:mainSegment.selectedSegmentIndex];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
#else
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    [(CartViewController*)parent didSelectBuyMethod:[dict objectForKey:@"type"] andType:mainSegment.selectedSegmentIndex];
#endif
}

@end
