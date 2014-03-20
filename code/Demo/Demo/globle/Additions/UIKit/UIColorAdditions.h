//
//  UIColorAdditions.h
//  DandelionPhone
//
//  Created by Tracy E on 13-1-5.
//  Copyright (c) 2013 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef HEX
#define HEX(__color) [UIColor colorWithHEX:(__color)]

@interface UIColor (Additions)

/**
 The receiver's red component value. (read-only)
 */
@property (nonatomic, assign, readonly) CGFloat red;

/**
 The receiver's green component value. (read-only)
 */
@property (nonatomic, assign, readonly) CGFloat green;

/**
 The receiver's blue component value. (read-only)
 */
@property (nonatomic, assign, readonly) CGFloat blue;

/** 
 The receiver's alpha value. (read-only)
 */
@property (nonatomic, assign, readonly) CGFloat alpha;

/**
 Return a UIColor instance with color string like: red/#ff0000/#f00/rgb(255,0,0)/rgba(255,0,0,0)
 */
+ (UIColor *)colorWithString:(NSString *)color;

/**
 hex:#ff0000 return:UIDeviceRGBColorSpace 1 0 0 1
 */
+ (UIColor *)colorWithHEX:(NSString *)hex;

/**
 colorName:red return:UIDeviceRGBColorSpace 1 0 0 1
 */
+ (UIColor *)colorWithName:(NSString *)colorName;

/**
 rgb:rgb(255,0,0) return:UIDeviceRGBColorSpace 1 0 0 1
 */
+ (UIColor *)colorWithRGB:(NSString *)rgb;

/**
 rgba:rgba(255,0,0,0.5) return:UIDeviceRGBColorSpace 1 0 0 0.5
 */
+ (UIColor *)colorWithRGBA:(NSString *)rgba;

@end
