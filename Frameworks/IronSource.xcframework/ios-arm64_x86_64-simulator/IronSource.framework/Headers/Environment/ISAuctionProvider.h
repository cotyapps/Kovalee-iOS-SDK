//
//  ISAuctionProvider.h
//  Environment
//
//  Created by Hadar Pur on 22/06/2021.
//  Copyright © 2021 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class is a wrapper between the mediation and global data as held in the global data manager.
// The purpose is to recieve all the data that is related to the auction request from the global data manager,
// in the related format (such as meta data)
@interface ISAuctionProvider : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedInstance;

- (NSDictionary *)getAuctionData;

@end

