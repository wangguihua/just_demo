//
//  UINavigationController+Orientation.m
//  BOCMBCI
//
//  Created by Tracy E on 13-6-26.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "UINavigationController+Orientation.h"

@implementation UINavigationController (Orientation)

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return [[self visibleViewController] supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return [[self visibleViewController] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

@end
