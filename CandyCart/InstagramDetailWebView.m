//
//  InstagramDetailWebView.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/28/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "InstagramDetailWebView.h"

@interface InstagramDetailWebView ()

@end

@implementation InstagramDetailWebView

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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton *instagram = [UIButton buttonWithType:UIButtonTypeCustom];
    instagram.frame = CGRectMake(self.view.frame.size.width - 69, 8, 83, 30);
    instagram.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [instagram setTitle:NSLocalizedString(@"instagram_open_in_instagram_app", nil) forState:UIControlStateNormal];
    [instagram addTarget:self
               action:@selector(gotoInstagram)
     forControlEvents:UIControlEventTouchDown];
    
    [instagram setNuiClass:@"UiBarButtonItem"];
    [instagram.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:instagram];
    self.navigationItem.rightBarButtonItem = button;

}

-(void)gotoInstagram{
    
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://media?id=%@",mediaID]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
}

-(void)loadUrlInWebView:(NSString*)url mediaID:(NSString*)mediaIDs{
    NSLog(@"Open Url : %@",url);
    urls = url;
    CGRect webFrame;
    mediaID = mediaIDs;
    
    webFrame = [[DeviceClass instance] getResizeScreen:NO];
    webViewSe = [[UIWebView alloc] initWithFrame:webFrame];
    
    webViewSe.delegate = self;
    webViewSe.scalesPageToFit = YES;
    webViewSe.scrollView.delegate = self;
    NSString *urlAddress = url;
    urls = url;
    NSURL *urlss = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlss];
    [webViewSe loadRequest:requestObj];
    
    [self.view addSubview:webViewSe];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.title = NSLocalizedString(@"inappwebview_loading", nil)
    ;
    
    
}




- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.title = NSLocalizedString(@"inappwebview_done", nil);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
