//
//  ImageGalleryThumbController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/27/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageGalleryBox.h"
@interface ImageGalleryThumbController : UIViewController<UIScrollViewDelegate,IDMPhotoBrowserDelegate>
{
    MGScrollView *scroller;
    NSArray *info;
    NSMutableArray *photos;
}
-(void)setImageInfo:(NSArray*)setInfo;
@end
