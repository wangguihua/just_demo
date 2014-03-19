//
//  UIViewAdditionsm
//  DandelionPhone
//
//  Created by Tracy E on 12-11-30.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import "UIViewAdditions.h"
#import <QuartzCore/QuartzCore.h>
#import "MBConstant.h"

@implementation UIView (Additions)

- (void)willMoveToSuperview:(UIView *)newSuperview{
    self.exclusiveTouch = YES;
    self.multipleTouchEnabled = NO;
}

/////////////////////////////////////// ////////////////////////////////////////////////////////////
- (CGFloat)x {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)y {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage *)imageRepresentation{
    UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
//    while (self.subviews.count) {
//        UIView* child = self.subviews.lastObject;
//        [child removeFromSuperview];
//    }
    
    for (UIView *child in self.subviews) {
        [child  removeFromSuperview];
    }
}

- (void)presentView:(MBPresentView *)view
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MBAlertViewDidShowNotification object:nil userInfo:nil];
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [view.contentView.layer addAnimation:animation forKey:nil];

}

- (void)dismissView:(UIView *)view
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MBAlertViewDidHideNotification object:nil userInfo:nil];
    [view removeFromSuperview];
}


+ (void)swipeAnimationWithView:(UIView *)view tip:(NSString *)tipString done:(void (^)(BOOL finished))done{
    CGRect rect = view.frame;
    rect.size.width = 320;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0 - (rect.origin.x + rect.size.width), 0, rect.size.width, rect.size.height)];
    imageView.image = [[UIImage imageNamed:@"card_scroll_right.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:20];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont boldSystemFontOfSize:14];
    tipLabel.text = tipString;
    [imageView addSubview:tipLabel];
    [view addSubview:imageView];
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformMakeTranslation(rect.size.width, 0);
                     } completion:^(BOOL finished) {
                         double delayInSeconds = 0.3;
                         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                             done(TRUE);
                             [imageView removeFromSuperview];
                             view.transform = CGAffineTransformMakeTranslation(0, 0);
                         });
                     }];
}

- (void) deleteActionStart
{
    [UIView beginAnimations:nil context:NULL];
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
    [UIView commitAnimations];
}

- (void) deleteActionEnd
{
    [UIView beginAnimations:nil context:NULL];
    self.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
}

- (UIView *)addStanderdShadow
{
    self.layer.shadowPath    = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4f;
    self.layer.shadowOffset  = CGSizeMake(2.0f, 1.0f);
    self.layer.shadowRadius  = 7.0f;
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius  = 5.0;
    
    return self;
}

@end
