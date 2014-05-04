//
//  RightViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 9/7/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
  
     NSArray *menuItems;
    NSDictionary *fullInfo;
    UISegmentedControl *segmentControl;
}
@property(nonatomic,retain) UITableView *tbl;
-(void)setItems:(NSDictionary*)items;
@end
