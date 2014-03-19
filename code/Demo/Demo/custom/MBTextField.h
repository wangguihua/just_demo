//
//  MBTextField.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-29.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBRegExpCheck.h"

/** 键盘类型keyboardType：
 *  手机号：UIKeyboardTypeNumberPad
 *  金额输入框：UIKeyboardTypeDecimalPad
 *  邮件输入框：UIKeyboardTypeEmailAddress
 */

@interface MBTextField : UITextField

@property (nonatomic, assign) NSUInteger textMaxLength;
@property (nonatomic, assign) BOOL copyEnabled;             //Default is YES.
@property (unsafe_unretained, nonatomic, readonly) id<UITextFieldDelegate> textFieldDelegate;

@property (nonatomic, copy) NSString *regularExpression;    //Deprecated.
@property (nonatomic, copy) NSString *errorMessage;         //Deprecated.
//理财里面添加
@property (nonatomic, unsafe_unretained) BOOL isDrawPlaceholder;


@end

@protocol MBTextFieldDelegate <NSObject, UITextFieldDelegate>

@optional
- (void)textFieldDidCancelEditing:(MBTextField *)textField; //点击键盘上的“取消”按钮。
- (void)textFieldDidFinsihEditing:(MBTextField *)textField; //点击键盘框上的“确定”按钮。

@end
