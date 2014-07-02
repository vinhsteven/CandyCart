//
//  APPChildViewController.h
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPChildViewController : UIViewController <UIWebViewDelegate>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) NSMutableDictionary *promotionDict;

- (IBAction)closeView:(id)sender;

@end
