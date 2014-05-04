//
//  CameraViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/5/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "CameraViewController.h"
#import "DetailViewController.h"
@interface CameraViewController ()

@end

@implementation CameraViewController
@synthesize readerView;

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
    self.title = NSLocalizedString(@"camera_view_title", nil);
    // Do any additional setup after loading the view from its nib.
    readerView.readerDelegate = self;

    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerView;
    }

    UIButton *qrcode = [UIButton buttonWithType:UIButtonTypeCustom];
    qrcode.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    qrcode.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [qrcode setTitle:NSLocalizedString(@"camera_cancel_btn", nil) forState:UIControlStateNormal];
    [qrcode addTarget:self
               action:@selector(backAction)
     forControlEvents:UIControlEventTouchDown];
    
    [qrcode setNuiClass:@"UiBarButtonItem"];
    [qrcode.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:qrcode];
    self.navigationItem.leftBarButtonItem = button;
    
    UIImageView *mask =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 514)];
    mask.image = [UIImage imageNamed:@"cameralayeri5.png"];
    [readerView addSubview:mask];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
     [readerView start];
    
  
}
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        
        
       [readerView stop];
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        // Regiser for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
        
        // Show the HUD while the provided method executes in a new thread
        [HUD showWhileExecuting:@selector(scannerExe:) onTarget:self withObject:sym.data animated:YES];
        
        
        break;
    }
}

-(void)scannerExe:(NSString*)result{
    NSDictionary *dic = [[DataService instance] qrcodescanner:result];
    
    if([[dic objectForKey:@"post_type"] isEqualToString:@"product"])
    {
       [[ToolClass instance] checkLink:[dic objectForKey:@"link"] navigation:self.navigationController];
        
    }
    else if([[dic objectForKey:@"post_type"] isEqualToString:@"post"])
    {
        [[ToolClass instance] checkLink:[dic objectForKey:@"link"] navigation:self.navigationController];
        
    }
    else if([[dic objectForKey:@"post_type"] isEqualToString:@"page"])
    {
        [[ToolClass instance] checkLink:[dic objectForKey:@"link"] navigation:self.navigationController];
        
    }
    else if([[dic objectForKey:@"post_type"] isEqualToString:@"link"])
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Load Data Service In Background
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                iPhoneWebView *iphoneWeb = [[iPhoneWebView alloc] init];
                [iphoneWeb loadUrlInWebView:[dic objectForKey:@"link"]];
                [self.navigationController pushViewController:iphoneWeb animated:YES];
               
            });
            
        });
    }
    else
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Load Data Service In Background
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"general_notification_error_title", nil)
                                      
                                                               message: NSLocalizedString(@"camera_unsupport_qrcode_error_msg", nil)
                                                              delegate: nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:NSLocalizedString(@"general_notification_ok_btn_title", nil),nil];
                
                
                [alert show];

                [readerView start];
            });
            
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
