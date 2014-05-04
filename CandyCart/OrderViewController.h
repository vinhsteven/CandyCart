//
//  OrderViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/13/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "MyCartBox.h"
#import "PaymentWebViewController.h"
#import "OrderNotesViewController.h"
@interface OrderViewController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate>

{
    CGPoint initialContentOffset;
    CGPoint svos;
    CGRect currentRect;
    MGScrollView *scroller;
    MBProgressHUD *HUD;
    UIButton *payBtn;
    UIBarButtonItem *payBtnItem;
    BOOL noCloseBtn;
    UIButton *orderNotes;
    UIBarButtonItem *orderNotesBtnItems;
}
-(void)refreshOrderPaymentSuccessful;
-(void)refreshOrderFailed;

//UI Modified
-(void)noCloseBtn;
@end
