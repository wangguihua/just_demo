//
//  MBPresentView.h
//  BOCMBCI
//
//  Created by llbt_ych on 13-4-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#define MBPresentViewMagin 4
#define MBPresentViewContentWidth (kScreenWidth - 2 * MBPresentViewMagin)

#import <UIKit/UIKit.h>

typedef enum {
    MBPresentViewTypeLarge,
    MBPresentViewTypeSmall,
}MBPresentViewType;
//视图大小类型

@class MBContentView;
@protocol MBPresentViewDelegate;

@interface MBPresentView : UIView
@property (nonatomic, copy) NSString *title;        //弹出框标题
@property (nonatomic, strong) UIView *titleView;    //default is nil.
@property (nonatomic , readonly) MBContentView *contentView;
@property (nonatomic , strong) NSArray *contentSubviews;
@property (nonatomic , readonly) MBPresentViewType viewType;
@property (nonatomic, unsafe_unretained) id<MBPresentViewDelegate> dismissDelegate;

- (id)initHeight:(CGFloat )height withDeleteButton:(BOOL)with;
- (void)setShowCloseButtonOnCardView:(BOOL)show;
- (void)reloadView;// 在需要对视图内容进行改变时调用。  调用顺序：1、重新赋值contentSubviews ; 2、调用reloadView
- (void)setPresentViewHeight:(CGFloat)height;//设置MBPresentViewTypeSmall视图高度

@end

@protocol MBPresentViewDelegate <NSObject>
- (BOOL)presentViewDidDismissed:(MBPresentView *)view;
@end

@interface MBContentView : UIImageView
{
    __weak MBPresentView *mbView;
    BOOL _showCloseButton;
    
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong ,readonly) UIScrollView *cview;
- (id)initWithView:(MBPresentView *)view withDeleteButton:(BOOL)with;
@end
