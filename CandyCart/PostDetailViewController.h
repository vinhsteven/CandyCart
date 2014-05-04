//
//  PostDetailViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/23/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MDCParallaxView.h"
#import "socialMediaController.h"
@interface PostDetailViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,MBProgressHUDDelegate,MFMailComposeViewControllerDelegate,IDMPhotoBrowserDelegate,socialMediaControllerDelegate>
{
    MDCParallaxView *parallaxView;
     MBProgressHUD *HUD;
    UIView *topView;
    UIView *bottomView;
    NSDictionary *post;
    UIScrollView *imgScrollView;
     int current_index_image;
    UIButton *shareBtn;
    UIWebView *bottomWeb;
    FPPopoverController *sharePopOver;
}
-(void)setPostDictionary:(NSDictionary*)setPost;
@end
