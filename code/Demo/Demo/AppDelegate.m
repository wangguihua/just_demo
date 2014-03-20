//
//  AppDelegate.m
//  Demo
//
//  Created by llbt_wgh on 14-1-22.
//  Copyright (c) 2014年 llbt. All rights reserved.
//

#import "AppDelegate.h"
#import "UncaughtExceptionHandler.h"
#import "MBCorePreprocessorMacros.h"
#import "UIColorAdditions.h"
#import "MBConstant.h"
#import "MBGlobalUICommon.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageAdditions.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
#if __MB_DEBUG__
    InstallUncaughtExceptionHandler();
#endif
    self.tabBarController = [[MBTabBarController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = _tabBarController;
    _tabBarController.delegate=self;
    [self.window makeKeyAndVisible];
    [self appGlobleSetting];
    return YES;
}
-(void)appGlobleSetting
{
    //设置应用程序全局外观
    self.window.backgroundColor = [UIColor blackColor];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBarBG.png"]];
    self.window.tintColor = HEX(@"#5ec4fe");
    if (IOS7_OR_LATER) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.window.tintColor = HEX(@"#5ec4fe");
        [[UINavigationBar appearance] setBarTintColor:HEX(@"#5ec4fe")];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBarBG.png"]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                NSFontAttributeName: kBigTitleFont}];
    }

}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isEqual:[tabBarController.viewControllers objectAtIndex:2]]) {
        return NO;
    } 
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
