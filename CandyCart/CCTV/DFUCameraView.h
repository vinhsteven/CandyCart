//
//  DFUCameraView.h
//  DFURTSPPlayer
//
//  Created by Steven on 3/19/14.
//  Copyright (c) 2014 Bogdan Furdui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTSPPlayer;

@interface DFUCameraView : UIView {
    RTSPPlayer *video;
	float lastFrameTime;
    NSString *rtspStr;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) RTSPPlayer *video;
@property (nonatomic, strong) NSTimer *nextFrameTimer;

- (id) initWithURL:(NSString*)_url rect:(CGRect)_rect;

@end
