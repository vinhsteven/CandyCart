//
//  AppDelegate.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "AppDelegate.h"

#import "LaunchViewController.h"

@implementation NSData (AES)

- (NSString *)hexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}

@end

@implementation AppDelegate

//static NSString *url = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MainUrl"];
static NSString *couchDBURL = @"http://128.199.195.111";
static NSString *usernameAuthorizeCouchDB = nil;
static NSString *passwordAuthorizeCouchDB = nil;

#define KEY_AUT @"gd23aDs"

+ (AppDelegate *) instance {
	return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

+ (NSString*) getCouchDBUrl {
    return couchDBURL;
}

-(NSString*)getUrl{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"MainUrl"];
}

+ (NSString*) getUsernameAuthorizeCouchDB {
    return usernameAuthorizeCouchDB;
}

+ (NSString*) getPasswordAuthorizeCouchDB {
    return passwordAuthorizeCouchDB;
}

+ (NSString*) getDecryptedData:(NSString*)_hexString {
    NSError *error;
    NSData *newEncryptedData = [NSData dataFromHexString:_hexString];
    
    NSData *decryptedData = [RNDecryptor decryptData:newEncryptedData
                                        withPassword:KEY_AUT
                                               error:&error];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (NSString*) convertToThousandSeparator:(NSString*)_value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@"."];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@","];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *theString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[_value doubleValue]]];
    return theString;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [RevMobAds startSessionWithAppID:@"53493adc93963767642e90ff"];
//    [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;
    
    if([[DeviceClass instance] getOSVersion] == iOS7)
    {
        [NUISettings initWithStylesheet:@"CandyTheme_iOS7.NUI"];
    }
    else
    {
        [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
        [NUISettings initWithStylesheet:@"CandyTheme_iOS6.NUI"];
    }
    [NUIAppearance init];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //get account to authorize couchdb webservice
    NSMutableDictionary *settingDict = [NSMutableDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://nhuanquang.com/Setting.plist"]];
    
    usernameAuthorizeCouchDB = [settingDict objectForKey:@"username"];
    passwordAuthorizeCouchDB = [settingDict objectForKey:@"password"];
    
    LaunchViewController *launchView;
    //Create Launch ViewController
    launchView = [[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = launchView;
    [[MainViewClass instance] setRootViewController: self.window.rootViewController ];
    [[MainViewClass instance] setMainWindow:self.window];
    [self.window makeKeyAndVisible];
    
    
    [[MainViewClass instance] setLaunchOption:launchOptions];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    
//    [[RevMobAds session] showFullscreen];
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideBanner) userInfo:nil repeats:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) hideBanner {
    [[RevMobAds session] hideBanner];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	

#if !TARGET_IPHONE_SIMULATOR
    
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.didRegisterForRemoteNotification", NULL);
    dispatch_async(queue, ^(void) {
        [[DataService instance] updatePushNotification:[[DeviceClass instance] getUUID] pushtoken:deviceToken];
    });
#endif
    
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    NSLog(@"Warning : Memory Low");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
#if !TARGET_IPHONE_SIMULATOR
    NSLog(@"Got msgggg");
    //we handle all message inside class.. view more in PushedMsgClass.m
    [[PushedMsgClass instance] getPushNotificationMessage:userInfo needReloadRightView:YES];
#endif
}



@end
