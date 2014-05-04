//
//  FMSServerAPI.m
//  FMS
//
//  Created by Steven on 10/19/13.
//  Copyright (c) 2013 QGSVN. All rights reserved.
//

#import "NSData+Extension.h"

@implementation NSData (Extension)

- (NSString*) stringWithHexBytes {
	NSMutableString *stringBuffer = [NSMutableString
									 stringWithCapacity:([self length] * 2)];
	const unsigned char *dataBuffer = [self bytes];
	int i;
	
	for (i = 0; i < [self length]; ++i)
		[stringBuffer appendFormat:@"%02lX", (unsigned long)dataBuffer[ i ]];
	
	return [stringBuffer copy];
}

- (NSString*)toString
{
    NSString *ret = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return [ret copy];
}

- (NSDictionary*)jsonStringToDictionary
{
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:self
                                                                   options:0
                                                                     error:&error];
    if (error) {
        return nil;
    }
    
    return jsonDictionary;
}

@end
