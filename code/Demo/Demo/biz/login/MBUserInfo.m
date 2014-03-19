//
//  MBOprLoginInfo.m
//  BOCMBCI
//
//  Created by llbt_ych on 13-5-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBUserInfo.h"
#import "MBIIRequest.h"
#import "MBGlobalCore.h"
#import "MBConstant.h"

#import "MBCommon.h"
#import "NSString+MD5Addition.h"
#import "UIDevice+IdentifierAddition.h"

@interface MBUserInfo ()
@property (nonatomic,strong) NSMutableDictionary *userInfoDictionary;
@end


@implementation MBUserInfo


+(id)shareUserInfo
{
    static MBUserInfo *__userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __userInfo = [[MBUserInfo alloc] init];
    });
    return __userInfo;
}

-(id)init
{
    if (self = [super init]) {
        self.menuIndex = 0;
    }
    return self;
}

- (void)setUserInfo:(NSMutableDictionary *)dict
{
    if(self.userInfoDictionary == nil)
    {
        self.userInfoDictionary = dict;
    }
    else
    {
        [self.userInfoDictionary addEntriesFromDictionary:dict];
    }
}

- (void)getUserInfo
{
    MBUserInfo *userInfo = self;
    MBRequestItem *item = [MBRequestItem itemWithMethod:[PsnCommonQueryOprLoginInfo method] params:nil];
    [MBIIRequest requestWithItems:@[item] info:[NSDictionary dictionaryWithObject:@"no" forKey:MBRequest_CanCancelRequest]
                          success:^(id JSON) {
                              if (JSON[0] && [JSON[0][@"status"] isEqualToString:@"01"])
                              {
                                  [userInfo setUserInfo:JSON[0][@"result"]];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:MBUserDidLoginNotification object:JSON[0][@"result"]];
                                  
                                  NSLog(@"用户的手机号码是：%@",JSON[0][@"result"][@"cifNumber"]);
                                  //消息服务记录一下用户的手机号
                                  [[NSUserDefaults standardUserDefaults] setObject:JSON[0][@"result"][@"cifNumber"] forKey:@"cifNum"];
            
                              }
                          }
                          failure:^(NSError *error, id JSON) {
                              
                          }];
}


- (void)clearUserInfo{
    self.userInfoDictionary = nil;
}

- (BOOL)isLoginState{
    NSString *loginState = [_userInfoDictionary[@"loginStatus"] stringValue];
    if ([loginState isEqualToString:@"0"]) {        //0: login
        return YES;
    }
    return NO;
}

- (NSDictionary *)userInfo
{
    return _userInfoDictionary;
}

- (NSString *)valueForUserInfoKey:(NSString *)key{
    if (MBIsStringWithAnyText(key)) {
        return [_userInfoDictionary valueForKey:key];
    }
    return nil;
}

- (void)setValue:(id)value forUserInfoKey:(NSString *)key
{
    if (MBIsStringWithAnyText(value) && MBIsStringWithAnyText(key)) {
        if(_userInfoDictionary == nil){
            self.userInfoDictionary = [NSMutableDictionary dictionary];
        }
        [_userInfoDictionary setObject:value forKey:key];
    }
}

@end
