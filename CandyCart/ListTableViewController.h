//
//  ListTableViewController.h
//  CandyCart
//
//  Created by Steven on 5/7/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewController : UITableViewController {
    NSMutableArray *mainArray;
    NSMutableDictionary *userData;
}

@property (strong,nonatomic) NSString *buyMethod;

@end
