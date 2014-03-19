//
//  MBTimerButton.m
//  BOCMBCI
//
//  Created by Tracy E on 13-4-11.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBTimerButton.h"
#import "MBConstant.h"

@interface MBTimerButton (){
    __weak NSTimer *_timer;
    NSInteger _counter;
    NSString *_title;
}


@end

@implementation MBTimerButton

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}


- (id)init{
    self = [super init];
    if (self) {
        _timeInterval = 60;
        [self setBackgroundImage:[[UIImage imageNamed:@"timerButton.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateNormal];
        [self setTitleColor:kNormalTextColor forState:UIControlStateNormal];
        [self.titleLabel setFont:kNormalTextFont];
    }
    return self;
}

+ (id)buttonWithType:(UIButtonType)buttonType{
    return [[MBTimerButton alloc] init];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [super addTarget:target action:action forControlEvents:controlEvents];
    [super addTarget:self action:@selector(_timerButtonPressed) forControlEvents:controlEvents];
}

- (void)_timerButtonPressed{
    [self setEnabled:NO];
    [self setTitleColor:kTipTextColor forState:UIControlStateNormal];
    _counter = _timeInterval;
    _title = [self.titleLabel text];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerCountDown)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

}

- (void)removeFromSuperview{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)timerCountDown{
    _counter--;
    [self setTitle:[NSString stringWithFormat:@"%d",_counter] forState:UIControlStateNormal];
    if (_counter <= 0) {
        [self setTitle:_title forState:UIControlStateNormal];
        [self setTitleColor:kNormalTextColor forState:UIControlStateNormal];
        [self setEnabled:YES];
        [_timer invalidate];
        _timer = nil;
    }
}

@end
