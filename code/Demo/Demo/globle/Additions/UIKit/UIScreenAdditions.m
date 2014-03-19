//
//  UIScreenAdditionsm
//  DandelionPhone
//
//  Created by Tracy E on 12-12-25.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import "UIScreenAdditions.h"

@implementation UIScreen (Additions)

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isRetinaDisplay {
    static dispatch_once_t predicate;
    static BOOL answer;
    dispatch_once(&predicate, ^{
        answer = ([self respondsToSelector:@selector(scale)] && [self scale] == 2);
    });
    return answer;
}

@end
