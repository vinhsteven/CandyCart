//
//  MenuViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/9/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@protocol socialMediaControllerDelegate
-(void)didChooseEmail;
@end

@class DetailViewController;
@class FPPopoverController;
@interface socialMediaController : UITableViewController<MFMailComposeViewControllerDelegate>
{
    UITableView *tblView;
    NSArray *menuItems;
    NSString *url;
    DetailViewController *de;
    FPPopoverController *pop;
    
     id <socialMediaControllerDelegate> delegate;
}
@property (retain, nonatomic) id <socialMediaControllerDelegate> delegate;
-(void)setUrl:(NSString*)productURL;

@end
