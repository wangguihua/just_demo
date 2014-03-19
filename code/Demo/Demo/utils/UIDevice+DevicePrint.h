//
//  MBConstant.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice (DevicePrint)

//use: [[UIDevice currentDevice] devicePrint];
@property(nonatomic,readonly,retain) NSString    *devicePrint;  //设备指纹

/*
 * 更新位置
 */
- (void)updateLocation;

/**
 * 设备信息用来区别终端特性，建议格式：“厂商名,产品名,型号”;
 * 如果是基于浏览器的RIA应用，则填写浏览器信息，建议格式：“厂商名,产品名,版本号”
 */
- (NSString *)requestHeaderDevice;

/** 
 * 操作系统信息,建议格式：“厂商名,产品名,版本号” 
 */
- (NSString *)requestHeaderPlatform;


/**
 * 版本号
 */
- (NSString *)requestHeaderVersion;

@end


