//
//  LeftViewController.h
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlainPostDetailViewController.h"
#import "PostByCategoryViewController.h"
#import "ContactUsViewController.h"
#import "RSSFeedControllerViewController.h"
#import "ImageGalleryThumbController.h"
#import <MessageUI/MessageUI.h>
#import "InstagramViewController.h"
#import "mapViewViewController.h"
@interface LeftViewController : UIViewController<UITableViewDelegate,MFMailComposeViewControllerDelegate,UITableViewDataSource,UISearchBarDelegate,MBProgressHUDDelegate>
{
    UITableView *tbl;
    NSArray *menuItems;
    BOOL hideNavBar;
    MBProgressHUD *HUD;
    UISearchBar *searchBar;
    UIImageView* blurView;
    
    
}
-(void)setMenuItems:(NSArray*)items hideNavBar:(BOOL)hide;
@end
