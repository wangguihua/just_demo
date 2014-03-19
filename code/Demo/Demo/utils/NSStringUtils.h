//
//  NSString+Utils.h
//  BOCMBCI
//
//  Created by Tracy E on 13-4-12.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

//字符串替换（如：[@"2013-05-01" replace:@"-" with@"/"];）
- (NSString *)replace:(NSString *)oldString with:(NSString *)newString;

//过滤手机号中一些特殊字符
- (NSString *)phoneNumberTrim;

//账户反显格式化(目前为4-6-4)
- (NSString *)format4n4;

//金额格式化 (99,888,000.00)
- (NSString *)formatMonery;

//特殊币种格式化不要小数点 (99,888,000)
- (NSString *)formatMonerySpecial;

//金额币种格式化带小数点后3位
- (NSString *)formatMoneryThreeDecimal;

//金额小数位不做控制
-(NSString *)formatAnyDecimal;

//更正用户输入
//例如：用户在金额输入.11实际是正常的，应该做一下更正
- (NSString *)correctUserInput;

- (NSString *)mobileFormat;

//去除字符串前后空格
- (NSString *)formatWhiteSpace;


//去除字符串前后空格以及后面的换行
- (NSString *)formatWhiteSpaceAndNewLineCharacterSet;

//返回小数点后一位（不带逗号）
-(NSString *)formatBalance;

@end
