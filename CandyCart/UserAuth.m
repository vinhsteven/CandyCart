//
//  UserAuth.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/2/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "UserAuth.h"

@implementation UserAuth
@synthesize userData,username,password;
+ (UserAuth *) instance {
    static UserAuth *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)setUserDatas:(NSDictionary *)source{
    
    userData = [source copy];
}

-(void)saveAuthorizedStatus:(NSString*)usernameCopy password:(NSString*)passwordCopy{
    
    username = usernameCopy;
    password = passwordCopy;
    
    NSMutableDictionary *saveTemp =[[NSMutableDictionary alloc] init];
    
    
    [saveTemp setValue:username forKey:@"username"];
    [saveTemp setValue:password forKey:@"password"];
    [self saveUserLogged:saveTemp];
    
  
}


-(void)saveUserLogged:(NSMutableDictionary*)array{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"userAuth.dat"];
    
    [array writeToFile:yourArrayFileName atomically:YES];
    
   
}

-(NSMutableDictionary*)getFileSave{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"userAuth.dat"];
    
    //Load the array
    NSMutableDictionary *tempStringArray = [[NSMutableDictionary alloc] initWithContentsOfFile: yourArrayFileName];
    
    return tempStringArray;
}


-(void)deleteArrayFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"userAuth.dat"];
    
    [[NSFileManager defaultManager] removeItemAtPath: yourArrayFileName error: nil];
}


-(BOOL)checkUserAlreadyLogged{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:@"userAuth.dat"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    if(fileExists == YES)
    {
        NSMutableDictionary *saveTemp =[self getFileSave];
        username = [saveTemp objectForKey:@"username"];
        password = [saveTemp objectForKey:@"password"];
         
        return YES;
    }
    else
    {
       
        return NO;
    }
    
    
}

-(void)setAlreadyLoggedIn:(BOOL)status{
    
    alreadyLogged = status;
    
}

-(BOOL)checkUserIfAlreadyLoggedInMobile{
    
   if( alreadyLogged == YES)
   {
       return true;
       
   }
    else
    {
        return false;
    }
    
    
}

@end
