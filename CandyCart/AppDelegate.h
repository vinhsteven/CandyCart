//
//  AppDelegate.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUIAppearance.h"

@interface NSData(AES)
- (NSString *)hexadecimalString;
+ (NSData *)dataFromHexString:(NSString *)string;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
   
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
+ (AppDelegate *) instance;
+ (NSString*) getCouchDBUrl;
- (NSString*)getUrl;
- (NSString*) convertToThousandSeparator:(NSString*)_value;
+ (NSString*) getUsernameAuthorizeCouchDB;
+ (NSString*) getPasswordAuthorizeCouchDB;
+ (NSString*) getDecryptedData:(NSString*)_hexString;

@end
