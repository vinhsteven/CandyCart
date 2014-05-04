//
//  NoInternetViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 9/28/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "NoInternetViewController.h"

@interface NoInternetViewController ()

@end

@implementation NoInternetViewController
@synthesize desc,tryAgain;
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
    // Do any additional setup after loading the view from its nib.
    desc.text = NSLocalizedString(@"general_no_internet_connectivitiy_desc", nil);
    tryAgain.titleLabel.text = NSLocalizedString(@"general_no_internet_connectivitiy_btn_lbl", nil);
    [tryAgain setNuiClass:@"LargeButton"];
}


-(IBAction)tryAgainAction:(id)sender{
    
    UIWindow *window = [[MainViewClass instance] getCurrentMainWindow];
    
    LaunchViewController *launchView = [[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil];
    
    window.rootViewController = launchView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
