//
//  WpPostBox.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/24/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "WpPostBox.h"

@implementation WpPostBox

- (void)setup {
    
    
    
    // background
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

+(WpPostBox *)onBrowseTemplateImgTitleDate:(NSString*)featuredImage title:(NSString*)pTitle ago:(NSString*)ago {
    
    
    WpPostBox *box = [WpPostBox boxWithSize:CGSizeMake(300,180)];
    
    UIImageView *featuredImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    
    UIImageView *se = featuredImgView;
    
    [featuredImgView setImageWithURL:[NSURL URLWithString:featuredImage]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(300, 150) source:image];
                       
                   }];
    
    
    [box addSubview:featuredImgView];
    
    
        
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 220, 30)];
    title.text = pTitle;
    [title setNuiClass:@"postBoxTitle"];
    [box addSubview:title];
    
    
    UILabel *agoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 280, 32)];
    agoTitle.text = ago;
    [agoTitle setNuiClass:@"postBoxAgoTitle"];
    [box addSubview:agoTitle];
    
    
    return box;
}


+(WpPostBox *)onBrowseTemplateTitleImgDesc:(NSString*)featuredImage{
    
    
    WpPostBox *box = [WpPostBox boxWithSize:CGSizeMake(300,150)];
    
    UIImageView *featuredImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    
    UIImageView *se = featuredImgView;
    
    [featuredImgView setImageWithURL:[NSURL URLWithString:featuredImage]
                    placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               
                               se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(300, 150) source:image];
                               
                           }];
    
    
    [box addSubview:featuredImgView];
    
    
    
    
    return box;
}

+ (WpPostBox *)timeAgo:(NSString*)label
{
    
    WpPostBox *box = [WpPostBox boxWithSize:CGSizeMake(300, 20)];
    box.layer.borderWidth = 0;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, -4, 280, 20)];
    lbl.text = label;
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:10];
    lbl.backgroundColor = [UIColor clearColor];
    [box addSubview:lbl];
    return box;
    
}


@end
