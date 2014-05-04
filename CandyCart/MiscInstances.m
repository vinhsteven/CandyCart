//
//  MiscInstances.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/15/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "MiscInstances.h"

@implementation MiscInstances
+ (MiscInstances *) instance {
    static MiscInstances *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)setLoadMoreUILabel:(UILabel*)lbl{
    
    loadmorelbl = lbl;
}

-(UILabel*)getLoadMoreUILabel
{
    return loadmorelbl;
}


-(void)setLoadMoreActivityView:(UIActivityIndicatorView*)act{
    
    loadmoreActivity = act;
}

-(UIActivityIndicatorView*)getLoadMoreActivityView
{
    return loadmoreActivity;
}

@end
