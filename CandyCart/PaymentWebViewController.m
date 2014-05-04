//
//  PaymentWebViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/14/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "PaymentWebViewController.h"
#import "OrderViewController.h"
@interface PaymentWebViewController ()

@end

@implementation PaymentWebViewController

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
    
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"payment_cancel_btn_title", nil)
                                                               style:UIBarButtonItemStyleDone target:self action:@selector(cancelBtnExe)];
    self.navigationItem.leftBarButtonItem = cancel;
}


-(void)setOrderViewController:(OrderViewController *)orders{
    
    order = orders;
}

-(void)cancelBtnExe
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadUrlInWebView:(NSString*)url{
    NSLog(@"Open Url : %@",url);
    urls = url;
    CGRect webFrame;
    
    webFrame = [[DeviceClass instance] getResizeScreen:NO];
    webViewSe = [[UIWebView alloc] initWithFrame:webFrame];
    
    webViewSe.delegate = self;
    webViewSe.scalesPageToFit = YES;
  
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
    
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
   
    NSString *myString = [[inRequest URL] absoluteString];
    
    NSArray *ary = [myString componentsSeparatedByString:@"?"];
    
    NSString *getSettingThankyouPage = [NSString stringWithFormat:@"%@",[[[[SettingDataClass instance] getSetting] objectForKey:@"page"] objectForKey:@"thankyou"]];
    
  /*
    NSString *fullThankyouPage = [NSString stringWithFormat:@"%@?order=%@&key=%@",getSettingThankyouPage,
     [[[MyOrderClass instance] getMyOrder] objectForKey:@"orderID"],
     [[[MyOrderClass instance] getMyOrder] objectForKey:@"order_key"]
     ];
   */
    
      NSString *getSettingCartPage = [NSString stringWithFormat:@"%@",[[[[SettingDataClass instance] getSetting] objectForKey:@"page"] objectForKey:@"cart"]];
    
    NSLog(@"Current Url : %@",[ary objectAtIndex:0]);
    NSLog(@"Setting URL : %@",getSettingCartPage);
    
    
    if([[ary objectAtIndex:0] isEqualToString:getSettingThankyouPage])
    {
        NSLog(@"Successful Paid");
        [self dismissViewControllerAnimated:YES completion:^{
            [order refreshOrderPaymentSuccessful];
        }];
    }
    else if([[ary objectAtIndex:0] isEqualToString:getSettingCartPage])
    {
        NSLog(@"Failed/cancel Order");
        [self dismissViewControllerAnimated:YES completion:^{
            [order refreshOrderFailed];
        }];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.title = NSLocalizedString(@"inappwebview_done", nil);
//    [HUD removeFromSuperview];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(BOOL)shouldAutorotate{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
