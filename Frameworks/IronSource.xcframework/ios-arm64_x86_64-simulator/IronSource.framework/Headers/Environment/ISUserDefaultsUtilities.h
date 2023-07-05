//
//  ISUserDefaultsUtilities.h
//  Environment
//
//  Created by Hadar Pur on 15/03/2021.
//  Copyright © 2021 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ISUserDefaultsUtilities : NSObject

+(void)saveStringToUserDefaultsWithKey:(nonnull NSString *)key andValue:(nonnull NSString *)value;
+(NSString *)getStringFromUserDefaultsWithKey:(nonnull NSString *)key defaultValue:(nonnull NSString *)defaultValue;
+(nullable NSString *)getStringFromUserDefaultsWithKey:(nonnull NSString *)key;

+(void)saveBoolToUserDefaultsWithKey:(nonnull NSString *)key andValue:(BOOL)value;
+(BOOL)getBoolFromUserDefaultsWithKey:(nonnull NSString *)key;

+(void)saveNumberToUserDefaultsWithKey:(nonnull NSString *)key andValue:(nonnull NSNumber *)value;
+(NSNumber *)getNumberFromUserDefaultsWithKey:(nonnull NSString *)key;

+(void)removeObjectForKey:(nonnull NSString *)key;
+(BOOL)hasObjectForKey:(nonnull NSString *)key;

@end

NS_ASSUME_NONNULL_END
