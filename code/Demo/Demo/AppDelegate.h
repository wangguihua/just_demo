//
//  AppDelegate.h
//  Demo
//
//  Created by llbt_wgh on 14-1-22.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MBTabBarController *tabBarController;

@end
