//
//  MBException.m
//  BOCMBCI
//
//  Created by Tracy E on 13-4-2.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBException.h"
#import "MBGlobalUICommon.h"
#import "MBConstant.h"

#import "MBAlertView.h"

@interface MBException ()<UIAlertViewDelegate>

@end

@implementation MBException

+ (MBException *)defaultException{
    static MBException *_exception = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _exception = [[MBException alloc] init];
    });
    return _exception;
}

- (void)alertWithMessage:(NSString *)message{
    MBAlertView *alert = [[MBAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertWithErrorCode:(NSString *)code{
    NSLog(@"errorCode: %@",code);
    
    NSString *message = NSLocalizedStringFromTable(code, @"tips", @"");
    if ([code isEqualToString:message]) {
        message = NSLocalizedStringFromTable(@"-1001", @"tips", @"");
    }
    
    MBAlertView *alert = [[MBAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

//通讯异常时，如果界面contentView为空白，点击提示框确定按钮返回到上一级界面。
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MBExceptionAlertViewDidHideNotification object:nil];
}


@end
