//
//  TokenMinimizedConstants.h
//  Environment
//
//  Created by Tomer Ben-Rachel on 09/06/2020.
//  Copyright © 2020 ironSource. All rights reserved.
//

//SDK5 Minimized Token Keys
static NSString * const kOMID_Version_Key_Minimized = @"omidV";
static NSString * const kOMID_Partner_Version_Key_Minimized = @"omidPV";
static NSString * const kAppOrientation_Minimized = @"appOr";
static NSString * const kSDKVersion_Minimized = @"sdkV";
static NSString * const kScreenScale_Minimized = @"dScrenScle";
static NSString * const kDisplaySizeWidth_Minimized = @"dSizeW";
static NSString * const kDisplaySizeHeight_Minimized = @"dSizeH";
static NSString * const kDeviceVolume_Minimized = @"dVol";
static NSString * const kTimezoneOffset_Minimized = @"tzOff";
static NSString * const kChinaCDNKey_Minimized = @"cnaCDN";
static NSString * const kIphoneAppOnIpadDevice_Minimized = @"phneAppOnIpd";
static NSString * const kAllowArbitraryLoads_Minimized = @"alwArbLds";
static NSString * const kAllowArbitraryLoadsInWebContent_Minimized = @"alwArbLdsInWbCntnt";

static NSString * const kOMID_Version_Key_Token = @"omidVersion";
static NSString * const kOMID_Partner_Version_Key_Token = @"omidPartnerVersion";
static NSString * const kAppOrientation_Token = @"appOrientation";
static NSString * const kSDKVersion_Token = @"SDKVersion";
static NSString * const kScreenScale_Token = @"deviceScreenScale";
static NSString * const kDisplaySizeWidth_Token = @"displaySizeWidth";
static NSString * const kDisplaySizeHeight_Token = @"displaySizeHeight";
static NSString * const kDeviceVolume_Token = @"deviceVolume";
static NSString * const kTimezoneOffset_Token = @"timezoneOffset";
static NSString * const kChinaCDNKey_Token = @"chinaCDN";
static NSString * const kIphoneAppOnIpadDevice_Token = @"iphoneAppOnIpadDevice";
static NSString * const kAllowArbitraryLoads_Token = @"allowArbitraryLoads";
static NSString * const kAllowArbitraryLoadsInWebContent_Token = @"allowArbitraryLoadsInWebContent";

static NSString * const kDeviceOEM_Token = @"deviceOEM";
static NSString * const kDeviceModel_Token = @"deviceModel";
static NSString * const kDeviceOS_Token = @"deviceOs";
static NSString * const kDeviceOSVersion_Token = @"deviceOSVersion";
static NSString * const kDeviceApiLevel_Token = @"deviceApiLevel";
static NSString * const kConnectionType_Token = @"connectionType";
static NSString * const kDeviceIdsIFA_Token = @"deviceIds[IFA]";
static NSString * const kDeviceIdsIDFV_Token = @"deviceIds[IDFV]";
static NSString * const kMobileCarrier_Token = @"mobileCarrier";
static NSString * const kDiskFreeSize_Token = @"diskFreeSize";
static NSString * const kLocalTime_Token = @"localTime";
static NSString * const kBundleId_Token = @"bundleId";
static NSString * const kUserGender_Token = @"applicationUserGender";
static NSString * const kSdkPluginType_Token = @"SDKPluginType";
static NSString * const kUserAgeGroup_Token = @"applicationUserAgeGroup";
static NSString * const kAppVersion_Token = @"appVersion";
static NSString * const kMetaData_Token = @"metadata";
static NSString * const kIsLimitAdTrackingEnabled_Token = @"isLimitAdTrackingEnabled";
static NSString * const kDeviceLanguage_Token = @"deviceLanguage";
static NSString * const kApplicationUserId_Token = @"applicationUserId";
static NSString * const kAppKey_Token = @"applicationKey";

// keys used both by sdk5 and sdk7
static NSString * const kAuthorizationStatus = @"att";
static NSString * const kAuthorizationStatus_Minimized = @"att";

//SDK7 Minimized Token Keys
static NSString * const kUserAge_Minimized = @"uAge";
static NSString * const kAdvertisingId_Minimized = @"advId";
static NSString * const kApplicationKey_Minimized = @"appKey";
static NSString * const kMobileCarrier_Minimized = @"mCar";
static NSString * const kMediationSDKVersion_Minimized = @"medV";
static NSString * const kConnectionType_Minimized = @"connT";
static NSString * const kDeviceWidth_Minimized = @"dWidth";
static NSString * const kDeviceHeight_Minimized = @"dHeight";
static NSString * const kDeviceModel_Minimized = @"dModel";
static NSString * const kClientTimestamp_Minimized = @"cTime";
static NSString * const kSessionDepthRV_Minimized = @"sDepRV";
static NSString * const kSessionDepthIS_Minimized = @"sDepIS";
static NSString * const kSessionId_Minimized = @"sId";
static NSString * const kPluginType_Minimized = @"plType";
static NSString * const kDeviceOSVersion_Minimized = @"dOSV";
static NSString * const kDeviceOS_Minimized = @"dOS";
static NSString * const kDeviceMake_Minimized = @"dMake";
static NSString * const kDeviceAPILevel_Minimized = @"dAPI";
static NSString * const kBundleId_Minimized = @"bId";
static NSString * const kApplicationVersion_Minimized = @"appV";
static NSString * const kApplicationUserId_Minimized = @"usId";
static NSString * const kDiskFreeSpace_Minimized = @"diskFS";
static NSString * const kDeviceLanguage_Minimized = @"dLang";
static NSString * const kMetaData_Minimized = @"MD";
static NSString * const kUserGender_Minimized = @"uGen";
static NSString * const kAdvertisingIdType_Minimized = @"advType";
static NSString * const kIsLimitedAdTracking_Minimized = @"isLAT";
static NSString * const kIDE_Minimized = @"ide";
static NSString * const kConsent_Token = @"consent";
static NSString * const kAppUserId_Minimized = @"auid";
static NSString * const kSkan_Minimized = @"skd";
static NSString * const kBrowserUserAgent_Minimized = @"UA";

static NSString * const kMetaDataKeyPrefix = @"metadata_";

static NSString * const kiOSKeyword = @"ios";
static NSString * const kAppleKeyword = @"Apple";

@interface TokenConstants : NSObject

+ (NSArray *) DefaultPlayerTokenKeysToPassInExternalMediation;

+ (NSDictionary *) MinimizedTokenKeyName;

@end

