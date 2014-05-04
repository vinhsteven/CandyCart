//
//  UICustomScrollView.h
//  DFURTSPPlayer
//
//  Created by Steven on 3/19/14.
//  Copyright (c) 2014 Bogdan Furdui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPageControl.h"

@interface UICustomScrollView : UIView <UIScrollViewDelegate> {
    int numberPage;
    BOOL pageControlIsChangingPage;
    NSMutableArray *itemArray;
}

@property (unsafe_unretained) id parent;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MyPageControl* pageControl;
@property (nonatomic, strong) NSMutableArray *itemArray;

- (id)initWithFrame:(CGRect)frame parent:(id)sender;
- (IBAction)changePage:(id)sender;
- (void) removeAllItems;
- (void)setupPage;
- (void) reloadSearchTableView;

@end
