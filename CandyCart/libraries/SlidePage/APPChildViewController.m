//
//  APPChildViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPChildViewController.h"

@interface APPChildViewController ()

@end

@implementation APPChildViewController
@synthesize myWebView;
@synthesize promotionDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *myUrl;
    if ([[DeviceClass instance] getDevice] == IPHONE_5)
        myUrl = [promotionDict objectForKey:@"imageUrl-568"];
    else
        myUrl = [promotionDict objectForKey:@"imageUrl-480"];
    
    if ([myUrl rangeOfString:@"http://"].location != NSNotFound)
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:myUrl]]];
    else {
//        NSString *embedHTML = @"\
//        <html><head>\
//        <style type=\"text/css\">\
//        body {\
//        background-color: transparent;\
//        color: white;\
//        }\
//        </style>\
//        </head><body style=\"margin:0\">\
//        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
//        width=\"%0.0f\" height=\"%0.0f\"></embed>\
//        </body></html>";
//
//        NSString *htmlStr = [NSString stringWithFormat:embedHTML,self.view.frame.size.width, self.view.frame.size.height, myUrl];

        NSString *youTubeVideoHTML = @"<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'http://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%0.0f', height:'%0.0f', videoId:'%@', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>";
        
        NSString *htmlStr = [NSString stringWithFormat:youTubeVideoHTML, self.view.frame.size.width*3+50,self.view.frame.size.height*3,myUrl];
        
        [myWebView loadHTMLString:htmlStr baseURL:nil];
        myWebView.mediaPlaybackRequiresUserAction = NO;
    }
    
    myWebView.scalesPageToFit = YES;
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
