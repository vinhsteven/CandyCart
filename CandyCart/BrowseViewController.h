//
//  BrowseViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+StackBlur.h"
#import "BrowseDetailViewController.h"
#import "CameraViewController.h"
@interface BrowseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    CGPoint initialContentOffset;
    UITableView *tblView;
    NSArray *aryDic;
    UIView *searchLayer;
    UISearchBar *productSearchBar;
    UIImageView* blurView;
    
}
@end
