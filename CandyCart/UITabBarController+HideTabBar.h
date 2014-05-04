//
//  UITabBarController+HideTabBar.h
//  TabBarAnimation
//
//  Created by Shane.Wu on 13/4/25.
//  Copyright (c) 2013年 Shane.Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (HideTabBar)

@property (assign, nonatomic, getter = isTabBarHidden) BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
