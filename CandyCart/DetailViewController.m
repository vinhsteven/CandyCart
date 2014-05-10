//
//  DetailViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/5/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setNuiClass:@"ViewInit"];
    // Do any additional setup after loading the view from its nib.
    self.title = [[productInfo objectForKey:@"general"] objectForKey:@"title"];
    //initialize
    isVariableOn = NO;
    product_variable_copy = nil;
    
    //tam thoi` hide chuc nang share di
//    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
//    shareBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
//    [shareBtn setTitle:NSLocalizedString(@"product_detail_view_share_btn", nil) forState:UIControlStateNormal];
//    [shareBtn addTarget:self
//                 action:@selector(shareBtnAction)
//       forControlEvents:UIControlEventTouchDown];
//    
//    [shareBtn setNuiClass:@"UiBarButtonItem"];
//    [shareBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//    
//    UIBarButtonItem *button = [[UIBarButtonItem alloc]
//                               initWithCustomView:shareBtn];
//    self.navigationItem.rightBarButtonItem = button;
    
    
    [self setProductView];
    
    //NSArray *varData = [[productInfo objectForKey:@"if_variants"] objectForKey:@"variables"];
    
    //get start, end work hour
    //get current time
    //calculate the date from Age
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
    
//    int day     = [components day];
//    int month   = [components month];
//    int year    = [components year];
    int currentHour    = [components hour];
//    int currentMin     = [components minute];
    
    NSString *startWorkHour = [[NSUserDefaults standardUserDefaults] objectForKey:START_WORK_HOUR];
    NSString *endWorkHour   = [[NSUserDefaults standardUserDefaults] objectForKey:END_WORK_HOUR];
    
    //separate start work hour
    NSArray *tmpArray = [startWorkHour componentsSeparatedByString:@":"];
    NSEnumerator *nse = [tmpArray objectEnumerator];
    int startHour   = [[nse nextObject] intValue];
//    int startMin    = [[nse nextObject] intValue];
    
    //separate end work hour
    tmpArray = [endWorkHour componentsSeparatedByString:@":"];
    nse = [tmpArray objectEnumerator];
    int endHour = [[nse nextObject] intValue];
//    int endMin  = [[nse nextObject] intValue];
    
    //check validate open hour of merchant
#ifdef ibar
    endHour += 24; //doi voi bar thi +24h de chuyen wa ngay moi
#endif
    if (currentHour < startHour || currentHour >= endHour) {
        //out of order
        addToCartBox.addToCartLbl.text = NSLocalizedString(@"product_detail_add_to_cart_btn_out_of_order", nil);

        isOutOfOrder = YES;
    }
    
    //kiem tra va ko cho order neu la` muc slug = ca-si
    NSArray *categories = [productInfo objectForKey:@"categories"];
    if ([categories count] > 0) {
        for (int i=0;i < [categories count];i++) {
            NSString *slug = [[categories objectAtIndex:i] objectForKey:@"slug"];
            if ([slug isEqualToString:@"ca-si"]) {
                addToCartBox.addToCartLbl.text = NSLocalizedString(@"product_detail_singer_welcome_title", nil);
                
                isOutOfOrder = YES;
                break;
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"Appearr");
}


-(void)setProductInfo:(NSDictionary*)product{
    
    productInfo = product;
}

-(void)setProductView{
    
    //setup View
    [self topView];
    
    [self bottomView];
    [scroller layoutWithSpeed:0.3 completion:nil];
    
    bottomView.frame = CGRectMake(0, 0, scroller.contentSize.width, scroller.contentSize.height);
    scroller.frame = CGRectMake(0, 0, scroller.contentSize.width, scroller.contentSize.height);
    
    
    // Add Into ParallaxView
    parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:topView
                                                    foregroundView:bottomView];
    
    //init parallax content size
    
    
    parallaxView.frame = [[DeviceClass instance] getResizeScreen:NO];
    
    
    
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    parallaxView.backgroundHeight = 190.0f;
    parallaxView.scrollView.scrollsToTop = YES;
    
    parallaxView.backgroundInteractionEnabled = YES;
    parallaxView.scrollViewDelegate = self;
    
    
    
    [self.view addSubview:parallaxView];
    
    
    
}



-(void)bottomView{
    
    CGRect textRect = CGRectMake(0, 0, 320, 300);
    
    
    bottomView =[[UIView alloc] initWithFrame:textRect];
    [bottomView setNuiClass:@"ViewInit"];
    
    bottomView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(0, -1);
    bottomView.layer.shadowRadius = 1;
    bottomView.layer.shadowOpacity = 0.3;
    
    scroller = [[MGScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 340)];
    scroller.contentLayoutMode = MGLayoutGridStyle;
    scroller.bottomPadding = 8;
    [bottomView addSubview:scroller];
    
    //Show Product Stock IF Manageble
    NSNumber *manage_stock = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"manage_stock"];
    if([manage_stock boolValue] == TRUE)
    {
        NSNumber *allowedBackOrder = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"allow_backorder"];
        NSNumber *allowedBackOrderNoti = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"allow_backorder_require_notification"];
        
        NSNumber *stockStatus = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"stock_status"];
        if([stockStatus boolValue] == false)
        {
            //Not add anything if out of stock
        }
        else
        {
            
            [self inventory:[[productInfo objectForKey:@"inventory"] objectForKey:@"quantity"] allowedBackOrder:[allowedBackOrder boolValue] allowedBackOrderNotification:[allowedBackOrderNoti boolValue]];
            
        }
    }
    
    
    //.................................
    
    //Show product sale count down
    // [self saleStartEndCountDown];
    
    
    //Show Product variable IF type is Variable and has attribute
    [self AddProductVariable];
    //.................................................
    
    
    
    [self addToCartBtn];
    
    
    
    
    NSString *desc = [[[productInfo objectForKey:@"general"] objectForKey:@"content"] objectForKey:@"excepts"];
    
    
    
    NSLog(@"Product Desc : %@",desc);
    [self shortDesc:[[ToolClass instance] decodeHTMLCharacterEntities:desc]];
    
    [self readMoreButton];
    
    if([[[productInfo objectForKey:@"advanced"] objectForKey:@"comment_status"] isEqualToString:@"open"])
    {
        [self reviewButton];
    }
    
    
    
    //Product You May Like if exist
    if([(NSArray*)[[productInfo objectForKey:@"linked_products"] objectForKey:@"upsells"] count] > 0)
    {
        [self productYouMayLike:[[productInfo objectForKey:@"linked_products"] objectForKey:@"upsells"]];
        
    }
}

-(void)topView{
    current_product_image_index = 0; //init image index;
    imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,320)];
    imgScrollView.delegate = self;
    
    
    UIImageView* myImgViewsse;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    //Get Featured Image
    [colors addObject:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]];
    
    //Get Other Images
    NSArray *otherImages = [[productInfo objectForKey:@"product_gallery"] objectForKey:@"other_images"];
    
    for (int otherIm = 0; otherIm<[otherImages count]; otherIm++) {
        [colors addObject:[otherImages objectAtIndex:otherIm]];
    }
    
    for (int i = 0; i < colors.count; i++) {
        CGRect frame;
		
        // horizontal scrolling
        frame.origin.x = imgScrollView.frame.size.width * i;
		frame.origin.y = 0;
        
        // to show vertical comment the 2 lines above and uncomment the 2 lines below
        //      frame.origin.x = 0;
        //      frame.origin.y = self.scrollView.frame.size.height * i;
        
        // create a frame with the size of our scrollview
        // this is done to keep image the size of our scrollview
		frame.size = imgScrollView.frame.size;
        
        // init a view with the size of our scrollview
		UIView *subview = [[UIView alloc] initWithFrame:frame];
        
        // init an image with the width/height of our scrollview
        myImgViewsse = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgScrollView.frame.size.width, imgScrollView.frame.size.height)];
        
        // keep our autoresizing masks in place
        myImgViewsse.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        // async image loading & caching
        //[myImgViewsse setImageWithURL:[NSURL URLWithString:[colors objectAtIndex:i]] placeholderImage:nil];
        
        UIImageView *temp = myImgViewsse;
        
        [myImgViewsse setImageWithURL:[NSURL URLWithString:[colors objectAtIndex:i]]
                     placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                
                                temp.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(320, 290) source:image];
                                
                            }];
        
        
        
        // image interaction enabled
        myImgViewsse.userInteractionEnabled = TRUE;
        
        // aspect fit mode
        //[myImgView setContentMode:UIViewContentModeScaleAspectFit];
        
        
        UILabel *backSleek = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, 320, 200)];
        backSleek.backgroundColor = [UIColor clearColor];
        backSleek.alpha = 1;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = backSleek.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [backSleek.layer insertSublayer:gradient atIndex:0];
        
        
        
        // add image to our subview collection
        [subview addSubview:myImgViewsse];
        
        [subview addSubview:backSleek];
        
        // add subview to scrollview
		[imgScrollView addSubview:subview];
        
	}
    
    
    
    imgScrollView.contentSize = CGSizeMake(imgScrollView.frame.size.width * colors.count, imgScrollView.frame.size.height);
    
    // comment the above and uncomment the below to show vertical scrolling
    //    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height* colors.count);
    
    imgScrollView.contentMode = UIViewContentModeScaleAspectFit;
    
    // scrollview options
    imgScrollView.zoomScale = 0;
    
    imgScrollView.pagingEnabled = YES;
    imgScrollView.showsHorizontalScrollIndicator = NO;
    
    imgScrollView.alwaysBounceHorizontal = YES;
    
    imgScrollView.alwaysBounceVertical = NO;
    
    
    topView = [[UIView alloc] initWithFrame:imgScrollView.bounds];
    [topView setBackgroundColor:[UIColor blackColor]];
    topView.userInteractionEnabled = YES;
    topView.multipleTouchEnabled =NO;
    [topView addSubview:imgScrollView];
    
    if([[[productInfo objectForKey:@"ratings"] objectForKey:@"rating_count"] intValue] > 0)
    {
        DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(180, 110, 150, 153) andStars:5 isFractional:NO starGapCustomAdjust:0.5];
        customNumberOfStars.enabled = NO;
        
        [customNumberOfStars setStar:[UIImage imageNamed:@"smallStar.png"] highlightedStar:[UIImage imageNamed:@"smallStarHigh.png"]];
        customNumberOfStars.backgroundColor = [UIColor clearColor];
        
        customNumberOfStars.rating = [[[productInfo objectForKey:@"ratings"] objectForKey:@"average_rating"] floatValue];
        [topView addSubview:customNumberOfStars];
    }
    
    UILabel *he = [[UILabel alloc] initWithFrame:topView.bounds];
    [topView addSubview:he];
    
    UITextView *tryDulu = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 310,60)];
    tryDulu.text = [[productInfo objectForKey:@"general"] objectForKey:@"title"];
    tryDulu.backgroundColor = [UIColor clearColor];
    tryDulu.textColor = [UIColor whiteColor];
    tryDulu.font = [UIFont fontWithName:BOLDFONT size:18];
    
    
    [he addSubview:tryDulu];
    
    BOOL isDisplayPrice = YES;
    //kiem tra va ko cho order neu la` muc slug = ca-si
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
    if (isDisplayPrice) {
        //Top View Product Simple
        if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"simple"] || [[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"external"])
        {
            NSNumber *boolean = (NSNumber *)[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            if([boolean boolValue] == FALSE)
            {
                UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(205, 200, 120, 40)];
                price.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
                price.text = [NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]];
                price.layer.cornerRadius = 3;
                price.layer.masksToBounds = YES;
                price.textAlignment = NSTextAlignmentCenter;
                price.textColor = [UIColor whiteColor];
                [he addSubview:price];
                
            }
            else
            {
                TTTAttributedLabel *price = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(105, 200, 220, 40)];
                
                price.textAlignment = NSTextAlignmentCenter;
                price.font = [UIFont fontWithName:PRIMARYFONT size:14];
                price.textColor = [UIColor whiteColor];
                price.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                price.layer.cornerRadius = 3;
                [he addSubview:price];
                
                NSString *regular = [NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]];
                
                NSString *sale_price = [NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[[[productInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]]];
                
                NSString *text = [NSString stringWithFormat:@"%@ %@",regular,sale_price];
                [price setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange boldRange = [[mutableAttributedString string] rangeOfString:sale_price options:NSCaseInsensitiveSearch];
                    NSRange strikeRange = [[mutableAttributedString string] rangeOfString:regular options:NSCaseInsensitiveSearch];
                    
                    // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
                    UIFont *boldSystemFont = [UIFont fontWithName:BOLDFONT size:14];
                    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                    if (font) {
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                        [mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:[NSNumber numberWithBool:YES] range:strikeRange];
                        CFRelease(font);
                    }
                    
                    return mutableAttributedString;
                }];
                
                UILabel *onSaleBadge = [[UILabel alloc] initWithFrame:CGRectMake(10, 195, 50, 50)];
                onSaleBadge.text = NSLocalizedString(@"sale_badge_title", nil);
                [onSaleBadge setNuiClass:@"OnSaleBadge"];
                onSaleBadge.textAlignment = NSTextAlignmentCenter;
                onSaleBadge.layer.cornerRadius = 25;
                
                onSaleBadge.layer.masksToBounds = YES;
                
                [he addSubview:onSaleBadge];
            }
            //End of Top View Product Simple
            
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"grouped"]){
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(105, 200, 220, 40)];
            price.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
            price.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil), [[SettingDataClass instance] getCurrencySymbol],[[[productInfo objectForKey:@"if_group"] objectForKey:@"min_price"] objectForKey:@"price"]];
            price.layer.cornerRadius = 3;
            price.layer.masksToBounds = YES;
            price.textAlignment = NSTextAlignmentCenter;
            price.textColor = [UIColor whiteColor];
            [he addSubview:price];
            
        }
        else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"]){
            variablePrice = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(105, 200, 220, 40)];
            
            variablePrice.textAlignment = NSTextAlignmentCenter;
            variablePrice.font = [UIFont fontWithName:PRIMARYFONT size:14];
            variablePrice.textColor = [UIColor whiteColor];
            variablePrice.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            variablePrice.layer.cornerRadius = 3;
            [he addSubview:variablePrice];
            
            NSString *text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil), [[SettingDataClass instance] getCurrencySymbol],[[[productInfo objectForKey:@"if_variants"] objectForKey:@"min_price"] objectForKey:@"price"]];
            [variablePrice setText:text];
            
            onSaleBadgeVariable = [[UILabel alloc] initWithFrame:CGRectMake(10, 195, 50, 50)];
            onSaleBadgeVariable.text = NSLocalizedString(@"sale_badge_title", nil);
            [onSaleBadgeVariable setNuiClass:@"OnSaleBadge"];
            onSaleBadgeVariable.textAlignment = NSTextAlignmentCenter;
            onSaleBadgeVariable.layer.cornerRadius = 25;
            
            onSaleBadgeVariable.layer.masksToBounds = YES;
            onSaleBadgeVariable.hidden = YES;
            [he addSubview:onSaleBadgeVariable];
            
        }
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [topView addGestureRecognizer:tapGesture];
}

-(void)addToCartBtnForExternalProduct{
    
    NSDictionary *external = [[productInfo objectForKey:@"general"] objectForKey:@"if_external"];
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    addToCartBox = [[ProductDetailBox alloc] init];
    ProductDetailBox *box2 = [addToCartBox addToCartBtn:NO];
    [section.topLines addObject:box2];
    
    addToCartBox.addToCartLbl.text = [external objectForKey:@"button_name"];
    
    UserDataTapGestureRecognizer *addToCart = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddToCartExternal:)];
    addToCart.userData = [external objectForKey:@"product_url"];
    [box2 addGestureRecognizer:addToCart];
}

-(void)handleAddToCartExternal:(UserDataTapGestureRecognizer*)tap{
    
    NSString* originalString =
    [tap.userData stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"Go to web View %@",originalString);
    
    iPhoneWebView *webView = [[iPhoneWebView alloc] init];
    [webView loadUrlInWebView:[NSString stringWithFormat:@"%@",originalString]];
    [self.navigationController pushViewController:webView animated:YES];
}


-(void)groupedProduct:(NSString *)featuredImage title:(NSString*)title currency:(NSString*)currency price:(NSString*)price salePrice:(NSString*)salePrice isOnSale:(BOOL)isOnSale productInfo:(NSDictionary*)productGroupInfo{
    
    
    
    MGTableBoxStyled *section2 = MGTableBoxStyled.box;
    [scroller.boxes addObject:section2];
    ProductDetailBox *box = [ProductDetailBox groupItem:featuredImage productTitle:title currency:currency price:price salePrice:salePrice isOnSale:isOnSale];
    
    [section2.topLines addObject:box];
    
    box.onTap = ^{
        
        DetailViewController *detail = [[DetailViewController alloc] init];
        [detail setProductInfo:productGroupInfo];
        [self.navigationController pushViewController:detail animated:YES];
        
    };
    
}


-(void)addToCartBtn
{
    
    if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"external"])
    {
        
        [self addToCartBtnForExternalProduct];
    }
    else if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"grouped"])
    {
        //Not add any cart btn...and we are going to add all group product
        
        NSArray *groupData = [[productInfo objectForKey:@"if_group"] objectForKey:@"group"];
        
        for(int i=0;i<[groupData count];i++)
        {
            
            
            NSDictionary *groupInfo = [groupData objectAtIndex:i];
            
            NSString *featuredImage = [[groupInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"];
            
            NSNumber *boolean = (NSNumber *)[[[groupInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            
            [self groupedProduct:featuredImage title:[[groupInfo objectForKey:@"general"] objectForKey:@"title"] currency: [[SettingDataClass instance] getCurrencySymbol] price:[[AppDelegate instance] convertToThousandSeparator:[[[groupInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]] salePrice:[[AppDelegate instance] convertToThousandSeparator:[[[groupInfo objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"sale_price"]] isOnSale:[boolean boolValue] productInfo:groupInfo];
            
        }
    }
    else
    {
        MGTableBoxStyled *section = MGTableBoxStyled.box;
        section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
        [scroller.boxes addObject:section];
        
        addToCartBox = [[ProductDetailBox alloc] init];
        ProductDetailBox *box2;
        //Show Product Stock IF Manageble
        NSNumber *manage_stock = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"manage_stock"];
        if([manage_stock boolValue] == TRUE)
        {
            
            NSNumber *stockStatus = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"stock_status"];
            
            
            if([stockStatus boolValue] == false)
            {
                box2 = [addToCartBox addToCartBtn:YES];
            }
            else
            {
                box2 = [addToCartBox addToCartBtn:NO];
            }
        }
        else
        {
            box2 = [addToCartBox addToCartBtn:NO];
        }
        
        
        UserDataTapGestureRecognizer *addToCart = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddToCart:)];
        
        
        if([manage_stock boolValue] == TRUE)
        {
            
            NSNumber *stockStatus = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"stock_status"];
            if([stockStatus boolValue] == false)
            {
                //nothing execute.... out off stock
                addToCart.openPopOver = @"0";
            }
            else
            {
                addToCart.openPopOver = @"1";
                
                
                
                if([[[productInfo objectForKey:@"inventory"] objectForKey:@"quantity"] intValue] < AddToCartQuantityMax)
                {
                    
                    addToCart.userData = [[productInfo objectForKey:@"inventory"] objectForKey:@"quantity"];
                    
                }
                else
                {
                    addToCart.userData = [NSString stringWithFormat:@"%d",AddToCartQuantityMax];
                }
            }
        }
        else
        {
            addToCart.userData = [NSString stringWithFormat:@"%d",AddToCartQuantityMax];
            addToCart.openPopOver = @"1";
        }
        
        
        [box2 addGestureRecognizer:addToCart];
        
        //Check if this product inside cart. If Yes We tag it...for variable product, please check it in productVariableQueryMethod
        if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"simple"])
        {
            
            if([[MyCartClass instance] checkInCart:[productInfo objectForKey:@"product_ID"]])
            {
                [addToCartBox addToCartBtnInCart:[[MyCartClass instance] productQuantityInsideCart:[productInfo objectForKey:@"product_ID"]]];
            }
            
        }
        
        [section.topLines addObject:box2];
    }
}

-(void)handleAddToCart:(UserDataTapGestureRecognizer*)tap{
    NSLog(@"Tapped AddToCart");
    if (isOutOfOrder)
        return;
        
    if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
    {
        if(product_variable_copy == nil)
        {
            //Havent Choose any Variation so we throw an alert to user
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"product_detail_add_to_cart_error_title", nil)
                                                           message: NSLocalizedString(@"product_detail_add_to_cart_error_content", nil)
                                                          delegate: nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"product_detail_add_to_cart_error_btn", nil),nil];
            
            
            [alert show];
            
        }
        else
        {
            
            AddToCartQuantity *menu = [[AddToCartQuantity alloc] init];
            
            
            NSNumber *stockStatus = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"sold_individually"];
            if([stockStatus boolValue] == false)
            {
                //Product Varialble - Not Sold Individually
                if([[[product_variable_copy objectForKey:@"inventory"] objectForKey:@"quantity"] isEqualToString:@""])
                {
                    [menu setTotalQuantity:[tap.userData intValue] setCurrentDetail:self];
                }
                else if([[[product_variable_copy objectForKey:@"inventory"] objectForKey:@"quantity"] intValue] < AddToCartQuantityMax)
                {
                    [menu setTotalQuantity:[[[product_variable_copy objectForKey:@"inventory"] objectForKey:@"quantity"] intValue] setCurrentDetail:self];
                }
                else
                {
                    [menu setTotalQuantity:[tap.userData intValue] setCurrentDetail:self];
                }
                
            }
            else
            {
                //Product Varialble - Sold Individually
                [menu setTotalQuantity:1 setCurrentDetail:self];
            }
            
            popoverAddToCart = [[FPPopoverController alloc] initWithViewController:menu];
            popoverAddToCart.border = NO;
            popoverAddToCart.tint = FPPopoverWhiteTint;
            popoverAddToCart.contentSize = CGSizeMake(120,200);
            [popoverAddToCart.view setNuiClass:@"DropDownView"];
            
            [popoverAddToCart presentPopoverFromView:addToCartBox.addToCartLbl];
        }
    }
    else
    {
        if([tap.openPopOver isEqualToString:@"1"])
        {
            AddToCartQuantity *menu = [[AddToCartQuantity alloc] init];
            
            
            NSNumber *stockStatus = (NSNumber *)[[productInfo objectForKey:@"inventory"] objectForKey:@"sold_individually"];
            if([stockStatus boolValue] == false)
            {
                //Simple Type : Not Sold Individually
                [menu setTotalQuantity:[tap.userData intValue] setCurrentDetail:self];
            }
            else
            {
                //Simple Type : Sold Individually
                [menu setTotalQuantity:1 setCurrentDetail:self];
            }
            popoverAddToCart = [[FPPopoverController alloc] initWithViewController:menu];
            popoverAddToCart.border = NO;
            popoverAddToCart.tint = FPPopoverWhiteTint;
            popoverAddToCart.contentSize = CGSizeMake(120,200);
            [popoverAddToCart.view setNuiClass:@"DropDownView"];
            
            [popoverAddToCart presentPopoverFromView:addToCartBox.addToCartLbl];
        }
    }
}


-(void)addToCartExe:(int)quantity{
    [addToCartBox addToCartBtnInCart:quantity];
    
    if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
    {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        [temp setValue:[productInfo objectForKey:@"product_ID"] forKey:@"parentID"];
        [temp setValue:productInfo forKey:@"parentInfo"];
        
        [[MyCartClass instance] addToCart:@"variable" productID:[product_variable_copy objectForKey:@"product_ID"] productQuantity:[NSString stringWithFormat:@"%d",quantity] fullProductInfo:product_variable_copy ifVariableParentInfo:temp];
    }
    else
    {
        [[MyCartClass instance] addToCart:@"simple" productID:[productInfo objectForKey:@"product_ID"] productQuantity:[NSString stringWithFormat:@"%d",quantity] fullProductInfo:productInfo ifVariableParentInfo:nil];
        
    }
    
    [popoverAddToCart dismissPopoverAnimated:YES];
    UIImage *img = [[ToolClass instance] ChangeViewToImage:parallaxView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(0, 0, 320, parallaxView.height);
    [self.view addSubview:imgView];
    
    [imgView genieInTransitionWithDuration:GenieAnimationSpeedDuration destinationRect:CGRectMake(270, 480, 5, 30) destinationEdge:BCRectEdgeTop completion:
     ^{
         
         [imgView removeFromSuperview];
         
         [[MyCartClass instance] countCartTabBar];
         
     }];
}


-(void)productVariableHalf:(NSString*)label isHalf:(BOOL)boolen arrayValue:(NSArray*)ary termName:(NSString*)termName
{
    MGBox *section =  MGBox.box;
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    ProductDetailBox *box;
    if(boolen == TRUE)
    {
        box = [ProductDetailBox option:CGSizeMake(145, 30)];
    }
    else
    {
        
        box = [ProductDetailBox option:CGSizeMake(300, 30)];
    }
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, box.size.width, box.size.height)];
    
    [lbl setNuiClass:@"inventory"];
    
    lbl.text = label;
    lbl.textAlignment = NSTextAlignmentLeft;
    
    [box addSubview:lbl];
    
    
    box.onTap = ^{
        
        MenuViewController *menu = [[MenuViewController alloc] init];
        [menu setArray:ary];
        [menu setTermNa:termName];
        [menu setLabelToSend:lbl];
        [menu setDetailController:self];
        
        popover = [[FPPopoverController alloc] initWithViewController:menu];
        popover.tint = FPPopoverWhiteTint;
        
        popover.border = NO;
        
        [popover.view setNuiClass:@"DropDownView"];
        
        [popover presentPopoverFromView:lbl];
    };
    
    [section.boxes addObject:box];
}

-(void)inventory:(NSString*)stock allowedBackOrder:(BOOL)backorder allowedBackOrderNotification:(BOOL)backorderNoti
{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    /*
     section.layer.shadowColor = nil;
     section.layer.shadowColor = nil;
     section.layer.shadowOffset = CGSizeMake(0, 0);
     section.layer.shadowRadius = 0;
     section.layer.shadowOpacity = 0;
     */
    section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    ProductDetailBox *box = [ProductDetailBox inventory:stock allowedBackOrderNotification:backorderNoti];
    
    
    box.onTap = ^{
        
        
    };
    
    [section.topLines addObject:box];
    
    
}


-(void)shortDesc:(NSString*)desc
{
    /*
     MGTableBoxStyled *section = MGTableBoxStyled.box;
     [scroller.boxes addObject:section];
     section.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
     
     
     
     id body = [NSString stringWithFormat:@"%@",[[ToolClass instance] decodeHTMLCharacterEntities:desc]];
     
     
     
     
     // stuff
     MGLineStyled *line = [MGLineStyled multilineWithText:body font:nil width:300
     padding:UIEdgeInsetsMake(10, 10, 10.0, 10.0)];
     line.backgroundColor = [UIColor clearColor];
     line.font = [UIFont fontWithName:PRIMARYFONT size:11];
     
     [section.topLines addObject:line];
     */
    
    
    MGBox *section2 =  MGBox.box;
    section2.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    [scroller.boxes addObject:section2];
    
    
    CGSize detailSize = [desc sizeWithFont:[UIFont fontWithName:PRIMARYFONT size:11] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    boxWeb = [ProductDetailBox desc:CGSizeMake(300, detailSize.height+20)];
    
    /*
     UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, detailSize.height)];
     
     lbl.backgroundColor = [UIColor clearColor];
     lbl.numberOfLines = 0;
     lbl.lineBreakMode = NSLineBreakByWordWrapping;
     lbl.font = [UIFont fontWithName:PRIMARYFONT size:11];
     lbl.text =[[ToolClass instance] decodeHTMLCharacterEntities:desc];
     [box addSubview:lbl];
     [lbl sizeToFit];
     [section2.boxes addObject:box];
     */
    
    
    webViewSe = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 280, detailSize.height)];
    
    webViewSe.delegate = self;
    
    webViewSe.scrollView.delegate = self;
    webViewSe.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    webViewSe.scrollView.scrollEnabled = NO;
    for(UIView *wview in [[[webViewSe subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
    }
    webViewSe.backgroundColor = [UIColor clearColor];
    [webViewSe setOpaque:NO];
    
    [boxWeb addSubview:webViewSe];
    
    NSString *myHTML = [NSString stringWithFormat:@"<style type=\"text/css\">body {background-color: transparent; padding:0px; font-family: \"%@\"; font-size: %@;} img{ width:100%%; height:auto; }</style><body>%@<br><br></body>",PRIMARYFONT,@"11px",desc];
    
    
    [webViewSe loadHTMLString:myHTML baseURL:nil];
    
    [section2.boxes addObject:boxWeb];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
    NSString *webViewHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    webViewSe.frame = CGRectMake(0, 0, 300, [webViewHeight floatValue]);
    boxWeb.frame = CGRectMake(0, 0, 300, [webViewHeight floatValue]);
    [scroller layoutWithSpeed:0.3 completion:nil];
    
    
    
}

-(void)readMoreButton{
    
    MGTableBoxStyled *section2 = MGTableBoxStyled.box;
    [scroller.boxes addObject:section2];
    section2.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    UIImage *arrow = [UIImage imageNamed:@"arrow.png"];
    MGLineStyled
    *triggers = [MGLineStyled lineWithLeft:NSLocalizedString(@"product_detail_read_more_btn_title", nil)
                                     right:arrow size:CGSizeMake(300, 29)];
    triggers.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section2.topLines addObject:triggers];
    
    section2.onTap = ^{
        //self.title = NSLocalizedString(@"back_btn_title", nil);
        ReadMoreViewController *readMores = [[ReadMoreViewController alloc] init];
        readMores.title = [[productInfo objectForKey:@"general"] objectForKey:@"title"];
        
        
        NSNumber *has_attribute = (NSNumber *)[[productInfo objectForKey:@"attributes"] objectForKey:@"has_attributes"];
        
        NSNumber *has_weight = (NSNumber *)[[[productInfo objectForKey:@"shipping"] objectForKey:@"weight"] objectForKey:@"has_weight"];
        NSNumber *has_dimension = (NSNumber *)[[[productInfo objectForKey:@"shipping"] objectForKey:@"dimension"] objectForKey:@"has_dimension"];
        
        if([has_attribute boolValue] == TRUE || [has_weight boolValue] == TRUE || [has_dimension boolValue] == TRUE)
        {
            [readMores setFullDescString:[[[productInfo objectForKey:@"general"] objectForKey:@"content"] objectForKey:@"full_html"] andHasAttribute:TRUE andProductInfo:productInfo];
        }
        else
        {
            [readMores setFullDescString:[[[productInfo objectForKey:@"general"] objectForKey:@"content"] objectForKey:@"full_html"] andHasAttribute:FALSE andProductInfo:productInfo];
        }
        [self.navigationController pushViewController:readMores animated:YES];
    };
}


-(void)saleStartEndCountDown{
    MGTableBoxStyled *section2 = MGTableBoxStyled.box;
    [scroller.boxes addObject:section2];
    section2.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    //UIImage *arrow = [UIImage imageNamed:@"arrow.png"];
    
    ProductDetailBox *countdown = [ProductDetailBox countDownTimer:CGSizeMake(300, 40) leftSmall:@"Deal will end in"];
    
    [section2.topLines addObject:countdown];
    
    
    section2.onTap = ^{
        
    };
    
    
}



-(void)reviewButton{
    
    MGTableBoxStyled *section2 = MGTableBoxStyled.box;
    [scroller.boxes addObject:section2];
    section2.margin = UIEdgeInsetsMake(10.0, 10.0, 0.0, 0.0);
    UIImage *arrow = [UIImage imageNamed:@"arrow.png"];
    MGLineStyled
    *triggers = [MGLineStyled lineWithLeft:NSLocalizedString(@"product_detail_reviews_btn_title", nil)
                                     right:arrow size:CGSizeMake(300, 29)];
    triggers.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [section2.topLines addObject:triggers];
    
    
    section2.onTap = ^{
        //self.title = NSLocalizedString(@"back_btn_title", nil);
        CommentViewController *comment = [[CommentViewController alloc] init];
        comment.postID = [productInfo objectForKey:@"product_ID"];
        comment.title = NSLocalizedString(@"product_detail_reviews_btn_title", nil);
        [self.navigationController pushViewController:comment animated:YES];
    };
}


-(void)productYouMayLike:(NSArray*)upsaleData
{
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    section.backgroundColor = [UIColor clearColor];
    section.layer.shadowColor = nil;
    section.layer.shadowOffset = CGSizeMake(0, 0);
    section.layer.shadowRadius = 0;
    section.layer.shadowOpacity = 0;
    section.layer.borderColor = nil;
    section.layer.borderWidth = 0;
    
    section.margin = UIEdgeInsetsMake(10.0, 0.1, 0.0, 0.0);
    [scroller.boxes addObject:section];
    
    ProductDetailBox *box = [ProductDetailBox productYouMayLike:upsaleData detail:self];
    
    box.backgroundColor = [UIColor clearColor];
    box.layer.shadowColor = nil;
    box.layer.shadowOffset = CGSizeMake(0, 0);
    box.layer.shadowRadius = 0;
    box.layer.shadowOpacity = 0;
    box.layer.borderColor = nil;
    box.layer.borderWidth = 0;
    
    
    [section.topLines addObject:box];
    
    
}

-(void)productYouMayLikeTapAction:(id)userData{
    
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(goToProductExe:) onTarget:self withObject:[NSArray arrayWithObjects:userData, nil] animated:YES];
    
}

-(void)goToProductExe:(NSArray*)ary
{
    
    NSDictionary * singleProduct = [[DataService instance] getSingleProduct:[ary objectAtIndex:0]];
    NSLog(@"Single Product : %@",singleProduct);
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        DetailViewController *detail = [[DetailViewController alloc] init];
        [detail setProductInfo:singleProduct];
        detail.title  = [[singleProduct objectForKey:@"general"] objectForKey:@"title"];
        [self.navigationController pushViewController:detail animated:YES];
    });
    
    
}

-(void)shareBtnAction{
    
    socialMediaController *menu = [[socialMediaController alloc] init];
    menu.delegate = self;
    [menu setUrl:[[productInfo objectForKey:@"general"] objectForKey:@"link"]];
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:menu];
    popover.border = YES;
    
    popover.contentSize = CGSizeMake(170,170);
    [popover.view setNuiClass:@"DropDownView"];
    
    [popover presentPopoverFromView:shareBtn];
    
}

-(void)didChooseEmail{
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
//    [NUIRenderer renderNavigationBar:mailer.navigationBar withClass:@"NavigationBar"];
    
    NSString *emailBody = [[productInfo objectForKey:@"general"] objectForKey:@"link"];
    [mailer setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailer animated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    initialContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [bottomView setNeedsDisplay];
    [[SettingDataClass instance] autoHideGlobal:scrollView navigationView:self.navigationController contentOffset:initialContentOffset];
    
    CGFloat pageWidth = imgScrollView.frame.size.width;
    current_product_image_index = floor((imgScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
}


//Add into View
-(void)AddProductVariable{
    
    //Init Some Variable
    copyOfimgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,320)];
    attributeQuery = [[NSMutableDictionary alloc] init];
    
    //insert into db first
    
    
    NSMutableArray *temp_attr = [[NSMutableArray alloc] init];
    NSMutableArray *temp_attr2 = [[NSMutableArray alloc] init];
    if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
    {
        NSArray *ary  = [[productInfo objectForKey:@"attributes"] objectForKey:@"attributes"];
        
        int cou = 0;
        for(int i=0;i<[ary count];i++)
        {
            NSDictionary *dic = [ary objectAtIndex:i];
            
            if([[dic objectForKey:@"is_variation"] intValue] == 1)
            {
                cou += 1;
                
                
                [temp_attr addObject:[NSString stringWithFormat:@"'attribute_%@' TEXT",[dic objectForKey:@"name"]]];
                [temp_attr2 addObject:[dic objectForKey:@"name"]];
                
                [attributeQuery setValue:@""  forKey:[NSString stringWithFormat:@"attribute_%@",[dic objectForKey:@"name"]]];
                
            }
        }
    }
    
    [self addChildProductIntoDatabaseifVariable:temp_attr temp2:temp_attr2 productVariable:[[productInfo objectForKey:@"if_variants"] objectForKey:@"variables"]];
    
    //then we add into the view
    
    
    if([[[productInfo objectForKey:@"general"] objectForKey:@"product_type"] isEqualToString:@"variable"])
    {
        NSArray *ary  = [[productInfo objectForKey:@"attributes"] objectForKey:@"attributes"];
        
        
        for(int i=0;i<[ary count];i++)
        {
            NSDictionary *dic = [ary objectAtIndex:i];
            
            if([[dic objectForKey:@"is_variation"] intValue] == 1)
            {
                
                NSArray *available_attribute = [self find_available_attribute:[NSString stringWithFormat:@"attribute_%@",[dic objectForKey:@"name"]]];
                NSLog(@"Avalaible Atrr : %@",available_attribute);
                if([dic objectForKey:@"label"] == [NSNull null])
                {
                    [self productVariableHalf:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"product_detail_choose_an_option_if_label_null", nil),[dic objectForKey:@"slug"]] isHalf:NO arrayValue:available_attribute termName:[NSString stringWithFormat:@"attribute_%@",[dic objectForKey:@"name"]]];
                }
                else
                {
                    [self productVariableHalf:[dic objectForKey:@"label"] isHalf:NO arrayValue:available_attribute termName:[NSString stringWithFormat:@"attribute_%@",[dic objectForKey:@"name"]]];
                }
            }
        }
    }
}

-(void)addChildProductIntoDatabaseifVariable:(NSMutableArray*)ary temp2:(NSMutableArray*)ary2 productVariable:(NSArray*)product{
    
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"temp.db"];
    [dbManager doQuery:@"DROP TABLE product_variable"];
    
    NSString *sqlCreateStateMent = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'product_variable' ('no' INTEGER PRIMARY KEY  NOT NULL , 'index_key' TEXT,'product_ID' TEXT,'quantity' TEXT, %@);",[ary componentsJoinedByString:@","]];
    
    
    
    NSError *error = [dbManager doQuery:sqlCreateStateMent];
	if (error != nil) {
		NSLog(@"Error: %@",[error localizedDescription]);
	}
    
    for(int i=0;i<[product count];i++)
    {
        NSDictionary *dic = [product objectAtIndex:i];
        NSString *inventoryQuantity;
        if ([[[dic objectForKey:@"inventory"] objectForKey:@"quantity"] isEqualToString:@""]) {
            inventoryQuantity = @"Null";
        }
        else
        {
            inventoryQuantity = [[dic objectForKey:@"inventory"] objectForKey:@"quantity"];
        }
        
        NSArray *product_attr = [dic objectForKey:@"product_attribute"];
        [dbManager doQuery:[NSString stringWithFormat:@"INSERT INTO product_variable(index_key,product_ID,quantity) VALUES('%d','%@','%@')",i,[dic objectForKey:@"product_ID"],inventoryQuantity]];
        
        for(int x = 0;x<[product_attr count];x++)
        {
            NSDictionary *atr = [product_attr objectAtIndex:x];
            [dbManager doQuery:[NSString stringWithFormat:@"UPDATE product_variable SET %@='%@' WHERE product_ID='%@'",[atr objectForKey:@"key"],[atr objectForKey:@"value"],[dic objectForKey:@"product_ID"]]];
        }
    }
    
    NSArray *testAry = [self test];
    NSLog(@"Variable Product : %@",testAry);
}


-(NSArray*)test{
    
    NSArray * ma = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM product_variable"]];
    
    return ma;
}


-(NSArray*)find_available_attribute:(NSString*)collum_name{
    NSArray * ma = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT DISTINCT %@ FROM product_variable",collum_name]];
    
    return ma;
}

- (void)handleTap:(UIGestureRecognizer *)gesture {
    
    
    
    //self.title = NSLocalizedString(@"back_btn_title", nil);
    
    
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    if(isVariableOn == NO)
    {
        
        //Get Featured Image
        [colors addObject:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]];
        
        [photos addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:[[productInfo objectForKey:@"product_gallery"] objectForKey:@"featured_images"]]]];
        
        
        //Get Other Images
        NSArray *otherImages = [[productInfo objectForKey:@"product_gallery"] objectForKey:@"other_images"];
        
        for (int otherIm = 0; otherIm<[otherImages count]; otherIm++) {
            [colors addObject:[otherImages objectAtIndex:otherIm]];
            
            [photos addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:[otherImages objectAtIndex:otherIm]]]];
        }
    }
    else
    {
        [colors addObject:newFeaturedImage];
        
        [photos addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:newFeaturedImage]]];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    
    browser.delegate = self;
    [browser setInitialPageIndex:current_product_image_index];
    
    // Show
    [self presentViewController:browser animated:YES completion:nil];
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index
{
    //id <IDMPhoto> photo = [photoBrowser photoAtIndex:index];
    
    
    
    
}

-(void)closeBtnAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setAttributeQuery:(NSString*)value key:(NSString*)key
{
    
    //hide popover
    [popover dismissPopoverAnimated:YES];
    
    [attributeQuery setValue:value forKey:key];
    
    NSArray *ary  = [[productInfo objectForKey:@"attributes"] objectForKey:@"attributes"];
    
    NSMutableArray *temp_attr = [[NSMutableArray alloc] init];
    for(int i=0;i<[ary count];i++)
    {
        NSDictionary *dic = [ary objectAtIndex:i];
        
        if([[dic objectForKey:@"is_variation"] intValue] == 1)
        {
            
            NSString *keyValue = [attributeQuery objectForKey:[NSString stringWithFormat:@"attribute_%@",[dic objectForKey:@"name"]]];
            
            [temp_attr addObject:[NSString stringWithFormat:@"attribute_%@ = '%@'",[dic objectForKey:@"name"],keyValue]];
            
        }
    }
    
    NSArray * ma = [dbManager getRowsForQuery:[NSString stringWithFormat:@"SELECT * FROM product_variable WHERE %@",[temp_attr componentsJoinedByString:@" AND "]]];
    
    if([ma count] > 0)
    {
        NSDictionary *var_info = [ma objectAtIndex:0];
        
        //Now We can Retrive it from JSON Back to get Variable Info
        NSArray *product_variable_arrays = [[productInfo objectForKey:@"if_variants"] objectForKey:@"variables"];
        
        NSDictionary *product_variable = [product_variable_arrays objectAtIndex:[[var_info objectForKey:@"index_key"] intValue]];
        product_variable_copy = product_variable;
//        NSLog(@"%@",product_variable);
        [copyOfimgScrollView removeFromSuperview];
        
        //Check Product Variable Type if insdie the Cart...If Yes we change it
        
        
        if([[MyCartClass instance] checkInCart:[product_variable objectForKey:@"product_ID"]])
        {
            [addToCartBox addToCartBtnInCart:[[MyCartClass instance] productQuantityInsideCart:[product_variable objectForKey:@"product_ID"]]];
        }
        else
        {
            
            addToCartBox.addToCartLbl.text = NSLocalizedString(@"product_detail_add_to_cart_btn_title", nil);
        }
        
        if([[product_variable objectForKey:@"featured_images"] isEqualToString:@"0"])
        {
            isVariableOn = NO;
            // If Featured Image Is Not Available
            //Not change in image just change the price
            imgScrollView.userInteractionEnabled = YES;
            variablePrice.text = [NSString stringWithFormat:@"%@ %@",
                                  [[SettingDataClass instance] getCurrencySymbol],
                                  [[[product_variable objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]];
//                                  [[AppDelegate instance] convertToThousandSeparator:[[[product_variable objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]];
        }
        else
        {
            
            isVariableOn = YES;
            newFeaturedImage = [product_variable objectForKey:@"featured_images"];
            
            //Once We Got The Variable In Dictionary. We update the TopView->imgScrollView & TopView->price
            
            //We Copy First for Backup
        
            //The We Add With New Image From Variable Product
            NSMutableArray *colors = [[NSMutableArray alloc] init];
            //Get Variable Featured Image
            [colors addObject:[product_variable objectForKey:@"featured_images"]];
            
            UIImageView *myImgViewsse;
            
            for (int i = 0; i < colors.count; i++) {
                CGRect frame;
                    
                frame.origin.x = copyOfimgScrollView.frame.size.width * i;
                frame.origin.y = 0;
                frame.size = copyOfimgScrollView.frame.size;
                UIView *subview = [[UIView alloc] initWithFrame:frame];
                myImgViewsse = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, copyOfimgScrollView.frame.size.width, copyOfimgScrollView.frame.size.height)];
                myImgViewsse.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
                [myImgViewsse setImageWithURL:[NSURL URLWithString:[colors objectAtIndex:i]] placeholderImage:nil];
                UIImageView *temp = myImgViewsse;
                [myImgViewsse setImageWithURL:[NSURL URLWithString:[colors objectAtIndex:i]]
                             placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                        
                                        temp.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(320, 290) source:image];
                                        
                                    }];
                
                
                myImgViewsse.userInteractionEnabled = TRUE;
                UILabel *backSleek = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, 320, 200)];
                backSleek.backgroundColor = [UIColor clearColor];
                backSleek.alpha = 1;
                
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = backSleek.bounds;
                gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
                [backSleek.layer insertSublayer:gradient atIndex:0];
                
                [subview addSubview:myImgViewsse];
                
                [subview addSubview:backSleek];
                
                [copyOfimgScrollView addSubview:subview];   
            }
            imgScrollView.userInteractionEnabled = NO;
            [imgScrollView setContentOffset:CGPointZero animated:YES];
            [imgScrollView addSubview:copyOfimgScrollView];
            
            
            //Once Done We Change The Price
            NSNumber *boolean = (NSNumber *)[[product_variable objectForKey:@"pricing"] objectForKey:@"is_on_sale"];
            
            if([boolean boolValue] == true)
            {
                onSaleBadgeVariable.hidden = NO;
                
                NSString *regular = [NSString stringWithFormat:@"%@ %@",
                                     [[SettingDataClass instance] getCurrencySymbol],
                                     [[[product_variable objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]];
//                                     [[AppDelegate instance] convertToThousandSeparator:[[[product_variable objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]];
                
                NSString *sale_price = [NSString stringWithFormat:@"%@ %@",
                                        [[SettingDataClass instance] getCurrencySymbol],
                                        [[product_variable objectForKey:@"pricing"] objectForKey:@"sale_price"]];
                
                NSString *text = [NSString stringWithFormat:@"%@ %@",regular,sale_price];
                [variablePrice setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange boldRange = [[mutableAttributedString string] rangeOfString:sale_price options:NSCaseInsensitiveSearch];
                    NSRange strikeRange = [[mutableAttributedString string] rangeOfString:regular options:NSCaseInsensitiveSearch];
                    
                    // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
                    UIFont *boldSystemFont = [UIFont fontWithName:BOLDFONT size:14];
                    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                    if (font) {
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                        [mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:[NSNumber numberWithBool:YES] range:strikeRange];
                        CFRelease(font);
                    }
                    
                    return mutableAttributedString;
                }];
            }
            else
            {
                onSaleBadgeVariable.hidden = YES;
                
                NSString *regularPrice = [[product_variable objectForKey:@"pricing"] objectForKey:@"regular_price"];
                
                [variablePrice setText:[NSString stringWithFormat:@"%@ %@",
                                        [[SettingDataClass instance] getCurrencySymbol],
//                                        [[[product_variable objectForKey:@"general"] objectForKey:@"pricing"] objectForKey:@"regular_price"]]];
                                        regularPrice]];
            }
            
            if([[[product_variable objectForKey:@"inventory"] objectForKey:@"quantity"] isEqualToString:@""])
            {
                
                //If empty we assume this variable item is not set any inventory
                [addToCartBox addToCartBtnIfVariableNoIventory];
            }
            else
            {
                [addToCartBox addToCartBtnIfVariableQuantityAppear:[[product_variable objectForKey:@"inventory"] objectForKey:@"quantity"]];
                
            }
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
