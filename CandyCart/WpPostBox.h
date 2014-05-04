//
//  WpPostBox.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/24/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MGBox.h"

@interface WpPostBox : MGBox
+(WpPostBox *)onBrowseTemplateTitleImgDesc:(NSString*)featuredImage; // Template 1
+(WpPostBox *)onBrowseTemplateImgTitleDate:(NSString*)featuredImage title:(NSString*)pTitle ago:(NSString*)ago; // Template 2
+ (WpPostBox *)timeAgo:(NSString*)label;
@end
