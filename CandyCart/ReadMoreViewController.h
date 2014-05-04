//
//  ReadMoreViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/26/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "SDSegmentedControl.h"
#import "iPhoneWebView.h"
#import "PhotoBox.h"
@interface ReadMoreViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
{
    UIWebView *webViewC;
    SDSegmentedControl *segmentedControl;
    NSString *html;
    BOOL hasAttribute;
        CGPoint initialContentOffset;
    NSDictionary *productInfo;
    UIView *firstView;
    UIView *secondView;
    MGScrollView *scroller;
         MBProgressHUD *HUD;
}
-(void)setFullDescString:(NSString*)string andHasAttribute:(BOOL)has andProductInfo:(NSDictionary*)productInfos;
@end
