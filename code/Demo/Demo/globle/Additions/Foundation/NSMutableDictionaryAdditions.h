//
//  NSMutableDictionaryAdditions.h
//  DandelionPhone
//
//  Created by Tracy E on 12-11-30.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Additions)

/**
 * Adds a string on the condition that it's non-nil and non-empty.
 */
- (void)setNonEmptyString:(NSString*)string forKey:(id)key;

@end
