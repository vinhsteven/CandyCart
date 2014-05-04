//
//  ImageGalleryBox.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/27/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ImageGalleryBox.h"

@implementation ImageGalleryBox


+ (ImageGalleryBox *)imgThumb:(CGSize)size img:(NSString*)url{
    
    ImageGalleryBox *box = [ImageGalleryBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = [UIColor clearColor];
    box.layer.borderColor = [UIColor lightGrayColor].CGColor;
    box.layer.borderWidth = 0.5;
    box.tag = -1;
    
    // add the add image
    
    UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    
    
    UIImageView *se = addView;
    
    [addView setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(size.width, size.height) source:image];
                       
                   }];
    
    
    [box addSubview:addView];
    
    
    
    return box;
}



@end
