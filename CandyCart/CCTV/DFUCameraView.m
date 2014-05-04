//
//  DFUCameraView.m
//  DFURTSPPlayer
//
//  Created by Steven on 3/19/14.
//  Copyright (c) 2014 Bogdan Furdui. All rights reserved.
//

#import "DFUCameraView.h"
#import "RTSPPlayer.h"
#import "Utilities.h"

@implementation DFUCameraView
@synthesize imageView;
@synthesize video;

- (id) initWithURL:(NSString*)_url rect:(CGRect)_rect {
    if (self == [super initWithFrame:_rect]) {
        rtspStr = _url;
        
        imageView = [[UIImageView alloc] initWithFrame:_rect];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview:imageView];
        
        [self addVideo];
    }
    return self;
}

- (void) addVideo {
    video = [[RTSPPlayer alloc] initWithVideo:rtspStr usesTcp:NO];
    video.outputWidth  = imageView.frame.size.width;
    video.outputHeight = imageView.frame.size.height;
    
    [self playVideo];
}

-(void) playVideo {
	lastFrameTime = -1;
	
	// seek to 0.0 seconds
	[video seekTime:0.0];
    
    [_nextFrameTimer invalidate];
	self.nextFrameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30
                                                           target:self
                                                         selector:@selector(displayNextFrame:)
                                                         userInfo:nil
                                                          repeats:YES];
}

#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)

-(void)displayNextFrame:(NSTimer *)timer
{
	NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
	if (![video stepFrame]) {
		[timer invalidate];
        [video closeAudio];
		return;
	}
	imageView.image = video.currentImage;
	float frameTime = 1.0/([NSDate timeIntervalSinceReferenceDate]-startTime);
	if (lastFrameTime<0) {
		lastFrameTime = frameTime;
	} else {
		lastFrameTime = LERP(frameTime, lastFrameTime, 0.8);
	}
}

- (void)dealloc
{
    NSLog(@"DFUCameraView dealloc");
	//[video release];
    video = nil;

	//[imageView release];
    imageView = nil;

    //[super dealloc];
}


@end
