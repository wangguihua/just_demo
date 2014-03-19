//
//  MBScrollMenu.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-26.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
@protocol MBScrollMenuDelegate;
@protocol MBScrollMenuDataSource;
@interface MBScrollMenu : UIView{
    NSUInteger _itemCount;
    NSInteger _defaultSelectedIndex;
    UIScrollView *_scrollView;
    NSMutableArray *_items;
}
@property (nonatomic, unsafe_unretained) id<MBScrollMenuDelegate> delegate;
@property (nonatomic, unsafe_unretained) id<MBScrollMenuDataSource> dataSource;
@property (nonatomic, readonly) BOOL isVisible;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, unsafe_unretained) UIButton *activeButton;
@property (nonatomic, strong) NSArray * unVisibleArray;

- (void)setSelectedIndex:(NSInteger)index;
- (void)showScrollMenu;
- (void)hideScrollMenu;
- (void)reloadData;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
@interface MBScrollCell : UIButton{
    UIImageView *_myImageView;
    UILabel *_textLabel;
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, unsafe_unretained) UIColor *textColor;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
@protocol MBScrollMenuDelegate <NSObject>

- (BOOL)scrollMenu:(MBScrollMenu *)scrollMenu didSelectRowAtIndex:(NSUInteger)index;

@optional
- (void)scrollMenu:(MBScrollMenu *)scrollMenu didDeselectRowAtIndex:(NSUInteger)index;
- (void)scrollMenuWillShow:(MBScrollMenu *)scrollMenu;
- (void)scrollMenuWillHide:(MBScrollMenu *)scrollMenu;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
@protocol MBScrollMenuDataSource <NSObject>

@required
- (NSUInteger)numberOfItemsInScrollMenu:(MBScrollMenu *)scrollMenu;
- (MBScrollCell *)scrollMenu:(MBScrollMenu *)scrollMenu cellForRowAtIndex:(NSUInteger)index;

@optional
- (NSUInteger)defaultSelectedAtIndex:(MBScrollMenu *)scrollMenu;

@end