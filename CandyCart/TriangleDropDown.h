//
//  TriangleDropDown.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/9/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TriangleDropDown : UIView
{
    UIColor *colors;
}
-(void)setColor:(UIColor*)color;
-(void)rotateToDown;
@end
