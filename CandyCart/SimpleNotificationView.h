//
//  SimpleNotificationView.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 9/6/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleNotificationView : UIView
{
    UIView *inView;
    BOOL isOpen;
    UILabel *closeLbl;
    NSTimer *timer;
    
}
@property (nonatomic, retain) UILabel *label;
@property (nonatomic,retain) UIImageView *closeBtn;
- (id)initWithFrame:(CGRect)frame andView:(UIView*)view;
-(void)showView:(NSString*)setText completed:(void (^)())block;
-(void)closeView;
@end
