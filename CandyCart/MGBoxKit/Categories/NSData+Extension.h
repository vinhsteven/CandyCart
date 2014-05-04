//
//  FMSServerAPI.h
//  FMS
//
//  Created by Steven on 10/19/13.
//  Copyright (c) 2013 QGSVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extension)

- (NSString*)stringWithHexBytes;
- (NSString*)toString;
- (NSDictionary*)jsonStringToDictionary;

@end
