//
//  SettingDataClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/14/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "SettingDataClass.h"

@implementation SettingDataClass
+ (SettingDataClass *) instance {
    static SettingDataClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)setSetting:(NSDictionary*)set{
    
    settings = set;
}

-(NSDictionary*)getSetting{
    return settings;
}


-(NSString*)getCurrencySymbol{
//    NSLog(@"currency = %@",[settings objectForKey:@"currency_symbol"]);
    return [[ToolClass instance] decodeHTMLCharacterEntities:[settings objectForKey:@"currency_symbol"]];
}


-(NSString*)get_instagram_client_id{
    return [[settings objectForKey:@"instagram_api"] objectForKey:@"client_id"];
}


-(BOOL)getEnableAutoHideSetting{
    
    return NO;
}


-(void)autoHideGlobal:(UIScrollView*)scroll navigationView:(UINavigationController*)nav contentOffset:(CGPoint)offset{
    
    if([self getEnableAutoHideSetting] == YES)
    {
        if (scroll.contentOffset.y - offset.y > 0.0f) {
            // Scroll positively, hide tab bar.
            [nav.tabBarController setTabBarHidden:YES animated:YES];
            
        } else {
            // Scroll negatively, show tab bar.
            [nav.tabBarController setTabBarHidden:NO animated:YES];
            
        }
    }
}


@end
