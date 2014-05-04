//
//  InstagramViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/27/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramBox.h"
#import <MediaPlayer/MediaPlayer.h>
#import "InstagramDetailWebView.h"
#import "InstagramNativeDetailViewController.h"
@interface InstagramViewController : UIViewController<UIScrollViewDelegate>
{
    MGScrollView *scroller;
    NSArray *info;
    NSDictionary *respond;
    NSString *hashTag;
    MPMoviePlayerController *player;
    float fixedHeight;
    BOOL reachMax;
    UILabel *listLbl;
    UILabel *gridLbl;
    UIImageView *listBtn;
   UIImageView *gridBtn;
    BOOL processing;
    int postTotal;
    NSMutableArray *dataArray;
    BOOL is_list_view;
}
-(void)setInfoDictionary:(NSDictionary*)instagramResponse hashtag:(NSString*)hashtag postTotal:(int)total;
@end
