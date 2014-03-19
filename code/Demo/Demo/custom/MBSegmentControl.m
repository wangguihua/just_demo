//
//  MBSegmentControl.m
//  BOCMBCI
//
//  Created by llbt_ych on 13-4-12.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#define kSegmentRadius 5.0
#define kSegmentHeight 35.0

#define kSegmentSelectedImage [UIImage imageNamed:@"segment_selected.png"]
#define kSegmentUnselectedImage [UIImage imageNamed:@"segment_unselected.png"]


#import "MBSegmentControl.h"
#import <QuartzCore/QuartzCore.h>
#import "MBConstant.h"

@implementation MBSegmentControl

- (void) dealloc
{
    MB_RELEASE_SAFELY(_itemNameArray);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kSegmentHeight);
        self.backgroundColor = [UIColor clearColor];
        _selectIndex = -1;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame.size.height = kSegmentHeight;
    [super setFrame:frame];
}

- (void)setSegSelectIndex:(NSInteger)index
{
    _selectIndex = index;
    [self setNeedsDisplay];
}

- (void)reloadView
{
    
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    UIColor *selectedBgColor = [UIColor colorWithPatternImage:kSegmentSelectedImage];
    UIColor *unselectedBgColor = [UIColor colorWithPatternImage:kSegmentUnselectedImage];
    
    CGFloat width = self.frame.size.width / _itemNameArray.count;
    CGFloat height = self.frame.size.height;
    
    // Rect with radius, will be used to clip the entire view
	CGFloat minx = CGRectGetMinX(rect) + 1, midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) + 1, midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect) ;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(c);
    // Path are drawn starting from the middle of a pixel, in order to avoid an antialiased line
    CGContextMoveToPoint(c, minx - .5, midy - .5);
    CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, kSegmentRadius);
    CGContextSetStrokeColorWithColor(c, kTipTextColor.CGColor);
    CGContextClosePath(c);
    
    CGContextClip(c);
    
    for (int i = 0; i < _itemNameArray.count; i++) {
        
        CGRect itemBgRect = CGRectMake(i * width,
                                       0.0f,
                                       width,
                                       height);
        
        if (i == self.selectIndex && !_disableSelectState) {
            // Inner shadow
            
            int blendMode = kCGBlendModeDarken;
            
            // Right and left inner shadow
            CGContextSaveGState(c);
            CGContextSetBlendMode(c, blendMode);
            CGContextClipToRect(c, itemBgRect);
            
            CGContextRestoreGState(c);
            
            // Top inner shadow
            CGContextSaveGState(c);
            CGContextSetBlendMode(c, blendMode);
            CGContextClipToRect(c, itemBgRect);
            
            CGContextSetFillColorWithColor(c, selectedBgColor.CGColor);
            CGContextFillRect(c, itemBgRect);
            
            CGContextRestoreGState(c);
            
        }else{
            CGContextSaveGState(c);
            CGContextSetFillColorWithColor(c, unselectedBgColor.CGColor);
            CGContextFillRect(c, itemBgRect);
            CGContextRestoreGState(c);
        }
        
        NSString *string = _itemNameArray[i];
        CGSize stringSize = [string sizeWithFont:kSmallButtonTitleFont];
        CGRect stringRect = CGRectMake(i * width + (width - stringSize.width) / 2,
                                       (height - stringSize.height) / 2,// + kTopPadding,
                                       stringSize.width,
                                       stringSize.height);
        
        if (self.selectIndex == i && !_disableSelectState) {
            [[UIColor colorWithWhite:0.0f alpha:.2f] setFill];
            [string drawInRect:CGRectOffset(stringRect, 0.0f, -1.0f) withFont:kSmallButtonTitleFont];
            [kWhiteTextColor setFill];
            [kWhiteTextColor setStroke];
            [string drawInRect:stringRect withFont:kSmallButtonTitleFont];
        } else {
            [[UIColor colorWithWhite:0.0f alpha:.2f] setFill];
            [string drawInRect:CGRectOffset(stringRect, 0.0f, 1.0f) withFont:kSmallButtonTitleFont];
            [kNormalTextColor setFill];
            [kNormalTextColor setStroke];
            [string drawInRect:stringRect withFont:kSmallButtonTitleFont];
        }
        
        // Separator分割线
        if ((i > 0 && i - 1 != self.selectIndex && i != self.selectIndex) || _momentary) {
            CGContextSaveGState(c);
            CGContextMoveToPoint(c, itemBgRect.origin.x + .5, itemBgRect.origin.y);
            CGContextAddLineToPoint(c, itemBgRect.origin.x + .5, itemBgRect.size.height);
            CGContextSetLineWidth(c, .5f);
            CGContextSetStrokeColorWithColor(c, kTipTextColor.CGColor);
            CGContextStrokePath(c);
            
            CGContextRestoreGState(c);
        }
    }
    CGContextRestoreGState(c);
    
    CGContextSaveGState(c);
    
    CGRect bottomHalfRect = CGRectMake(0,
                                       rect.size.height - kSegmentRadius + 7,
                                       rect.size.width,
                                       kSegmentRadius);
    CGContextClearRect(c, CGRectMake(0,
                                     rect.size.height - 1,
                                     rect.size.width,
                                     1));
    CGContextClipToRect(c, bottomHalfRect);
    
    CGContextMoveToPoint(c, minx + .5, midy - .5);
    CGContextAddArcToPoint(c, minx + .5, miny - .5, midx - .5, miny - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, minx + .5, maxy - .5, minx - .5, midy - .5, kSegmentRadius);
    CGContextClosePath(c);
    
    CGContextSetBlendMode(c, kCGBlendModeLighten);
    CGContextSetStrokeColorWithColor(c,[UIColor colorWithWhite:255/255.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(c, .5f);
    CGContextStrokePath(c);
    
    CGContextRestoreGState(c);
    midy--, maxy--;
    CGContextMoveToPoint(c, minx - .5, midy - .5);
    CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kSegmentRadius);
    CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, kSegmentRadius);
    CGContextClosePath(c);
    
    CGContextSetBlendMode(c, kCGBlendModeMultiply);
    CGContextSetStrokeColorWithColor(c,[UIColor colorWithWhite:30/255.0 alpha:.9].CGColor);
    CGContextSetLineWidth(c, .5f);
    CGContextStrokePath(c);
    
    CFRelease(colorSpace);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    int itemIndex = floor(_itemNameArray.count * point.x / self.bounds.size.width);
    if (itemIndex == _selectIndex && !_momentary) {
        return;
    }
    self.selectIndex = itemIndex;
    _disableSelectState = NO;
    [self setNeedsDisplay];
    if (_delegate && [_delegate respondsToSelector:@selector(MBSegment:selectAtIndex:)]) {
        [_delegate MBSegment:self selectAtIndex:_selectIndex];
    }
    if (_momentary) {
        double delayInSeconds = 0.25;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _disableSelectState = YES;
            [self setNeedsDisplay];
        });
    }
}


@end