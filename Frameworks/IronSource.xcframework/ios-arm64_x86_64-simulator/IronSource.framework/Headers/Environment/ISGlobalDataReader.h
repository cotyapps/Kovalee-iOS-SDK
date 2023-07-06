//
//  ISGlobalDataReader.h
//  Environment
//
//  Created by Asaf Gur on 14/06/2021.
//  Copyright © 2021 ironSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISGlobalDataReader : NSObject

- (NSDictionary *)dataByKeys:(NSArray<NSString *> *)keys;

@end
