//
//  UITabBar+TabBarButtons.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-27.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "UITabBar+TabBarButtons.h"

@implementation UITabBar (TabBarButtons)

- (NSArray *)tabBarButtons{
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:5];
    for (UIView *v in self.subviews){
        if ([v isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [buttons addObject:v];
        }
    }
    [buttons sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView *button1 = (UIView *)obj1;
        UIView *button2 = (UIView *)obj2;
        if (button1.frame.origin.x < button2.frame.origin.x) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return buttons;
}

- (id)tabBarButtonAtIndex:(NSUInteger)index{
    return [[self tabBarButtons] objectAtIndex:index];
}

@end
