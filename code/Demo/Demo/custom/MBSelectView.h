//
//  MBSelectView.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-30.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBAccessoryView.h"

typedef NS_ENUM(NSInteger, MBSelectType) {
    MBSelectTypeNormal,
    MBSelectTypeDate
};

@interface MBSelectView : UIView<MBAccessoryViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
}

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) MBSelectType selectType;

@property (nonatomic,unsafe_unretained) NSString *title;
//type normal
@property (nonatomic, strong) NSArray *options;     //select items.
@property (nonatomic, copy) NSString *value;        //result.

//type date
@property (nonatomic, strong) NSDate *dateValue;    //result.
@property (nonatomic, strong) NSDate *minDate;      //enabled min date range.
@property (nonatomic, strong) NSDate *maxDate;      //enabled max date range.

- (void)setSelectedDate:(NSDate *)selectedDate;     //set default display date.

- (void)addTarget:(id)target forVauleChangedaction:(SEL)action;

- (void)showPickerView;
@end

