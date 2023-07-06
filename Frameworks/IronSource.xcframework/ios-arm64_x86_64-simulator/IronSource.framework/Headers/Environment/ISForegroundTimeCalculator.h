//
//  ISForegroundTimeCalculator.h
//  Environment
//
//  Created by maoz.elbaz on 02/09/2021.
//  Copyright © 2021 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ISForegroundTimeCalculator : NSObject



- (instancetype)initWithTarget:(id)target
                            selector:(SEL)selector;


- (void)startNow;


@end


NS_ASSUME_NONNULL_END
