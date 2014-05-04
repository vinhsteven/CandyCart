//
//  UserDetailViewController.m
//  User Directory
//
//  Created by Dead Mac on 11/11/13.
//  Copyright (c) 2013 Dead Mac. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController
@synthesize userImage,name,position,address_line_1,address_line_2,address_line_3,address_line_4,phone,email,url,notes,address_full;
@synthesize address_lbl,phone_lbl,email_lbl,url_lbl,note_lbl;
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
    //init
    copyString = @"";
    
    //Localize
    address_lbl.text = @"Address";
    phone_lbl.text = @"Phone";
    email_lbl.text = @"Email";
    url_lbl.text = @"Url";
    note_lbl.text = @"Description";
    
    
    // Do any additional setup after loading the view from its nib.
    userImage.layer.cornerRadius = 40;
    userImage.layer.masksToBounds = YES;
    userImage.layer.borderWidth = 0.5;
    userImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    UIImageView *img = [[UIImageView alloc] init];
    img = userImage;
    
    [userImage setImageWithURL:[NSURL URLWithString:[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"thumbnail"] ]
                   placeholderImage:[UIImage imageNamed:@"no-user-image-square.jpg"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              if(error)
                              {
                                  img.image = [UIImage imageNamed:@"no-user-image-square.jpg"];
                              }
                              else
                              {
                                  img.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(150, 150) source:image];
                              }
                              
                          }];
    
    name.text = [NSString stringWithFormat:@"%@",[personalData objectForKey:@"title"]];
  
    address_full.text = [NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"address"]];
    
    UILongPressGestureRecognizer *addressLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addressLongPress:)];
    [address_full addGestureRecognizer:addressLongPress];
    /*
    address_line_1.text = [NSString stringWithFormat:@"%@",[personalData objectForKey:@"address_line_1"]];
    address_line_2.text = [NSString stringWithFormat:@"%@",[personalData objectForKey:@"address_line_2"]];
    address_line_3.text = [NSString stringWithFormat:@"%@ %@",[personalData objectForKey:@"poscode"],[personalData objectForKey:@"city"]];
    NSString *state = [personalData objectForKey:@"state"];
    if([state isEqualToString:@""])
    {
    address_line_4.text = [NSString stringWithFormat:@"%@",[personalData objectForKey:@"country"]];
    }
    else
    {
      address_line_4.text = [NSString stringWithFormat:@"%@, %@",state,[personalData objectForKey:@"country"]];
    }
    
    UILongPressGestureRecognizer *addressLongPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addressLongPress:)];
    [address_line_1 addGestureRecognizer:addressLongPress1];
   
    UITapGestureRecognizer *address1Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMapTap:)];
    [address1Tap setNumberOfTapsRequired:1];
    [address_line_1 addGestureRecognizer:address1Tap];
    
    UILongPressGestureRecognizer *addressLongPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addressLongPress:)];
    [address_line_2 addGestureRecognizer:addressLongPress2];
    
    UITapGestureRecognizer *address2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMapTap:)];
    [address2Tap setNumberOfTapsRequired:1];
    [address_line_2 addGestureRecognizer:address2Tap];
    
    UILongPressGestureRecognizer *addressLongPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addressLongPress:)];
    [address_line_3 addGestureRecognizer:addressLongPress3];
    
    UITapGestureRecognizer *address3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMapTap:)];
    [address3Tap setNumberOfTapsRequired:1];
    [address_line_3 addGestureRecognizer:address3Tap];
    
    UILongPressGestureRecognizer *addressLongPress4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addressLongPress:)];
    [address_line_4 addGestureRecognizer:addressLongPress4];
    
    UITapGestureRecognizer *address4Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMapTap:)];
    [address4Tap setNumberOfTapsRequired:1];
    [address_line_4 addGestureRecognizer:address4Tap];
    */
    
    phone.text = [NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"pNumber"]];
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callNow:)];
    [phoneTap setNumberOfTapsRequired:1];
    [phone addGestureRecognizer:phoneTap];
    
    
    UILongPressGestureRecognizer *phoneLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(phoneLongPress:)];
    [phone addGestureRecognizer:phoneLongPress];
    
     email.text = [NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"contact_email"]];
    
    UITapGestureRecognizer *emailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailNowTap:)];
    [emailTap setNumberOfTapsRequired:1];
    [email addGestureRecognizer:emailTap];
    
    UILongPressGestureRecognizer *emailLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(emailLongPress:)];
    [email addGestureRecognizer:emailLongPress];
    
     url.text = [NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"url"]];
    
    UILongPressGestureRecognizer *urlLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(urlLongPress:)];
    
    [url addGestureRecognizer:urlLongPress];
    
    
    UITapGestureRecognizer *urlTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToUrlTap:)];
    [urlTap setNumberOfTapsRequired:1];
    [url addGestureRecognizer:urlTap];
    
    notes.text = [NSString stringWithFormat:@"%@",[personalData objectForKey:@"full_content_plain"]];
    
    UIButton *map = [UIButton buttonWithType:UIButtonTypeCustom];
    map.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    map.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [map setTitle:@"Map"  forState:UIControlStateNormal];
    [map addTarget:self
            action:@selector(goToMap:)
     forControlEvents:UIControlEventTouchDown];
    
    [map setNuiClass:@"UiBarButtonItem"];
    [map.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:map];
    self.navigationItem.rightBarButtonItem = button;

}
/*
-(IBAction)addToContact:(id)sender
{
    NSLog(@"Add to ontact");
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            [self createContact];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self createContact];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"failed_lbl", nil) message: [NSString stringWithFormat:NSLocalizedString(@"userdetail_failed_address_access", nil)] delegate: nil cancelButtonTitle: NSLocalizedString(@"ok_lbl", nil)  otherButtonTitles:nil];
        
        [updateAlert show];
    }
}
*/
/*
-(void)createContact{
    
    
    
    
    CFErrorRef error = NULL;
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(nil,&error);
    ABRecordRef newPerson = ABPersonCreate();
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty,(__bridge CFTypeRef)([personalData objectForKey:@"first_name"]), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)([personalData objectForKey:@"last_name"]), &error);
    ABRecordSetValue(newPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef)([personalData objectForKey:@"position"]), &error);
    
    ABRecordSetValue(newPerson, kABPersonNoteProperty, (__bridge CFTypeRef)([NSString stringWithFormat:@"%@",[personalData objectForKey:@"note"]]), &error);
    
    UIImage *im = userImage.image;
    NSData *dataRef = UIImagePNGRepresentation(im);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, nil);
    
    //Add my phone number
    ABMutableMultiValueRef PhoneVar = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(PhoneVar,(__bridge CFTypeRef)([personalData objectForKey:@"phone"]), kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, PhoneVar,nil);
    CFRelease(PhoneVar);
    
    
    //Add my email address
    ABMutableMultiValueRef EmailVar = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(EmailVar,(__bridge CFTypeRef)([personalData objectForKey:@"email"]) , kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, EmailVar,nil);
    CFRelease(EmailVar);
    
    
    ABMutableMultiValueRef webVar = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(webVar,(__bridge CFTypeRef)([personalData objectForKey:@"website"]) , kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonURLProperty, webVar,nil);
    CFRelease(webVar);
    
   
    
    //Add my mailing address
    ABMutableMultiValueRef Address = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
    [addressDict setObject:[NSString stringWithFormat:@"%@,%@",[address_line_1 text],[address_line_2 text]] forKey:(NSString *) kABPersonAddressStreetKey];
   
    [addressDict setObject:(__bridge id)((__bridge CFTypeRef)([personalData objectForKey:@"poscode"])) forKey:(NSString *)kABPersonAddressZIPKey];
     [addressDict setObject:(__bridge id)((__bridge CFTypeRef)([personalData objectForKey:@"city"])) forKey:(NSString *)kABPersonAddressCityKey];
    [addressDict setObject:(__bridge id)((__bridge CFTypeRef)([personalData objectForKey:@"state"])) forKey:(NSString *)kABPersonAddressStateKey];
    [addressDict setObject:(__bridge id)((__bridge CFTypeRef)([personalData objectForKey:@"country"])) forKey:(NSString *)kABPersonAddressCountryKey];
    ABMultiValueAddValueAndLabel(Address, (__bridge CFTypeRef)(addressDict), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, Address,&error);
    CFRelease(Address);
    
    //Finally saving the contact in the address book
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    if (error != NULL)
    {
        NSLog(@"Saving contact failed.");
    }
    
    
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"notification_lbl", nil) message: [NSString stringWithFormat:NSLocalizedString(@"userdetail_added_successful", nil)] delegate: nil cancelButtonTitle: NSLocalizedString(@"ok_lbl", nil)  otherButtonTitles:nil];
    
    [updateAlert show];

}
 */

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (BOOL) becomeFirstResponder
{
    return [super becomeFirstResponder];
}

-(void)getData:(NSDictionary*)userPersonalData{
    
    personalData = userPersonalData;
}


- (void)nameLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        copyString = [name text];
        
        [self becomeFirstResponder];
        
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }
    
}

- (void)positionLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        copyString = [position text];
        
        [self becomeFirstResponder];
        
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }
    
}



- (void)addressLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        copyString = [NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"address"]];
        
        [self becomeFirstResponder];
        
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }
    
}

-(void)goToMapTap:(UITapGestureRecognizer*)gesture{
    
    ContactUsViewController *contact = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:nil];
    contact.title = [personalData objectForKey:@"title"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%@",[personalData objectForKey:@"title"]] forKey:@"candyStoreName"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"address"]] forKey:@"candyStoreAddress"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"pNumber"]] forKey:@"candyLocPhone"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"contact_email"]] forKey:@"candyLocEmail"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"latitude"]] forKey:@"candyLat"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"longtitude"]] forKey:@"candyLong"];
    
    [contact initContactUsTemplateDictionary:dic];
    [self.navigationController pushViewController:contact animated:YES];
}

-(IBAction)goToMap:(id)sender
{
    ContactUsViewController *contact = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:nil];
    contact.title = [personalData objectForKey:@"title"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%@",[personalData objectForKey:@"title"]] forKey:@"candyStoreName"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"address"]] forKey:@"candyStoreAddress"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"pNumber"]] forKey:@"candyLocPhone"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"contact_email"]] forKey:@"candyLocEmail"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"latitude"]] forKey:@"candyLat"];
    [dic setValue:[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"longtitude"]] forKey:@"candyLong"];
    
    [contact initContactUsTemplateDictionary:dic];
    [self.navigationController pushViewController:contact animated:YES];
}

-(void)callNowTap:(UITapGestureRecognizer*)sender
{
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Redirect" message: [NSString stringWithFormat:@"Do you want to call %@",[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"pNumber"]]] delegate: self cancelButtonTitle: NSLocalizedString(@"cancel_lbl", nil)  otherButtonTitles:NSLocalizedString(@"call_lbl", nil),nil];
    
    [updateAlert show];
}

-(IBAction)callNow:(id)sender
{
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Confirmation" message: [NSString stringWithFormat:@"%@ %@",@"Do you want to call this number",[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"pNumber"]]] delegate: self cancelButtonTitle: @"Cancel"   otherButtonTitles:@"Call Now",nil];
    
    [updateAlert show];
}

- (void)phoneLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        copyString = [phone text];
        
        [self becomeFirstResponder];
      
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }

}









- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        //Cancel
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",[[[personalData objectForKey:@"page_template_meta"] objectForKey:@"if_businessDirectoryPlugin"] objectForKey:@"pNumber"]]]]];
    }
    
}

-(void)emailNowTap:(UILongPressGestureRecognizer*)gestureRecognizer
{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    NSArray *usersTo = [NSArray arrayWithObjects:[email text], nil];
    [mailer setToRecipients:usersTo];
    
    [self presentViewController:mailer animated:YES completion:nil];
    
}

-(IBAction)emailNow:(id)sender
{
    
   
    
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
   
    NSArray *usersTo = [NSArray arrayWithObjects:[email text], nil];
    [mailer setToRecipients:usersTo];
    
    [self presentViewController:mailer animated:YES completion:nil];
  
    
}



- (void)emailLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        copyString = [email text];
        
        [self becomeFirstResponder];
        
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }
    
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goToUrlTap:(UITapGestureRecognizer*)gesture{
    iPhoneWebView *webview = [[iPhoneWebView alloc] init];
    [webview loadUrlInWebView:[NSString stringWithFormat:@"http://%@",url.text]];
    [self.navigationController pushViewController:webview animated:YES];
}

-(IBAction)goToUrl:(id)sender
{
    iPhoneWebView *webview = [[iPhoneWebView alloc] init];
    [webview loadUrlInWebView:[NSString stringWithFormat:@"http://%@",url.text]];
    [self.navigationController pushViewController:webview animated:YES];
    
}

- (void)urlLongPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        copyString = [url text];
        
        [self becomeFirstResponder];
        
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0.0f, 0.0f) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }
    
}


- (void) copy:(id) sender {
    // called when copy clicked in menu
    [[UIPasteboard generalPasteboard] setString:copyString];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
