//
//  ChildCommentViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/30/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "PhotoBox.h"
#import "DEComposeViewController.h"
@interface ChildCommentViewController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate>
{
MGScrollView *scroller;
CGPoint initialContentOffset;
NSDictionary *productReview;
UIActivityIndicatorView *spinner;
    MBProgressHUD *HUD;
}

@property(nonatomic,retain) NSDictionary* child;
@property(nonatomic,retain) NSString* postID;
@end
