//
//  MBStepView.h
//  BOCMBCI
//
//  Created by Tracy E on 13-4-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBStepView : UIScrollView

@property (nonatomic, strong) NSArray *steps;
@property (nonatomic, assign) NSInteger startIndex;     //开始显示的步骤数（从1开始）
@property (nonatomic, assign) NSInteger currentIndex;   //当前正在显示的步骤（从1开始）

@end
