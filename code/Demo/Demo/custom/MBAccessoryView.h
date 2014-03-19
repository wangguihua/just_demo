//
//  MBInputAccessoryView.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-29.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
//  键盘辅助视图

#import <UIKit/UIKit.h>

@protocol MBAccessoryViewDelegate;

@interface MBAccessoryView : UIToolbar
- (id)initWithDelegate:(id<MBAccessoryViewDelegate>)delegate;
- (void)setTitle:(NSString *)title;
@end


@protocol MBAccessoryViewDelegate <NSObject>

@optional
- (void)accessoryViewDidPressedCancelButton:(MBAccessoryView *)view;
- (void)accessoryViewDidPressedDoneButton:(MBAccessoryView *)view;

@end
