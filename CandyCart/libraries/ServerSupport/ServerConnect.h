//
//  ServerConnect.h
//  CandyCart
//
//  Created by Steven on 4/6/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFHTTPClient.h"

typedef enum {
    ServerResponsePlanText,
    ServerResponseTypeJSON
} ServerResponseType;

@interface ServerConnect : NSObject {
    NSString *_userName;
    NSString *_password;
}

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, assign) ServerResponseType responseType;
@property(nonatomic, copy) void(^completionBlock)(NSDictionary*,NSString*);
@property(nonatomic, copy) void(^errorBlock)(NSDictionary* error,NSString*);

+ (ServerConnect *)shareClient;

//ser info authentication
- (void)setUserName:(NSString *)userName password:(NSString *)password;
- (void) listCameraOfMerchant:(NSMutableDictionary*)_arguments successs:(void (^)(id response))successs failure:(void (^)(NSError *error))failure;

@end
