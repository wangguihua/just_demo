//
//  MBCorePreprocessorMacros.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBLog.h"

//--------------------------------------------------------------------------------------------------
// Global compile
#define __MB_UAT__                  (0)  //是否是UAT环境
#define __MB_DEBUG__                (0)  //是否为debug模式
#define __MB_LOG__                  (0)  //是否打开log
#define __MB_SAVE_LOG__             (0)  //是否将log保存到文件/Documents/log/
#define __MB_ENABLE_THIRDPARTY__    (1)  //是否加载第三方程序
#define __MB_PRODUCT__              (1)  //是否是生产环境，为1时需要将 __MB_DEBUG__ 置为0、__MB_ENABLE_THIRDPARTY__ 置为1

#define MB_RELEASE_SAFELY(__POINTER) {  __POINTER = nil; }
#define MB_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

#define MBAppBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//--------------------------------------------------------------------------------------------------
//rgb颜色
#define MB_RGB(__r, __g, __b) [UIColor colorWithRed:(__r / 255.0) green:(__g / 255.0) blue:(__b / 255.0) alpha:1]
#define MB_RGBA(__r, __g, __b, __a) [UIColor colorWithRed:(__r / 255.0) green:(__g / 255.0) blue:(__b / 255.0) alpha:__a]

//--------------------------------------------------------------------------------------------------
//生成静态属性
#undef MB_STATIC_PROPERTY
#define MB_GET_PROPERTY( __name) \
    @property (nonatomic, strong, readonly) NSString* __name; \
    + (NSString *)__name;

#undef MB_SET_PROPERTY
#define MB_SET_PROPERTY( __name, __value) \
    @dynamic __name; \
    + (NSString *)__name \
    { \
        return __value; \
    }


//--------------------------------------------------------------------------------------------------
//申明为单例
#undef	MB_AS_SINGLETON
#define MB_AS_SINGLETON( __class ) \
    + (__class *)sharedInstance;

#undef	MB_DEF_SINGLETON
#define MB_DEF_SINGLETON( __class ) \
    + (__class *)sharedInstance \
    { \
        static dispatch_once_t once; \
        static __class * __singleton__; \
        dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
        return __singleton__; \
}

//--------------------------------------------------------------------------------------------------
//6.0一下兼容6.0枚举类型，避免版本导致的警告
#define UILineBreakMode                 NSLineBreakMode
#define UILineBreakModeWordWrap			NSLineBreakByWordWrapping
#define UILineBreakModeCharacterWrap	NSLineBreakByCharWrapping
#define UILineBreakModeClip				NSLineBreakByClipping
#define UILineBreakModeHeadTruncation	NSLineBreakByTruncatingHead
#define UILineBreakModeTailTruncation	NSLineBreakByTruncatingTail
#define UILineBreakModeMiddleTruncation	NSLineBreakByTruncatingMiddle

#define UITextAlignment                 NSTextAlignment
#define UITextAlignmentLeft				NSTextAlignmentLeft
#define UITextAlignmentCenter			NSTextAlignmentCenter
#define UITextAlignmentRight			NSTextAlignmentRight

//--------------------------------------------------------------------------------------------------
//4.3的情况下兼容5.0的ARC关键字
#if (!__has_feature(objc_arc)) || \
(defined __IPHONE_OS_VERSION_MIN_REQUIRED && \
__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0) || \
(defined __MAC_OS_X_VERSION_MIN_REQUIRED && \
__MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_7)
#undef weak
#define weak unsafe_unretained
#undef __weak
#define __weak __unsafe_unretained
#endif

//--------------------------------------------------------------------------------------------------
//performSelector方法在ARC模式下会有警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#pragma clang diagnostic pop
