//
//  NSNull+Additions.m
//  BOCMBCI
//
//  Created by Tracy E on 13-5-14.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "NSNullAdditions.h"

@implementation NSNull (Additions)

- (NSString *)stringValue{
    return @"-";
}

- (NSString *)format4n4{
    return @"-";
}

- (NSString *)formatMonery{
    return @"-";
}

- (NSString *)formatMoneyWithCurrency:(NSString *)currency
{
    return @"-";
}
-(NSString *)formatAnyDecimal{
    return @"-";
}



- (BOOL)isEqualToString:(NSString *)string{
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

@end
