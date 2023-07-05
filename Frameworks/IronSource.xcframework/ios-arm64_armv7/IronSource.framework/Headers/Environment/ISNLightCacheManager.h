//
//  ISNLightCacheManager.h
//  Environment
//
//  Created by Itai Asaf on 12/12/2017.
//  Copyright © 2017 Supersonic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISNLightCacheManager : NSObject

@property (nonatomic, strong) NSString *rootDirectoryPath;

+ (ISNLightCacheManager*)sharedInstance;
- (void)saveDataOnRootDirectory:(NSData*)data
                       fileName:(NSString*)fileName
                          error:(NSError **)error;

- (NSURL*)fileUrlForFileNameOnRootDirectory:(NSString*)fileName;

@end
