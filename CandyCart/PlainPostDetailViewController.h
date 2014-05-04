//
//  PlainPostDetailViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/23/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlainPostDetailViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,socialMediaControllerDelegate,MFMailComposeViewControllerDelegate>
{
     UIWebView *webViewSe;
    NSDictionary *postInfo;
     MBProgressHUD *HUD;
    UIButton *shareBtn;
     FPPopoverController *sharePopOver;
}
-(void)setPostInfo:(NSDictionary*)postIn;
@end
