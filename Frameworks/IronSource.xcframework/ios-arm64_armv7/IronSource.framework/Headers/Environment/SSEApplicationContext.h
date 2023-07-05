//
//  SSEApplicationContext.h
//  RewardedVideo
//
//  Created by yossi mozgerashvily on 10/19/15.
//  Copyright © 2015 Supersonic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSEOrientationContext.h"

@interface SSEApplicationContext : NSObject

+ (SSEApplicationContext*) defaultApplicationContext;

+ (NSDictionary *)dictionaryForAppTransportSecurityFlag;

+ (NSObject*) getAllowsArbitraryLoadsFlagInATS;

+ (NSObject*) getAllowsArbitraryLoadsInWebContentFlagInATS;

+ (NSString*) getAppVersion;

+(BOOL)isUIViewControllerBasedStatusBarAppearanceFlagSetToNo;

@property NSString* applicationBundleId;
@property NSString* filePathCacheDirectory;

@end
