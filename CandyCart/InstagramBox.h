//
//  InstagramBox.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/27/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MGBox.h"
#import "NSDate+TimeAgo.h"
@interface InstagramBox : MGBox
+(InstagramBox *)instagramBox:(NSString*)featuredImage type:(NSString*)type;
+(InstagramBox *)instagramHeader:(NSString*)profileImage name:(NSString*)name created:(NSString*)createdTime mediaID:(NSString*)mediaID;
+(InstagramBox *)instagramNavTop:(int)postTotalCount;
@end
