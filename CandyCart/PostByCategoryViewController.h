//
//  PostByCategoryViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/24/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WpPostBox.h"
#import "PostDetailViewController.h"
#import "PlainPostDetailViewController.h"
@interface PostByCategoryViewController : UIViewController<UIScrollViewDelegate>
{
    MGScrollView *scroller;
    NSDictionary *postDictionary;
    CGPoint initialContentOffset;
    int totalPage;
    int currentPage;
    float fixedHeight;
    BOOL processing;
}
-(void)setPostDictionary:(NSDictionary*)postDictionarys;
@end
