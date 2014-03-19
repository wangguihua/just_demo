//
//  MBSignImageView.h
//  BOCMBCI
//
//  Created by llbt_ych on 13-4-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
//
/*
 账户类型
 */
#define CardTypeNomal @"101"                 //普通活期
#define CardTypeBCCred @"103"                //中银信用卡
#define CardTypeGtwCred @"104"               //长城信用卡
#define CardTypeElectronCard @"119"          //长城电子借记卡
#define CardTypeForeignCard @"107"           //单外币信用卡
#define CardTypeVirtualDCard @"108"          //虚拟卡(贷记)
#define CardTypeVirtualZCard @"109"          //虚拟卡(准贷记)
#define CardTypeSaveCard @"140"              //存本取息
#define CardTypeFullCard @"150"              //零存整取
#define CardTypeEduCard @"152"               //教育储蓄
#define CardTypeOneDCard @"170"              //定期一本通
#define CardTypeOneHcard @"188"              //活期一本通
#define CardTypeExclusiveCard @"190"         //网上专属理财账户   
#define CardTypeCrashCard @"300"             //电子现金账户

#import <UIKit/UIKit.h>

//图片显示位置
typedef enum{
    SignImagePositionTop = 0,
    SignImagePositionCenter,
    SignImagePositionBottom
}SignImagePosition;

@interface MBSignImageView : UIView
- (id)initWithFrame:(CGRect)frame imagePosition:(SignImagePosition)imagePostion;

@property (nonatomic , assign) CGRect rect;
@property (nonatomic , assign) SignImagePosition position;
@property (nonatomic , assign) BOOL defaultCard;                //是否是默认账户
@property (nonatomic , strong) NSArray *openedFunctionArray;         //已开通功能数组   (前提是不同的卡类型开通功能代号是相同的，且需要显示的图片是一样的)

@property (nonatomic , strong) NSString *cardType;  // 预留一个卡类型
@end
