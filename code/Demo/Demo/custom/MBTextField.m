//
//  MBTextField.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-29.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBTextField.h"
#import "MBAccessoryView.h"
#import "MBConstant.h"
#import <QuartzCore/QuartzCore.h>
#import "RegexKitLite.h"
#import "NSStringUtils.h"

@interface MBTextFieldAgent : NSObject<UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) MBTextField *target;

@end

@implementation MBTextFieldAgent

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_target.textFieldDelegate &&
        [_target.textFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_target.textFieldDelegate textFieldShouldBeginEditing:textField];
    }
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_target.textFieldDelegate &&
        [_target.textFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_target.textFieldDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.text = [textField.text formatWhiteSpace];
    
    if (_target.textFieldDelegate &&
        [_target.textFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_target.textFieldDelegate textFieldShouldEndEditing:textField];
    }
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_target.textFieldDelegate &&
        [_target.textFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_target.textFieldDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.keyboardType == UIKeyboardTypeDecimalPad) {
        if ([string isEqualToString:@"."] &&
            [textField.text rangeOfString:@"."].location != NSNotFound) {
            return NO;
        }
    }
    
    int _textMaxLength = _target.textMaxLength;
    if (_textMaxLength == 0) {
        return YES;
    }
    
    if ( 1 == range.length && string.length == 0)
	{
		return YES; //删除
	}
	else
	{
		NSString * text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfRegex:@"[\u4e00-\u9fa5]" withString:@"##"];
        int symbol = [[text componentsMatchedByRegex:@"\u2006"] count];
		if ( _textMaxLength > 0 && text.length - symbol > _textMaxLength )
		{
			return NO;
		}
		return YES;
	}
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (_target.textFieldDelegate &&
        [_target.textFieldDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_target.textFieldDelegate textFieldShouldClear:textField];
    }
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"[%@]",textField.text);
    NSLog(@"%@",[textField.text componentsMatchedByRegex:@"\\S"]);
    
    if (_target.textFieldDelegate &&
        [_target.textFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [_target.textFieldDelegate textFieldShouldReturn:textField];
    }
	return YES;
}


@end



@interface MBTextField ()<MBAccessoryViewDelegate>{
    NSString *_lastText;
    BOOL _shouldConfigBorder;
    
    __weak id <UITextFieldDelegate> _origDelegate;
    
    BOOL _firstTimeSetDeleagte;
    MBTextFieldAgent *_agent;
}

@end

@implementation MBTextField


#pragma mark - Draw layout
- (void)showGlowing
{
    if (_shouldConfigBorder) {
        [self animateBorderColorFrom:(id)self.layer.borderColor to:(id)self.layer.shadowColor shadowOpacityFrom:(id)[NSNumber numberWithFloat:0.f] to:(id)[NSNumber numberWithFloat:1.f]];
    }
}

- (void)hideGlowing
{
    if (_shouldConfigBorder) {
        [self animateBorderColorFrom:(id)self.layer.borderColor to:(id)[UIColor lightGrayColor].CGColor shadowOpacityFrom:(id)[NSNumber numberWithFloat:1.f] to:(id)[NSNumber numberWithFloat:0.f]];
    }
}


- (void)_configBackground{
    _shouldConfigBorder = YES;
    
    //add by lgj
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    leftView.backgroundColor = [UIColor clearColor];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView.userInteractionEnabled = NO;
    
    self.borderStyle = UITextBorderStyleNone;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 4.f;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.layer.shadowColor = [UIColor orangeColor].CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.f].CGPath;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 3.f;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)animateBorderColorFrom:(id)fromColor to:(id)toColor shadowOpacityFrom:(id)fromOpacity to:(id)toOpacity
{
    CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    borderColorAnimation.fromValue = fromColor;
    borderColorAnimation.toValue = toColor;
    
    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacityAnimation.fromValue = fromOpacity;
    shadowOpacityAnimation.toValue = toOpacity;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.0f / 3.0f;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[borderColorAnimation, shadowOpacityAnimation];
    
    [self.layer addAnimation:group forKey:nil];
}

//- (CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(8, 0, bounds.size.width-16, bounds.size.height);
//}
//
//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 8, 0);
////    return CGRectMake(8, 0, bounds.size.width-35, bounds.size.height);
//}
//
//- (CGRect)textRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(8, 0, bounds.size.width-16, bounds.size.height);
//}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle{
    if (borderStyle == UITextBorderStyleRoundedRect) {
        [self _configBackground];
    } else {
    }
    [super setBorderStyle:UITextBorderStyleNone];
}


#pragma mark - UITextField
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.inputAccessoryView = [[MBAccessoryView alloc] initWithDelegate:self];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.font = kNormalTextFont;
        self.textColor = kNormalTextColor;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        _shouldConfigBorder = NO;
        
        _agent = [[MBTextFieldAgent alloc] init];
        _agent.target = self;
        
        _copyEnabled = YES;
        _firstTimeSetDeleagte = YES;
        self.delegate = _agent;
    }
    return self;
}

- (id)init{
    self = [self initWithFrame:CGRectZero];
    return self;
}


- (void)setDelegate:(id<UITextFieldDelegate>)delegate{
    if (_firstTimeSetDeleagte) {
        [super setDelegate:delegate];
        _firstTimeSetDeleagte = NO;
    } else {
        _textFieldDelegate = delegate;
    }
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (_copyEnabled) {
        return [super canPerformAction:action withSender:sender];
    } else {
        return NO;
    }
}


- (void)setFont:(UIFont *)font{
    [super setFont:kNormalTextFont];
}

- (BOOL)becomeFirstResponder{
    if (!_lastText) {
        _lastText = [self.text copy];
    }
    [self showGlowing];

    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    if([self isFirstResponder]){
        [self hideGlowing];
    }
    return [super resignFirstResponder];
}

- (void)setText:(NSString *)text{
    _lastText = nil;
    [super setText:text];
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    if (self.isDrawPlaceholder)
    {
        [kTipTextColor setFill];
        [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:12]];
    }
    else
    {
        [super drawPlaceholderInRect:rect];
    }
}




#pragma mark - UIAccessoryViewDelegate Methods
- (void)accessoryViewDidPressedCancelButton:(MBAccessoryView *)view{
    self.text = _lastText;
    _lastText = nil;
    
    if (self.textFieldDelegate &&
        [self.textFieldDelegate respondsToSelector:@selector(textFieldDidCancelEditing:)]) {
        [self.textFieldDelegate performSelector:@selector(textFieldDidCancelEditing:) withObject:self];
    }
    [self resignFirstResponder];
}

- (void)accessoryViewDidPressedDoneButton:(MBAccessoryView *)view{
    
    [self resignFirstResponder];
    
    if (self.text) {
        self.text = [self ToDBS:self.text];
        _lastText = [self.text copy];
    }
    
    if (self.textFieldDelegate &&
        [self.textFieldDelegate respondsToSelector:@selector(textFieldDidFinsihEditing:)]) {
        [self.textFieldDelegate performSelector:@selector(textFieldDidFinsihEditing:) withObject:self];
    }
}

#pragma mark - 半角空格
- (NSString *)ToDBS:(NSString *)str
{
    NSMutableString *result = [[NSMutableString alloc] init];
    unichar tmp;
    for (unsigned int i = 0; i < [str length]; i++) {
        tmp = [str characterAtIndex:i];
        
        if (tmp == 8198) {//空格
            continue;
        }else {
            [result appendString:[str substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return result;
}

@end
