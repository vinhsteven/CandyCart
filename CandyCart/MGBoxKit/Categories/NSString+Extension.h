//
//  FMSServerAPI.h
//  FMS
//
//  Created by Steven on 10/19/13.
//  Copyright (c) 2013 QGSVN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)append:(NSString *)aString;
- (NSString *)prepend:(NSString *)aString;
- (NSArray *)split:(NSString *)aString;
- (NSArray *)split;
- (NSString *)MD5;

@end
