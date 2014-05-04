//
//  UserDetailViewController.h
//  User Directory
//
//  Created by Dead Mac on 11/11/13.
//  Copyright (c) 2013 Dead Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ContactUsViewController.h"
//#import <AddressBookUI/AddressBookUI.h>
#import "iPhoneWebView.h"
@interface UserDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSDictionary *personalData;
    NSString *copyString;
}
-(void)getData:(NSDictionary*)userPersonalData;
@property(nonatomic,retain) IBOutlet UIImageView *userImage;
@property(nonatomic,retain) IBOutlet UILabel *name;
@property(nonatomic,retain) IBOutlet UILabel *position;
@property(nonatomic,retain) IBOutlet UITextView *address_full;
@property(nonatomic,retain) IBOutlet UILabel *address_line_1;
@property(nonatomic,retain) IBOutlet UILabel *address_line_2;
@property(nonatomic,retain) IBOutlet UILabel *address_line_3;
@property(nonatomic,retain) IBOutlet UILabel *address_line_4;
@property(nonatomic,retain) IBOutlet UILabel *phone;
@property(nonatomic,retain) IBOutlet UILabel *email;
@property(nonatomic,retain) IBOutlet UILabel *url;


@property(nonatomic,retain) IBOutlet UILabel *address_lbl;
@property(nonatomic,retain) IBOutlet UILabel *phone_lbl;
@property(nonatomic,retain) IBOutlet UILabel *email_lbl;
@property(nonatomic,retain) IBOutlet UILabel *url_lbl;
@property(nonatomic,retain) IBOutlet UILabel *note_lbl;


@property(nonatomic,retain) IBOutlet UITextView *notes;

-(IBAction)goToMap:(id)sender;
-(IBAction)emailNow:(id)sender;
-(IBAction)callNow:(id)sender;
-(IBAction)goToUrl:(id)sender;
@end
