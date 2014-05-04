//
//  ImageGalleryBox.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/27/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MGBox.h"

@interface ImageGalleryBox : MGBox
+ (ImageGalleryBox *)imgThumb:(CGSize)size img:(NSString*)url;
@end
