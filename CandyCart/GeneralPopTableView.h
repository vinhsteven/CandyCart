//
//  GeneralPopTableView.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/18/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GeneralPopTableViewDelegate
-(void)didChooseGeneralPopTableView:(NSDictionary*)chooseData;
@end

@interface GeneralPopTableView : UITableViewController
{
     UITableView *tbl;
     NSArray *menuItems;
    NSString *termName;
    NSString *detailTermName;
    BOOL needDetail;
    
    id <GeneralPopTableViewDelegate> delegate;
}
@property (retain, nonatomic) id <GeneralPopTableViewDelegate> delegate;
-(void)initGeneralPopTableView:(NSString*)tblListTermName detailList:(NSString*)detailListTermName menuItem:(NSArray*)menuItemsArray;
@end
