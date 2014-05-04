//
//  DataService.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "DataService.h"
#import "AppDelegate.h"
@implementation DataService
@synthesize productCategories,productCategoriesCustom,featuredProducts,countries,recentItems,leftMenuData,pushNotifications,home_page_api,randomItems;
+ (DataService *) instance {
    static DataService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)loadAllData{
    [[UserAuth instance] checkUserAlreadyLogged];
    [self getSettings]; // load all settings
    [self getLeftMenuData];
    [self getCountries]; // load all countries start
    [self getHomePageApi];
    [self getRecentItems];
    
    dispatch_queue_t queue1 = dispatch_queue_create("com.nhuanquang.getProductCategories", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("com.nhuanquang.getProductCategoriesCustom", NULL);
    dispatch_queue_t queue3 = dispatch_queue_create("com.nhuanquang.getFeatureProducts", NULL);
    dispatch_queue_t queue4 = dispatch_queue_create("com.nhuanquang.getRandomProducts", NULL);
    dispatch_queue_t queue5 = dispatch_queue_create("com.nhuanquang.pushNotificationApi", NULL);
    dispatch_queue_t queue6 = dispatch_queue_create("com.nhuanquang.getBusinessInfo", NULL);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue1, ^{ [self getProductCategories]; });
    dispatch_group_async(group, queue2, ^{ [self getProductCategoriesCustom]; });
    dispatch_group_async(group, queue3, ^{ [self getFeaturedProducts]; });
    dispatch_group_async(group, queue4, ^{ [self getRandomProducts]; });
    dispatch_group_async(group, queue5, ^{ [self getProductCategoriesCustom]; });
    
    //get business info
    dispatch_group_async(group, queue6, ^{ [self getBusinessInfo]; });
    
#if !TARGET_IPHONE_SIMULATOR
    dispatch_queue_t queue = dispatch_queue_create("com.nhuanquang.deviceIDSend", NULL);
    dispatch_async(queue, ^(void) {
    
        //will save device ID if registered.. ignore
        [self deviceIDSend:[[DeviceClass instance] getUUID] device:[[DeviceClass instance] getDeviceModel]];
    });
    
#endif
    [self checkConnectivity];
}

- (void) getBusinessInfo {
    //get database URL of user by email or username
    NSString *decryptedUsername = [AppDelegate getDecryptedData:[AppDelegate getUsernameAuthorizeCouchDB]];
    NSString *decryptedPassword = [AppDelegate getDecryptedData:[AppDelegate getPasswordAuthorizeCouchDB]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@:3001/get_user",[AppDelegate getCouchDBUrl]];
        
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.requestMethod = @"POST";
    request.username = decryptedUsername;
    request.password = decryptedPassword;
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [request addPostValue:ROOT_ACCOUNT forKey:@"username"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
    NSString *startTime = @"00:00";
    NSString *endTime   = @"00:00";
    
    if (!error) {
        NSString *response = [request responseString];
        
        NSMutableDictionary *dict = [response JSONValue];
        
        //check status of this user
        BOOL status = [[dict objectForKey:@"status"] boolValue];
        
        if (status) {
            startTime = [dict objectForKey:@"startTime"] == nil ? @"06:00" : [dict objectForKey:@"startTime"];
            endTime = [dict objectForKey:@"endTime"] == nil ? @"21:00" : [dict objectForKey:@"endTime"];
        }
    }
    [userDefautls setObject:startTime forKey:START_WORK_HOUR];
    [userDefautls setObject:endTime forKey:END_WORK_HOUR];
}
//Check Connectivity

-(void)checkConnectivity{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if(networkStatus == NotReachable)
    {
        NoInternetViewController *noInternet = [[NoInternetViewController alloc] initWithNibName:@"NoInternetViewController" bundle:nil];
        UIWindow *window = [[MainViewClass instance] getCurrentMainWindow];
        
        window.rootViewController = noInternet;
    }
}


//Init On Load

-(void)getProductCategories{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=product-categories&parent=0",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSLog(@"Categories : %@",rawJson);
    productCategories = [rawJson JSONValue];
    
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}

-(void)getSettings{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-settings",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *settings = [rawJson JSONValue];
    
    [[SettingDataClass instance] setSetting:settings];
    
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}
-(void)updateProgressBar
{
    [[TempVariables instance] setProgressBarValue:[[TempVariables instance] onLounchProgress].progress + 0.1];
}

-(void)getHomePageApi{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=home-appearance-api",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *value = [[rawJson JSONValue] mutableCopy];
    
    NSMutableArray *itemsArray = [value objectForKey:@"items"];
    for (int i=0;i < [itemsArray count];i++) {
        NSMutableDictionary *dict = [itemsArray objectAtIndex:i];
        NSString *title = [dict objectForKey:@"title"];
        if ([title isEqualToString:@"New Items"])
            [dict setObject:NSLocalizedString(@"exploreViewController.new_items_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Featured Items"])
            [dict setObject:NSLocalizedString(@"exploreViewController.featured_items_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Discount Items"])
            [dict setObject:NSLocalizedString(@"exploreViewController.discount_items_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Services"])
            [dict setObject:NSLocalizedString(@"exploreViewController.service_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Coffee"])
            [dict setObject:NSLocalizedString(@"exploreViewController.coffee_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Other drink"])
            [dict setObject:NSLocalizedString(@"exploreViewController.other_drink_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Favorites"])
            [dict setObject:NSLocalizedString(@"exploreViewController.favorites_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Brandy"])
            [dict setObject:NSLocalizedString(@"exploreViewController.brandy_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Soft foods"])
            [dict setObject:NSLocalizedString(@"exploreViewController.soft_food_title", nil) forKey:@"title"];
        else if ([title isEqualToString:@"Drinks"])
            [dict setObject:NSLocalizedString(@"exploreViewController.drinks_title", nil) forKey:@"title"];
    }
    
    home_page_api = value;
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}


-(void)getFeaturedProducts{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-featured-product",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    
    featuredProducts = value;
//    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}


-(void)getRandomProducts{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-random-items",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    
    randomItems = value;
//    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}

-(void)getRecentItems{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-recent-items",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    recentItems = value;
    
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
    
}

-(void)getProductCategoriesCustom{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=custom-category-appearance-api",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSArray *value = [rawJson JSONValue];
    
    productCategoriesCustom = value;
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}

-(void)deviceIDSend:(NSString*)deviceID device:(NSString*)deviceName{
    
    NSString *post =[NSString stringWithFormat:@"deviceID=%@&device=%@",deviceID,deviceName];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=analytics&type=insert",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Analytics Status : %@",rawJson);
    
}

-(void)updatePushNotification:(NSString*)deviceID pushtoken:(NSString*)pushtoken{
    
    NSString *post =[NSString stringWithFormat:@"deviceID=%@&token=%@",deviceID,pushtoken];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=analytics&type=update",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Pushnotification Status : %@",rawJson);
    
}

//@pushnotification API
-(void)pushNotificationApi{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",
                     [UserAuth instance].username,
                     [UserAuth instance].password
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=notification&type=json&page=1&postPerPage=%@",[[AppDelegate instance] getUrl],PUSH_NOTTIFICATION_PERPAGE]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    pushNotifications = returnValue;
//    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}


//@Instagram API
-(NSDictionary*)getInstagramAPI:(NSString*)hashTag{
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@",hashTag,[[SettingDataClass instance] get_instagram_client_id]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    
    return value;
    
}


-(int)countInstagramHashTag:(NSString*)hashTag{
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/search?q=%@&client_id=%@",hashTag,[[SettingDataClass instance] get_instagram_client_id]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    NSArray *hashtag = [value objectForKey:@"data"];
    if([hashtag count] > 0)
    {
        NSDictionary *currentHashTag = [hashtag objectAtIndex:0];
        
        return [[currentHashTag objectForKey:@"media_count"] intValue];
    }
    else
    {
        
        return 0;
    }
}


-(NSDictionary*)getPaginationApi:(NSString*)nextUrl{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",nextUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    
    return value;
    
}



//@WP Menu API
-(void)getLeftMenuData{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=wp-menu-json-api&type=menu&slugname=CandyCartPushLeftMenu",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    leftMenuData = value;
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}



-(NSDictionary*)getBussinessDirectoryPlugin{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=wp-post-api&type=get-business-directory-listing",[[AppDelegate instance] getUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    
    return value;
    
}


//By demand @Wordpress API
-(NSDictionary*)getWpPostByPostID:(NSString*)postID{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=wp-post-api&type=get-single-post&postID=%@",[[AppDelegate instance] getUrl],postID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    return value;
}


-(NSDictionary*)getPostByCategory:(NSString*)catID currentPage:(NSString*)currentPage postPerPage:(NSString*)post_per_page{
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=wp-post-api&type=get-post-by-category-id&catID=%@&currentPage=%@&post_per_page=%@",[[AppDelegate instance] getUrl],catID,currentPage,post_per_page];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    NSDictionary *value = [rawJson JSONValue];
    
    return value;
    
}


-(NSDictionary*)get_search_post:(NSString*)keyword currentPage:(NSString*)currentPage postPerPage:(NSString*)post_per_page{
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=wp-post-api&type=search-post&keyword=%@&currentPage=%@&post_per_page=%@",[[AppDelegate instance] getUrl],keyword,currentPage,post_per_page];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    NSDictionary *value = [rawJson JSONValue];
    
    return value;
    
}



-(NSArray*)getRSSXmlData:(NSString*)RSSUrl{
    NSString *urlString = [NSString stringWithFormat:@"%@",RSSUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    RXMLElement *rxml = [RXMLElement elementFromXMLData:sa];
    
    NSMutableArray *xml = [[NSMutableArray alloc] init];
    
    [rxml iterate:@"channel.item" with: ^(RXMLElement *attribute) {
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[NSString stringWithFormat:@"%@",[attribute child:@"title"]] forKey:@"title"];
        [dic setValue:[NSString stringWithFormat:@"%@",[attribute child:@"description"]] forKey:@"description"];
        [dic setValue:[NSString stringWithFormat:@"%@",[attribute child:@"pubDate"]] forKey:@"pubDate"];
        [dic setValue:[NSString stringWithFormat:@"%@",[attribute child:@"link"]] forKey:@"link"];
        [xml addObject:dic];
        
        
    }];
    
    
    
    return [xml copy];
    
}

//@ Get Comment
-(NSDictionary*)getCommentByCommentID:(NSString*)commentID{
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-comment-by-id&commentID=%@",[[AppDelegate instance] getUrl],commentID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    NSDictionary *value = [rawJson JSONValue];
    
    return value;
    
}


//@type = follow/unfollow
-(NSDictionary*)comment_follow:(NSString*)username password:(NSString*)password commentID:(NSString*)commentID type:(NSString*)type{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&commentID=%@",
                     username,
                     password,
                     commentID
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=comment-follow&type=%@",[[AppDelegate instance] getUrl],type]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
    
}


//..................................................................

//By demand @Woocommerce API

-(NSDictionary*)getSinglePaymentGatewayMetaKey:(NSString*)key{
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=get-single-payment-gateway-meta&key=%@",[[AppDelegate instance] getUrl],key];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    NSDictionary *value = [rawJson JSONValue];
    
    return value;
    
}


-(NSArray*)getChildProductCategories:(NSString*)parentID{
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=product-categories&parent=%@",[[AppDelegate instance] getUrl],parentID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    NSArray *value = [rawJson JSONValue];
    return value;
    
}


-(NSDictionary*)getProductByCategory:(NSString*)categoryID page:(NSString*)page productPerPage:(NSString*)productPerPage{
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=product-by-category-id&id=%@&page=%@&products-per-page=%@",[[AppDelegate instance] getUrl],categoryID,page,productPerPage];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *productByCategoriesID = [rawJson JSONValue];
    
    return productByCategoriesID;
    
}


-(NSDictionary*)getProductByKeyword:(NSString*)keyword page:(NSString*)page productPerPage:(NSString*)productPerPage{
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=search-product&keyword=%@&page=%@&products-per-page=%@",[[AppDelegate instance] getUrl],keyword,page,productPerPage];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *productByKeyWord = [rawJson JSONValue];
    
    return productByKeyWord;
    
}



-(NSDictionary*)getProductReview:(NSString*)postID parent:(NSString*)parent{
    
    
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",
                     [UserAuth instance].username,
                     [UserAuth instance].password
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=comment-by-post-id&id=%@&parent=%@",[[AppDelegate instance] getUrl],postID,parent]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
}


-(NSDictionary*)getSingleProduct:(NSString*)postID{
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=single-product&id=%@",[[AppDelegate instance] getUrl],postID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSArray *singleProduct = [rawJson JSONValue];
    
    return [singleProduct objectAtIndex:0];
    
}

-(void)getCountries{
    /*
     if([[FileSaveArrayClass instance] checkFileIfExists:@"countries.dat"] == false)
     {
     NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=countries",[[AppDelegate instance] getUrl]];
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
     
     // Perform request and get JSON back as a NSData object
     NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
     
     NSArray *getCountries = [rawJson JSONValue];
     countries = getCountries;
     
     [[FileSaveArrayClass instance] saveNSArrayAsFile:countries initWithFileName:@"countries.dat"];
     }
     else
     {
     
     countries = [[FileSaveArrayClass instance] getNSArrayFile:@"countries.dat"];
     }
     */
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countriesstored" ofType:@"dat"];
    NSArray *tempStringArray = [[NSArray alloc] initWithContentsOfFile: path];
    countries = tempStringArray;
    
    [self performSelectorOnMainThread:@selector(updateProgressBar) withObject:nil waitUntilDone:NO];
}

//Post & GET Service



-(NSDictionary*)get_my_order:(NSString*)username password:(NSString*)password filter:(NSString*)filter{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&filter=%@",
                     username,
                     password,
                     filter
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=get-my-order",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
    
}

-(NSDictionary*)user_logout{
    NSString *post =[NSString stringWithFormat:@"deviceID=%@",[[DeviceClass instance] getUUID]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-logout",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *user_data = [rawJson JSONValue];
    
    return user_data;
    
}



-(NSDictionary*)user_login:(NSString*)username password:(NSString*)password{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&deviceID=%@",username,password,[[DeviceClass instance] getUUID]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-login",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *user_data = [rawJson JSONValue];
    NSLog(@"User Dtaa : %@",user_data);
    return user_data;
    
}


-(NSDictionary*)sign_up:(NSString*)username email:(NSString*)email first_name:(NSString*)first_name last_name:(NSString*)last_name password:(NSString*)password{
    NSString *post =[NSString stringWithFormat:@"username=%@&email=%@&first_name=%@&last_name=%@&password=%@&deviceID=%@",username,email,first_name,last_name,password,[[DeviceClass instance] getUUID]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-registration",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *user_data = [rawJson JSONValue];
    
    NSLog(@"User Data : %@",user_data);
    
    return user_data;
    
}



-(NSDictionary*)get_single_order:(NSString*)username password:(NSString*)password orderID:(NSString*)orderID{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&orderID=%@",
                     username,
                     password,
                     orderID
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=get-order",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
    
}


-(NSDictionary*)profile_update:(NSString*)username password:(NSString*)password arg:(NSMutableDictionary*)arg{
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&first_name=%@&last_name=%@&display_name=%@&email=%@",
                     username,
                     password,
                     [arg objectForKey:@"first_name"],
                     [arg objectForKey:@"last_name"],
                     [arg objectForKey:@"display_name"],
                     [arg objectForKey:@"email"]
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-profile-update",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
    
}

-(NSDictionary*)profileImageUpdate:(NSString*)username password:(NSString*)password imageData:(NSData*)imageData{
    NSLog(@"%@ %@ ",username,password);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=json-api&type=user-profile-image-update",[[AppDelegate instance] getUrl]];
    
    NSMutableURLRequest *requestLol = [[NSMutableURLRequest alloc] init];
    [requestLol setURL:[NSURL URLWithString:urlString]];
    [requestLol setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [requestLol addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requestLol setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:requestLol returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [returnString JSONValue];
    
    return returnValue;
    
}

-(NSDictionary*)billing_update:(NSString*)username password:(NSString*)password arg:(NSMutableDictionary*)arg{
    
    NSLog(@"%@ %@",[arg objectForKey:@"billing_phone"],[arg objectForKey:@"billing_email"]);
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&billing_first_name=%@&billing_last_name=%@&billing_company=%@&billing_address_1=%@&billing_address_2=%@&billing_city=%@&billing_postcode=%@&billing_state=%@&billing_country=%@&billing_phone=%@&billing_email=%@",
                     username,
                     password,
                     [arg objectForKey:@"billing_first_name"],
                     [arg objectForKey:@"billing_last_name"],
                     [arg objectForKey:@"billing_company"],
                     [arg objectForKey:@"billing_address_1"],
                     [arg objectForKey:@"billing_address_2"],
                     [arg objectForKey:@"billing_city"],
                     [arg objectForKey:@"billing_postcode"],
                     [arg objectForKey:@"billing_state"],
                     [arg objectForKey:@"billing_country"],
                     [arg objectForKey:@"billing_phone"],
                     [arg objectForKey:@"billing_email"]
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-billing-update",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
    
}



-(NSDictionary*)shipping_update:(NSString*)username password:(NSString*)password arg:(NSMutableDictionary*)arg{
    
    
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&shipping_first_name=%@&shipping_last_name=%@&shipping_company=%@&shipping_address_1=%@&shipping_address_2=%@&shipping_city=%@&shipping_postcode=%@&shipping_state=%@&shipping_country=%@",
                     username,
                     password,
                     [arg objectForKey:@"shipping_first_name"],
                     [arg objectForKey:@"shipping_last_name"],
                     [arg objectForKey:@"shipping_company"],
                     [arg objectForKey:@"shipping_address_1"],
                     [arg objectForKey:@"shipping_address_2"],
                     [arg objectForKey:@"shipping_city"],
                     [arg objectForKey:@"shipping_postcode"],
                     [arg objectForKey:@"shipping_state"],
                     [arg objectForKey:@"shipping_country"]
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-shipping-update",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
    
}


-(NSDictionary*)post_comment:(NSString*)username password:(NSString*)password arg:(NSMutableDictionary*)arg{
    
    
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&comment=%@&comment_parent=%@&postID=%@&starRating=%@",
                     username,
                     password,
                     [arg objectForKey:@"comment"],
                     [arg objectForKey:@"comment_parent"],
                     [arg objectForKey:@"postID"],
                     [arg objectForKey:@"starRating"]
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-post-comment",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
    
}

-(NSDictionary*)reviewCartWithCoupon:(NSString*)username password:(NSString*)password productInJsonString:(NSString*)productInJsonString coupon:(NSString*)couponCodeInJsonString{
    NSLog(@"BackEnd %@",productInJsonString);
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&productIDJson=%@&couponCodeJson=%@",
                     username,
                     password,
                     productInJsonString,
                     couponCodeInJsonString
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=cart-api",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    
    NSLog(@"Test Json %@",returnValue);
    
    return returnValue;
    
}


-(NSDictionary*)placeAnOrder:(NSString*)username password:(NSString*)password productInJsonString:(NSString*)productInJsonString coupon:(NSString*)couponCodeInJsonString paymentMethodID:(NSString*)paymentMethod orderNotes:(NSString*)orderNotes{
    
    NSLog(@"BackEnd %@",productInJsonString);
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@&productIDJson=%@&couponCodeJson=%@&paymentMethodID=%@&orderNotes=%@",
                     username,
                     password,
                     productInJsonString,
                     couponCodeInJsonString,
                     paymentMethod,
                     orderNotes
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=place-an-order-api",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"raw Json %@",rawJson);
    NSDictionary *returnValue = [rawJson JSONValue];
    
    return returnValue;
}


-(NSDictionary*)process_payment_aut_dot_net:(NSString*)orderKey orderNo:(NSString*)orderNo methodID:(NSString*)methodID credit_card_number:(NSString*)credit_card_number expire_date_year:(NSString*)expire_date_year expire_date_month:(NSString*)expire_date_month cvv:(NSString*)cvv profileID:(NSString*)profileID{
    
    
    
    NSString *post =[NSString stringWithFormat:@"authorize-net-cim-cc-number=%@&authorize-net-cim-cc-exp-year=%@&authorize-net-cim-cc-exp-month=%@&authorize-net-cim-payment-profile-id=%@&authorize-net-cim-cc-cvv=%@",
                     credit_card_number,
                     expire_date_year,
                     expire_date_month,
                     profileID,
                     cvv
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    if([MAIN_URL_HTTPS isEqualToString:@""])
    {
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=mobile-payment-redirect-authorize-dot-net-api&orderKey=%@&orderID=%@&paymentMethodID=%@",MAIN_URL,orderKey,orderNo,methodID]]];
    }
    else
    {
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=mobile-payment-redirect-authorize-dot-net-api&orderKey=%@&orderID=%@&paymentMethodID=%@",MAIN_URL_HTTPS,orderKey,orderNo,methodID]]];
    }
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"raw Json %@",rawJson);
    NSDictionary *returnValue = [rawJson JSONValue];
    
    
    
    
    return returnValue;
}



-(NSDictionary*)change_password:(NSString*)username password:(NSString*)password newpassword:(NSString*)newpassword{
    
    NSString *post =[NSString stringWithFormat:@"username=%@&currentpassword=%@&newpassword=%@",
                     username,
                     password,
                     newpassword
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=change-password",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    
    return returnValue;
    
}

-(NSDictionary*)user_registration:(NSString*)username email:(NSString*)email firstname:(NSString*)firstname lastname:(NSString*)lastname password:(NSString*)password{
    
    NSString *post =[NSString stringWithFormat:@"username=%@&email=%@&first_name=%@&last_name=%@&password=%@&deviceID=%@",
                     username,
                     email,
                     firstname,
                     lastname,
                     password,
                     [[DeviceClass instance] getUUID]
                     ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?candycart=json-api&type=user-registration",[[AppDelegate instance] getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    
    NSString *rawJson = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *returnValue = [rawJson JSONValue];
    
    
    return returnValue;
    
}


-(NSDictionary*)qrcodescanner:(NSString*)string{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/?candycart=qrcode-api&link=%@",[[AppDelegate instance] getUrl],string];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Perform request and get JSON back as a NSData object
    NSData *sa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* rawJson = [[NSString alloc] initWithData:sa encoding:NSUTF8StringEncoding];
    
    NSDictionary *value = [rawJson JSONValue];
    
    
    return value;
    
}


@end
