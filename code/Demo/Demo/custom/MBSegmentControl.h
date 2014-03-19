//
//  MBSegmentControl.h
//  BOCMBCI
//
//  Created by llbt_ych on 13-4-12.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MBSegmentControlDelegate;
@class SegmentButton;
@interface MBSegmentControl : UIView{
    BOOL _disableSelectState;
}

@property (nonatomic , assign) NSInteger selectIndex;                       //选中索引
@property (nonatomic , unsafe_unretained) id <MBSegmentControlDelegate>delegate;
@property (nonatomic , strong) NSArray *itemNameArray;                      //个项title数组
@property (nonatomic, assign) BOOL momentary;                               //default is NO.
     
- (void)setSegSelectIndex:(NSInteger)index;                    //主动设置索引
- (void)reloadView;

@end

@protocol MBSegmentControlDelegate <NSObject>

@optional
- (void) MBSegment:(MBSegmentControl *)segment selectAtIndex:(NSInteger)index;

@end