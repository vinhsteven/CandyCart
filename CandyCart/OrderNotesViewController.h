//
//  OrderNotesViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/18/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
@interface OrderNotesViewController : UIViewController<UIScrollViewDelegate>
{
    CGPoint initialContentOffset;
    CGPoint svos;
    CGRect currentRect;
    MGScrollView *scroller;
}
@end
