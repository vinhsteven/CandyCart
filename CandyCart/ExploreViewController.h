//
//  ExploreViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "PhotoBox.h"
#import "SDSegmentedControl.h"

#import "DetailViewController.h"
@interface ExploreViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,MBProgressHUDDelegate>
{
    MGScrollView *scroller;
    CGPoint initialContentOffset;
    SDSegmentedControl *segmentedControl;
    UIWebView *webView;
    UIActivityIndicatorView *ind;
    MBProgressHUD *HUD;
    NSMutableArray *itemsArray;
}
@end
