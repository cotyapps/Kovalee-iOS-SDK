//
//  SSEOrientation.h
//  Environment
//
//  Created by yossi mozgerashvily on 10/20/15.
//  Copyright © 2015 Supersonic. All rights reserved.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISOrientationData.h"

@interface SSEOrientationContext : NSObject
+ (ISOrientationData*)applicationOrientationData;
+ (NSInteger)orientationLockedState;

/* returns UIInterfaceOrientationMask of the viewController, otherwise returns -1 */
+ (UIInterfaceOrientationMask)supportedOrientationForViewController:(UIViewController*)viewController;
+ (UIInterfaceOrientationMask)windowOrientation;
@end

