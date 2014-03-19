//
//  MBSelectView.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-30.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBSelectView.h"
#import "MBConstant.h"
#import "MBAccessoryView.h"
#import "MBCorePreprocessorMacros.h"
#import "UIViewAdditions.h"

#define kSelectViewHeight 25.0

@interface MBSelectView ()
{
  @private
    UIButton *      _button;
    UIView *        _selectView;
    BOOL            _isVisible;
    NSString *      _tempSelectedValue;
    __weak id       _target;
    SEL             _selector;
    NSDate *        _selectedDate;
}

@end

@implementation MBSelectView

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 25.0f;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSelf];
    }
    return self;
}

- (void)initSelf{
    _isVisible = NO;
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.exclusiveTouch = YES;
    _button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_button setBackgroundImage:[[UIImage imageNamed:@"select.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateNormal];
    [_button setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 22)];
    [_button.titleLabel setFont:kNormalTextFont];
    [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_button addTarget:self action:@selector(selectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerViewWillShow:)
                                                 name:MBSelectViewWillShowNotification
                                               object:nil];

    
}




- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_selectView) {
        [_selectView removeFromSuperview];
        MB_RELEASE_SAFELY(_selectView);
    }
    MB_RELEASE_SAFELY(_options);
}


- (void)setFrame:(CGRect)frame{
    frame.size.height = kSelectViewHeight;
    [super setFrame:frame];
}

- (void)reloadData{
    if (_selectType == MBSelectTypeNormal) {
        if (!MBIsStringWithAnyText(_value) && MBIsArrayWithItems(_options)) {
            _value = [_options[0] copy];
        }
    } else {
        NSDate *defaultDate = nil;
        if (_selectedDate) {
            defaultDate = _selectedDate;
            
        } else {
            defaultDate = [NSDate date];
        }
        _dateValue = defaultDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        formatter.dateFormat = kDateFormat;
        _value = [[formatter stringFromDate:defaultDate] copy];
    }
    
    _tempSelectedValue = _value;
    [_button setTitle:_value forState:UIControlStateNormal];
}

- (void)setOptions:(NSArray *)options{
    _options = options;
    
    [self reloadData];
}

- (void)setValue:(NSString *)value{
    _value = [value copy];
    
    [self reloadData];
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    
    [self reloadData];
}

- (void)setSelectType:(MBSelectType)selectType{
    _selectType = selectType;
    
    [self reloadData];
}

- (void)selectButtonPressed{
    [self showPickerView];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)showPickerView{
    if (!_isVisible) {
        [self becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] postNotificationName:MBSelectViewWillShowNotification object:self];
        _isVisible = YES;

        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kToolBarHeight + kPickerViewHeight)];
        MBAccessoryView *accessoryView = [[MBAccessoryView alloc] initWithDelegate:self];
        [accessoryView setTitle:_title];
        [_selectView addSubview:accessoryView];
        if (_selectType == MBSelectTypeNormal) {
            UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kToolBarHeight, kScreenWidth, kPickerViewHeight)];
            picker.delegate = self;
            picker.dataSource = self;
            [picker setShowsSelectionIndicator:YES];
            if ([_options containsObject:_value]) {
                [picker selectRow:[_options indexOfObject:_value] inComponent:0 animated:NO];
            } else {
                _tempSelectedValue = [_options[0] copy];
            }
            [_selectView addSubview:picker];
        } else if (_selectType == MBSelectTypeDate) {
            UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kToolBarHeight, kScreenWidth, kPickerViewHeight)];
            [picker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            picker.datePickerMode = UIDatePickerModeDate;
            if (_selectedDate) {
                [picker setDate:_selectedDate animated:NO];
            }
            if (_value) {
                _dateValue = picker.date;
            }
            
            picker.minimumDate = _minDate;
            picker.maximumDate = _maxDate;
            [_selectView addSubview:picker];
        }
        
        [self.window addSubview:_selectView];
        
        [UIView animateWithDuration:0.26 animations:^{
            _selectView.transform = CGAffineTransformMakeTranslation(0, -(kToolBarHeight + kPickerViewHeight));
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MBSelectViewDidShowNotification object:self];
            finished = YES;
        }];
    }
}

- (BOOL)resignFirstResponder{
    if ([self isFirstResponder]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MBSelectViewWillHideNotification object:self];
        [UIView animateWithDuration:0.25 animations:^{
            _selectView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MBSelectViewDidHideNotification object:self];
            [_selectView removeFromSuperview];
            MB_RELEASE_SAFELY(_selectView);
            _isVisible = NO;
            finished = YES;
        }];
    }
    return [super resignFirstResponder];
}

- (void)hidePickerView{
    if (_isVisible) {
        [self resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    [self hidePickerView];
}

- (void)pickerViewWillShow:(NSNotification *)notification{
    [self hidePickerView];
}

- (void)addTarget:(id)target forVauleChangedaction:(SEL)action{
    _target = target;
    _selector = action;
}

- (void)setEnabled:(BOOL)enabled{
    _button.userInteractionEnabled = enabled;
    if (enabled) {
        [_button setBackgroundImage:[[UIImage imageNamed:@"select.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateNormal];
    } else {
        [_button setBackgroundImage:[[UIImage imageNamed:@"select_pressed.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateNormal];
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    _button.userInteractionEnabled = userInteractionEnabled;
    if (userInteractionEnabled) {
        [_button setBackgroundImage:[[UIImage imageNamed:@"select.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateNormal];
    } else {
        [_button setBackgroundImage:[[UIImage imageNamed:@"select_pressed.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:0] forState:UIControlStateNormal];
    }
}

#pragma mark MBAccessoryViewDelegate
- (void)accessoryViewDidPressedCancelButton:(MBAccessoryView *)view{
    //值还原
    _tempSelectedValue = _value;
    
    _selectedDate = _dateValue;
    
    [self hidePickerView];
}

- (void)accessoryViewDidPressedDoneButton:(MBAccessoryView *)view{
    //值确认
    _value = [_tempSelectedValue copy];
    
    _dateValue = _selectedDate;
    
    [_button setTitle:_value forState:UIControlStateNormal];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    [_target performSelector:_selector withObject:self];

#pragma clang diagnostic pop

    [self hidePickerView];
}


- (void)datePickerValueChanged:(UIDatePicker *)picker{
    _selectedDate = picker.date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kDateFormat;
    _tempSelectedValue = [formatter stringFromDate:picker.date];
}


#pragma mark UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_options count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_options objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _tempSelectedValue = [_options objectAtIndex:row];
}


@end
