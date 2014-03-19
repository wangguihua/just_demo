//
//  UIApplicationAdditionsm
//  DandelionPhone
//
//  Created by Tracy E on 13-1-9.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "UIApplicationAdditions.h"

@implementation UIApplication (Additions)


- (void)setNetworkActivity:(BOOL)inProgress {
	// Ensure we're on the main thread
	if ([NSThread isMainThread] == NO) {
		[self performSelectorOnMainThread:@selector(_setNetworkActivityWithNumber:) withObject:[NSNumber numberWithBool:inProgress] waitUntilDone:NO];
		return;
	}
	
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_setNetworkActivityIndicatorHidden) object:nil];
	
	if (inProgress == YES) {
		if (self.networkActivityIndicatorVisible == NO) {
			self.networkActivityIndicatorVisible = YES;
		}
	} else {
		[self performSelector:@selector(_setNetworkActivityIndicatorHidden) withObject:nil afterDelay:0.1];
	}
}


- (NSString *)documentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


- (NSString *)cachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

@end



////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIApplication (ESPrivateAdditions)
- (void)_setNetworkActivityWithNumber:(NSNumber *)number;
- (void)_setNetworkActivityIndicatorHidden;
@end

@implementation UIApplication (ESPrivateAdditions)

- (void)_setNetworkActivityWithNumber:(NSNumber *)number {
	[self setNetworkActivity:[number boolValue]];
}


- (void)_setNetworkActivityIndicatorHidden {
	self.networkActivityIndicatorVisible = NO;
}

@end
