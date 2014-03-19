//
//  MBConstant.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBAdditions.h"
#import "MBGlobalCore.h"

#define ChangeLimiteValueStepHeight 25
#define kBooleanTrueString @"1"
#define kBooleanFalseString @"0"
//--------------------------------------------------------------------------------------------------
//Global frames
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kStatusBarHeight 20.0f
#define kNavigationBarHeight 44.0f
#define kNavigationBarLandscapeHeight 33.0f
#define kTabBarHeight 49.0f
#define kContentViewHeight (kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTabBarHeight)
#define kPickerViewHeight 216.0f
#define kToolBarHeight 44.0f
#define kStepViewHeight 25.0f
#define kTextFieldHeight 25.0f
#define kInputViewHeight (kPickerViewHeight + kToolBarHeight)

#define kDateFormat @"yyyy-MM-dd"


//--------------------------------------------------------------------------------------------------
//View Frames

//MBScrollMenu
#define kScrollCellWidth 66.0f
#define kScrollCellHeight 72.0f
#define kScrollButtonWidth 27.0f
#define kScrollButtonHeight 66.0f
#define kScrollMenuWidth (kScrollCellWidth + kScrollButtonWidth)

//--------------------------------------------------------------------------------------------------
//Global Fonsts

//大标题 40点
#define kBigTitleFont [UIFont boldSystemFontOfSize:20]

//小标题 28点
#define kSmallTitleFont [UIFont boldSystemFontOfSize:14]

//普通文本，正文
#define kNormalTextFont [UIFont boldSystemFontOfSize:15]

//步骤条文字
#define kSmallTextFont [UIFont systemFontOfSize:11]

//正文按钮字体
#define kButtonTitleFont [UIFont boldSystemFontOfSize:14]

//弹出框按钮大小
#define kSmallButtonTitleFont [UIFont boldSystemFontOfSize:13]

//#202020
#define kNormalTextColor [UIColor colorWithRed:(32 / 255.0) green:(32 / 255.0) blue:(32 / 255.0) alpha:1]

//#ffffff
#define kWhiteTextColor [UIColor whiteColor]

//#ba001d
#define kRedTextColor [UIColor colorWithRed:(186 / 255.0) green:0 blue:(29 / 255.0) alpha:1]

//#919191
#define kTipTextColor [UIColor colorWithRed:(145 / 255.0) green:(145 / 255.0) blue:(145 / 255.0) alpha:1]

//#c6c6c6
#define kStepViewTextColor [UIColor colorWithRed:(198 / 255.0) green:(198 / 255.0) blue:(198 / 255.0) alpha:1]

//#016622
#define kGreenColor [UIColor colorWithRed:(1 / 255.0) green:(102 / 255.0) blue:(34 / 255.0) alpha:1]

//--------------------------------------------------------------------------------------------------
//Button Frames
#define kLeftButtonFrame(__offsetY) CGRectMake(10, __offsetY, 138, 39)
#define kRightButtonFrame(__offsetY) CGRectMake(172, __offsetY, 138, 39)

#define kMiddleButtonFrame(__offsetY) CGRectMake(56, __offsetY,208, 40)

//一行三个按钮
#define kLineButton1(__offsetY) CGRectMake(5, __offsetY, 104, 39)
#define kLineButton2(__offsetY) CGRectMake(108, __offsetY, 104, 39)
#define kLineButton3(__offsetY) CGRectMake(211, __offsetY, 104, 39)




//--------------------------------------------------------------------------------------------------
//Notification Names
#define MBUserDidLoginNotification @"MBUserDidLoginNotification"
#define MBUserDidLogoutNotification @"MBUserDidLogoutNotification"

#define MBSelectViewWillShowNotification @"MBSelectViewWillShowNotification"
#define MBSelectViewWillHideNotification @"MBSelectViewWillHideNotification"
#define MBSelectViewDidShowNotification @"MBSelectViewDidShowNotification"
#define MBSelectViewDidHideNotification @"MBSelectViewDidHideNotification"

#define MBAlertViewDidShowNotification @"MBAlertViewDidShowNotification"
#define MBAlertViewDidHideNotification @"MBAlertViewDidHideNotification"
#define MBProtocolChangeLimiteCompleteNotification @"MBProtocolChangeLimiteCompleteNotification"

#define MBLoadingViewDidHideNotification @"MBLoadingViewDidHideNotification"
#define MBExceptionAlertViewDidHideNotification @"MBExceptionAlertViewDidHideNotification"

//消息通知，非固定产品签约成功刷新表格通知
#define MBFGDSingNotification @"MBFGDSingNotification"

//--------------------------------------------------------------------------------------------------
//NSUserDefault keys:
#define kAppVersion             @"appVersion"
#define kBizMenuOrder           @"bizMenuOrder"
#define kSubShortcutMenus       @"SubShortcutMenus"
#define kAppLaunchedTimes       @"appLaunchedTimes"
#define kAcctLaunchedTimes      @"acctLaunchedTimes"
#define kAppTimeoutInterval     @"AppTimeoutInterval"
#define kFidgetCityName         @"fidgetCityName"
#define kFidgetCityCode         @"fidgetCityCode"
#define kRememberLoginName      @"shouldRememberLoginName"
#define kLoginName              @"loginName"
#define kLoginHint              @"loginHint"
#define kZuoTiAccount           @"zuoTiAccount"

//--------------------------------------------------------------------------------------------------
//交易数据字典
@interface MBConstant : NSObject


@end