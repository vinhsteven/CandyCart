//
//  ExploreViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/1/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ExploreViewController.h"
#import "AppDelegate.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"tabb_bar_explore", nil);
        self.tabBarItem.image = [UIImage imageNamed:NSLocalizedString(@"tabb_bar_explore_image", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setNuiClass:@"ViewInit"];
    
    
    // Do any additional setup after loading the view from its nib.
    [self.view setMultipleTouchEnabled:YES];
    //self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIColor redColor];
    NSMutableArray *arrayTitle = [[NSMutableArray alloc] init];
    NSArray *tempArray = [[[DataService instance] home_page_api] objectForKey:@"items"];
    
    for(int i=0;i<[tempArray count];i++)
    {
        [arrayTitle addObject:[[tempArray objectAtIndex:i] objectForKey:@"title"]];
    }
    
    NSArray *ary = arrayTitle;
    
    NSString *home_menu_type = [[[DataService instance] home_page_api] objectForKey:@"home_menu_type"];
    
    if([home_menu_type isEqualToString:@"usehtml"])
    {
        
        NSString *link = [[[DataService instance] home_page_api] objectForKey:@"html_link"];
        
        webView = [[UIWebView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
        
        for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) {
            if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
        }
        webView.backgroundColor = [UIColor clearColor];
        webView.delegate = self;
        webView.scrollView.delegate = self;
        [webView setOpaque:NO];
        
        NSURL *urlss = [NSURL URLWithString:link];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlss];
        [webView loadRequest:requestObj];
        
        
        [self.view addSubview:webView];
        
        ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        
        CGRect frame = ind.frame;
        frame.origin.x = webView.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = webView.size.height / 2 - frame.size.height / 2;
        ind.frame = frame;
        [webView addSubview:ind];
        [ind stopAnimating];
    }
    else if([home_menu_type isEqualToString:@"usewppage"])
    {
        NSString *content = [[[DataService instance] home_page_api] objectForKey:@"content"];
        
        webView = [[UIWebView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:NO]];
        
        for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) {
            if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
        }
        webView.backgroundColor = [UIColor clearColor];
        webView.delegate = self;
        webView.scrollView.delegate = self;
        [webView setOpaque:NO];
        
        NSString *resources = [[NSBundle mainBundle] resourcePath];
        NSURL *baseURL = [NSURL fileURLWithPath:resources];
        
        
        NSString *myHTML = [NSString stringWithFormat:@"<script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'> <style type=\"text/css\">body {background-color: transparent; padding:10px; font-family: \"%@\"; font-size: %@;} img{ width:100%%; height:auto; }</style><body>%@<br><br><br></body>",JQUERY,BOOTSTRAP_JS,CUSTOM_JS,SWIPER_JS,SWIPER_JS_SCROLLBAR,SWIPER_JS_3D_FLOW,BOOTSTRAP_CSS,BOOTSTRAP_THEME,CUSTOM_CSS,SWIPER_CSS,SWIPER_CSS_SCROLLBAR,SWIPER_CSS_3D,PRIMARYFONT,GENERAL_UIWEBVIEW_FONT_SIZE,[[ToolClass instance] decodeHTMLCharacterEntities:content]];
        [webView loadHTMLString:myHTML baseURL:baseURL];
        
        [self.view addSubview:webView];
        
        ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        
        CGRect frame = ind.frame;
        frame.origin.x = webView.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = webView.size.height / 2 - frame.size.height / 2;
        ind.frame = frame;
        [webView addSubview:ind];
        [ind stopAnimating];
        
    }
    else
    {
        segmentedControl = [[SDSegmentedControl alloc] initWithItems:ary];
        segmentedControl.frame = CGRectMake(0, 0, 320, 50);
        //segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.arrowSize = 0;
        [segmentedControl addTarget:self action:@selector(valueChanged) forControlEvents: UIControlEventValueChanged];
        [segmentedControl setNuiClass:@"Button:TopTabButton"];
        
        [self.view addSubview:segmentedControl];
        
        
        NSLog(@"ScrollView %f",segmentedControl.scrollView.contentSize.height);
        
        scroller = [MGScrollView scroller];
        scroller.frame = [[DeviceClass instance] getResizeScreen:YES];
        
        scroller.delegate = self;
        
        scroller.bottomPadding = 8;
        scroller.hidden = YES;
        
        [self.view addSubview:scroller];
        
        
        webView = [[UIWebView alloc] initWithFrame:[[DeviceClass instance] getResizeScreen:YES]];
        webView.hidden = YES;
        
        for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) {
            if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
        }
        webView.backgroundColor = [UIColor clearColor];
        webView.delegate = self;
        webView.scrollView.delegate = self;
        [webView setOpaque:NO];
        
        
        [self.view addSubview:webView];
        
        ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        
        CGRect frame = ind.frame;
        frame.origin.x = webView.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = webView.size.height / 2 - frame.size.height / 2;
        ind.frame = frame;
        [webView addSubview:ind];
        [ind stopAnimating];
        

        [self valueChanged];
    }
    
    [self performSelector:@selector(displayPromotion) withObject:nil afterDelay:1];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        NSString *url = [NSString stringWithFormat:@"itms://itunes.apple.com/us/app/%@/id%@?ls=1&mt=8",APP_NAME,APP_ID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void) displayPromotion {
    //check shop has promotion or not to pop up the promotion banner.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *newVersion = [userDefaults objectForKey:NEW_VERSION];
    if (newVersion != nil) {
        if (![newVersion isEqualToString:APP_VERSION]) {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"update-new-version-title", nil) message:NSLocalizedString(@"update-new-version-message", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"no-btn-title", nil),NSLocalizedString(@"yes-btn-title", nil), nil];
            [dialog show];
        }
    }
    
    NSArray *promotionArray = [userDefaults objectForKey:PROMOTION];
    if (promotionArray != nil && [promotionArray count] > 0) {
        APPViewController *controller = [[APPViewController alloc] init];
        controller.mainArray = promotionArray;
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}

-(void)valueChanged
{
    
    [scroller setContentSize:CGSizeMake(320, 480)];
    
    int indexnumber = segmentedControl.selectedSegmentIndex;
    
    NSArray *tempArray = [[[DataService instance] home_page_api] objectForKey:@"items"];
    
    NSString *type = [[tempArray objectAtIndex:indexnumber] objectForKey:@"type"];
    
    
    if([type isEqualToString:@"featureditems"])
    {
        [self setFeturedProductsView];
    }
    else if([type isEqualToString:@"newitems"])
    {
        
        [self setRecentProductsView];
    }
    else if([type isEqualToString:@"randomitems"])
    {
        [self setRandomProductsView];
        
    }
    else if([type isEqualToString:@"customitems"])
    {
        
        [self setCustomProductsView:indexnumber];
    }
    else if([type isEqualToString:@"customitems"])
    {
        
        [self setCustomProductsView:indexnumber];
    }
    else if([type isEqualToString:@"usehtml"])
    {
        NSString *url = [[tempArray objectAtIndex:indexnumber] objectForKey:@"link"];
        [self useHtml:url];
        
    }
    else if([type isEqualToString:@"usepage"])
    {
        NSString *content = [[tempArray objectAtIndex:indexnumber] objectForKey:@"content"];
        [self usePage:content];
        
    }
    else
    {
        [self setRecentProductsView];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [ind startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [ind stopAnimating];
}


-(void)useHtml:(NSString*)url{
    
    webView.hidden = NO;
    scroller.hidden = YES;
    
    NSURL *urlss = [NSURL URLWithString:url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlss];
    [webView loadRequest:requestObj];
}



-(void)usePage:(NSString*)content{
    
    webView.hidden = NO;
    scroller.hidden = YES;
    
    NSString *resources = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [NSURL fileURLWithPath:resources];
    
    
    NSString *myHTML = [NSString stringWithFormat:@"<script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'> <style type=\"text/css\">body {background-color: transparent; padding:10px; font-family: \"%@\"; font-size: %@;} img{ width:100%%; height:auto; }</style><body>%@<br><br><br></body>",JQUERY,BOOTSTRAP_JS,CUSTOM_JS,SWIPER_JS,SWIPER_JS_SCROLLBAR,SWIPER_JS_3D_FLOW,BOOTSTRAP_CSS,BOOTSTRAP_THEME,CUSTOM_CSS,SWIPER_CSS,SWIPER_CSS_SCROLLBAR,SWIPER_CSS_3D,PRIMARYFONT,GENERAL_UIWEBVIEW_FONT_SIZE,[[ToolClass instance] decodeHTMLCharacterEntities:content]];
    [webView loadHTMLString:myHTML baseURL:baseURL];
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        
        NSString *myString = [[inRequest URL] absoluteString];
        
        if ([myString rangeOfString:@"#"].location == NSNotFound) {
            
            HUD = [[MBProgressHUD alloc] initWithView:[[MainViewClass instance] getCurrentMainWindow]];
            [[[MainViewClass instance] getCurrentMainWindow] addSubview:HUD];
            
            HUD.delegate = self;
            
            
            [HUD showWhileExecuting:@selector(checkLink:) onTarget:self withObject:myString animated:YES];
            
        } else {
            return YES;
        }
        
        return NO;
    }
    return YES;
}

-(void)checkLink:(NSString*)str{
    
    [[ToolClass instance] checkLink:str navigation:self.navigationController];
}

-(void)setCustomProductsView:(int)indexNumber{
    webView.hidden = YES;
    scroller.hidden = NO;
    
    [scroller.boxes removeAllObjects];
    
    NSArray *tempArray = [[[DataService instance] home_page_api] objectForKey:@"items"];
    
    NSArray *type = [[tempArray objectAtIndex:indexNumber] objectForKey:@"data"];
    
    NSArray *allFeaturedArray = type;
    
    for(int i=0;i<[allFeaturedArray count];i++)
    {
        NSDictionary *productInfo = [allFeaturedArray objectAtIndex:i];
        
        
        if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"simple"] || [[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"external"])
        {
            
            NSNumber *isOnSale = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]
                     salePrice:[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]]
                      isOnSale:[isOnSale boolValue]
                   productInfo:productInfo
                     notSimple:NO
             ];
            
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"grouped"])
        {
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]
                     salePrice:[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]
                      isOnSale:NO
                   productInfo:productInfo
                     notSimple:YES
             ];
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
        {
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]
                     salePrice:[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]
                      isOnSale:NO
                   productInfo:productInfo
                     notSimple:YES
             ];
        }
    }
    
    [scroller layoutWithSpeed:0.3 completion:nil];
    
}

-(void)setRandomProductsView{
    
    webView.hidden = YES;
    scroller.hidden = NO;
    [scroller.boxes removeAllObjects];
    
    
    NSDictionary *featuredProducts = [[DataService instance] randomItems];
    
    NSArray *allFeaturedArray = [featuredProducts objectForKey:@"products"];
    
    for(int i=0;i<[allFeaturedArray count];i++)
    {
        NSDictionary *productInfo = [allFeaturedArray objectAtIndex:i];
        
        
        if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"simple"] || [[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"external"])
        {
            
            NSNumber *isOnSale = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]
                     salePrice:[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]]
                      isOnSale:[isOnSale boolValue]
                   productInfo:productInfo
                     notSimple:NO
             ];
            
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"grouped"])
        {
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]
                     salePrice:[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]
                      isOnSale:NO
                   productInfo:productInfo
                     notSimple:YES
             ];
            
            
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
        {
            
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]
                     salePrice:[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]
                      isOnSale:NO
                   productInfo:productInfo
                     notSimple:YES
             ];
            
            
        }
        
    }
    
    
    [scroller layoutWithSpeed:0.3 completion:nil];
    
}



-(void)setFeturedProductsView{
    webView.hidden = YES;
    scroller.hidden = NO;
    
    [scroller.boxes removeAllObjects];
    
    
    NSDictionary *featuredProducts = [[DataService instance] featuredProducts];
    
    NSArray *allFeaturedArray = [featuredProducts objectForKey:@"products"];
    
    for(int i=0;i<[allFeaturedArray count];i++)
    {
        NSDictionary *productInfo = [allFeaturedArray objectAtIndex:i];
        
        
        if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"simple"] || [[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"external"])
        {
            
            NSNumber *isOnSale = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]
                     salePrice:[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]]
                      isOnSale:[isOnSale boolValue]
                   productInfo:productInfo
                     notSimple:NO
             ];
            
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"grouped"])
        {
            
            
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]
                     salePrice:[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]
                      isOnSale:NO
                   productInfo:productInfo
                     notSimple:YES
             ];
            
            
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
        {
            
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]
                     salePrice:[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]
                      isOnSale:NO
                   productInfo:productInfo
                     notSimple:YES
             ];
            
            
        }
        
    }
    
    
    [scroller layoutWithSpeed:0.3 completion:nil];
    
}



-(void)setRecentProductsView{
    
    webView.hidden = YES;
    scroller.hidden = NO;
    [scroller.boxes removeAllObjects];

    NSDictionary *recent = [[DataService instance] recentItems];
    
    NSArray *allRecentArray = [recent objectForKey:@"products"];
    
    for(int i=0;i<[allRecentArray count];i++)
    {
        NSDictionary *productInfo = [allRecentArray objectAtIndex:i];
        
        
        if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"simple"] || [[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"external"])
        {
            
            NSNumber *isOnSale = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]
                     salePrice:[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]]
                      isOnSale:[isOnSale boolValue]
                   productInfo:productInfo
                     notSimple:NO
             ];
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"grouped"])
        {
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]
                     salePrice:[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]
                      isOnSale:NO
                   productInfo:productInfo
                     notSimple:YES
             ];
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
        {
            
            [self fullImageBox:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]
                         title:[[productInfo objectForKey:@"general"] objectForKey:@"title"]
                      currency: [[SettingDataClass instance] getCurrencySymbol]
                  regularPrice:[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]
                     salePrice:[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]
                      isOnSale:NO
                   productInfo:productInfo
                     notSimple:YES
             ];
        }
    }
    
    [scroller layoutWithSpeed:0.3 completion:nil];
    
}


-(void)fullImageBox:(NSString*)url title:(NSString*)title currency:(NSString*)currency regularPrice:(NSString*)price salePrice:(NSString*)salePrice isOnSale:(BOOL)isOnSale productInfo:(NSDictionary*)productInfo notSimple:(BOOL)notSimple{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(20.0, 20.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    BOOL isDisplayPrice = YES;
    
    NSArray *categories = [productInfo objectForKey:@"categories"];
    if ([categories count] > 0) {
        for (int i=0;i < [categories count];i++) {
            NSString *slug = [[categories objectAtIndex:i] objectForKey:@"slug"];
            if ([slug isEqualToString:@"ca-si"]) {
                isDisplayPrice = NO;
                break;
            }
        }
    }
    
    PhotoBox *box = [PhotoBox fullImageBox:CGSizeMake(280,200) pictureURL:url title:title currency:currency regularPrice:price salePrice:salePrice isOnSale:isOnSale notSimple:notSimple displayPrice:isDisplayPrice];
    
    
    box.onTap = ^{
        
        DetailViewController *det = [[DetailViewController alloc] init];
        [det setProductInfo:productInfo];
        
        [self.navigationController pushViewController:det animated:YES];
    };
    
    [section.topLines addObject:box];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    initialContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[SettingDataClass instance] autoHideGlobal:scrollView navigationView:self.navigationController contentOffset:initialContentOffset];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
