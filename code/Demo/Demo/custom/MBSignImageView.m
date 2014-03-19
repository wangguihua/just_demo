//
//  MBSignImageView.m
//  BOCMBCI
//
//  Created by llbt_ych on 13-4-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#define SignImageWidth 20
#define SignImageHeight 20
#define SignImageMargin 5

//各显示标志的图片名称
#define SignImagelStar @""     //默认账户图片

#define SignImageRegular @""

#define SignImageCard @""

#define SignImageTrend @""

#define SignImageGold @""

#define SignImageDollar @""

#define SignImageSave @""

#import "MBSignImageView.h"
#import "MBConstant.h"


@interface MBSignImageView ()
- (NSDictionary *)functionListDictionary;
- (NSDictionary *)functionImageDictionary;
@end

@implementation MBSignImageView

//对应不同的卡能够开通的功能
//基金、外汇、投资理财、储蓄
/*
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
 */

//不同类型的卡对应的能够开通的功能数组
- (NSDictionary *)functionListDictionary
{
    return @{
             CardTypeNomal              : @[],
             CardTypeBCCred             : @[],
             CardTypeGtwCred            : @[],
             CardTypeElectronCard       : @[],
             CardTypeForeignCard        : @[],
             CardTypeVirtualDCard       : @[],
             CardTypeVirtualZCard       : @[],
             CardTypeSaveCard           : @[],
             CardTypeFullCard           : @[],
             CardTypeEduCard            : @[],
             CardTypeOneDCard           : @[],
             CardTypeOneHcard           : @[],
             CardTypeExclusiveCard      : @[],
             CardTypeCrashCard          : @[],
             };
}

//每一个功能对应的图片的名字
- (NSDictionary *)functionImageDictionary
{
    return @{
             @"test" : @"btn_red_big.png",
             @"test1" : @"butten_blue.png",
             };
}

- (id)init
{
    if (self = [super init]) {
        //init初始化方法给一个frame
        self.frame = CGRectMake(0, 0, 1, 1);//因为在Frame宽、高为零时，不会调用layoutSubviews方法
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imagePosition:(SignImagePosition)imagePostion
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blueColor];
        _rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MAX(frame.size.height, SignImageHeight));
        _position = imagePostion;
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.frame = _rect;
    
    CGFloat originX = 5;
    CGFloat originY;
    switch (_position)
    {
        case SignImagePositionTop:
            originY = 0;
            break;
        case SignImagePositionCenter:
            originY = (_rect.size.height - SignImageHeight)/2;
            break;
        case SignImagePositionBottom:
            originY = _rect.size.height - SignImageHeight;
            break;
        default:
            break;
    }
    
    if(_defaultCard)
    {
        [self addSubview:[self imageViewFrame:CGRectMake(originX, originY, SignImageWidth, SignImageHeight) name:SignImagelStar]];
        originX += (SignImageMargin + SignImageWidth) + 10;
    }
    for (int i = 0; i<_openedFunctionArray.count; i++) {
        [self addSubview:[self imageViewFrame:CGRectMake(originX, originY, SignImageWidth, SignImageHeight) name:[self functionImageDictionary][_openedFunctionArray[i]]]];
        originX += (SignImageMargin + SignImageWidth);
    }
}

- (UIImageView *)imageViewFrame:(CGRect)frame name:(NSString *)name
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:[UIImage imageNamed:name]];
    return imageView;
}

- (void)dealloc
{
    MB_RELEASE_SAFELY(_cardType);
    MB_RELEASE_SAFELY(_openedFunctionArray);
}
@end
