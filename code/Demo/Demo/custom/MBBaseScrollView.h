//
//  MBBaseScrollView.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-27.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewAdditions.h"

@interface MBBaseScrollView : UIScrollView

@property (unsafe_unretained, nonatomic, readonly) UIImageView *verticalIndicator;
@property (unsafe_unretained, nonatomic, readonly) UIImageView *horizontalIndicator;

- (void)scrollToTopAnimated:(BOOL)animation;
- (void)scrollToBottomAnimated:(BOOL)animation;

- (NSArray *)contentSubviews;

//子视图位置变化时调整contentSize。
- (void)contentSizeToFit;

@end
