//
//  PushedMsgClass.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 9/3/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//


typedef enum {
    NONE,
    POST,
    PAGE,
    PRODUCT,
    LINK,
    COMMENT,
    ORDERNOTES,
    STATUS_CHANGED,
    ORDER_STATUS
} kPushMsgType;
#define kPushMsgTypeArray @"none", @"post", @"page", @"product",@"link",@"comment",@"order_note",@"status_changed",@"order_status", nil


#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
@interface PushedMsgClass : NSObject<MBProgressHUDDelegate,MFMailComposeViewControllerDelegate>
{
    NSString *currentPostID; // to save if once got msg and use later...
  
    NSString *currentBody;
    MBProgressHUD *HUD;
    UIViewController *currentController;
    
    
}
+ (PushedMsgClass *) instance;
-(void)getPushNotificationMessage:(NSDictionary*)userInfo needReloadRightView:(BOOL)needReload;
@end
