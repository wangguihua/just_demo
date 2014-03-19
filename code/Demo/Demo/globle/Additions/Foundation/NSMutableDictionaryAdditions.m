//
//  NSMutableDictionaryAdditionsm
//  DandelionPhone
//
//  Created by Tracy E on 12-11-30.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import "NSMutableDictionaryAdditions.h"

#import "MBGlobalCore.h"

@implementation NSMutableDictionary (Additions)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setNonEmptyString:(NSString*)string forKey:(id)key {
    if (MBIsStringWithAnyText(string)) {
        [self setObject:string forKey:key];
    }
}


@end
