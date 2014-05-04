//
//  DFUViewController.m
//  DFURTSPPlayer
//
//  Created by Bogdan Furdui on 3/7/13.
//  Copyright (c) 2013 Bogdan Furdui. All rights reserved.
//

#import "DFUViewController.h"
#import "RTSPPlayer.h"
#import "Utilities.h"
#import "DFUCameraView.h"

@implementation DFUViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

    }
    
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainScrollView = [[UICustomScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) parent:self];
    [self.view addSubview:mainScrollView];
    
//    NSString *rtspStr[] = {
//        @"rtsp://admin@nhuanquang.dlinkddns.com:554/user=admin&password=%channel=1&stream=0.sdp?",
//    };
    NSMutableArray *rtspStrArray = [NSMutableArray arrayWithCapacity:1];
    
    for (int i=0;i < [_cameraArray count];i++) {
        if (i == _cameraIndex) {
            NSDictionary *dict = [_cameraArray objectAtIndex:i];
            NSString *username = [dict objectForKey:@"username"];
            NSString *password = [dict objectForKey:@"password"];
            NSString *domain   = [dict objectForKey:@"domain"];
            NSString *channel  = [dict objectForKey:@"channel"];
            
            NSString *rtspStr = [NSString stringWithFormat:@"rtsp://%@@%@:554/user=%@&password=%@channel=%@&stream=0.sdp?",username,domain,username,password,channel];
            [rtspStrArray addObject:rtspStr];
            break;
        }
    }
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:1];
    
    for (int i=0;i < [rtspStrArray count];i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[rtspStrArray objectAtIndex:i],@"rtspUrl", nil];
        [tmpArray addObject:dict];
    }
    mainScrollView.itemArray = tmpArray;
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:1];
    
    //add activity indicator
    UIActivityIndicatorView *loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingActivity startAnimating];
    
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithCustomView:loadingActivity];
    self.navigationItem.rightBarButtonItem = btnRight;
}

- (void) setupCamera {
    [mainScrollView setupPage];
}

- (void) dealloc {
    NSLog(@"DFUViewController dealloc");
    [super dealloc];
}

@end
