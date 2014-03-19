//
//  NSString+Utils.m
//  BOCMBCI
//
//  Created by Tracy E on 13-4-12.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "NSStringUtils.h"
#import "MBGlobalCore.h"
#import "MBConstant.h"

@implementation NSString (Utils)

+ (NSString *)stringWithString:(NSString *)string times:(NSInteger)times{
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < times; i++) {
        [result appendString:string];
    }
    return result;
}

- (NSString *)replace:(NSString *)o with:(NSString *)n{
    return [self stringByReplacingOccurrencesOfString:o withString:n];
}

- (NSString *)format4n4{
    NSInteger len = self.length;
    if (len < 8) {
        return self;
    }
    NSRange range = NSMakeRange(4, len - 8);
    NSString *points = [NSString stringWithString:@"*" times:6];
    return [self stringByReplacingCharactersInRange:range withString:points];
}

- (NSString *)mobileFormat
{
    NSInteger len = self.length;
    if (len <= 7) {
        return self;
    }
    NSRange range = NSMakeRange(3, len - 7);
    NSString *points = [NSString stringWithString:@"*" times:4];
    return [self stringByReplacingCharactersInRange:range withString:points];
}

- (NSString *)phoneNumberTrim{
    return [[[[[self replace:@"-" with:@""] replace:@"+86" with:@""] replace:@"(" with:@""] replace:@")" with:@""] replace:@" " with:@""];
}

- (NSString *)formatMonery{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setNegativeFormat:@""];
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:[self replace:@"," with:@""]];
    return [formatter stringFromNumber:number];
}


- (NSString *)formatMonerySpecial{
    return [[self formatMonery] componentsSeparatedByString:@"."][0];
}

- (NSString *)formatMoneryThreeDecimal
{
    NSString * value = [NSString stringWithFormat:@"%.3f",
                        [[self replace:@"," with:@""] doubleValue]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setCurrencySymbol:@""];
    
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:[value componentsSeparatedByString:@"."][0]];
    return [NSString stringWithFormat:@"%@.%@",
            [formatter stringFromNumber:number],
            [value componentsSeparatedByString:@"."][1]];
}

-(NSString *)formatBalance{
    return [[[self formatMonery] replace:@"," with:@""] substringToIndex:[[self formatMonery] replace:@"," with:@""].length-1];
}

- (NSString *)correctUserInput
{
    NSString *result = self;
    if (result.length > 0)
    {
        if ([result hasPrefix:@"."])
        {
            result = [NSString stringWithFormat:@"0%@",result];
        }
    }
    return result;
}
-(NSString *)formatAnyDecimal{
    if ([[self componentsSeparatedByString:@"."] count]==1) {
        return [[self formatMonery] componentsSeparatedByString:@"."][0];
    }
    NSString *str=[self componentsSeparatedByString:@"."][1];
    NSString *value=[[self formatMonery] componentsSeparatedByString:@"."][0];
    if (!value) {
        return [NSString stringWithFormat:@"0.%@",str];
    }
    return [NSString stringWithFormat:@"%@.%@",value,str];
}



- (NSString *)formatWhiteSpace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)formatWhiteSpaceAndNewLineCharacterSet
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
