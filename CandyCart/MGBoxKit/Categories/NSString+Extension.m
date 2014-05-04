//
//  FMSServerAPI.m
//  FMS
//
//  Created by Steven on 10/19/13.
//  Copyright (c) 2013 QGSVN. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

- (NSString *)append:(NSString *)aString {
    return [self stringByAppendingString:aString];
}

- (NSString *)prepend:(NSString *)aString {
    return [NSString stringWithFormat:@"%@%@", aString, self];
}

- (NSArray *)split:(NSString *)aString {
    return [self componentsSeparatedByString:aString];
}

- (NSArray *)split {
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)MD5
{
	// Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
 	// Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
	// Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
	// Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end
