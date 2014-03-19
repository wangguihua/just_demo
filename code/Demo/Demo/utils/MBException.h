//
//  MBException.h
//  BOCMBCI
//
//  Created by Tracy E on 13-4-2.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
//  通讯异常处理类

#import <Foundation/Foundation.h>

@interface MBException : NSObject

+ (MBException *)defaultException;

- (void)alertWithMessage:(NSString *)message;

//错误信息文件佳能/files/errorCode.strings
- (void)alertWithErrorCode:(NSString *)code;    //根据通讯返回的错误码，提示自定义的错误信息

@end
