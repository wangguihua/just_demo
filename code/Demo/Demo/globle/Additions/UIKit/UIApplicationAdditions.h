//
//  UIApplicationAdditions.h
//  DandelionPhone
//
//  Created by Tracy E on 13-1-9.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Additions)

/**
 Returns the file URL of the documents directory.
 */
@property (nonatomic, readonly) NSString *documentsDirectory;

/**
 Returns the file URL of the caches directory.
 */
@property (nonatomic, readonly) NSString *cachesDirectory;


/**
 Aggregates calls to settings `networkActivityIndicatorVisible` to avoid flashing of the indicator in the status bar.
 Simply use `setNetworkActivity:` instead of `setNetworkActivityIndicatorVisible:`.
 
 Specify `YES` if the application should show network activity and `NO` if it should not. The default value is `NO`.
 A spinning indicator in the status bar shows network activity. The application may explicitly hide or show this
 indicator.
 
 @param inProgress A Boolean value that turns an indicator of network activity on or off.
 */
- (void)setNetworkActivity:(BOOL)inProgress;

@end
