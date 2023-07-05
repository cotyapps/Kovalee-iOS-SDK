//
//  UncaughtExceptionHandler.h
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.


#import <UIKit/UIKit.h>

@interface ISUncaughtExceptionHandler : NSObject{

}
+(void)ISRegisterCrashReporter:(NSSet *) keys toURL:(NSString *) url withSessionId:(NSString *) sessionId withSDKVersion:(NSString *) SDKVersion;
@end

void ISInstallUncaughtExceptionHandler(void);
