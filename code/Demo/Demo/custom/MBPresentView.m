//
//  MBPresentView.m
//  BOCMBCI
//
//  Created by llbt_ych on 13-4-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
#define MBPresentViewDeleteButtonWH 40

#import "MBPresentView.h"
#import "MBConstant.h"
#import "MBCorePreprocessorMacros.h"
#import "MBUserInfo.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define kTitleLabelTag 400

@interface MBPresentView ()
{
    CGFloat _contentHeight;
    CGFloat _scrollYOffset;
    BOOL _alreadySet;
    BOOL _keyboardShowing;
}
@property (nonatomic, assign) BOOL showCloseButtonOnCardView;
@end

@implementation MBPresentView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MB_RELEASE_SAFELY(_contentView);
    MB_RELEASE_SAFELY(_contentSubviews)
}

- (id)initHeight:(CGFloat )height withDeleteButton:(BOOL)with
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeSelf)
                                                     name:MBUserDidLogoutNotification
                                                   object:nil];
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = MB_RGBA(10, 10, 10, 0.4);
        _contentView = [[MBContentView alloc] initWithView:self withDeleteButton:with];
        
        CGRect rect;
        if (with) {
            _viewType = MBPresentViewTypeLarge;
            height = kScreenHeight - 130;
            _contentView.image = [[UIImage imageNamed:@"popoverBackground.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:60];
            _contentHeight = height + MBPresentViewDeleteButtonWH/2;
            rect = CGRectMake(MBPresentViewMagin, (kScreenHeight - _contentHeight)/2, MBPresentViewContentWidth, _contentHeight);

        } else {
            _viewType = MBPresentViewTypeSmall;
            height = 190;
            _contentView.image = [UIImage imageNamed:@"smallPopoverBG.png"];
            rect = CGRectMake(10, (kScreenHeight - height) / 2, 300, height);
            _contentView.backgroundColor = [UIColor clearColor];
        
        }
        
        _contentView.frame = rect;
        
        [self addSubview:_contentView];
    }
    return self;
}

- (void)setPresentViewHeight:(CGFloat)height
{
    CGRect rect = CGRectMake(10, (kScreenHeight - height) / 2, 300, height);
    _contentView.frame = rect;
}

- (void)setShowCloseButtonOnCardView:(BOOL)show{
    _showCloseButtonOnCardView = show;
}


- (void)setTitle:(NSString *)title{
    _title = [title copy];
    _contentView.titleLabel.text = title;
}

- (void)keyboardWillShow{
    if (_keyboardShowing) {
        return;
    }
    float height =  0;
    if (_viewType == MBPresentViewTypeLarge) {
        height = (kScreenHeight - _contentView.frame.size.height) / 2 - MBPresentViewDeleteButtonWH / 2;
    } else if (_viewType == MBPresentViewTypeSmall) {
        height = _contentView.frame.origin.y - (kScreenHeight - kInputViewHeight - _contentView.frame.size.height);
    }
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.transform = CGAffineTransformMakeTranslation(0, -height);
        _keyboardShowing = YES;
    }];
}

- (void)keyboardWillHide{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.transform = CGAffineTransformMakeTranslation(0, 0);
        _keyboardShowing = NO;
    }];
}


- (void)layoutSubviews
{
    if (_alreadySet) {
        return;
    }
    _alreadySet = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeSelf)
                                                 name:MBUserDidLogoutNotification
                                               object:nil];

    for(UIView *v in _contentView.cview.subviews)
    {
        [v removeFromSuperview];
    }
    CGFloat yOffset = 0;
    for(UIView *v in _contentSubviews)
    {
        [_contentView.cview addSubview:v];
        yOffset = MAX(yOffset, v.frame.origin.y + v.frame.size.height);
    }
    [_contentView.cview setContentSize:CGSizeMake(0, yOffset)];
}

- (void)reloadView
{
    _alreadySet = NO;
    [self setNeedsLayout];
}

- (void)removeFromSuperview{
    _alreadySet = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _contentView.transform = CGAffineTransformMakeTranslation(0, 0);
    [super removeFromSuperview];
}

- (void)dismissSelf
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MBAlertViewDidHideNotification object:nil userInfo:nil];
    
    if (_dismissDelegate && [_dismissDelegate respondsToSelector:@selector(presentViewDidDismissed:)]) {
        [_dismissDelegate presentViewDidDismissed:self];
    }
    [self removeFromSuperview];
}

- (void)removeSelf
{
    [self removeFromSuperview];
}

@end


@implementation MBContentView

- (id)initWithView:(MBPresentView *)view withDeleteButton:(BOOL)with
{
    if (self = [super init]) {
        mbView = view;
        self.userInteractionEnabled = YES;
        _showCloseButton = with;
        _cview = [[UIScrollView alloc] init];
        _cview.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)layoutSubviews
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }

    [self addSubview:_cview];
        
    if (_showCloseButton) {
        _cview.frame = CGRectMake(10, 50, MBPresentViewContentWidth - 25 , self.frame.size.height - 65);

        if (mbView.titleView) {
            mbView.titleView.frame = CGRectMake(10, 18,  MBPresentViewContentWidth - 25, 30);
            mbView.titleView.backgroundColor = [UIColor clearColor];
            [self addSubview:mbView.titleView];
        } else {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, MBPresentViewContentWidth - 25, 30)];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.tag = kTitleLabelTag;
            _titleLabel.font = kSmallTitleFont;
            _titleLabel.textColor = kNormalTextColor;
            _titleLabel.text = mbView.title;
            _titleLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_titleLabel];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(MBPresentViewContentWidth - MBPresentViewDeleteButtonWH,
                                  5,
                                  MBPresentViewDeleteButtonWH, MBPresentViewDeleteButtonWH);
        [button setTag:2005];
        [button addTarget:mbView action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    } else {
        _cview.frame = CGRectMake(10, 10, 280 , self.frame.size.height - 20);
        
        if (mbView.showCloseButtonOnCardView) {
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton setBackgroundImage:[UIImage imageNamed:@"red_close.png"] forState:UIControlStateNormal];
            closeButton.frame = CGRectMake(275, 2, 24, 24);
            [closeButton addTarget:mbView action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:closeButton];
        }

    }
}

-(void)dealloc
{
    MB_RELEASE_SAFELY(_cview);
}
@end
