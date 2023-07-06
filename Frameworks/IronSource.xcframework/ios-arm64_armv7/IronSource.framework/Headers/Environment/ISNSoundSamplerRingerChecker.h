//
//  ISNSoundSamplerRingerChecker.h
//  Environment
//
//  Created by Itai Asaf on 10/12/2017.
//  Copyright © 2017 Supersonic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ISNRingerCheckerStatusChangedHandler)(BOOL silent);

@interface ISNSoundSamplerRingerChecker : NSObject

@property (nonatomic, readonly, getter=isDetecting) BOOL detecting;
@property (nonatomic, readonly, getter=isActive) BOOL activated;
@property (nonatomic, readonly, getter=isSilentOn) BOOL silentOn;
@property (atomic, copy) ISNRingerCheckerStatusChangedHandler statusHandler;

+(ISNSoundSamplerRingerChecker*)shared;

- (void)startDetecting;
- (void)stopDetecting;

@end
