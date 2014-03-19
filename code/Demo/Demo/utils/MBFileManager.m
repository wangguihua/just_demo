//
//  MBFileManager.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-28.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBFileManager.h"
#import "UIApplicationAdditions.h"
//#import "SSZipArchive.h"//解压zip.rar 文件


@implementation MBFileManager

+ (MBFileManager *)shareManager{
    static MBFileManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MBFileManager alloc] init];
    });
    return _manager;
}

- (NSDictionary *)dictionaryFromBundlePlist:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:[fileName stringByReplacingOccurrencesOfString:@".plist" withString:@""] ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:path]];
}

- (void)writeFile:(id)object toDocumentPath:(NSString *)path{
    NSString *documentPath = [[UIApplication sharedApplication] documentsDirectory];
    NSString *toPath = [documentPath stringByAppendingPathComponent:path];
    NSLog(@"Documents : %@",toPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:toPath]) {
        [fileManager createDirectoryAtPath:[toPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [object writeToFile:toPath atomically:YES];
}

// 解压zip.rar 文件
//- (void)unzipAndDeleteFileAtDocumentPath:(NSString *)path{
//    NSString *documentPath = [[UIApplication sharedApplication] documentsDirectory];
//    NSString *toPath = [documentPath stringByAppendingPathComponent:path];
//    [SSZipArchive unzipFileAtPath:toPath toDestination:[toPath stringByDeletingPathExtension]];
//    [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
//}

- (id)objectFromDocumentPath:(NSString *)path{
    NSString *documentPath = [[UIApplication sharedApplication] documentsDirectory];
    NSString *filePath = [documentPath stringByAppendingPathComponent:path];
    return [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
}

- (id)arrayFromDocumentPath:(NSString *)path{
    NSString *documentPath = [[UIApplication sharedApplication] documentsDirectory];
    NSString *filePath = [documentPath stringByAppendingPathComponent:path];
    return [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (NSString *)documentPathFromPath:(NSString *)path{
    NSString *documentPath = [[UIApplication sharedApplication] documentsDirectory];
    return [documentPath stringByAppendingPathComponent:path];
}

- (void)removeItemAtDocumentPath:(NSString *)path{
    NSString *filePath = [self documentPathFromPath:path];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


@end
