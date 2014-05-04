//
//  DetailViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/5/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MenuViewController.h"
#import "MDCParallaxView.h"
#import "socialMediaController.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import <MessageUI/MessageUI.h>
#import "ProductDetailBox.h"
#import "ReadMoreViewController.h"
#import "DLStarRatingControl.h"
#import "CommentViewController.h"
#import "DetailViewController.h"
#import "AddToCartQuantity.h"
#import "UIView+Genie.h"
#import "iPhoneWebView.h"
#import "IDMPhotoBrowser.h"
#import "DetailViewController.h"
@interface DetailViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate,MBProgressHUDDelegate,IDMPhotoBrowserDelegate,socialMediaControllerDelegate>
{
    MGScrollView *scroller;
    UIScrollView *imgScrollView;
    UIView *topView;
    UIView *bottomView;
    CGPoint initialContentOffset;
    UIButton *shareBtn;
    NSDictionary *productInfo;
    int current_product_image_index;
    SQLiteManager *dbManager;
    NSMutableDictionary *attributeQuery;
    UIScrollView *copyOfimgScrollView;
    TTTAttributedLabel *variablePrice;
    UILabel *onSaleBadgeVariable;
    NSString *newFeaturedImage;
    BOOL isVariableOn;
    MBProgressHUD *HUD;
    ProductDetailBox *addToCartBox;
    FPPopoverController *popoverAddToCart;
    MDCParallaxView *parallaxView;
    NSDictionary *product_variable_copy;
    UIWebView *webViewSe;
    ProductDetailBox *boxWeb;
    BOOL isOutOfOrder;
}
-(void)setProductInfo:(NSDictionary*)product;

-(void)setAttributeQuery:(NSString*)value key:(NSString*)key; //Use to update dictionary after choose in variable menu
-(void)productYouMayLikeTapAction:(id)userData;
-(void)addToCartExe:(int)quantity;
@end
