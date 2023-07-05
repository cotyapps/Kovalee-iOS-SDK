//
//  ISLifeCycleSensitiveTimer.h
//  Environment
//
//  Created by Guy Lis on 20/10/2020.
//  Copyright © 2020 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 a timer sensitive to the app lifecycle that considers the time the app is in the background (the timer will not fire while in the background)
 for a timer that considers the time interval only when the app is in the foreground, use NSTimer
 once the timer fires, in order to use it again, either call invalidate first or call initWithTimeInterval to reinitialize it
 */
@interface ISLifeCycleSensitiveTimer : NSObject


/*
 initialize the timer
    - timeInterval: the time interval,
    - target: the target for running the selector when the timer fires
    - selector: the selector for running by the target when the timer fires
    - startNow: whether to start the timer immediately
 
 */
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval
                              target:(id)target
                            selector:(SEL)selector
                            startNow:(BOOL)startNow;
/*
 start the timer if it has not already started
 can only be run once
 in order to run again, either invalidate the timer or call initWithTimeInterval once again
 */

- (void)startNow;

/*
 invalidate the timer
 */
- (void) invalidate;

/*
 checking whether the timer is valid
 */
- (BOOL) isValid;
@end


NS_ASSUME_NONNULL_END
