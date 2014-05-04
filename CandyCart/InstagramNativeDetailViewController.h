//
//  InstagramNativeDetailViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/29/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramNativeDetailViewController : UIViewController<UIScrollViewDelegate>
{
    MGScrollView *scroller;
    MPMoviePlayerController *player;
    NSDictionary *postInfo;
}
-(void)setPostInfo:(NSDictionary*)pInfo;
@end
