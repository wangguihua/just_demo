//
//  MBSearchResultView.h
//  BOCMBCI
//
//  Created by Tracy E on 13-6-1.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
//  查询结果视图

#import <UIKit/UIKit.h>

@interface MBSearchResultView : UIView {
    UIImageView *   _scrollView;
    UIImageView *   _indicatorImageView;
    BOOL            _isAnimating;
}
@property (nonatomic, assign) BOOL isSearched;  //默认No，显示查询条件视图
@property (nonatomic, readonly, unsafe_unretained) UIButton *indicatorButton;  //收起|下拉 按钮
@property (nonatomic, strong) UIView *actionView;     //排序或筛选视图


@property (nonatomic, strong) UIView *searchView;       //查询条件视图
@property (nonatomic, strong) UIView *resultView;       //结果提示视图
@property (nonatomic, strong) UIView *resultListView;   //结果列表视图

- (void)scrollUp;
- (void)scrollDown;

@end
