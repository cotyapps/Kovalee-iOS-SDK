//
//  SSEDeviceContext.h
//  RewardedVideo
//
//  Created by yossi mozgerashvily on 10/19/15.
//  Copyright © 2015 Supersonic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSEDeviceContext : NSObject

+ (SSEDeviceContext*) defaultDeviceContext;

@property (nonatomic, strong) NSString*     deviceOSName;
@property (nonatomic, strong) NSString*     deviceOSVersion;
@property (nonatomic, strong) NSString*     deviceModel;
@property (nonatomic, strong) NSString*     deviceOEM;

@end
