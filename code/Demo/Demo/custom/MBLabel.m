//
//  MBLabel.m
//  BOCMBCI
//
//  Created by Tracy E on 13-4-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBLabel.h"
#import "CMPopTipView.h"
#import "UIViewAdditions.h"
#import "MBConstant.h"
#import <objc/runtime.h>

#define MBLabelTipWillShowNotification @"MBLabelTipWillShowNotification"

@interface MBLabel ()<CMPopTipViewDelegate,UIScrollViewDelegate, UITableViewDelegate>{
    CMPopTipView *_tipView;
    UITapGestureRecognizer *_tapGesturer;
    NSTimer *_paoMDTimer;//跑马灯timer
}

@property (nonatomic, strong) UILabel *paoMaDengLabel;

@end

@implementation MBLabel

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MBLabelTipWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MBUserDidLogoutNotification
                                                  object:nil];
    [self removeLabel];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setShowFullTextIfNeeded];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self setShowFullTextIfNeeded];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setShowFullTextIfNeeded];
}

- (void)removeLabel
{
    self.userInteractionEnabled = NO;
    [self removeGestureRecognizer:_tapGesturer];
    
    if (_isPaoMaDeng) {
        if (_paoMaDengLabel) {
            self.textColor = _paoMaDengLabel.textColor;
            [_paoMaDengLabel removeFromSuperview];
            _paoMaDengLabel = nil;
        }
        
        if (_paoMDTimer) {
            [_paoMDTimer invalidate];
            _paoMaDengLabel = nil;
        }
    }
}

- (void)setShowFullTextIfNeeded{
    [self removeLabel];
    
    BOOL longer = NO;
    float fullWidth = [self.text sizeWithFont:self.font].width;
    NSInteger numberOfLines = self.numberOfLines;
    if (numberOfLines!= 1) {
        CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, self.frame.size.height*300)];
        if (size.height > self.frame.size.height) {
            longer = YES;
        }
    }
    else{
        if (fullWidth > self.frame.size.width) {
            longer = YES;
        }
    }
    if (longer) {
        
        if (_isPaoMaDeng) {//跑马灯
            _paoMaDengLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fullWidth, self.frame.size.height)];
            _paoMaDengLabel.text = self.text;
            _paoMaDengLabel.font = self.font;
            _paoMaDengLabel.textColor = self.textColor;
            _paoMaDengLabel.backgroundColor = [UIColor clearColor];
            _paoMaDengLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_paoMaDengLabel];
            
            self.textColor = [UIColor clearColor];
            
            _paoMDTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.5] interval:0.1 target:self selector:@selector(beginPaoMaDengAnimation) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_paoMDTimer forMode:NSRunLoopCommonModes];
            [_paoMDTimer fire];
            
        }else{//气泡提示
            self.userInteractionEnabled = YES;
            _tapGesturer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullText)];
            [self addGestureRecognizer:_tapGesturer];
        }
    }
}

- (void)setIsPaoMaDeng:(BOOL)isPaoMaDeng{
    
    _isPaoMaDeng = isPaoMaDeng;
    
    [self setShowFullTextIfNeeded];
}

- (void)beginPaoMaDengAnimation
{
    if (abs(_paoMaDengLabel.frame.origin.x) < _paoMaDengLabel.frame.size.width) {
        _paoMaDengLabel.frame = CGRectOffset(_paoMaDengLabel.frame, -1, 0);
    }else{
        _paoMaDengLabel.frame = CGRectMake(self.frame.size.width, 0, _paoMaDengLabel.frame.size.width, _paoMaDengLabel.frame.size.height);
    }
}

- (void)hideTipIfNeeded{
    if (_tipView) {
        [_tipView dismissAnimated:YES];
        _tipView = nil;
    }
}

- (void)showFullText{
    if (!_tipView) {
 
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MBLabelTipWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hideTipIfNeeded)
                                                     name:MBLabelTipWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MBLabelTipWillShowNotification object:nil];
        
       
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hideTipIfNeeded)
                                                     name:MBUserDidLogoutNotification
                                                   object:nil];

        _tipView = [[CMPopTipView alloc] initWithMessage:self.text];
        _tipView.dismissTapAnywhere = YES;
        _tipView.delegate = self;
        _tipView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8];
        _tipView.borderColor = [UIColor clearColor];
        _tipView.textColor = [UIColor whiteColor];
        [_tipView presentPointingAtView:self inView:self.window animated:YES];
    } else {
        [_tipView dismissAnimated:YES];
        _tipView = nil;
    }
}


#pragma mark CMPopTipView Delegate Method
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView{
    _tipView = nil;
}


@end
