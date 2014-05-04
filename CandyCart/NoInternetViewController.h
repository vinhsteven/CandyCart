//
//  NoInternetViewController.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 9/28/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoInternetViewController : UIViewController
@property(nonatomic,retain) IBOutlet UILabel *desc;
@property(nonatomic,retain) IBOutlet UIButton *tryAgain;
-(IBAction)tryAgainAction:(id)sender;
@end
