//
//  MBLabel.h
//  BOCMBCI
//
//  Created by Tracy E on 13-4-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
#define MBLabelTipWillShowNotification @"MBLabelTipWillShowNotification"

#import <UIKit/UIKit.h>

@interface MBLabel : UILabel

//跑马灯
@property (nonatomic, unsafe_unretained) BOOL isPaoMaDeng;

//隐藏提示信息
- (void)hideTipIfNeeded;

@end
