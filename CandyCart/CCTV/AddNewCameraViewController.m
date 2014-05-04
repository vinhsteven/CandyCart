//
//  AddNewCameraViewController.m
//  ShopManager
//
//  Created by Steven on 3/23/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "AddNewCameraViewController.h"
#import "ListCameraViewController.h"

@interface AddNewCameraViewController ()

@end

@implementation AddNewCameraViewController
@synthesize parent;
@synthesize isEdit;
@synthesize cameraDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(id)_parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        parent = _parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lbCameraName.text  = NSLocalizedString(@"addNewCameraVC.lb-camera-title", nil);
    _lbDomain.text      = NSLocalizedString(@"addNewCameraVC.lb-domain-title", nil);
    _lbChannel.text     = NSLocalizedString(@"addNewCameraVC.lb-channel-title", nil);
    _lbUsername.text    = NSLocalizedString(@"addNewCameraVC.lb-username-title", nil);
    _lbPassword.text    = NSLocalizedString(@"addNewCameraVC.lb-password-title", nil);
    _txtCameraName.placeholder  = NSLocalizedString(@"addNewCameraVC.txt-camera-name", nil);
    _txtDomain.placeholder      = NSLocalizedString(@"addNewCameraVC.txt-domain", nil);
    _txtUsername.placeholder    = NSLocalizedString(@"addNewCameraVC.txt-username", nil);
    _txtPassword.placeholder    = NSLocalizedString(@"addNewCameraVC.txt-password", nil);
    
    _txtChannel.text = @"1";
    
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"addNewCameraVC.btn-save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveCamera)];
    self.navigationItem.rightBarButtonItem = btnSave;
    
    if (isEdit) {
        _txtCameraName.text  = [cameraDict objectForKey:@"cameraName"];
        _txtDomain.text      = [cameraDict objectForKey:@"domain"];
        _txtUsername.text    = [cameraDict objectForKey:@"username"];
        _txtPassword.text    = [cameraDict objectForKey:@"password"];
        
        _txtChannel.text = @"1";
    }
}

- (void) saveCamera {
    if (_txtCameraName.text == nil || [_txtCameraName.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"addNewCameraVC.required-camera-name", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if (_txtDomain.text == nil || [_txtDomain.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"addNewCameraVC.required-domain", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if (_txtChannel.text == nil || [_txtChannel.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"general.warning", nil) message:NSLocalizedString(@"addNewCameraVC.required-channel", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"general.ok", nil) otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if (!isEdit) {
        NSMutableDictionary *tmpCameraDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_txtCameraName.text,@"cameraName",_txtDomain.text,@"domain",_txtChannel.text,@"channel",_txtUsername.text,@"username",_txtPassword.text,@"password", nil];
        [[(ListCameraViewController*)parent mainArray] addObject:tmpCameraDict];
    }
    else {
        [cameraDict setObject:_txtCameraName.text forKey:@"cameraName"];
        [cameraDict setObject:_txtDomain.text forKey:@"domain"];
        [cameraDict setObject:_txtChannel.text forKey:@"channel"];
        [cameraDict setObject:_txtUsername.text forKey:@"username"];
        [cameraDict setObject:_txtPassword.text forKey:@"password"];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[(ListCameraViewController*)parent mainArray] forKey:CAMERA_LIST];
    
    [[(ListCameraViewController*)parent tableView] reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
