//
//  MyPageControl.h
//
//  Created by Steven Pham on 4/2/12.
//  Copyright (c) 2014 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageControl : UIPageControl{
    UIImage* activeImage;
    UIImage* inactiveImage;
    BOOL isSearch;
}
@property(assign,readwrite) BOOL isSearch;

-(void) setCurrentPage:(NSInteger)page;
@end
