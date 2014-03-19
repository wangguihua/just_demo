//
//  MBSearchResultView.m
//  BOCMBCI
//
//  Created by Tracy E on 13-6-1.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBSearchResultView.h"
#import "MBConstant.h"

@implementation MBSearchResultView{
    CGFloat _scrollHeight;
    BOOL _animating;
    CGRect _listLastRect;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.image = [[UIImage imageNamed:@"search_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:10];
        
        _indicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_indicatorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [_indicatorButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_indicatorButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [_indicatorButton setTitleColor:kTipTextColor forState:UIControlStateNormal];
        [_indicatorButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_scrollView addSubview:_indicatorButton];
        
        _indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300, 10, 13, 9)];
        [_indicatorButton addSubview:_indicatorImageView];
        
        [self addSubview:_scrollView];
        
        _searchView = [[UIView alloc] initWithFrame:CGRectZero];
        _resultView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _resultListView = [[UIView alloc] initWithFrame:CGRectZero];
        [_resultListView setAutoresizesSubviews:YES];
        [self addSubview:_resultListView];
    }
    return self;
}

- (void)scrollUp{
    _isSearched = YES;
    [UIView animateWithDuration:_scrollHeight / 800.0 animations:^{
        _scrollView.transform = CGAffineTransformMakeTranslation(0, -_scrollHeight);
        _actionView.transform = CGAffineTransformMakeTranslation(0, -_scrollHeight);
    } completion:^(BOOL finished) {
        [_indicatorButton setTitle:@"下拉" forState:UIControlStateNormal];
        _indicatorImageView.image = [UIImage imageNamed:@"img_arrow-gray_down.png"];
    }];
    
    [_actionView setHidden:NO];
}

- (void)scrollDown{
    _isSearched = NO;
    [UIView animateWithDuration:_scrollHeight / 800.0 animations:^{
        _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
        _actionView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [_indicatorButton setTitle:@"收起" forState:UIControlStateNormal];
        _indicatorImageView.image = [UIImage imageNamed:@"img_arrow-gray_up.png"];
    }];
    [_actionView setHidden:YES];
}

- (void)buttonAction{
    if (_isSearched) {
        [self scrollDown];
    } else {
        [self scrollUp];
    }
}

- (void)setResultListView:(UIView *)resultListView{
    [_resultListView removeFromSuperview];
    
    _resultListView = resultListView;
    [self addSubview:_resultListView];
}

- (void)setActionView:(UIView *)actionView{
    [_actionView removeFromSuperview];
    
    _actionView = actionView;
    [self addSubview:_actionView];
}

- (void)layoutSubviews{
    if (_animating) {
        return;
    }
    
    [self sendSubviewToBack:_resultListView];
    if (_isSearched) {
        _indicatorImageView.image = [UIImage imageNamed:@"img_arrow-gray_down.png"];
        [_indicatorButton setTitle:@"下拉" forState:UIControlStateNormal];
    } else {
        _indicatorImageView.image = [UIImage imageNamed:@"img_arrow-gray_up.png"];
        [_indicatorButton setTitle:@"收起" forState:UIControlStateNormal];
    }
        
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 1);
    if (_isSearched) {
        [_searchView removeFromSuperview];
        [_scrollView addSubview:_resultView];
        
        for (UIView *v in _resultView.subviews) {
            rect = CGRectUnion(rect, v.frame);
        }
        _resultView.frame = rect;
        
    } else {
        [_resultView removeFromSuperview];
        [_scrollView addSubview:_searchView];
        
        for (UIView *v in _searchView.subviews) {
            rect = CGRectUnion(rect, v.frame);
        }
        _searchView.frame = rect;
    }
    rect.size.height += 20;
    _scrollView.frame = rect;
    
    float actionHeight = 0;
    if (_actionView) {
        _actionView.frame = CGRectMake((self.width - _actionView.width) / 2,
                                       _scrollView.height - 12,
                                       _actionView.width,
                                       _actionView.height);
        actionHeight = _actionView.height - 12;
    }

    _indicatorButton.frame = CGRectMake(0, rect.size.height - 40, kScreenWidth, 30);
    [_scrollView bringSubviewToFront:_indicatorButton];
    
    _scrollHeight = _searchView.height - _resultView.height;

    if (CGRectIsEmpty(_listLastRect)) {
        _resultListView.frame = CGRectMake(_resultListView.frame.origin.x,
                                           _scrollView.height + actionHeight,
                                           _resultListView.frame.size.width,
                                           self.height - _scrollView.height - actionHeight);
        _listLastRect = _resultListView.frame;
    } else {
        _resultListView.frame = _listLastRect;
        [UIView animateWithDuration:_scrollHeight / 800.0 animations:^{
            _resultListView.frame = CGRectMake(_resultListView.frame.origin.x,
                                               _scrollView.height + actionHeight,
                                               _resultListView.frame.size.width,
                                               self.height - _scrollView.height - actionHeight);
            
        } completion:^(BOOL finished) {
            _listLastRect = _resultListView.frame;
        }];
    }
}


@end
