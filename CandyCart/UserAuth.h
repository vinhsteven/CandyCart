//
//  UserAuth.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/2/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAuth : NSObject
{
    bool alreadyLogged;
}
@property(nonatomic,retain) NSMutableDictionary *userData;
@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) NSString *password;

+ (UserAuth *) instance;
-(void)setUserDatas:(NSDictionary *)source;
-(void)saveAuthorizedStatus:(NSString*)usernameCopy password:(NSString*)passwordCopy;
-(BOOL)checkUserAlreadyLogged;
-(BOOL)checkUserIfAlreadyLoggedInMobile;
-(void)deleteArrayFile;
-(void)setAlreadyLoggedIn:(BOOL)status;
@end
