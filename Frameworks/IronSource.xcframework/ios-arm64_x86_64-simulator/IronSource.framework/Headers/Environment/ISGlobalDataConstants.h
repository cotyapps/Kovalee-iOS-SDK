//
//  ISGlobalDataConstants.h
//  Environment
//
//  Created by Asaf Gur on 27/05/2021.
//  Copyright © 2021 ironSource. All rights reserved.
//
//

#ifndef ISGlobalDataConstants
#define ISGlobalDataConstants

// Token
static NSString * const kGD_DeviceAPILevelKey                     = @"apilvl";
static NSString * const kGD_ApplicationVersionKey                 = @"apv";

static NSString * const kGD_BatteryLevelKey                       = @"bat";
static NSString * const kGD_BundleIdKey                           = @"bid";

static NSString * const kGD_CellularNetworkTypeKey                = @"cnt";
static NSString * const kGD_ChinaCDNKey                           = @"cncdn";
static NSString * const kGD_ConnectionTypeKey                     = @"connt";
static NSString * const kGD_ConrollerGenericParams                = @"ctgp";

static NSString * const kGD_DiskFreeSpaceKey                      = @"dfs";

static NSString * const kGD_IDEKey                                = @"ide";
static NSString * const kGD_IDFAKey                               = @"idfa";
static NSString * const kGD_IDFVKey                               = @"idfv";

static NSString * const kGD_DeviceLanguageKey                     = @"lang";
static NSString * const kGD_IsLimitedAdTrackingKey                = @"lat";

static NSString * const kGD_DeviceMakeKey                         = @"make";
static NSString * const kGD_MetaDataKey                           = @"md";
static NSString * const kGD_MediationSDKVersionKey                = @"medv";
static NSString * const kGD_DeviceModelKey                        = @"model";

static NSString * const kGD_DeviceOSKey                           = @"os";
static NSString * const kGD_DeviceOSVersionKey                    = @"osv";
static NSString * const kGD_OMIDPartnerVersionKey                 = @"ompv";
static NSString * const kGD_OMIDVersionKey                        = @"omv";
static NSString * const kGD_AppOrientationKey                     = @"apor";

static NSString * const kGD_PluginTypeKey                         = @"plugin";

static NSString * const kGD_DeviceHeightKey                       = @"scrnh";
static NSString * const kGD_DeviceWidthKey                        = @"scrnw";
static NSString * const kGD_SessionDepthISKey                     = @"sdia";
static NSString * const kGD_SessionDepthRVKey                     = @"sdra";
static NSString * const kGD_SessionDepthBNKey                     = @"sdba";
static NSString * const kGD_SDKVersionKey                         = @"sdkv";
static NSString * const kGD_SessionIdKey                          = @"sid";
static NSString * const kGD_ScreenScaleKey                        = @"sscl";

static NSString * const kGD_TokenVersionKey                       = @"tkv";

static NSString * const kGD_DeviceVolumeKey                       = @"vol";


// Token - const values
static NSString * const kGD_TokenVersionValue                     = @"2.0";

// Auction
static NSString * const kGD_AdUnitKey                             = @"adu";

static NSString * const kGD_BannerDataKey                         = @"bndt";
static NSString * const kGD_BannerSizeKey                         = @"bns";
static NSString * const kGD_BannerWidthKey                        = @"bnw";
static NSString * const kGD_BannerHeightKey                       = @"bnh";
static NSString * const kGD_BiddingAdditionalDataKey              = @"badt";

static NSString * const kGD_ClientDataKey                         = @"ctdt";
static NSString * const kGD_CVClientValueKey                      = @"cval";
static NSString * const kGD_CVClientTimestampKey                  = @"cvtms";
static NSString * const kGD_ConverstionValueDataKey               = @"cvdt";

static NSString * const kGD_DoNotEncryptResponseKey               = @"dner";

static NSString * const kGD_InstancesKey                          = @"inst";
static NSString * const kGD_InstanceTypeKey                       = @"instp";

static NSString * const kGD_SecureKey                             = @"scr";
static NSString * const kGD_SessionDepthKey                       = @"sd";

static NSString * const kGD_PerformanceKey                        = @"prfm";

static NSString * const kGD_ApplicationUserIdKey                  = @"usid";

static NSString * const kGD_SegmentKey                            = @"sg";


// Auction - const values
static int const kGD_InstanceTypeNonBidderValue                   = 1;
static int const kGD_InstanceTypeBidderValue                      = 2;
static int const kGD_CVClientTimeframeValue                       = 1440; // 24 hours in minutes

// Shared
static NSString * const kGD_EmptyString                           = @"";

static NSString * const kGD_AuctionDataKey                        = @"audt";
static NSString * const kGD_ApplicationKey                        = @"apky";
static NSString * const kGD_AuthorizationStatusKey                = @"att";
static NSString * const kGD_AuidKey                               = @"auid";

static NSString * const kGD_BtKey                                 = @"bt";

static NSString * const kGD_MobileCarrierKey                      = @"carrier";
static NSString * const kGD_ConsentKey                            = @"cnst";

static NSString * const kGD_FirstSessionKey                       = @"fs";
static NSString * const kGD_FisrtSessionTimestampKey              = @"fst";

static NSString * const kGD_IsoCountryCodeKey                     = @"icc";

static NSString * const kGD_LocalTimeKey                          = @"ltime";
static NSString * const kGD_LowPowerModeKey                       = @"lpm";

static NSString * const kGD_MobileCountryCodeKey                  = @"mcc";
static NSString * const kGD_MobileNetworkCodeKey                  = @"mnc";

static NSString * const kGD_SkanKey                               = @"skd";

static NSString * const kGD_TokenGenericParamsKey                 = @"tkgp";
static NSString * const kGD_TimezoneIdKey                         = @"tz";
static NSString * const kGD_TimezoneOffsetKey                     = @"tzoff";

static NSString * const kGD_BrowserUserAgentKey                   = @"ua";
static NSString * const kGD_UtKey                                 = @"ut";
static NSString * const kGD_UtsKey                                = @"uts";
static NSString * const kGD_ITPKey                                = @"itp";

static NSString * const kGD_TcaKey                                = @"tca";
static NSString * const kGD_TcsKey                                = @"tcs";

static NSString * const kGD_DemandOnly                            = @"do";
static NSString * const kGD_OneFlow                               = @"eof";

//  Global data manager keys (for internal usage only)
static NSString * const kGD_NetworksSkan                          = @"allnetworkskan";
static NSString * const kGD_BrowserUserAgentSharedPref            = @"browserUserAgent";
static NSString * const kGD_IronSourceSkan                        = @"ironsourceskan";

// Network debug params
static NSString * const kGD_NetworkDebugKey                       = @"debug";

#endif /* ISGlobalDataConstants */
