//
//  InstagramNativeDetailViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/29/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "InstagramNativeDetailViewController.h"

@interface InstagramNativeDetailViewController ()

@end

@implementation InstagramNativeDetailViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setNuiClass:@"ViewInit"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    scroller = [MGScrollView scroller];
    scroller.frame = [[DeviceClass instance] getResizeScreen:NO];
    scroller.delegate = self;
    scroller.bottomPadding = 8;
    [self.view addSubview:scroller];
    scroller.alwaysBounceVertical = YES;
    
    [self instagramBox:postInfo];
    [scroller layoutWithSpeed:0.3 completion:nil];
}




-(void)setPostInfo:(NSDictionary*)pInfo{
    
    postInfo = pInfo;
}

-(void)instagramBox:(NSDictionary*)fullinfo{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    InstagramBox *header = [InstagramBox instagramHeader:[[fullinfo objectForKey:@"user"] objectForKey:@"profile_picture"] name:[[fullinfo objectForKey:@"user"] objectForKey:@"username"] created:[fullinfo objectForKey:@"created_time"] mediaID:[fullinfo objectForKey:@"id"]];
    [section.topLines addObject:header];
    
    
    UIImageView *openInInsta = [[UIImageView alloc] initWithFrame:CGRectMake(260, 15, 30, 30)];
    openInInsta.image = [UIImage imageNamed:@"instagram_flat_icon.png"];
    openInInsta.userInteractionEnabled = YES;
    [header addSubview:openInInsta];
    
    UserDataTapGestureRecognizer *openInInstagram = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(openInInstagramExe:)];
    openInInstagram.userData = fullinfo;
    
    [openInInsta addGestureRecognizer:openInInstagram];
    
    //Img Center
    InstagramBox *box = [InstagramBox instagramBox:[[[fullinfo objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"] type:[fullinfo objectForKey:@"type"]];
    [section.topLines addObject:box];
    //END Img Center
    MGLineStyled *bottom;
    @try {
        NSString * str = [NSString stringWithFormat:@"%@",[[fullinfo objectForKey:@"caption"] objectForKey:@"text"]];
        
        if([str length] > 0)
        {
            id bottomBody = str;
            
            
            bottom = [MGLineStyled multilineWithText:bottomBody font:nil width:300
                                             padding:UIEdgeInsetsMake(10, 10, 10.0, 10.0)];
            bottom.backgroundColor = [UIColor clearColor];
            bottom.font = [UIFont fontWithName:PRIMARYFONT size:11];
            [section.topLines addObject:bottom];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
    NSString * likes = [NSString stringWithFormat:@"%@ %@",[[fullinfo objectForKey:@"likes"] objectForKey:@"count"],NSLocalizedString(@"instagram_likes", nil)];
    NSString * comments = [NSString stringWithFormat:@"%@ %@",[[fullinfo objectForKey:@"comments"] objectForKey:@"count"],NSLocalizedString(@"instagram_comments", nil)];
    
    id likeID = likes;
    id commentsID = comments;
    
    
    
    
    MGLineStyled
    *likeAngComment = [MGLineStyled lineWithLeft:likeID
                                           right:commentsID size:CGSizeMake(300, 29)];
    likeAngComment.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section.topLines addObject:likeAngComment];
    
    InstagramBox *tempBox = box;
    
    box.onTap = ^{
        NSString *type = [fullinfo objectForKey:@"type"];
        if([type isEqualToString:@"video"])
        {
            [player.view removeFromSuperview];
            player.view.alpha = 0;
            NSString *videoUrl = [NSString stringWithFormat:@"%@",[[[fullinfo objectForKey:@"videos"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
            
            
            NSURL *movieURL = [NSURL URLWithString:videoUrl];
            player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
            player.view.frame = CGRectMake(0, 0, 300, 300);
            [tempBox addSubview:player.view];
            
            
            
            player.shouldAutoplay = YES;
            [player prepareToPlay];
            
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            player.view.alpha = 1;
            
            [UIView commitAnimations];
            
            [player play];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self // the object listening / "observing" to the notification
                                                     selector:@selector(myMovieFinishedCallback) // method to call when the notification was pushed
                                                         name:MPMoviePlayerPlaybackDidFinishNotification // notification the observer should listen to
                                                       object:player];
        }
        else
        {
            
        }
        
        
    };
    
       
}

-(void)myMovieFinishedCallback{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    player.view.alpha = 0;
    
    [UIView commitAnimations];
    
    
}

-(void)openInInstagramExe:(UserDataTapGestureRecognizer*)gesture{
    NSLog(@"Open Instagram");
    NSDictionary *fullinfo = gesture.userData;
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://media?id=%@",[fullinfo objectForKey:@"id"]]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    else
    {
        InstagramDetailWebView *detail = [[InstagramDetailWebView alloc] init];
        [detail loadUrlInWebView:[fullinfo objectForKey:@"link"] mediaID:[fullinfo objectForKey:@"id"]];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
