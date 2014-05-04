//
//  FileSaveArrayClass.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/5/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "FileSaveArrayClass.h"

@implementation FileSaveArrayClass

+ (FileSaveArrayClass *) instance {
    static FileSaveArrayClass *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)saveNSMutableDictionaryAsFile:(NSMutableDictionary*)array initWithFileName:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [array writeToFile:yourArrayFileName atomically:YES];
    
    
}


-(void)saveNSArrayAsFile:(NSArray*)array initWithFileName:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [array writeToFile:yourArrayFileName atomically:YES];
    
    
}


-(void)saveNSMutableArrayAsFile:(NSMutableArray*)array initWithFileName:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [array writeToFile:yourArrayFileName atomically:YES];
    
    
}


-(NSMutableDictionary*)getNSMutableDictionaryFile:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //Load the array
    NSMutableDictionary *tempStringArray = [[NSMutableDictionary alloc] initWithContentsOfFile: yourArrayFileName];
    
    return tempStringArray;
}

-(NSArray*)getNSArrayFile:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //Load the array
    NSArray *tempStringArray = [[NSArray alloc] initWithContentsOfFile: yourArrayFileName];
    
    return tempStringArray;
}





-(NSMutableArray*)getNSMutableArrayFile:(NSString*)fileName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //Load the array
    NSMutableArray *tempStringArray = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    
    return tempStringArray;
}

-(void)deleteArrayFile:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [[NSFileManager defaultManager] removeItemAtPath: yourArrayFileName error: nil];
}


-(BOOL)checkFileIfExists:(NSString*)fileName{
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    if(fileExists == YES)
    {
        
        
        return YES;
    }
    else
    {
        return NO;
    }
    
    
}





@end
