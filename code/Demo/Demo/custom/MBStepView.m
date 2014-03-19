//
//  MBStepView.m
//  BOCMBCI
//
//  Created by Tracy E on 13-4-8.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBStepView.h"
#import "MBCorePreprocessorMacros.h"
#import "MBConstant.h"

@implementation MBStepView

- (void)dealloc
{
    MB_RELEASE_SAFELY(_steps);
}

- (id)initWithFrame:(CGRect)frame
{
    return nil;
    
    frame.size = CGSizeMake(kScreenWidth, 24);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _currentIndex = 1;
        _startIndex = 1;
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIFont *textFont = kSmallTextFont;
    UIFont *numberFont = kSmallTitleFont;
    CGFloat spaceWidth = 40.0f;
    CGFloat arrowWidth = 12.0f;
    CGFloat offsetX = 0;
    CGFloat viewHeight = rect.size.height;
    NSInteger stepCount = [_steps count];

    NSMutableArray *lengthArray = [[NSMutableArray alloc] initWithCapacity:3];
    CGFloat totalLength = 0;
    for (int i = 0; i < stepCount; i++) {
        NSString *text = _steps[i];
        CGFloat textLength = [text sizeWithFont:textFont].width;
        CGFloat stepLength = textLength + spaceWidth;
        //为了让第一个看起来不是比其它的长
        if (i == 0) {
            stepLength -= arrowWidth;
        }
        [lengthArray addObject:@(stepLength)];
        totalLength += stepLength;
    }
    
    //如果所有文本+空隙的长度小于控件长度，每一段均分多余长度
    if (totalLength < rect.size.width) {
        CGFloat moreLength = rect.size.width - totalLength;
        for (int i = 0; i < stepCount; i++) {
            CGFloat textLength = [lengthArray[i] floatValue];
            textLength += moreLength / stepCount;
            lengthArray[i] = @(textLength);
        }
    }
    
    //draw background
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);

    for (int i = 0; i < stepCount; i++) {
        CGContextSetStrokeColorWithColor(context, MB_RGBA(10, 10, 10, 0.1).CGColor);
        CGFloat textLength = [lengthArray[i] floatValue];
        CGContextMoveToPoint(context, offsetX, 0);
//        if ([_steps count] == 2) {
//            textLength = kScreenWidth / 2;
//        }else {
//            textLength = kScreenWidth / 3;
//        }
        if (i == 0) {
            //第一项
            CGPoint points[6] = {
                CGPointMake(offsetX, 0),
                CGPointMake(offsetX + textLength, 0),
                CGPointMake(offsetX + textLength + arrowWidth, viewHeight / 2.0),
                CGPointMake(offsetX + textLength, viewHeight),
                CGPointMake(offsetX, viewHeight),
                CGPointMake(offsetX, 0)
            };
            CGContextAddLines(context, points, 6);

        } else if (i == stepCount - 1) {
            //最后一项
            CGPoint points[6] = {
                CGPointMake(offsetX, 0),
                CGPointMake(offsetX + textLength, 0),
                CGPointMake(offsetX + textLength, viewHeight),
                CGPointMake(offsetX, viewHeight),
                CGPointMake(offsetX + arrowWidth, viewHeight / 2.0),
                CGPointMake(offsetX, 0)
            };
            CGContextAddLines(context, points, 6);
        } else {
            //中间项
            CGPoint points[7] = {
                CGPointMake(offsetX, 0),
                CGPointMake(offsetX + textLength, 0),
                CGPointMake(offsetX + textLength + arrowWidth, viewHeight / 2.0),
                CGPointMake(offsetX + textLength, viewHeight),
                CGPointMake(offsetX, viewHeight),
                CGPointMake(offsetX + arrowWidth, viewHeight / 2.0),
                CGPointMake(offsetX, 0)
            };
            CGContextAddLines(context, points, 7);
        }
        if (i == _currentIndex - 1) {
            CGContextSetFillColorWithColor(context, [UIColor colorWithPatternImage:[UIImage imageNamed:@"stepNow.png"]].CGColor);
        } else {
            CGContextSetFillColorWithColor(context, [UIColor colorWithPatternImage:[UIImage imageNamed:@"stepNext.png"]].CGColor);
        }
        CGContextDrawPath(context, kCGPathFillStroke);
        
        //draw text
        if ([_steps[i] length] != 0) {
            UIGraphicsPushContext(context);
            if (_currentIndex - 1 == i) {
                [kWhiteTextColor set];
            } else {
                [kStepViewTextColor set];
            }
            float numberOffsetX = i ? arrowWidth + 5 : 5;
            [[NSString stringWithFormat:@"%d",i + _startIndex]
             drawAtPoint:CGPointMake(offsetX + numberOffsetX, (viewHeight - numberFont.lineHeight) / 2.0)
             withFont:numberFont];
            
            [_steps[i] drawAtPoint:CGPointMake(offsetX + numberOffsetX + 20,
                                               (viewHeight - textFont.lineHeight) / 2.0)
                          withFont:textFont];

        }

        offsetX += textLength;
    }
 }

- (void)setCurrentIndex:(NSInteger)index{
    if (_currentIndex != index) {
        [self setNeedsDisplay];
    }
    _currentIndex = index;
}


@end
