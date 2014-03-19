//
//  UncaughtExceptionHandler.h
//  BOCMBCI
//
//  Created by llbt_wgh on 13-12-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject
{
         BOOL dismissed;
}
@end
void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);