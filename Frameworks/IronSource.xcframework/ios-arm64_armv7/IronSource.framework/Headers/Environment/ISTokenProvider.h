//
//  ISTokenProvider.h
//  Environment
//
//  Created by Asaf Gur on 20/06/2021.
//  Copyright © 2021 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

// This classe is to create a wrapper between the mediation tnd global data.
// The purpose is to reciev all the data that related to the get token api from the global data manager,
// with the related format (such as meta data)
@interface ISTokenProvider : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedInstance;

- (NSDictionary *)getToken;

@end
