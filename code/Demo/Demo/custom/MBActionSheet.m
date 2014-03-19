//
//  MBActionSheet.m
//  BOCMBCI
//
//  Created by Tracy E on 13-5-18.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBActionSheet.h"
#import "MBConstant.h"
#import <QuartzCore/QuartzCore.h>

@implementation MBActionSheet

- (void)showFromToolbar:(UIToolbar *)view{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_dismiss)
                                                 name:MBUserDidLogoutNotification
                                               object:nil];

    [super showFromToolbar:view];
}

- (void)showFromTabBar:(UITabBar *)view{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_dismiss)
                                                 name:MBUserDidLogoutNotification
                                               object:nil];

    [super showFromTabBar:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_dismiss)
                                                 name:MBUserDidLogoutNotification
                                               object:nil];

    [super showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_dismiss)
                                                 name:MBUserDidLogoutNotification
                                               object:nil];

    [super showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_dismiss)
                                                 name:MBUserDidLogoutNotification
                                               object:nil];

    [super showInView:view];
}

- (void)_dismiss{
    [self dismissWithClickedButtonIndex:self.destructiveButtonIndex animated:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
}

@end
