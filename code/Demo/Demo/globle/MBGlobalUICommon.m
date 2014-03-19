//
//  ESGlobalUICommon.m
//  DandelionPhone
//
//  Created by Tracy E on 12-11-30.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import "MBGlobalUICommon.h"
#import "MBAlertView.h"
#import "MB_Reachability.h"
#import "UIWindowAdditions.h"
#import "BOCProgressHUD.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
float MBOSVersion() {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsKeyboardVisible() {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return !![window findFirstResponder];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsNetworkStatusOnline() {
    return [[MBReachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsDeviceJailbroken() {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Application/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsMultiTaskingSupported() {
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]){
        backgroundSupported = device.multitaskingSupported;
    }
    return backgroundSupported;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsPad() {
#ifdef __IPHONE_3_2
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
UIDeviceOrientation MBDeviceOrientation() {
    UIDeviceOrientation orient = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationUnknown == orient) {
        return UIDeviceOrientationPortrait;
        
    } else {
        return orient;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBDeviceOrientationIsPortrait() {
    UIDeviceOrientation orient = MBDeviceOrientation();
    
    switch (orient) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            return YES;
        default:
            return NO;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBDeviceOrientationIsLandscape() {
    UIDeviceOrientation orient = MBDeviceOrientation();
    
    switch (orient) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return YES;
        default:
            return NO;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect MBApplicationFrame() {
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void MBAlert(NSString *message) {
    MBAlertView *alert = [[MBAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void MBAlertNoTitle(NSString *message) {
    MBAlertView* alert = [[MBAlertView alloc] initWithTitle:nil
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
    [alert show];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
void MBAlertWithDelegate(NSString* message, id delegate) {
    MBAlertView* alert = [[MBAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsIPhone5() {
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight > 480.0f) {
        return YES;
    }
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
UIImage* MBImageNamed(NSString *imageName) {
    if (MBIsIPhone5()) {
        if ([[imageName lowercaseString] hasSuffix:@".png"] ||
            [[imageName lowercaseString] hasSuffix:@".jpg"] ||
            [[imageName lowercaseString] hasSuffix:@".gif"]) {
            NSString *name = [NSString stringWithFormat:@"%@-568h@2x%@",
                              [imageName substringToIndex:(imageName.length - 4)],
                              [imageName substringFromIndex:(imageName.length - 4)]];
            UIImage *image = [UIImage imageNamed:name];
            if (image) {
                return image;
            }
        }
    }
    return [UIImage imageNamed:imageName];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
void MBHUD(NSString *message, float time){
    [BOCProgressHUD showHUDViewTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view]
                           image:nil
                            text:message
                    timeInterval:time];
}