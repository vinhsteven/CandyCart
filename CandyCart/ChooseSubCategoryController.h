//
//  ChooseSubCategoryController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/12/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"
@class BrowseDetailViewController;
@interface ChooseSubCategoryController : UITableViewController
{
    UITableView *tblView;
    NSArray *menuItems;
    UILabel* lblToSend;
    FPPopoverController *pop;
    BrowseDetailViewController *brow;
    NSString *categoryParentID;
}
-(void)setArray:(NSArray*)ary;
-(void)setLabelToSend:(UILabel*)lbl;
-(void)setPopOverController:(FPPopoverController*)pops;
-(void)setParentController:(BrowseDetailViewController*)browse;
-(void)setCategoryParentID:(NSString*)parentID;
@end
