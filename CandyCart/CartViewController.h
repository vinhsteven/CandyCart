//
//  CartViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "MyCartBox.h"
#import "DetailViewController.h"
#import "BillingCheckOutViewController.h"
@interface CartViewController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate,FPPopoverControllerDelegate>
{
    MGScrollView *scroller;
    MBProgressHUD *HUD;
    CGPoint initialContentOffset;
    FPPopoverController *popover;
    UIButton *btnNext;
}

- (void) didSelectBuyMethod:(NSString*)type andType:(int)_howType;

@end
