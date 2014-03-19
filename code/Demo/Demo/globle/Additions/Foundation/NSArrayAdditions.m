//
//  NSArrayAdditionsm
//  DandelionPhone
//
//  Created by Tracy E on 12-11-30.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import "NSArrayAdditions.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSArray (Additions)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithValue:(id)value forKey:(id)key {
    for (id object in self) {
        id propertyValue = [object valueForKey:key];
        if ([propertyValue isEqual:value]) {
            return object;
        }
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithClass:(Class)cls {
    for (id object in self) {
        if ([object isKindOfClass:cls]) {
            return object;
        }
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)containsObject:(id)object withSelector:(SEL)selector {
    for (id item in self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
         BOOL result = [[item performSelector:selector withObject:object] boolValue];
#pragma clang diagnostic pop

        if (result) {
            return YES;
        }
    }
    return NO;
}

@end
