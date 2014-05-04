//
//  SettingDataClass.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/14/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingDataClass : NSObject
{
    NSDictionary *settings;
}
+ (SettingDataClass *) instance;
-(void)setSetting:(NSDictionary*)set;
-(NSDictionary*)getSetting;
-(NSString*)getCurrencySymbol;
-(NSString*)get_instagram_client_id;
-(BOOL)getEnableAutoHideSetting;
-(void)autoHideGlobal:(UIScrollView*)scroll navigationView:(UINavigationController*)nav contentOffset:(CGPoint)offset;
@end
