//
//  PaymentWebViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/14/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderViewController;
@interface PaymentWebViewController : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate>
{
    UIWebView *webViewSe;
    NSString *urls;
    CGPoint initialContentOffset;
      MBProgressHUD *HUD;
    OrderViewController*order;
}
-(void)loadUrlInWebView:(NSString*)url;
-(void)setOrderViewController:(OrderViewController *)orders;
@end
