//
//  FileSaveArrayClass.h
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/5/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSaveArrayClass : NSObject

+ (FileSaveArrayClass *) instance;
//Public Method
-(void)saveNSMutableDictionaryAsFile:(NSMutableDictionary*)array initWithFileName:(NSString*)fileName;
-(void)saveNSArrayAsFile:(NSArray*)array initWithFileName:(NSString*)fileName;
-(void)saveNSMutableArrayAsFile:(NSMutableArray*)array initWithFileName:(NSString*)fileName;

-(NSMutableDictionary*)getNSMutableDictionaryFile:(NSString*)fileName;
-(NSArray*)getNSArrayFile:(NSString*)fileName;
-(NSMutableArray*)getNSMutableArrayFile:(NSString*)fileName;

-(void)deleteArrayFile:(NSString*)fileName;
-(BOOL)checkFileIfExists:(NSString*)fileName;
@end
