//
//  DFUViewController.h
//  DFURTSPPlayer
//
//  Created by Bogdan Furdui on 3/7/13.
//  Copyright (c) 2013 Bogdan Furdui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomScrollView.h"

@class RTSPPlayer;

@interface DFUViewController : UIViewController
{
    UICustomScrollView *mainScrollView;
}

@property (strong,nonatomic) NSMutableArray *cameraArray;
@property (assign) int cameraIndex;

@end
