//
//  TempVariables.h
//  Mindful Minerals
//
//  Created by Dead Mac on 1/30/14.
//  Copyright (c) 2014 Dead Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ReviewCheckOutViewController;
@interface TempVariables : NSObject
+ (TempVariables *) instance;
//For Authorize.net Credit Card
@property(nonatomic,retain) NSString *credit_card_aut;
@property(nonatomic,retain) NSString *credit_card_year_aut;
@property(nonatomic,retain) NSString *credit_card_month_aut;
@property(nonatomic,retain) NSString *credit_card_cvv_aut;
@property(nonatomic,retain) NSString *credit_card_profile_id_aut;
@property(nonatomic,retain) UIProgressView *onLounchProgress;
@property(nonatomic,retain) ReviewCheckOutViewController *review_checkout;
-(void)setAutNet:(NSString*)credit_card_no expired_year:(NSString*)year expired_month:(NSString*)month cvv:(NSString*)cvv profileID:(NSString*)profileID;
-(void)setReviewCheckout:(ReviewCheckOutViewController *)review_checkouts;
-(void)setOnLounchProgressBar:(UIProgressView *)bar;
-(void)setProgressBarValue:(float)fl;
@end
