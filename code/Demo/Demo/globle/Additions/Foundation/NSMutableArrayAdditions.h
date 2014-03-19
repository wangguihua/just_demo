//
//  NSMutableArrayAdditions.h
//  DandelionPhone
//
//  Created by Tracy E on 12-11-30.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Additions)

/**
 * Adds a string on the condition that it's non-nil and non-empty.
 */
- (void)addNonEmptyString:(NSString*)string;

/*
 * Shuffle the array with a random algorithm.
 */
- (void)shuffle;

@end
