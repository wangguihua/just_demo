//
//  MBInputAccessoryView.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-29.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBAccessoryView.h"
#import "MBConstant.h"

@interface MBAccessoryView ()
{
    UILabel *_titleLabel;
}
@property (nonatomic, unsafe_unretained) id<MBAccessoryViewDelegate> accessoryDelegate;
@end

@implementation MBAccessoryView

- (void)dealloc
{
    MB_RELEASE_SAFELY(_titleLabel);
}

- (id)initWithDelegate:(id<MBAccessoryViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        // Initialization code
        self.accessoryDelegate = delegate;
        self.frame = CGRectMake(0, 0, kScreenWidth, kToolBarHeight);
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(inputCancel)];
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,200,kToolBarHeight}];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:kNormalTextFont];
        [_titleLabel setTextColor:kWhiteTextColor];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithCustomView:_titleLabel];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(inputDone)];
        
        self.items = @[cancelButton, flexibleSpace, doneButton];
        self.barStyle = UIBarStyleBlack;
        self.translucent = YES;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if (MBIsStringWithAnyText(title)) {
        [_titleLabel setText:title];
    }
}

- (void)inputCancel{
    if (_accessoryDelegate && [_accessoryDelegate respondsToSelector:@selector(accessoryViewDidPressedCancelButton:)]) {
        [_accessoryDelegate accessoryViewDidPressedCancelButton:self];
    }
}

- (void)inputDone{
    if (_accessoryDelegate && [_accessoryDelegate respondsToSelector:@selector(accessoryViewDidPressedDoneButton:)]) {
        [_accessoryDelegate accessoryViewDidPressedDoneButton:self];
    }
}


@end
