//
//  MenuViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/9/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController;
@class ReviewCheckOutViewController;
@interface MenuViewController : UITableViewController
{
    UITableView *tblView;
    NSArray *menuItems;
    UILabel* lblToSend;
    NSString *termName;
    DetailViewController *det;
    ReviewCheckOutViewController *review;
}
-(void)setArray:(NSArray*)ary;
-(void)setTermNa:(NSString*)ter;
-(void)setLabelToSend:(UILabel*)lbl;
-(void)setDetailController:(DetailViewController*)deti;
-(void)setReviewController:(ReviewCheckOutViewController*)deti;
@end
