//
//  InstagramDetailWebView.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/28/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramDetailWebView : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    UIWebView *webViewSe;
    NSString *urls;
    CGPoint initialContentOffset;
    NSString *mediaID;
}
-(void)loadUrlInWebView:(NSString*)url mediaID:(NSString*)mediaID;
@end
