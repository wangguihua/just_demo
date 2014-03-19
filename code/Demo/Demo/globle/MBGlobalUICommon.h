//
//  ESGlobalUICommon.h
//  DandelionPhone
//
//  Created by Tracy E on 12-11-30.
//  Copyright (c) 2012 China M-World Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @return the current runtime version of the iOS.
 */
float MBOSVersion();

/**
 * @return TRUE if the keyboard is visible.
 */
BOOL MBIsKeyboardVisible();

/**
 * @return TRUE if the network status is online.
 */
BOOL MBIsNetworkStatusOnline();

/**
 * @return TRUE if the device is jailbrken.
 */
BOOL MBIsDeviceJailbroken();

/**
 * @return TRUE if the device supports backgrounding
 */
BOOL MBIsMultiTaskingSupported();

/**
 * @return TRUE if the device is iPad.
 */
BOOL MBIsPad();

/**
 * @return the current device orientation.
 */
UIDeviceOrientation MBDeviceOrientation();

/**
 * @return TRUE if the current device orientation is portrait or portrait upside down.
 */
BOOL MBDeviceOrientationIsPortrait();

/**
 * @return TRUE if the current device orientation is landscape left, or landscape right.
 */
BOOL MBDeviceOrientationIsLandscape();

/**
 * @return the application frame with no offset.
 *
 * From the Apple docs:
 * Frame of application screen area in points (i.e. entire screen minus status bar if visible)
 */
CGRect MBApplicationFrame();

/**
 * A convenient way to show a UIAlertView with a message.
 */
void MBAlert(NSString *message);

/**
 * Same as TTAlert but the alert view has no title.
 */
void MBAlertNoTitle(NSString* message);

/**
 * Same as MBAlert but the alert view has delegate.
 */
void MBAlertWithDelegate(NSString* message, id delegate);

/**
 * return TRUE if device is iPhone5.
 */
BOOL MBIsIPhone5();

/**
 * return image according the name & deivce.
 * Default.png  Default@2x.png  Default-586h@2x.png
 */
UIImage* MBImageNamed(NSString *imageName);

/**
 *  A convenient way to show a MBProgressHUD with a message.
 */
void MBHUD(NSString *message, float time);
