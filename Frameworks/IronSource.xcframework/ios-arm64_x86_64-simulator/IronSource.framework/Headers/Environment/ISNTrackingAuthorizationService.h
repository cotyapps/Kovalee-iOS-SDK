//
//  ISNTrackingAuthorizationService.h
//  Environment
//
//  Created by Tomer Ben-Rachel on 22/08/2020.
//  Copyright © 2020 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kAppTransparencyTrackingManagerClass = @"ATTrackingManager";
static NSString * const kSKAdNetworkUserTrackingDescrpitionPlistKey = @"NSUserTrackingUsageDescription";
static NSString * const kAppTransparencyFrameworkPathPhysicalDevice = @"/System/Library/Frameworks/AppTrackingTransparency.framework/AppTrackingTransparency";
static NSString * const kAppTransparencyTrackingManagerAuthorizationStatusMethod = @"trackingAuthorizationStatus";

@interface ISNTrackingAuthorizationService : NSObject

+ (ISNTrackingAuthorizationService*)sharedService;

/**
 * @abstract Gathers the authorization status of the user for being tracked (uses reflection)
 * @return A NSNumber object - in case of using this API in OS versions lower than 14, the API will return a NIL object
 */

- (NSNumber*)getAuthorizationStatus;
+ (BOOL)isAppTransparencyFrameworkLoaded;
+ (BOOL)loadAppTransparencyFramework;

@end
