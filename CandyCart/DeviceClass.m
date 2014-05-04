//
//  DeviceClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/5/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "DeviceClass.h"

@implementation DeviceClass
+ (DeviceClass *) instance {
    static DeviceClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
-(int)getDevice{
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            return IPHONE_5;
        } else {
            return IPHONE;
        }
    } else {
        return IPAD;
    }
    
}



-(int)getOSVersion{
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
   if([version floatValue] >= 7.0)
    {
        return iOS7;
    }
    else
    {
        return iOS6;
    }
}

-(void)setPushToken:(NSString*)push_token{
    
    pushToken = push_token;
}

-(NSString*)getPushToken{
    
    return pushToken;
}

-(CGRect)getResizeScreen:(BOOL)isTopButtonAvailable
{
     int topButtonNavi = 51;
    
   
    
    CGRect se = [self screenSize];
    CGRect new;
    if(isTopButtonAvailable == YES)
    {
        new = CGRectMake(se.origin.x, se.origin.y+topButtonNavi, se.size.width, se.size.height-topButtonNavi);
    }
    else
    {
        new = se;
    }
    
    return new;
}






-(CGRect)screenSize{
    // Put 0 if status bar disable
     // Put 20 if status bar enable
    int statusbar = 20;
    int navigationbar = 44;
    int tabbar = 49;
    
    CGRect ret;
    
    if([self getDevice] == IPHONE_5)
    {
        if([[SettingDataClass instance] getEnableAutoHideSetting] == YES)
        {
           ret = CGRectMake(0, 0, 320, 568-statusbar-navigationbar);
        }
        else
        {
          ret = CGRectMake(0, 0, 320, 568-statusbar-navigationbar-tabbar);
        }
    }
    else
    {
        
        
        if([[SettingDataClass instance] getEnableAutoHideSetting] == YES)
        {
            ret = CGRectMake(0, 0, 320, 480-statusbar-navigationbar);
        }
        else
        {
            ret = CGRectMake(0, 0, 320, 480-statusbar-navigationbar-tabbar);
        }
        
      
    }
    
    return ret;
    
}


- (NSString *)getUUID
{
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueID"];
    if (!UUID)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        UUID = [(__bridge NSString*)string stringByReplacingOccurrencesOfString:@"-"withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:UUID forKey:@"uniqueID"];
    }
    
    
    
    return UUID;
}


-(NSString*)getDeviceModel{
    
    return [[UIDevice currentDevice] model];
}

@end
