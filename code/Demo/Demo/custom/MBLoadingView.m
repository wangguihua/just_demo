//
//  MBLoadingView.m
//  BOCMBCI
//
//  Created by Tracy E on 13-5-28.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBLoadingView.h"
#import "MBConstant.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation MBLoadingView {
    UIButton *cancelButton;
}

- (void)dealloc{
    self.requestOperation = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
}

- (id)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _canCancel = YES;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 80)];
        backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        backgroundView.layer.cornerRadius = 3.0;
        backgroundView.center = self.center;
        [self addSubview:backgroundView];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.frame = CGRectMake(30, 30, _activityIndicatorView.frame.size.width,
                                                  _activityIndicatorView.frame.size.height);
        [backgroundView addSubview:_activityIndicatorView];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 40)];
        tipLabel.text = NSLocalizedStringFromTable(@"appRequestTip", @"tips", @"");
        tipLabel.textColor = kNormalTextColor;
        tipLabel.font = kNormalTextFont;
        tipLabel.backgroundColor = [UIColor clearColor];
        [backgroundView addSubview:tipLabel];
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(backgroundView.frame.origin.x + backgroundView.frame.size.width - 25,
                                        backgroundView.frame.origin.y -21, 44, 44);
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.hidden = YES;
        [self addSubview:cancelButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hideLoading)
                                                     name:MBUserDidLogoutNotification
                                                   object:nil];
    }
    return self;
}

- (void)hideLoading{
    [_requestOperation cancel];
    [self hide];
}

- (void)setCanCancel:(BOOL)can{
    _canCancel = can;
    cancelButton.hidden = !_canCancel;
}

- (void)cancel{
    [_requestOperation cancel];
    [self hide];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MBLoadingViewDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MBFGDSingNotification object:nil];
}


- (void)show{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
        for (UIView *v in window.subviews) {
            if ([v isKindOfClass:[MBLoadingView class]]) {
                [v removeFromSuperview];
            }
        }
        [_activityIndicatorView startAnimating];
        [window addSubview:self];
    });
}

- (void)hide{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_activityIndicatorView stopAnimating];
        [self removeFromSuperview];
    });
}

@end
