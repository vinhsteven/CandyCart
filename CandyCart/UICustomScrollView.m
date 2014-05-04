//
//  UICustomScrollView.m
//  DFURTSPPlayer
//
//  Created by Steven on 3/19/14.
//  Copyright (c) 2014 Bogdan Furdui. All rights reserved.
//

#import "UICustomScrollView.h"
#import "DFUCameraView.h"

@implementation UICustomScrollView
@synthesize scrollView;
@synthesize pageControl;
@synthesize itemArray;
@synthesize parent;

- (id)initWithFrame:(CGRect)frame parent:(id)sender
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        parent = sender;
        
        self.backgroundColor = [UIColor clearColor];
        
        numberPage = 0;
        pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake(0,self.frame.size.height - 10,150,10)];
        pageControl.center = CGPointMake(self.frame.size.width/2,pageControl.center.y);
        pageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:pageControl];
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10)];
        [self addSubview:scrollView];
        [self setupPage];
    }
    return self;
}

- (void) setupPage {
    int numberItemPerPage = 1;
    if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 1136) {
            numberItemPerPage = 4;
        }
        else
        {
            numberItemPerPage = 4;
        }
    }
    if([itemArray count] % numberItemPerPage == 0)
        numberPage = [itemArray count] / numberItemPerPage;
    else
        numberPage = ([itemArray count] / numberItemPerPage) + 1;
    
    scrollView.delegate = self;
    
	[scrollView setCanCancelContentTouches:NO];
	scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
    CGFloat cx = 0;
    
    for (int i=0; i<numberPage; i++) {
        for (int j =0; j < numberItemPerPage; j++) {
            if(i*numberItemPerPage+j >= [itemArray count])
                break;
            NSMutableDictionary *dict = [itemArray objectAtIndex:i*numberItemPerPage+j];
            
            int row = j/2;
            int column = j%2;
            
            CGRect rect;
            if ([[DeviceClass instance] getDevice] == IPHONE_5)
                rect = CGRectMake(cx + column*82.5,25, 320, 300);
            else
                rect = CGRectMake(cx + column*82.5,10, 320, 300);
            
            DFUCameraView *cameraView = [[DFUCameraView alloc] initWithURL:[dict objectForKey:@"rtspUrl"] rect:rect];
            
//            btnService.tag = i*numberItemPerPage+j + btnServiceDetailTag;
//            btnService.btnItem.tag = btnService.tag;
//            [btnService.btnItem addTarget:parent action:@selector(buttonServiceClick:) forControlEvents:UIControlEventTouchUpInside];
            //get image
            cameraView.tag = i*numberItemPerPage+j + 50;
            [scrollView addSubview:cameraView];
            
        }
        cx += scrollView.frame.size.width;
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self endEditing:NO];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender
{
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlIsChangingPage = YES;
}

- (void) dealloc {
    NSLog(@"UICustomScrollView dealloc");
    for (DFUCameraView *cameraView in scrollView.subviews) {
        [cameraView.nextFrameTimer invalidate];
    }
}

@end
