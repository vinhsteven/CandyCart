//
//  PushedMsgClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 9/3/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "PushedMsgClass.h"
#import "OrderViewController.h"

@implementation PushedMsgClass
+ (PushedMsgClass *) instance {
    static PushedMsgClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//What we want to do when we get a message.We filter first by Message type.
-(void)getPushNotificationMessage:(NSDictionary*)userInfo needReloadRightView:(BOOL)needReload{
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *messageBody = [[apsInfo objectForKey:@"alert"] objectForKey:@"body"];
    NSString *postID = [[apsInfo objectForKey:@"alert"] objectForKey:@"postID"];
    NSString *type = [[apsInfo objectForKey:@"alert"] objectForKey:@"type"];
    
    if([type isEqualToString:[self pushMsgTypeEnumToString:NONE]])
    {
        [self for_NONE:messageBody];
    }
    else if([type isEqualToString:[self pushMsgTypeEnumToString:POST]])
    {
        [self for_POST_PAGE:messageBody postID:postID];
    }
    else if([type isEqualToString:[self pushMsgTypeEnumToString:PAGE]])
    {
        [self for_POST_PAGE:messageBody postID:postID];
    }
    else if([type isEqualToString:[self pushMsgTypeEnumToString:LINK]])
    {
        [self for_LINK:messageBody postID:postID]; //Post ID Become Link
    }
    else if([type isEqualToString:[self pushMsgTypeEnumToString:PRODUCT]])
    {
        [self for_PRODUCT:messageBody postID:postID];
    }
    else if([type isEqualToString:[self pushMsgTypeEnumToString:COMMENT]])
    {
        [self for_COMMENT:messageBody postID:postID];
    }
    else if([type isEqualToString:[self pushMsgTypeEnumToString:ORDERNOTES]])
    {
        [self for_ORDERNOTES:messageBody postID:postID];
    }
    else if([type isEqualToString:[self pushMsgTypeEnumToString:STATUS_CHANGED]])
    {
        [self for_STATUS_CHANGED:messageBody postID:postID];
    }
    else if ([type isEqualToString:[self pushMsgTypeEnumToString:ORDER_STATUS]])
    {
        [self for_ORDER_STATUS:messageBody postID:postID];
    }
    else
    {
        [self for_NONE:messageBody];
    }
    
    if(needReload == YES)
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [[DataService instance] pushNotificationApi];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [[MainViewClass instance].rightView setItems:[DataService instance].pushNotifications];
                [[MainViewClass instance].rightView.tbl reloadData];
            });
            
        });
    }
    
    
    
    
    
    
}


-(void)for_COMMENT:(NSString*)messageBody postID:(NSString*)postID{
    
    currentPostID = postID;
    currentBody = messageBody;
    
    
    
    [[MainViewClass instance].notification showView:messageBody completed:^{
        
        
        
        UITapGestureRecognizer *lblTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblCommentExe:)];
        [lblTap setNumberOfTouchesRequired:1];
        [[MainViewClass instance].notification.label addGestureRecognizer:lblTap];
        
    }];
    
    
}




-(void)for_STATUS_CHANGED:(NSString*)messageBody postID:(NSString*)postID{
    currentPostID = postID;
    currentBody = messageBody;
    
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns_title", nil)
                                                   message:messageBody
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"apns_close_btn", nil)
                                         otherButtonTitles:NSLocalizedString(@"apns_action_btn", nil),nil];
    
    noti.tag = STATUS_CHANGED;
    [noti show];
    
}


-(void)for_ORDERNOTES:(NSString*)messageBody postID:(NSString*)postID{
    
    
    currentPostID = postID;
    currentBody = messageBody;
    
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns_title", nil)
                                                   message:messageBody
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"apns_close_btn", nil)
                                         otherButtonTitles:NSLocalizedString(@"apns_action_btn", nil),nil];
    
    noti.tag = ORDERNOTES;
    [noti show];
    
}



-(void)for_NONE:(NSString*)messageBody{
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns_title", nil)
                                                   message:messageBody
                                                  delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"apns_close_btn", nil)
                                         otherButtonTitles:nil];
    [noti show];
    
}

-(void)for_POST_PAGE:(NSString*)messageBody postID:(NSString*)postID{
    
    
    currentPostID = postID;
    currentBody = messageBody;
    
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns_title", nil)
                                                   message:messageBody
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"apns_close_btn", nil)
                                         otherButtonTitles:NSLocalizedString(@"apns_action_btn", nil),nil];
    
    noti.tag = POST;
    [noti show];
    
}


-(void)for_LINK:(NSString*)messageBody postID:(NSString*)postID{
    
    
    currentPostID = postID;
    currentBody = messageBody;
    
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns_title", nil)
                                                   message:messageBody
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"apns_close_btn", nil)
                                         otherButtonTitles:NSLocalizedString(@"apns_action_btn", nil),nil];
    
    noti.tag = LINK;
    [noti show];
    
}


-(void)for_PRODUCT:(NSString*)messageBody postID:(NSString*)postID{
    currentPostID = postID;
    currentBody = messageBody;
    
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns_title", nil)
                                                   message:messageBody
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"apns_close_btn", nil)
                                         otherButtonTitles:NSLocalizedString(@"apns_action_btn", nil),nil];
    
    noti.tag = PRODUCT;
    [noti show];
}

- (void) for_ORDER_STATUS:(NSString*)messageBody postID:(NSString*)postID {
    currentPostID = postID;
    currentBody = messageBody;
    
    UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns_title", nil)
                                                   message:messageBody
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"apns_close_btn", nil)
                                         otherButtonTitles:NSLocalizedString(@"apns_action_btn", nil),nil];
    
    noti.tag = ORDER_STATUS;
    [noti show];
}

- (void) for_ORDER_STATUS_load {
    HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
    [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
    
    HUD.delegate = self;
    
    [HUD showWhileExecuting:@selector(for_ORDER_STATUS_exe) onTarget:self withObject:nil animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == POST)
    {
        if (buttonIndex == 1)
        {
            //View Btn
            [self for_POST_PAGE_load];
        }
        
    }
    else if(alertView.tag == PRODUCT)
    {
        if (buttonIndex == 1)
        {
            //View Btn
            [self for_PRODUCT_load];
        }
        
    }
    else if(alertView.tag == LINK)
    {
        if (buttonIndex == 1)
        {
            //View Btn
            [self for_LINK_load];
        }
        
    }
    else if(alertView.tag == ORDERNOTES)
    {
        if (buttonIndex == 1)
        {
            //View Btn
            [self for_ORDERNOTES_load];
        }
        
    }
    else if(alertView.tag == STATUS_CHANGED)
    {
        if (buttonIndex == 1)
        {
            //View Btn
            [self for_STATUSCHANGED_load];
        }
    }
    else if (alertView.tag == ORDER_STATUS) {
        if (buttonIndex == 1) {
            [self for_ORDER_STATUS_load];
        }
    }
}

-(void)lblCommentExe:(UITapGestureRecognizer*)tap{
    
    [[MainViewClass instance].notification closeView];
    
    HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
    [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
    
    HUD.delegate = self;
    
    
    [HUD showWhileExecuting:@selector(for_COMMENT_exe) onTarget:self withObject:nil animated:YES];
}

-(void)for_STATUSCHANGED_load{
    
    HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
    [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
    
    HUD.delegate = self;
    
    
    [HUD showWhileExecuting:@selector(for_STATUSCHANGED_exe) onTarget:self withObject:nil animated:YES];
    
}


-(void)for_ORDERNOTES_load{
    
    HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
    [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
    
    HUD.delegate = self;
    
    
    [HUD showWhileExecuting:@selector(for_ORDERNOTES_exe) onTarget:self withObject:nil animated:YES];
    
}

-(void)for_COMMENT_exe
{
    NSDictionary *comment = [[DataService instance] getCommentByCommentID:currentPostID];
    NSDictionary *productReview = [[DataService instance] getProductReview:[comment objectForKey:@"comment_post_ID"] parent:currentPostID];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            
            
            
            
            ChildCommentViewController *child = [[ChildCommentViewController alloc] init];
            child.child = productReview;
            child.navigationItem.leftBarButtonItem = [self closeBtn];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:child];
            child.title = NSLocalizedString(@"product_review_child_view_controller_title", nil);
            
            nav.navigationBar.translucent = NO;
            [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:^{
                
            }];
            
            currentController = child;
            
        });
        
    });
    
}


-(void)for_STATUSCHANGED_exe
{
    if([[UserAuth instance] checkUserAlreadyLogged] == true)
    {
        NSDictionary *orderInfo = [[DataService instance] get_single_order:[UserAuth instance].username password:[UserAuth instance].password orderID:currentPostID];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                
                [[MyOrderClass instance] setMyOrder:orderInfo];
                OrderViewController *order = [[OrderViewController alloc] init];
                [order noCloseBtn];
                order.navigationItem.leftBarButtonItem = [self closeBtn];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:order];
                nav.navigationBar.translucent = NO;
                [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:^{
                    
                }];
                
                currentController = order;
            });
            
        });
    }
    else
    {
        
        UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general_notification_title", nil)
                                                       message:NSLocalizedString(@"general_notification_error_need_signin_order", nil)
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                                             otherButtonTitles:nil];
        [noti show];
        
    }
}



-(void)for_ORDERNOTES_exe
{
    if([[UserAuth instance] checkUserAlreadyLogged] == true)
    {
        NSDictionary *orderInfo = [[DataService instance] get_single_order:[UserAuth instance].username password:[UserAuth instance].password orderID:currentPostID];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                
                [[MyOrderClass instance] setMyOrder:orderInfo];
                OrderViewController *order = [[OrderViewController alloc] init];
                [order noCloseBtn];
                order.navigationItem.leftBarButtonItem = [self closeBtn];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:order];
                nav.navigationBar.translucent = NO;
                [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:^{
                    
                    OrderNotesViewController *notes = [[OrderNotesViewController alloc] init];
                    [nav pushViewController:notes animated:YES];
                    
                }];
                
                currentController = order;
            });
            
        });
    }
    else
    {
        
        UIAlertView *noti = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general_notification_title", nil)
                                                       message:NSLocalizedString(@"general_notification_error_need_signin_order", nil)
                                                      delegate:nil
                                             cancelButtonTitle:NSLocalizedString(@"general_notification_ok_btn_title", nil)
                                             otherButtonTitles:nil];
        [noti show];
        
    }
}



//What we want to do if POST type pushed
-(void)for_POST_PAGE_load{
    
    HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
    [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
    
    HUD.delegate = self;
    
    
    [HUD showWhileExecuting:@selector(for_POST_PAGE_exe) onTarget:self withObject:nil animated:YES];
    
}


-(void)for_PRODUCT_load{
    
    HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
    [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
    
    HUD.delegate = self;
    
    
    [HUD showWhileExecuting:@selector(for_PRODUCT_exe) onTarget:self withObject:nil animated:YES];
    
}


-(void)for_LINK_load{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            iPhoneWebView *webView = [[iPhoneWebView alloc] init];
            [webView loadUrlInWebView:currentPostID];
            
            webView.navigationItem.leftBarButtonItem = [self closeBtn];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webView];
            nav.navigationBar.translucent = NO;
            [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
            
            currentController = webView;
            
        });
        
    });
    
    
}

-(void)for_PRODUCT_exe
{
    
    NSDictionary *postDictionary = [[DataService instance] getSingleProduct:currentPostID];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            DetailViewController *det = [[DetailViewController alloc] init];
            [det setProductInfo:postDictionary];
            det.navigationItem.leftBarButtonItem = [self closeBtn];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:det];
            nav.navigationBar.translucent = NO;
            [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
            
            currentController = det;
        });
    });
}

- (void) for_ORDER_STATUS_exe {
//    NSDictionary *postDictionary = [[DataService instance] getSingleProduct:currentPostID];
    NSDictionary *postDictionary = [[DataService instance] get_single_order:[UserAuth instance].username password:[UserAuth instance].password orderID:[NSString stringWithFormat:@"%@",currentPostID]];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
//            DetailViewController *det = [[DetailViewController alloc] init];
//            [det setProductInfo:postDictionary];
            
            OrderViewController *controller = [[OrderViewController alloc] init];
            [[MyOrderClass instance] setMyOrder:postDictionary];
            
            controller.navigationItem.leftBarButtonItem = [self closeBtn];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            nav.navigationBar.translucent = NO;
            [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
            
            currentController = controller;
        });
    });
}


-(void)for_POST_PAGE_exe{
    
    
    NSDictionary *postDictionary = [[DataService instance] getWpPostByPostID:currentPostID];
    
    NSString *pageTemplate = [postDictionary objectForKey:@"page_template_type"];
    
    NSArray *xmlArray;
    
    NSDictionary *instagram_responses;
    NSString *hashtag;
    int hashtag_post_total = 0;
    
    if([pageTemplate isEqualToString:@"RSSFeed"])
    {
        NSString *rssUrl = [[[postDictionary objectForKey:@"page_template_meta"] objectForKey:@"if_candyRSSFeed"] objectForKey:@"candyRSSFeed"];
        xmlArray= [[DataService instance] getRSSXmlData:rssUrl];
        
    }
    else if([pageTemplate isEqualToString:@"instagramHash"])
    {
        hashtag = [[[postDictionary objectForKey:@"page_template_meta"] objectForKey:@"if_instagramHash"] objectForKey:@"hash_tag"];
        
        
        instagram_responses = [[DataService instance] getInstagramAPI:hashtag];
        hashtag_post_total = [[DataService instance] countInstagramHashTag:hashtag];
    }
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            
            if([pageTemplate isEqualToString:@"ParallaxPage"])
            {
                
                PostDetailViewController *pDetail = [[PostDetailViewController alloc] init];
                [pDetail setPostDictionary:postDictionary];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pDetail];
                pDetail.navigationController.navigationBar.translucent = NO;
                
                pDetail.navigationItem.leftBarButtonItem = [self closeBtn];
                nav.navigationBar.translucent = NO;
                [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
                
                currentController = pDetail;
                
                
                
                
            }
            else if([pageTemplate isEqualToString:@"PlainPageWithoutFeaturedImage"])
            {
                PlainPostDetailViewController *plainPost = [[PlainPostDetailViewController alloc] init];
                plainPost.title = [postDictionary objectForKey:@"title"];
                [plainPost setPostInfo:postDictionary];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:plainPost];
                plainPost.navigationController.navigationBar.translucent = NO;
                
                plainPost.navigationItem.leftBarButtonItem = [self closeBtn];
                nav.navigationBar.translucent = NO;
                [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
                
                currentController = plainPost;
                
                
            }
            else if([pageTemplate isEqualToString:@"OfficeOrStoreLocation"])
            {
                
                NSDictionary *contactInfo = [[postDictionary objectForKey:@"page_template_meta"] objectForKey:@"if_OfficeOrStoreLocation"];
                ContactUsViewController *con = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:nil];
                con.title = [postDictionary objectForKey:@"title"];
                con.navigationController.navigationBar.translucent = NO;
                [con initContactUsTemplateDictionary:contactInfo];
                con.navigationItem.leftBarButtonItem = [self closeBtn];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
                nav.navigationBar.translucent = NO;
                [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
                
                currentController = con;
                
                
            }
            else if([pageTemplate isEqualToString:@"CallUs"])
            {
                NSString *phoneNumber = [[[postDictionary objectForKey:@"page_template_meta"] objectForKey:@"if_CallUs"] objectForKey:@"candyCallUs"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]];
                
            }
            else if([pageTemplate isEqualToString:@"EmailUs"])
            {
                
                NSString *email = [[[postDictionary objectForKey:@"page_template_meta"] objectForKey:@"if_EmailUs"] objectForKey:@"candyEmail"];
                
                
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                
                NSArray *usersTo = [NSArray arrayWithObjects:email, nil];
                [mailer setToRecipients:usersTo];
                
                [[[MainViewClass instance] getPPReavealController] presentViewController:mailer animated:YES completion:nil];
                
                currentController = mailer;
                
                
                
            }
            else if([pageTemplate isEqualToString:@"RSSFeed"])
            {
                [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                RSSFeedControllerViewController *rss = [[RSSFeedControllerViewController alloc] init];
                rss.navigationController.navigationBar.translucent = NO;
                [rss setRSSInfo:xmlArray];
                rss.navigationItem.leftBarButtonItem = [self closeBtn];
                rss.title = [postDictionary objectForKey:@"title"];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rss];
                nav.navigationBar.translucent = NO;
                [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
                
                
                currentController = rss;
            }
            else if([pageTemplate isEqualToString:@"instagramHash"])
            {
                
                InstagramViewController *insta = [[InstagramViewController alloc] init];
                [insta setInfoDictionary:instagram_responses hashtag:hashtag postTotal:hashtag_post_total];
                insta.navigationController.navigationBar.translucent = NO;
                insta.title = [postDictionary objectForKey:@"title"];
                insta.navigationItem.leftBarButtonItem = [self closeBtn];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:insta];
                nav.navigationBar.translucent = NO;
                [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
                
                currentController = insta;
                
            }
            else if([pageTemplate isEqualToString:@"imggallery"])
            {
                [[[MainViewClass instance] getPPReavealController] openCompletelyAnimated:YES];
                NSArray *galleryImages = [[postDictionary objectForKey:@"images"] objectForKey:@"other_images"];
                ImageGalleryThumbController *gallery = [[ImageGalleryThumbController alloc] init];
                gallery.navigationController.navigationBar.translucent = NO;
                [gallery setImageInfo:galleryImages];
                gallery.navigationItem.leftBarButtonItem = [self closeBtn];
                gallery.title = [postDictionary objectForKey:@"title"];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gallery];
                nav.navigationBar.translucent = NO;
                [[[MainViewClass instance] getPPReavealController] presentViewController:nav animated:YES completion:nil];
                
                currentController = gallery;
                
            }
            else if([pageTemplate isEqualToString:@"KrukChat"])
            {
                
                
                
            }
            
        });
        
    });
    
    
    
}







-(NSString*) pushMsgTypeEnumToString:(kPushMsgType)enumVal
{
    NSArray *pushMsgTypeArray = [[NSArray alloc] initWithObjects:kPushMsgTypeArray];
    return [pushMsgTypeArray objectAtIndex:enumVal];
}


-(UIBarButtonItem*)closeBtn{
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(5, 8, 63, 30);
    closeBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [closeBtn setTitle:NSLocalizedString(@"close_btn_title", nil) forState:UIControlStateNormal];
    [closeBtn addTarget:self
                 action:@selector(closeBtnAction)
       forControlEvents:UIControlEventTouchDown];
    
    [closeBtn setNuiClass:@"UiBarButtonItem"];
    [closeBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:closeBtn];
    return button;
}

-(void)closeBtnAction{
    
    [currentController.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    [currentController dismissViewControllerAnimated:YES completion:nil];
}


@end
