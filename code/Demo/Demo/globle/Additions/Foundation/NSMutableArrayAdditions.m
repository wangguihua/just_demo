//
//  NSMutableArrayAdditionsm
//  DandelionPhone
//
//  Created by Tracy E on 12-11-30.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import "NSMutableArrayAdditions.h"
#import "MBGlobalCore.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSMutableArray (Additions)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addNonEmptyString:(NSString*)string {
    if (MBIsStringWithAnyText(string)) {
        [self addObject:string];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)shuffle
{
    for (NSUInteger i = [self count] - 1; i > 0; i--) {
        [self exchangeObjectAtIndex:arc4random_uniform(i + 1)
                 withObjectAtIndex:i];
    }
}

@end
