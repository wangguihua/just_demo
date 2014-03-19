//
//  MBRegExpCheck.m
//  BOCMBCI
//
//  Created by Tracy E on 13-5-9.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBRegExpCheck.h"
#import "GXMLNode.h"
#import "MBGlobalCore.h"
#import "MBGlobalUICommon.h"
#import "RegexKitLite.h"
#import "NSStringUtils.h"

#define REGEX_PRICE @"price"
#define REGEX_SILVERPRICE @"silverPrice"
#define REGEX_FOREXPRICE @"forexPrice"
#define REGEX_CRCDSERSETPRICE @"crcdSerSet"
#define REGEX_transactionAmountSpecail @"transactionAmountSpecail"
#define REGEX_rate @"rate"
#define REGEX_riyuanRate @"riyuanRate"
#define REGEX_lsforexriyuanRate @"lsforexriyuanRate"
#define REGEX_riyunaGangyuanRate @"riyunaGangyuanRate"
#define REGEX_ATMBOOKPASSWORD @"ATMBookPassword"

//insurance 保险
#define REGEX_InsuName @"insuName"
#define REGEX_InsuAddress @"insuAddress"
#define REGEX_InvName @"inVName"
#define REGEX_MBSafetyName @"safetyName"
#define REGEX_MBSafetyidentityCard @"MBSafetyidentityCard"
#define REGEX_MBSafetyIDCard @"MBSafetyIDCard"
#define REGEX_MBSafetyAddressName @"safetyAddressName"
#define REGEX_MBSafetyPostcode @"MBSafetyPostcode"
#define REGEX_MBMBSafetyMobile @"MBSafetyMobile"
#define REGEX_MBSafetyemail @"MBSafetyemail"


@interface MBRegExpCheckItem : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL required;

+ (id)itemWithLabel:(NSString *)label value:(NSString *)value type:(NSString *)type required:(BOOL)required;

@end


@implementation MBRegExpCheckItem

+ (id)itemWithLabel:(NSString *)label value:(NSString *)value type:(NSString *)type required:(BOOL)required{
    return [[MBRegExpCheckItem alloc] initWithLabel:label value:value type:type required:required];
}

- (id)initWithLabel:(NSString *)label value:(NSString *)value type:(NSString *)type required:(BOOL)required{
    self = [super init];
    if (self) {
        self.label = label;
        self.value = value;
        self.type = type;
        self.required = required;
        }
    return self;
}


@end


#pragma mark - RegExpCheck
static GXMLDocument *__regExpDocument = nil;
static GXMLDocument *regExpDocument() {
    if (__regExpDocument == NULL) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"RegExpList" ofType:@"xml"];
        NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        __regExpDocument = [[GXMLDocument alloc] initWithXMLString:string options:0 error:nil];
    }
    return __regExpDocument;
}

MBRegExpCheckItem *RegExpItem(NSString *label, NSString *value, NSString *type, BOOL required){
    return [MBRegExpCheckItem itemWithLabel:label value:value type:type required:required];
}

BOOL RegExpCheck(NSArray *checkList){
    return RegExpCheckWithDelegate(checkList, nil);
}

BOOL RegExpCheckWithDelegate(NSArray *checkList, id delegate){
    BOOL result = YES;
    for (MBRegExpCheckItem *item in checkList) {
        NSString *type = item.type;
        NSError *error = nil;
        NSArray *rules = [regExpDocument() nodesForXPath:[NSString stringWithFormat:@"/rules/rule[@type='%@']",type] error:&error];
        if (![rules count] || error) {
            NSLog(@"正则校验类型不存在! %s %d  %@",__FUNCTION__,__LINE__,type);
            return NO;
        }
        GXMLElement *rule = rules[0];
        NSString *pattern = [rule getAttribute:@"pattern"];
        NSString *tip = [rule getAttribute:@"tip"];
        if (item.required) {
            if (!MBIsStringWithAnyText([item.value formatWhiteSpace])) {
                result = NO;
                MBAlertWithDelegate([NSString stringWithFormat:@"请输入%@",item.label], delegate);
                break;
            } else if (![item.value isMatchedByRegex:pattern]) {
                NSLog(@"pattern:%@  value:%@",pattern,item.value);
                result = NO;
                
                if ([type isEqualToString:REGEX_PRICE] ||
                    [type isEqualToString:REGEX_CRCDSERSETPRICE] ||
                    [type isEqualToString:REGEX_transactionAmountSpecail] ||
                    [type isEqualToString:REGEX_rate] ||
                    [type isEqualToString:REGEX_riyuanRate] ||
                    [type isEqualToString:REGEX_lsforexriyuanRate] ||
                    [type isEqualToString:REGEX_riyunaGangyuanRate] ||
                    [type isEqualToString:REGEX_FOREXPRICE] ||
                    [type isEqualToString:REGEX_ATMBOOKPASSWORD]||
                    [type isEqualToString:REGEX_SILVERPRICE] ||
                    [type isEqualToString:REGEX_InsuName] ||
                    [type isEqualToString:REGEX_InsuAddress] ||
                    [type isEqualToString:REGEX_InvName] ||
                    [type isEqualToString:REGEX_MBSafetyName]||
                    [type isEqualToString:REGEX_MBSafetyidentityCard]||
                    [type isEqualToString:REGEX_MBSafetyIDCard]||
                    [type isEqualToString:REGEX_MBSafetyAddressName]||
                    [type isEqualToString:REGEX_MBSafetyPostcode]||
                    [type isEqualToString:REGEX_MBMBSafetyMobile]||
                    [type isEqualToString:REGEX_MBSafetyemail ]
                    ){
                    MBAlertWithDelegate([NSString stringWithFormat:@"%@%@", item.label, tip], delegate);
                }else{
                    MBAlertWithDelegate(tip, delegate);
                }
                
                break;
            }
        } else if(MBIsStringWithAnyText(item.value) && ![item.value isMatchedByRegex:pattern]) {
            NSLog(@"pattern:%@  value:%@",pattern,item.value);
            result = NO;
            
            if ([type isEqualToString:REGEX_PRICE] ||
                [type isEqualToString:REGEX_CRCDSERSETPRICE] ||
                [type isEqualToString:REGEX_transactionAmountSpecail] ||
                [type isEqualToString:REGEX_rate] ||
                [type isEqualToString:REGEX_riyuanRate] ||
                [type isEqualToString:REGEX_riyunaGangyuanRate] ||
                [type isEqualToString:REGEX_FOREXPRICE] ||
                [type isEqualToString:REGEX_ATMBOOKPASSWORD]){
                MBAlertWithDelegate([NSString stringWithFormat:@"%@%@", item.label, tip], delegate);
            }else{
                MBAlertWithDelegate(tip, delegate);
            }
            
            break;
        }
    }
    return result;
}

