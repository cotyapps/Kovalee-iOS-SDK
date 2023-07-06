//
//  ISInitProvider.h
//  Environment
//
//  Created by Hadar Pur on 26/09/2021.
//  Copyright © 2021 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class is a wrapper between the mediation and global data as held in the global data manager.
// The purpose is to recieve all the data that is related to the init request from the global data manager
@interface ISInitProvider : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedInstance;

- (NSDictionary *)getInitData;

@end

