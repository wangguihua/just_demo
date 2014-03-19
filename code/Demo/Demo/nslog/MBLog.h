//
//  MBLog.h
//  BOCMBCI
//
//  Created by Tracy E on 13-6-21.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef	NSLog
#define NSLog MBLog

void MBLog(NSObject *format, ...);
