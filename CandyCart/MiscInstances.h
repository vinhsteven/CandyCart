//
//  MiscInstances.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/15/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiscInstances : NSObject
{
    UILabel *loadmorelbl;
    UIActivityIndicatorView *loadmoreActivity;
}
+ (MiscInstances *) instance;
-(void)setLoadMoreUILabel:(UILabel*)lbl;
-(UILabel*)getLoadMoreUILabel;

-(void)setLoadMoreActivityView:(UIActivityIndicatorView*)act;
-(UIActivityIndicatorView*)getLoadMoreActivityView;
@end
