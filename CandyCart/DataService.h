//
//  DataService.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "NoInternetViewController.h"
@interface DataService : NSObject
{
    NSString *se;
   
}
+ (DataService *) instance;
@property(nonatomic,retain) NSArray *productCategories;
@property(nonatomic,retain) NSArray *productCategoriesCustom;
@property(nonatomic,retain) NSDictionary *home_page_api;
@property(nonatomic,retain) NSDictionary *featuredProducts;
@property(nonatomic,retain) NSDictionary *randomItems;
@property(nonatomic,retain) NSDictionary *recentItems;
@property(nonatomic,retain) NSDictionary *leftMenuData;
@property(nonatomic,retain) NSDictionary *pushNotifications;
@property(nonatomic,retain) NSArray *countries;
-(void)loadAllData;

-(void)pushNotificationApi;

//GET By Demand @Woocommerce API
-(NSDictionary*)getProductByCategory:(NSString*)categoryID page:(NSString*)page productPerPage:(NSString*)productPerPage;
-(NSDictionary*)getProductByKeyword:(NSString*)keyword page:(NSString*)page productPerPage:(NSString*)productPerPage;
-(NSDictionary*)getProductReview:(NSString*)postID parent:(NSString*)parent;
-(NSDictionary*)getSingleProduct:(NSString*)postID;
-(NSDictionary*)get_my_order:(NSString*)username password:(NSString*)password filter:(NSString*)filter;
-(NSArray*)getChildProductCategories:(NSString*)parentID;


//@ Wordpress API
-(NSDictionary*)getWpPostByPostID:(NSString*)postID;
-(NSDictionary*)getPostByCategory:(NSString*)catID currentPage:(NSString*)currentPage postPerPage:(NSString*)post_per_page;
-(NSDictionary*)get_search_post:(NSString*)keyword currentPage:(NSString*)currentPage postPerPage:(NSString*)post_per_page;
-(NSDictionary*)comment_follow:(NSString*)username password:(NSString*)password commentID:(NSString*)commentID type:(NSString*)type;
-(NSDictionary*)getCommentByCommentID:(NSString*)commentID;
-(void)getLeftMenuData;
-(NSDictionary*)getBussinessDirectoryPlugin;
//@ Instagram API
-(NSDictionary*)getInstagramAPI:(NSString*)hashTag;
-(NSDictionary*)getPaginationApi:(NSString*)nextUrl;
-(int)countInstagramHashTag:(NSString*)hashTag;

//@ RSS API
-(NSArray*)getRSSXmlData:(NSString*)RSSUrl;

//Post & GET Service @Woocomerce API
-(NSDictionary*)getSinglePaymentGatewayMetaKey:(NSString*)key;
-(NSDictionary*)user_login:(NSString*)username password:(NSString*)password;
-(NSDictionary*)user_logout;
-(NSDictionary*)profile_update:(NSString*)username password:(NSString*)password arg:(NSMutableDictionary*)arg;
-(NSDictionary*)billing_update:(NSString*)username password:(NSString*)password arg:(NSMutableDictionary*)arg;
-(NSDictionary*)shipping_update:(NSString*)username password:(NSString*)password arg:(NSMutableDictionary*)arg;
-(NSDictionary*)profileImageUpdate:(NSString*)username password:(NSString*)password imageData:(NSData*)imageData;
-(NSDictionary*)post_comment:(NSString*)username password:(NSString*)password arg:(NSMutableDictionary*)arg;

-(NSDictionary*)reviewCartWithCoupon:(NSString*)username password:(NSString*)password productInJsonString:(NSString*)productInJsonString coupon:(NSString*)couponCodeInJsonString;
-(NSDictionary*)placeAnOrder:(NSString*)username password:(NSString*)password productInJsonString:(NSString*)productInJsonString coupon:(NSString*)couponCodeInJsonString paymentMethodID:(NSString*)paymentMethod orderNotes:(NSString*)orderNotes;

-(NSDictionary*)get_single_order:(NSString*)username password:(NSString*)password orderID:(NSString*)orderID;

-(NSDictionary*)user_registration:(NSString*)username email:(NSString*)email firstname:(NSString*)firstname lastname:(NSString*)lastname password:(NSString*)password;
-(NSDictionary*)change_password:(NSString*)username password:(NSString*)password newpassword:(NSString*)newpassword;
-(NSDictionary*)qrcodescanner:(NSString*)string;

-(NSDictionary*)process_payment_aut_dot_net:(NSString*)orderKey orderNo:(NSString*)orderNo methodID:(NSString*)methodID credit_card_number:(NSString*)credit_card_number expire_date_year:(NSString*)expire_date_year expire_date_month:(NSString*)expire_date_month cvv:(NSString*)cvv profileID:(NSString*)profileID;

//@Push Notification
-(void)updatePushNotification:(NSString*)deviceID pushtoken:(NSString*)pushtoken;
@end
