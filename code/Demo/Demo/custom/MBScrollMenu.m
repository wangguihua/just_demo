//
//  MBScrollMenu.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-26.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBScrollMenu.h"
#import "MBConstant.h"
#import <QuartzCore/QuartzCore.h>
#import "MBGlobalUICommon.h"
@implementation MBScrollCell

- (id)init{
    self = [super init];
    if (self) {
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 26, 28)];
        [self addSubview:_myImageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, kScrollCellWidth - 10, 40)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        _textLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_textLabel];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return self;
}

- (void)setTextColor:(UIColor *)textColor{
    _textLabel.textColor = textColor;
}


- (void)layoutSubviews{
    _myImageView.image = _image;
    _textLabel.text = _title;
    
    [_textLabel sizeToFit];
    CGSize size = _textLabel.frame.size;
    _textLabel.frame = CGRectMake((kScrollCellWidth - size.width) / 2, 40, size.width, size.height);
}

@end


@implementation MBScrollMenu


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isVisible = NO;
        _items = [[NSMutableArray alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScrollCellWidth, kContentViewHeight)];
        
        UIImageView * scrolBGV = [[UIImageView alloc]initWithFrame:_scrollView.frame];
        [scrolBGV setImage:[UIImage imageNamed:@"scrollMenuBG.png"]];
        [self addSubview:scrolBGV];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        UIImageView *edge = [[UIImageView alloc] initWithFrame:CGRectMake(kScrollCellWidth - 2, 0, 5, frame.size.height)];
        edge.image = [UIImage imageNamed:@"scrollEdge.png"];
        [self addSubview:edge];
    
        _activeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_activeButton setBackgroundImage:[UIImage imageNamed:@"scrollRight.png"] forState:UIControlStateNormal];
        _activeButton.frame = CGRectMake(kScrollCellWidth + 1, (frame.size.height - kScrollButtonHeight) / 2, kScrollButtonWidth, kScrollButtonHeight);
        [_activeButton addTarget:self action:@selector(activeButtonPressed) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_activeButton];
    }
    return self;
}

- (void)showScrollMenu{
    _isVisible = YES;
    [UIView animateWithDuration:0.17 animations:^{
        if (_delegate && [_delegate respondsToSelector:@selector(scrollMenuWillShow:)]) {
            [_delegate scrollMenuWillShow:self];
        }
        self.transform = CGAffineTransformMakeTranslation(kScrollCellWidth - 3, 0);
        _isVisible = YES;
    } completion:^(BOOL finished) {
        [_activeButton setBackgroundImage:[UIImage imageNamed:@"scrollLeft.png"] forState:UIControlStateNormal];
    }];
    
 }

- (void)hideScrollMenu{
    _isVisible = NO;
    [UIView animateWithDuration:0.17 animations:^{
        if (_delegate && [_delegate respondsToSelector:@selector(scrollMenuWillHide:)]) {
            [_delegate scrollMenuWillHide:self];
        }
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        _isVisible = NO;
    } completion:^(BOOL finished) {
        [_activeButton setBackgroundImage:[UIImage imageNamed:@"scrollRight.png"] forState:UIControlStateNormal];
    }];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideScrollMenu) object:nil];
}


- (void)activeButtonPressed{
    if (!_isVisible) {
        [self showScrollMenu];
    } else {
        [self hideScrollMenu];
    }
}

- (void)layoutSubviews{
    
    for (UIView *cell in _scrollView.subviews){
        [cell removeFromSuperview];
    }
    [_items removeAllObjects];
    
    _itemCount = [_dataSource numberOfItemsInScrollMenu:self];
    _scrollView.contentSize = CGSizeMake(kScrollCellWidth, kScrollCellHeight * _itemCount);
    
  
    
    float cellPointY = 0;
    for (int i = 0; i < _itemCount; i++){
        float cellHeight = kScrollCellHeight;
        if (_unVisibleArray && [_unVisibleArray containsObject:[NSString stringWithFormat:@"%d", i]]) {
            cellHeight = 0;
        }
        
        MBScrollCell *cell = [_dataSource scrollMenu:self cellForRowAtIndex:i];
        [cell addTarget:self action:@selector(cellDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        cell.frame = CGRectMake(0, cellPointY, kScrollCellWidth, cellHeight);
        if (i == _selectedIndex) {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollCellSelected.png"]];
            cell.textColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollCell.png"]];
        }
        
        if (cellHeight != 0) {
            [_scrollView addSubview:cell];
            cellPointY += (cellHeight-0.5);
        }
        
        [_items addObject:cell];
    }
    
    _unVisibleArray = nil;
}

- (void)setSelectedIndex:(NSInteger)index{
    _selectedIndex = index;
    [_items enumerateObjectsUsingBlock:^(MBScrollCell *cell, NSUInteger idx, BOOL *stop) {
        if (index == idx) {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollCellSelected.png"]];
            cell.textColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollCell.png"]];
            cell.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        }
     }];
}

- (void)cellDidSelected:(MBScrollCell *)cell{
    NSInteger index = [_items indexOfObject:cell];
    if (_selectedIndex == index) {
        [self hideScrollMenu];
        return;
    }
    
    BOOL enable = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollMenu:didSelectRowAtIndex:)]) {
        enable = [_delegate scrollMenu:self didSelectRowAtIndex:[_items indexOfObject:cell]];
    }
    if (enable) {
        for (int i = 0; i < [_items count]; i++) {
            MBScrollCell *otherCell = [_items objectAtIndex:i];
            otherCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollCell.png"]];
            otherCell.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        }
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollCellSelected.png"]];
        cell.textColor = [UIColor whiteColor];
        
        _selectedIndex = index;
        
        [self hideScrollMenu];
    }
}

- (void)reloadData{
    _scrollView.contentOffset = CGPointMake(0, 0);
    [self layoutSubviews];
}

@end
