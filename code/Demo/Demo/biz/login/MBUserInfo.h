//
//  MBOprLoginInfo.h
//  BOCMBCI
//
//  Created by llbt_ych on 13-5-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

//保存用户信息
//在调用修改接口之后，应该将对应项同步更改

#import <Foundation/Foundation.h>

@interface MBUserInfo : NSObject

@property (nonatomic, unsafe_unretained) NSInteger menuIndex;

+ (id)shareUserInfo;
- (void)setUserInfo:(NSMutableDictionary *)dict;
- (void)getUserInfo;                    //发通信获取用户信息
- (void)clearUserInfo;                  //清除用户信息

- (BOOL)isLoginState;                   //是否为登录状态
- (NSDictionary *)userInfo;             //登录用户信息用户信息
- (NSString *)valueForUserInfoKey:(NSString *)key;
- (void)setValue:(id)value forUserInfoKey:(NSString *)key;
@end
