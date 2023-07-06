//
//  ISRewardedVideoAdapterProtocol.h
//  IronSource
//
//  Created by Roni Parshani on 10/12/14.
//  Copyright (c) 2014 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISRewardedVideoAdapterDelegate.h"

@class ISAdapterConfig;
@protocol ISRewardedVideoAdapterProtocol <NSObject>

@optional

- (BOOL)hasRewardedVideoWithAdapterConfig:(ISAdapterConfig *)adapterConfig;

- (void)showRewardedVideoWithViewController:(UIViewController *)viewController
                              adapterConfig:(ISAdapterConfig *)adapterConfig
                                   delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

#pragma mark - for traditional, non bidders

- (void)initRewardedVideoWithUserId:(NSString *)userId
                      adapterConfig:(ISAdapterConfig *)adapterConfig
                           delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)initRewardedVideoWithUserId:(NSString *)userId
                      adapterConfig:(ISAdapterConfig *)adapterConfig
                             adData:(NSDictionary *)adData
                           delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)initAndLoadRewardedVideoWithUserId:(NSString *)userId
                             adapterConfig:(ISAdapterConfig *)adapterConfig
                                  delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)initAndLoadRewardedVideoWithUserId:(NSString *)userId
                             adapterConfig:(ISAdapterConfig *)adapterConfig
                                    adData:(NSDictionary *)adData
                                  delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)initRewardedVideoForCallbacksWithUserId:(NSString *)userId
                                  adapterConfig:(ISAdapterConfig *)adapterConfig
                                       delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)fetchRewardedVideoForAutomaticLoadWithAdapterConfig:(ISAdapterConfig *)adapterConfig
                                                   delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)fetchRewardedVideoForAutomaticLoadWithAdapterConfig:(ISAdapterConfig *)adapterConfig
                                                     adData:(NSDictionary *)adData
                                                   delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

#pragma mark - for bidders

- (NSDictionary *)getRewardedVideoBiddingDataWithAdapterConfig:(ISAdapterConfig *)adapterConfig;

- (NSDictionary *)getRewardedVideoBiddingDataWithAdapterConfig:(ISAdapterConfig *)adapterConfig
                                                        adData:(NSDictionary *)adData;

- (void)collectRewardedVideoBiddingDataWithAdapterConfig:(ISAdapterConfig *)adapterConfig
                                                  adData:(NSDictionary *)adData
                                                delegate:(id<ISBiddingDataDelegate>)delegate;

- (void)initRewardedVideoForBiddingWithUserId:(NSString *)userId
                                adapterConfig:(ISAdapterConfig *)adapterConfig
                                     delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)loadRewardedVideoForBiddingWithAdapterConfig:(ISAdapterConfig *)adapterConfig
                                          serverData:(NSString *)serverData
                                            delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)loadRewardedVideoForBiddingWithAdapterConfig:(ISAdapterConfig *)adapterConfig
                                              adData:(NSDictionary *)adData
                                          serverData:(NSString *)serverData
                                            delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

#pragma mark - for demand only

- (void)initRewardedVideoForDemandOnlyWithUserId:(NSString *)userId
                                   adapterConfig:(ISAdapterConfig *)adapterConfig
                                        delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)loadRewardedVideoForDemandOnlyWithAdapterConfig:(ISAdapterConfig *)adapterConfig
                                               delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

- (void)loadRewardedVideoForDemandOnlyForBiddingWithAdapterConfig:(ISAdapterConfig *)adapterConfig
                                                       serverData:(NSString *)serverData
                                                         delegate:(id<ISRewardedVideoAdapterDelegate>)delegate;

@end
