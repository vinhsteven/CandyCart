//
//  AddNewCameraViewController.h
//  ShopManager
//
//  Created by Steven on 3/23/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewCameraViewController : UIViewController

@property (unsafe_unretained) id parent;
@property (assign) BOOL isEdit;
@property (strong, nonatomic) NSMutableDictionary *cameraDict;
@property (strong, nonatomic) IBOutlet UILabel *lbCameraName;
@property (strong, nonatomic) IBOutlet UILabel *lbDomain;
@property (strong, nonatomic) IBOutlet UILabel *lbChannel;
@property (strong, nonatomic) IBOutlet UILabel *lbUsername;
@property (strong, nonatomic) IBOutlet UILabel *lbPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtCameraName;
@property (strong, nonatomic) IBOutlet UITextField *txtDomain;
@property (strong, nonatomic) IBOutlet UITextField *txtChannel;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(id)_parent;

@end
