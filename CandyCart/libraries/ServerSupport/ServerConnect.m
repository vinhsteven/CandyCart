//
//  ServerConnect.m
//  CandyCart
//
//  Created by Steven on 4/6/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import "ServerConnect.h"
//#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLConnectionOperation.h"
#import "NSData+Extension.h"
#import "NSString+Extension.h"

#define mServerRequestError             @"mServerRequestError"
#define requestRetryLimit 10

@implementation ServerConnect

static ServerConnect *serverAPI = nil;
@synthesize baseURL;
@synthesize responseType;
+ (ServerConnect *)shareClient{
    @synchronized(serverAPI)
    {
        if(serverAPI == nil)
            serverAPI = [[ServerConnect alloc] initWithBaseURL:[AppDelegate getCouchDBUrl]];
    }
    
    return serverAPI;
}

- (id)initWithBaseURL:(NSString *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.baseURL = url;
    return self;
}
- (void)setUserName:(NSString *)userName password:(NSString *)password{
    _userName = userName;
    _password = password;
}

- (void) postErrorNotification: (NSError*) error
{
    NSNotification *note;
    if (error) {
        note = [NSNotification notificationWithName:mServerRequestError
                                             object:[NSDictionary dictionaryWithObject:error forKey:@"error"]];
    }
    else {
        note = [NSNotification notificationWithName:mServerRequestError
                                             object:nil];
    }
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)
                                                           withObject:note
                                                        waitUntilDone:YES];
}

- (void)postPath:(NSString*)pathAPI arguments:(NSDictionary*)arguments withRetry:(int)ntimes error:(NSError*)error success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(pathAPI);
    
    if (ntimes<=0) {
        [self postErrorNotification:error];
        if (failure) {
            failure(error);
        }
    } else {
        NSMutableURLRequest *httpReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self.baseURL append:pathAPI]]];//[ autorelease];
        
//        LOGAPP(@"Http Request: %@", httpReq);
        
        [httpReq setHTTPMethod:@"POST"];
        //NSArray*keys=[arguments allKeys];
        NSString *body = @"";
//        LOGAPP(@"count keys %i",[[arguments allKeys] count]);
        for(int i = 0;i<[[arguments allKeys] count];i++)
        {
            NSString *key = [NSString stringWithFormat:@"%@",[[arguments allKeys] objectAtIndex:i]];
            
            BOOL isYES = (i == [[arguments allKeys] count] - 1);
            
            NSString *value = [NSString stringWithFormat:isYES?@"%@=%@":@"%@=%@&",key,[arguments valueForKey:key]];
            
            body = [body stringByAppendingString:value];
        }
        //LOGAPP(@"body %@",body);
        [httpReq setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:httpReq];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSDictionary * parsedResults = nil;
                if (self.responseType == ServerResponseTypeJSON) {
                    parsedResults = [responseObject jsonStringToDictionary];
                }
                
                if ($safe(parsedResults)) {
                    if (success) {
                        success(parsedResults);
                    }
                } else {
                    if (success) {
                        success(responseObject);
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self postPath:pathAPI arguments:arguments withRetry:ntimes-1 error:error success:success failure:failure];
        }];
        
        [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
            if ([challenge previousFailureCount] == 0) {
                [[challenge sender]  useCredential:[NSURLCredential credentialWithUser:_userName password:_password
                                                                           persistence:NSURLCredentialPersistenceNone]
                        forAuthenticationChallenge:challenge];
                
            } else {
                [[challenge sender] cancelAuthenticationChallenge:challenge];
            }
        }];
        
        [operation start];
    }
}

- (void)postPath:(NSString*)pathAPI arguments:(NSDictionary*)arguments withRetry:(int)ntimes authenticationUserEmail:(NSString *)userEmail password:(NSString *)password error:(NSError*)error success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(pathAPI);
    
    if (ntimes<=0) {
        [self postErrorNotification:error];
        if (failure) {
            failure(error);
        }
    } else {
        NSMutableURLRequest *httpReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self.baseURL append:pathAPI]]];//[ autorelease];
        
//        LOGAPP(@"Http Request: %@", httpReq);
        
        [httpReq setHTTPMethod:@"POST"];
        //NSArray*keys=[arguments allKeys];
        NSString *body = @"";
//        LOGAPP(@"count keys %i",[[arguments allKeys] count]);
        for(int i = 0;i<[[arguments allKeys] count];i++)
        {
            NSString *key = [NSString stringWithFormat:@"%@",[[arguments allKeys] objectAtIndex:i]];
            
            BOOL isYES = (i == [[arguments allKeys] count] - 1);
            
            NSString *value = [NSString stringWithFormat:isYES?@"%@=%@":@"%@=%@&",key,[arguments valueForKey:key]];
            
            body = [body stringByAppendingString:value];
        }
        //LOGAPP(@"body %@",body);
        [httpReq setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:httpReq];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSDictionary * parsedResults = nil;
                if (self.responseType == ServerResponseTypeJSON) {
                    parsedResults = [responseObject jsonStringToDictionary];
                }
                
                if ($safe(parsedResults)) {
                    if (success) {
                        success(parsedResults);
                    }
                } else {
                    if (success) {
                        success(responseObject);
                    }
                }
                
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self postPath:pathAPI arguments:arguments withRetry:ntimes-1 error:error success:success failure:failure];
        }];
        
        [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
            if ([challenge previousFailureCount] == 0) {
                [[challenge sender]  useCredential:[NSURLCredential credentialWithUser:userEmail password:password
                                                                           persistence:NSURLCredentialPersistenceNone]
                        forAuthenticationChallenge:challenge];
                
            } else {
                [[challenge sender] cancelAuthenticationChallenge:challenge];
            }
        }];
        
        [operation start];
    }
}

#pragma mark Webservices
- (void) listCameraOfMerchant:(NSMutableDictionary*)_arguments successs:(void (^)(id response))successs failure:(void (^)(NSError *error))failure {
    
    self.responseType = ServerResponseTypeJSON;
    
//    [self postPath:@":3001/get_user" arguments:_arguments withRetry:requestRetryLimit error:nil success:successs failure:failure];
    
    //account use to authorize webservice
    NSString *decryptedUsername = [AppDelegate getDecryptedData:[AppDelegate getUsernameAuthorizeCouchDB]];
    NSString *decryptedPassword = [AppDelegate getDecryptedData:[AppDelegate getPasswordAuthorizeCouchDB]];
    
    [self postPath:@":3001/get_user" arguments:_arguments withRetry:requestRetryLimit authenticationUserEmail:decryptedUsername password:decryptedPassword error:nil success:successs failure:failure];
}

@end
