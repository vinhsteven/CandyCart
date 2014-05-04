//
//  UITabBarController+HideTabBar.m
//  TabBarAnimation
//
//  Created by Shane.Wu on 13/4/25.
//  Copyright (c) 2013年 Shane.Wu. All rights reserved.
//

#import "UITabBarController+HideTabBar.h"

#define AnimationDuration 0.2f
#define AnimationDelay 0.0f

@implementation UITabBarController (HideTabBar)
-(void)viewDidLoad{
    
    NSLog(@"TabBar Load");
    
    if([[DeviceClass instance] getOSVersion] == iOS7)
    {
    self.tabBar.translucent = YES;
   
    self.tabBar.barTintColor = [UIColor whiteColor];
    }
    else
    {
        
    }
}

- (BOOL)isTabBarHidden
{
    return self.tabBar.frame.origin.y >= self.view.frame.size.height;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    [self setTabBarHidden:tabBarHidden animated:NO];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (hidden == self.isTabBarHidden) return;
    
    if (animated) {
        [UIView animateWithDuration:AnimationDuration delay:AnimationDelay options:UIViewAnimationOptionCurveLinear animations:^{
            [self adjustSubviewsWithTabBarHidden:hidden];
        }completion:nil];
    } else {
        [self adjustSubviewsWithTabBarHidden:hidden];
    }
}

- (void)adjustSubviewsWithTabBarHidden:(BOOL)hidden
{
    CGRect viewFrame = self.view.frame;
    CGRect tabBarFrame = self.tabBar.frame;
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0.0f : tabBarFrame.size.height);
            view.frame = tabBarFrame;
        } else {
            CGRect containerFrame = view.frame;
            containerFrame.size.height = viewFrame.size.height - (hidden ? 0.0f : tabBarFrame.size.height);
            view.frame = containerFrame;
        }
    }
}

@end
