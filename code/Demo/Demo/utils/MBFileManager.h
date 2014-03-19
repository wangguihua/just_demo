//
//  MBFileManager.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-28.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
//  本地文件存储类

#import <Foundation/Foundation.h>

@interface MBFileManager : NSFileManager

+ (MBFileManager *)shareManager;

- (id)dictionaryFromBundlePlist:(NSString *)fileName;
- (void)writeFile:(id)object toDocumentPath:(NSString *)path;
//- (void)unzipAndDeleteFileAtDocumentPath:(NSString *)path;//解压zip.rar 文件
- (id)objectFromDocumentPath:(NSString *)path;  //dictionary
- (id)arrayFromDocumentPath:(NSString *)path;   //array
- (NSString *)documentPathFromPath:(NSString *)path;
- (void)removeItemAtDocumentPath:(NSString *)path;

@end
