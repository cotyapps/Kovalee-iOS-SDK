//
//  ISGlobalDataWriter.h
//  Environment
//
//  Created by Asaf Gur on 12/06/2021.
//  Copyright © 2021 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISGlobalDataWriter : NSObject

- (void)setInitialData;

- (void)setData:(id)value
         forKey:(NSString *)key;

- (void)setData:(NSDictionary *)data;

- (void)extendData:(NSDictionary *)data
            forKey:(NSString *)objToExtend;

@end
