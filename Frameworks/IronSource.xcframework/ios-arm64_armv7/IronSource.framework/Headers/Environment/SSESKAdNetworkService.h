//
//  SSESKAdNetworkService.h
//  Environment
//
//  Created by Guy Lis on 23/07/2020.
//  Copyright © 2020 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kSKAdNetworkItemsPlistKey = @"SKAdNetworkItems";
static NSString * const kSKAdNetworkIdPlistKey = @"SKAdNetworkIdentifier";

@interface SSESKAdNetworkService : NSObject

// property for determining whether to use idfv in the mediation/network by default true
@property (nonatomic, assign) BOOL shouldUseIdfv;

+ (SSESKAdNetworkService*)sharedService;

+ (NSSet*)collectNetworkIdsFromPlist;

@end

NS_ASSUME_NONNULL_END
