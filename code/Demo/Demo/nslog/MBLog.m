//
//  MBLog.m
//  BOCMBCI
//
//  Created by Tracy E on 13-6-21.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBLog.h"
#import "UIApplicationAdditions.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <sys/errno.h>
#include <math.h>
#include <limits.h>
#include <objc/runtime.h>

NSString * NSStringFormatted( NSString * format, va_list argList )
{
	return [[NSString alloc] initWithFormat:format arguments:argList];
}

extern void MBLog(NSObject *format, ...) {
#if __MB_LOG__
    
    if (nil == format) {
        return;
    }
    
    static NSDateFormatter *__dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
    });
    
    va_list args;
    va_start(args, format);
    
    NSString *text = nil;
    __dateFormatter.dateFormat = @"yyyy-MM-dd hh:ss:mm";
    if ([format isKindOfClass:[NSString class]]) {
        text = [NSString stringWithFormat:@"[%@] > %@",[__dateFormatter stringFromDate:[NSDate date]],NSStringFormatted((NSString *)format, args)];
    } else {
        text = [NSString stringWithFormat:@"[%@] > %@",[__dateFormatter stringFromDate:[NSDate date]], [format description]];
    }
    
    if ([text rangeOfString:@"\n"].length) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t\t"];
    }
    
#if __MB_LOG__
    printf("%s\n\n",[text UTF8String]);
#endif  //__MB_LOG__
    
#if __MB_SAVE_LOG__
    @autoreleasepool {
        __dateFormatter.dateFormat = @"yyyy_MM_dd";
        NSString *logPath = [[[UIApplication sharedApplication] documentsDirectory] stringByAppendingFormat:@"/log/%@.txt",[__dateFormatter stringFromDate:[NSDate date]]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:logPath]) {
            [fileManager createDirectoryAtPath:[[[UIApplication sharedApplication] documentsDirectory] stringByAppendingFormat:@"/log"] withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
        }
        
        const char *filePath;
        filePath = [logPath fileSystemRepresentation];
        FILE *f = fopen(filePath, "a+");
        if(f){
            const char *line;
            line = [text UTF8String];
            fprintf(f, "%s\n", line);
            fclose(f);
        }
    }
#endif  //__MB_SAVE_LOG__
    
    va_end(args);
    
    
#endif  //__MB_DEBUG__
}