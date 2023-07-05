//
//  SSEDeviceStatus.h
//  RewardedVideo
//
//  Created by yossi mozgerashvily on 10/19/15.
//  Copyright © 2015 Supersonic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Network/SSEReachability.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSString* const kInvalidAdvertisingId        = @"00000000-0000-0000-0000-000000000000";

static NSString* const kUserIdTypeIDFV              = @"IDFV";
static NSString* const kUserIdTypeIDFA              = @"IDFA";
static NSString* const kUserIdTypeUUID              = @"UUID";
static NSString* const kXcodeVersion                = @"DTXcode";
static NSString* const kXcodeBuildVersion           = @"DTXcodeBuild";
static NSString* const kAppUserID                   = @"auid";
static NSString* const kSavedAttValue               = @"attValue";
static NSString* const kGDPRApplies                 = @"IABTCF_gdprApplies";
static NSString* const kTCString                    = @"IABTCF_TCString";

@interface SSEDeviceStatus : NSObject

@property (readonly) NSString*                      advertiserId;
@property (readonly) NSString*                      language;
@property (readonly) uint64_t                       diskFreeSizeInMegaBytes;
@property (readonly) BOOL                           isAdvertisingTrackingEnabled;
@property (readonly) NSString*                      carrier;
@property (readonly) int64_t                        localTime; //milliseconds since the 1st of January 1970
@property (readonly) NSInteger                      timezoneOffset; //offset in minutes from GMT
@property (readonly) BOOL                           jailBroken;
@property (readonly) NSString*                      systemVersion;
@property (readonly) NSNumber*                      batteryLevel;
@property (readonly) NSNumber*                      volume;
@property (readonly) NSString*                      mobileCountryCode;
@property (readonly) NSString*                      mobileNetworkCode;
@property (readonly) NSString*                      isoCountryCode;
@property (nonatomic, copy, readonly) NSString*     customUUID;
@property (readonly) NSString*                      usedAdvertisingId;
@property (readonly) NSString*                      usedAdvertisingIdType;
@property (readonly) NSString*                      xcodeVersion;
@property (readonly) NSString*                      xcodeBuildVersion;
@property (readonly) NSDictionary*                  safeAreaInsets;
@property (readonly) NSNumber*                      userInterfaceStyle;
@property (readonly) float                          brightness;
@property (readonly) NSNumber*                      systemUptime;
@property (readonly) NSNumber*                      systemFullUptime;
@property (readonly, nullable) NSNumber*            systemBootTime;
@property (readonly) NSString*                      timeZoneId;
@property (readonly) NSString*                      appUserID;
@property (readonly) BOOL                           lowPowerModeEnabled;
@property (readonly) NSString*                      platformString;
@property (readonly, nullable) NSNumber*            trackingAuthorizationStatus;

+ (UIWindow*)getKeyWindow;
- (void)setBrowserUserAgent;
- (NSString*)getBrowserUserAgent;
- (NSString*)getTCString;
- (NSNumber*)getGdprApplies;
- (nullable NSString*)getVendorIdIfAllowed;

@end

NS_ASSUME_NONNULL_END
