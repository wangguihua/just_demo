//
//  MBRegExpCheck.h
//  BOCMBCI
//
//  Created by Tracy E on 13-5-9.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************Example*************************************
 
 NSArray *checkList = @[RegExpItem(@"手机号", _mobileTextField.text, @"mobile", YES),
                        RegExpItem(@"密码", _passwordTextField.text, @"password", YES)];
 if (RegExpCheck(checkList)) {
    NSLog(@"校验通过");
 } 
 
 **********************************************************************/

/**
 *  @param label: 字段名,在必填项没有输入时进行提示：“label不能为空”。
 *  @param value: 要校验的字符串
 *  @param type:  字段对用的正则类型
 *  @param required: 字段是否为必填项
 */
id RegExpItem(NSString *label, NSString *value, NSString *type, BOOL required);

/**
 *  @return 校验通过返回YES，校验失败返回NO。
 */
BOOL RegExpCheck(NSArray *checkList);

/**
 *  @param  delegate: 输入为空时弹出提示框的代理
 *  @return 校验通过返回YES，校验失败返回NO。
 */
BOOL RegExpCheckWithDelegate(NSArray *checkList, id delegate);




