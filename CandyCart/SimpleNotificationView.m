//
//  SimpleNotificationView.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 9/6/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "SimpleNotificationView.h"

@implementation SimpleNotificationView
@synthesize label,closeBtn;
- (id)initWithFrame:(CGRect)frame andView:(UIView*)view
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        inView = view;
        [self setNuiClass:@"BaseView"];
        [self createView];
        self.userInteractionEnabled = YES;
    }
    return self;
}


-(void)createView{
    [inView addSubview:self];
    
    if([[DeviceClass instance] getOSVersion] == iOS7)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-40, self.frame.size.height)];
        
        [label setNuiClass:@"BaseView_label"];
        [label setNumberOfLines:2];
        label.userInteractionEnabled = YES;
        label.text = @"This is only sample : Lorem ipsum how to get the notification";
        [self addSubview:label];
        isOpen = NO;
        
        closeLbl = [[UILabel alloc] initWithFrame:CGRectMake(276, 10, 44, 44)];
        [closeLbl setNuiClass:@"BaseView_label"];
        
        closeLbl.userInteractionEnabled = YES;
        [self addSubview:closeLbl];
        closeBtn = [[UIImageView alloc] initWithFrame:CGRectMake(15, 23, 20, 20)];
        closeBtn.image = [UIImage imageNamed:@"closeBtn.png"];
        closeBtn.userInteractionEnabled = YES;
        [closeLbl addSubview:closeBtn];
        
        UITapGestureRecognizer *closeBtnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnTapExe:)];
        [closeBtnTap setNumberOfTouchesRequired:1];
        [closeLbl addGestureRecognizer:closeBtnTap];
        
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-40, self.frame.size.height)];
        
        [label setNuiClass:@"BaseView_label"];
        [label setNumberOfLines:2];
        label.userInteractionEnabled = YES;
        label.text = @"This is only sample : Lorem ipsum how to get the notification";
        [self addSubview:label];
        isOpen = NO;
        
        closeLbl = [[UILabel alloc] initWithFrame:CGRectMake(276, 0, 44, 44)];
        [closeLbl setNuiClass:@"BaseView_label"];
        
        closeLbl.userInteractionEnabled = YES;
        [self addSubview:closeLbl];
        closeBtn = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
        closeBtn.image = [UIImage imageNamed:@"closeBtn.png"];
        closeBtn.userInteractionEnabled = YES;
        [closeLbl addSubview:closeBtn];
        
        UITapGestureRecognizer *closeBtnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnTapExe:)];
        [closeBtnTap setNumberOfTouchesRequired:1];
        [closeLbl addGestureRecognizer:closeBtnTap];
    }
}

-(void)closeBtnTapExe:(UITapGestureRecognizer*)tap{
    NSLog(@"Close Notification");
    CGRect rect = self.frame;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         if([[DeviceClass instance] getOSVersion] == iOS7)
                         {
                             self.frame = CGRectMake(0, -64, rect.size.width, rect.size.height);
                         }
                         else
                         {
                             self.frame = CGRectMake(0, -44, rect.size.width, rect.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         isOpen = NO;
                         [timer invalidate];
                     }];
    
}

-(void)showView:(NSString*)setText completed:(void (^)())block{
    
    label.text = setText;
    CGRect rect = self.frame;
    if(isOpen == NO)
    {
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             
                             self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
                         }
                         completion:^(BOOL finished){
                             
                             isOpen = YES;
                             
                             
                             timer = [NSTimer scheduledTimerWithTimeInterval:NOTIFICATION_DELAY target:self selector:@selector(closeView) userInfo:nil repeats:NO];
                             
                             block();
                         }];
        
    }
    else
    {
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:NOTIFICATION_DELAY target:self selector:@selector(closeView) userInfo:nil repeats:NO];
    }
    
}

-(void)closeView
{
    CGRect rect = self.frame;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         if([[DeviceClass instance] getOSVersion] == iOS7)
                         {
                             self.frame = CGRectMake(0, -64, rect.size.width, rect.size.height);
                         }
                         else
                         {
                             self.frame = CGRectMake(0, -44, rect.size.width, rect.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         
                         
                         isOpen = NO;
                         [timer invalidate];
                         
                     }];
}

@end
