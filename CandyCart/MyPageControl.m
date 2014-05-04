//
//  MyPageControl.h
//
//  Created by Steven Pham on 4/2/12.
//  Copyright (c) 2014 Nhuan Quang. All rights reserved.
//

#import "MyPageControl.h"
#define FrameY 2.0
@implementation MyPageControl
@synthesize isSearch;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isSearch = NO;
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    activeImage = [UIImage imageNamed:@"active_page_image.png"];
    inactiveImage = [UIImage imageNamed:@"inactive_page_image.png"];
    [self setCurrentPage:0];
}
-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        dot.frame = CGRectMake(dot.frame.origin.x, FrameY, 8, 8);
        if (i == self.currentPage)
        {
            if(isSearch && i == 0)
                dot.image = [UIImage imageNamed:@"iconBtnSearchActivate.png"];
            else
                dot.image = activeImage;
        }
        else
        {
            if(isSearch && i == 0)
                dot.image = [UIImage imageNamed:@"iconBtnSearch.png"];
            else
                dot.image = inactiveImage;
        }
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void) dealloc {
    NSLog(@"MyPageController dealloc");
}

@end
