//
//  ISOrientationData.h
//  Environment
//
//  Created by Adi Oz on 17/01/2018.
//  Copyright © 2018 Supersonic. All rights reserved.
//

#ifndef ISOrientationData_h
#define ISOrientationData_h

#import <UIKit/UIDevice.h>
#import <UIKit/UIApplication.h>

@interface ISOrientationData : NSObject

@property (nonatomic) UIDeviceOrientation currentDeviceOrientation; //device orientation
@property (nonatomic) NSArray* plistOrientation; //application orientation (plist)
@property (nonatomic) UIInterfaceOrientationMask windowOrientation; //presented window orientation
@property (nonatomic) UIInterfaceOrientationMask topMostViewControllerOrientation; //presented view controller orientation
@property (nonatomic) BOOL topMostViewControllerShouldAutorotate; //presented view controller shouldAutorotate value
@property (nonatomic) UIInterfaceOrientation preferredInterfaceOrientationForPresentation; //preferred interface orientation
@property (nonatomic) UIInterfaceOrientation statusBarOrientation; //status bar orientation
@property (nonatomic) BOOL isWindowOrientationOverrided; //status bar orientation
@end
#endif /* ISOrientationData_h */
