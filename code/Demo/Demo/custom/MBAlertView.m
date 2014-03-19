//
//  MYAlertView.m
//  mytestalert
//
//  Created by llbt_ych on 13-4-25.
//  Copyright (c) 2013年 llbt_ych. All rights reserved.
//

#define kDoneButtonImage [[UIImage imageNamed:@"btn_red_small.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0]
#define kCancelButtonImage [[UIImage imageNamed:@"btn_blue_small.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0]

#import "MBAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "MBConstant.h"
#import "MBGlobalCore.h"

static NSString *__message = nil;

@implementation MBAlertView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.frame.size.width == 0 || self.frame.size.height == 0) { return;}
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    

    
    for (UIView *v in [self subviews]) {
        if ([v isKindOfClass:[UIImageView class]]){
            [v setHidden:YES];
        }
        else if ([v isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)v;
            if ([label.text isEqualToString:self.message]) {
                [label setNumberOfLines:0];
                label.font = kNormalTextFont;
                label.textColor = kNormalTextColor;
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setTextColor:[UIColor blackColor]];
                [label setShadowOffset:CGSizeZero];
            } else if([label.text isEqualToString:self.title]) {
                label.font = kSmallTitleFont;
                label.textColor = kNormalTextColor;
                [label setShadowOffset:CGSizeZero];
            }
        }
        else if ([v isKindOfClass:[UIButton class]]) {
            CGRect buttonRect = v.frame;
            buttonRect.size.height = 35;
            [[(UIButton *)v titleLabel] setFont:kSmallButtonTitleFont];
            if (self.numberOfButtons == 1) {
                buttonRect.origin.x += (buttonRect.size.width - 127) / 2;
                buttonRect.size.width = 127;
                [(UIButton *)v setBackgroundImage:kDoneButtonImage forState:UIControlStateNormal];
                [(UIButton *)v setBackgroundImage:kDoneButtonImage forState:UIControlStateHighlighted];   
            } else {
                if (v.tag == 1) {
                    [(UIButton *)v setBackgroundImage:kCancelButtonImage forState:UIControlStateNormal];
                    [(UIButton *)v setBackgroundImage:kCancelButtonImage forState:UIControlStateHighlighted];
                } else {
                    [(UIButton *)v setBackgroundImage:kDoneButtonImage forState:UIControlStateNormal];
                    [(UIButton *)v setBackgroundImage:kDoneButtonImage forState:UIControlStateHighlighted];
                }
             }
            [(UIButton *)v setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
            v.frame = buttonRect;
        }
        else if ([v isKindOfClass:NSClassFromString(@"UIThreePartButton")]){//5.0以下调用
            CGRect buttonRect = v.frame;
            buttonRect.size.height = 35;
            [v removeFromSuperview];
            
            UIButton* vi = [UIButton buttonWithType:UIButtonTypeCustom];
            [vi addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            vi.tag = v.tag;
            [[vi titleLabel] setFont:kSmallButtonTitleFont];
            if (self.numberOfButtons == 1) {
                buttonRect.origin.x += (buttonRect.size.width - 127) / 2;
                buttonRect.size.width = 127;
                [vi setTitle:[self buttonTitleAtIndex:0] forState:UIControlStateNormal];
                [vi setBackgroundImage:kDoneButtonImage forState:UIControlStateNormal];
                [vi setBackgroundImage:kDoneButtonImage forState:UIControlStateHighlighted];
            } else {
                if (vi.tag == 1) {
                    [vi setTitle:[self buttonTitleAtIndex:0] forState:UIControlStateNormal];
                    [vi setBackgroundImage:kCancelButtonImage forState:UIControlStateNormal];
                    [vi setBackgroundImage:kCancelButtonImage forState:UIControlStateHighlighted];
                } else {
                    [vi setTitle:[self buttonTitleAtIndex:1] forState:UIControlStateNormal];
                    [vi setBackgroundImage:kDoneButtonImage forState:UIControlStateNormal];
                    [vi setBackgroundImage:kDoneButtonImage forState:UIControlStateHighlighted];
                }
            }
            [vi setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
            vi.frame = buttonRect;
            [self addSubview:vi];
        }
    }    
}

- (void)buttonPressed:(UIButton *)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:sender.tag-1];
    }
}

- (void)show{
    NSLog(@"title:%@", self.title);
    NSLog(@"message:%@",self.message);
    
//    if (MBIsStringWithAnyText(self.title) && MBIsStringWithAnyText(self.message)) {
//        self.title = @"   ";
//    }
//    else if(!MBIsStringWithAnyText(self.message)) {
//        self.message = self.title;
//        self.title = @"   ";
//    }
    
    NSLog(@"%@----%@",__message,self.message);
    if ([__message isEqualToString:self.message]) { return; }
    __message = self.message;
    
    [super show];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_dismiss)
                                                 name:MBUserDidLogoutNotification
                                               object:nil];
}


- (void)_dismiss{
    __message = nil;
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}

- (void)dealloc{
    __message = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MBUserDidLogoutNotification object:nil];
}

@end
