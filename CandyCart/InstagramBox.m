//
//  InstagramBox.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/27/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "InstagramBox.h"

@implementation InstagramBox

+(InstagramBox *)instagramBox:(NSString*)featuredImage type:(NSString*)type{
    
    
    InstagramBox *box = [InstagramBox boxWithSize:CGSizeMake(300,300)];
    
    UIImageView *featuredImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    UIImageView *se = featuredImgView;
    
    [featuredImgView setImageWithURL:[NSURL URLWithString:featuredImage]
                    placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               
                               se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(300, 300) source:image];
                               
                           }];
    
    
    [box addSubview:featuredImgView];
    
    
    if([type isEqualToString:@"video"])
    {
        UIImageView *videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instagram_video_icon.png"]];
        videoIcon.frame = CGRectMake(260,10,30,30);
        [featuredImgView addSubview:videoIcon];
        
        
        UIImageView *play_btn_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_btn.png"]];
        play_btn_icon.frame = CGRectMake(130,125,50,50);
        [featuredImgView addSubview:play_btn_icon];
        
    }
    
    
    return box;
}


+(InstagramBox *)instagramNavTop:(int)postTotalCount{
    
    InstagramBox *box = [InstagramBox boxWithSize:CGSizeMake(300,40)];
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:postTotalCount]];
    
    UILabel *postTotal = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    postTotal.text = [NSString stringWithFormat:@"%@ %@",formattedNumberString,NSLocalizedString(@"instagram_total_posts_count", nil)];
    postTotal.font = [UIFont fontWithName:BOLDFONT size:14];
    postTotal.textAlignment = NSTextAlignmentRight;
    postTotal.textColor = [UIColor darkGrayColor];
    postTotal.backgroundColor = [UIColor clearColor];
    [box addSubview:postTotal];
    
    return box;
}



+(InstagramBox *)instagramHeader:(NSString*)profileImage name:(NSString*)name created:(NSString*)createdTime mediaID:(NSString*)mediaID{
    
    InstagramBox *box = [InstagramBox boxWithSize:CGSizeMake(300,62)];
    
    UIImageView *featuredImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 57)];
    
    UIImageView *se = featuredImgView;
    
    [featuredImgView setImageWithURL:[NSURL URLWithString:profileImage]
                    placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               
                               se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(57, 57) source:image];
                               
                           }];
    
    
    [box addSubview:featuredImgView];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(57+10, 10, 233, 22)];
    nameLbl.text = name;
     nameLbl.font = [UIFont fontWithName:BOLDFONT size:14];
    nameLbl.textColor = [UIColor darkGrayColor];
    nameLbl.backgroundColor = [UIColor clearColor];
    [box addSubview:nameLbl];
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[createdTime intValue]];
    NSString *timeag = [date timeAgo];
    
    UILabel *ago = [[UILabel alloc] initWithFrame:CGRectMake(57+10, 27, 233, 22)];
    ago.text = timeag;
    ago.font = [UIFont fontWithName:PRIMARYFONT size:11];
    ago.textColor = [UIColor darkGrayColor];
    ago.backgroundColor = [UIColor clearColor];
    [box addSubview:ago];
    
    
    
    return box;
}

@end
