//
//  TempVariables.m
//  Mindful Minerals
//
//  Created by Dead Mac on 1/30/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import "TempVariables.h"
#import "ReviewCheckOutViewController.h"
@implementation TempVariables
@synthesize credit_card_aut,credit_card_year_aut,credit_card_month_aut,credit_card_cvv_aut,credit_card_profile_id_aut,review_checkout,onLounchProgress;
+ (TempVariables *) instance {
    static TempVariables *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)setOnLounchProgressBar:(UIProgressView *)bar{
    onLounchProgress = bar;
}

-(void)setProgressBarValue:(float)fl
{
    
    [onLounchProgress setProgress:fl animated:YES];
    
}

-(void)setAutNet:(NSString*)credit_card_no expired_year:(NSString*)year expired_month:(NSString*)month cvv:(NSString*)cvv profileID:(NSString*)profileID{
    credit_card_aut = credit_card_no;
    credit_card_year_aut = year;
    credit_card_month_aut = month;
    credit_card_profile_id_aut = profileID;
    credit_card_cvv_aut = cvv;
    
}

-(void)setReviewCheckout:(ReviewCheckOutViewController *)review_checkouts{

    review_checkout = review_checkouts;
}
@end
