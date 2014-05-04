//
//  RSSFeedControllerViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/26/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSFeedControllerViewController : UIViewController<UIScrollViewDelegate>
{
    MGScrollView *scroller;
    NSArray *info;
}
-(void)setRSSInfo:(NSArray*)info;
@end
