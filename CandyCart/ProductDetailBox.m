//
//  ProductDetailBox.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/16/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "ProductDetailBox.h"
#import "DetailViewController.h"
@implementation ProductDetailBox
@synthesize addToCartLbl;
- (void)setup {
    
    
    
    // background
    self.backgroundColor = [UIColor whiteColor];
    
    // shadow
    //self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:0.3].CGColor;
    //self.layer.shadowOffset = CGSizeMake(0, 0.5);
   // self.layer.shadowRadius = 1;
    //self.layer.shadowOpacity = 0.3;
   // self.layer.cornerRadius = 0;
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (void)addToCartBtnInCart:(int)incartquantity{
    
    
    
    addToCartLbl.text = [NSString stringWithFormat:@"%@ (%d)",NSLocalizedString(@"product_detail_add_to_cart_btn_incart_title", nil),incartquantity];
}


- (void)addToCartBtnIfVariableNoIventory{
    
    
    
    addToCartLbl.text = NSLocalizedString(@"product_detail_add_to_cart_btn_title", nil);
}

- (void)addToCartBtnIfVariableQuantityAppear:(NSString*)quantity{
    
    if([quantity isEqualToString:@"0"])
    {
    
   
        addToCartLbl.text = NSLocalizedString(@"product_detail_add_to_cart_btn_outofstock_title", nil);
    }
    else
    {
         addToCartLbl.text = [NSString stringWithFormat:@"%@ (%@ %@)",NSLocalizedString(@"product_detail_add_to_cart_btn_title", nil),quantity,NSLocalizedString(@"product_detail_in_stock", nil)];
    }
}

- (ProductDetailBox *)addToCartBtn:(BOOL)outOfStock{
    
    addToCartBox = [ProductDetailBox boxWithSize:CGSizeMake(300, 40)];
    
    addToCartLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    if(outOfStock == true)
    {
         [addToCartLbl setNuiClass:@"outOfStockBtn"];
        addToCartLbl.text = NSLocalizedString(@"product_detail_add_to_cart_btn_outofstock_title", nil);
    }
    else
    {
    [addToCartLbl setNuiClass:@"addToCartBtn"];
        addToCartLbl.text = NSLocalizedString(@"product_detail_add_to_cart_btn_title", nil);
    }
    
    addToCartLbl.lineBreakMode = NSLineBreakByWordWrapping;
    addToCartLbl.numberOfLines = 0;
    addToCartLbl.textAlignment = NSTextAlignmentCenter;
    addToCartLbl.autoresizesSubviews = YES;
    
    [addToCartBox addSubview:addToCartLbl];
    
    return addToCartBox;
}



+ (ProductDetailBox *)inventory:(NSString*)stock allowedBackOrderNotification:(BOOL)backorder{
    
    ProductDetailBox *box = [ProductDetailBox boxWithSize:CGSizeMake(300, 30)];
    
    
    
  
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 30)];
    
    [lbl setNuiClass:@"inventory"];
    
    if(backorder == TRUE)
    {
        lbl.text = [NSString stringWithFormat:@"%@ %@ (%@)",stock,NSLocalizedString(@"product_detail_in_stock", nil),NSLocalizedString(@"product_detail_allowed_backorder", nil)];
    }
    else
    {
    lbl.text = [NSString stringWithFormat:@"%@ %@",stock,NSLocalizedString(@"product_detail_in_stock", nil)];
    }
        lbl.textAlignment = NSTextAlignmentLeft;
    
    
    
    
    [box addSubview:lbl];
    
    
    
    return box;
}




+ (ProductDetailBox *)productYouMayLike:(NSArray*)upsale_data detail:(DetailViewController*)det{
    
    ProductDetailBox *box = [ProductDetailBox boxWithSize:CGSizeMake(320, 170)];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 20)];
    header.text = NSLocalizedString(@"product_detail_may_like", nil);
    [header setNuiClass:@"productYouMayLikeHeader"];
    [box addSubview:header];
    
    UIScrollView *imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(box.origin.x, 30, box.size.width,box.size.height)];
    
    UIImageView* myImgViewsse;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[upsale_data count];i++)
    {
        NSDictionary *directory = [upsale_data objectAtIndex:i];
      [colors addObject:[NSArray arrayWithObjects:
                         [NSString stringWithFormat:@"%@",[directory objectForKey:@"featured_image"]],
                         [directory objectForKey:@"title"],
                         [directory objectForKey:@"product_type"],
                         [directory objectForKey:@"pricing"],
                         [directory objectForKey:@"if_group"],
                         [directory objectForKey:@"if_variants"],
                         [directory objectForKey:@"ID"], nil]];
    }
    
    
    for (int i = 0; i < colors.count; i++) {
        CGRect frame;
		
        // horizontal scrolling
        frame.origin.x = 120 * i;
		frame.origin.y = 5;
        
        // to show vertical comment the 2 lines above and uncomment the 2 lines below
        //      frame.origin.x = 0;
        //      frame.origin.y = self.scrollView.frame.size.height * i;
        
        // create a frame with the size of our scrollview
        // this is done to keep image the size of our scrollview
		frame.size.width = imgScrollView.frame.size.width;
        frame.size.height = imgScrollView.frame.size.height;
        
        // init a view with the size of our scrollview
		UIView *subview = [[UIView alloc] initWithFrame:frame];
        [subview setNuiClass:@"productYouMayLikeScrollViewHolder"];
        // init an image with the width/height of our scrollview
        myImgViewsse = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
        // keep our autoresizing masks in place
        myImgViewsse.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        // async image loading & caching
      
        
        UIImageView *temp = myImgViewsse;
        
        [myImgViewsse setImageWithURL:[NSURL URLWithString:[[colors objectAtIndex:i] objectAtIndex:0]]
                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                
                                temp.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(100, 100) source:image];
                                
                            }];
        
        
        
        
        // image interaction enabled
        myImgViewsse.userInteractionEnabled = TRUE;
        
        // aspect fit mode
        //[myImgView setContentMode:UIViewContentModeScaleAspectFit];
        
        
        UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(12, 0, 100, 120)];
        
        holder.backgroundColor = [UIColor whiteColor];
        holder.layer.shadowColor = nil;
        holder.layer.shadowOffset = CGSizeMake(0, 0);
        holder.layer.shadowRadius = 0;
        holder.layer.shadowOpacity = 0;
        holder.layer.borderColor = [UIColor lightGrayColor].CGColor;
        holder.layer.borderWidth = 0.5;
        
        
        
        holder.layer.masksToBounds = NO;

        holder.userInteractionEnabled = YES;
        [holder addSubview:myImgViewsse];
        
        // add image to our subview collection
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(myImgViewsse.frame.origin.x+5, myImgViewsse.frame.size.height, myImgViewsse.frame.size.width-10, 18)];
        
        title.textAlignment = NSTextAlignmentCenter;
        [title setNuiClass:@"productYouMayLikeItemTitle"];
        title.text = [[ToolClass instance] decodeHTMLCharacterEntities:[[colors objectAtIndex:i] objectAtIndex:1]];
        [holder addSubview:title];
        
        NSString *type = [NSString stringWithFormat:@"%@",[[colors objectAtIndex:i] objectAtIndex:2]];
        
        if([type isEqualToString:@"simple"] || [type isEqualToString:@"external"] || [type isEqualToString:NULL])
        {
        
            NSDictionary *pricing = [[colors objectAtIndex:i] objectAtIndex:3];
            NSNumber *boolean = (NSNumber *)[pricing objectForKey:@"is_on_sale"];

            if([boolean boolValue] == FALSE)
            {
           
        
                UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 80, 16)];
                
                price.text = [NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[pricing objectForKey:@"regular_price"]]];
                price.textAlignment = NSTextAlignmentCenter;
                price.font = [UIFont fontWithName:BOLDFONT size:8];
                price.textColor = [UIColor whiteColor];
                price.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                price.layer.cornerRadius = 3;
                
                [myImgViewsse addSubview:price];
        
        
             }
            else
            {
                UILabel *onSaleBadge = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
                onSaleBadge.text = NSLocalizedString(@"sale_badge_title", nil);
                [onSaleBadge setNuiClass:@"OnSaleBadgeSmall"];
                onSaleBadge.textAlignment = NSTextAlignmentCenter;
                onSaleBadge.layer.cornerRadius = 15;
                
                onSaleBadge.layer.masksToBounds = YES;
                
                [holder addSubview:onSaleBadge];
                
                
                TTTAttributedLabel *price = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 75, 80, 16)];
                
                price.textAlignment = NSTextAlignmentCenter;
                price.font = [UIFont fontWithName:PRIMARYFONT size:8];
                price.textColor = [UIColor whiteColor];
                price.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];;
                [myImgViewsse addSubview:price];
                price.layer.cornerRadius = 3;
                
                
                NSString* regularPrice = [NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[pricing objectForKey:@"regular_price"]]];
                 NSString* salePrice = [NSString stringWithFormat:@"%@ %@", [[SettingDataClass instance] getCurrencySymbol],[[AppDelegate instance] convertToThousandSeparator:[pricing objectForKey:@"sale_price"]]];
                
                NSString *text = [NSString stringWithFormat:@"%@ %@",regularPrice,salePrice];
                [price setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange boldRange = [[mutableAttributedString string] rangeOfString:salePrice options:NSCaseInsensitiveSearch];
                    NSRange strikeRange = [[mutableAttributedString string] rangeOfString:regularPrice options:NSCaseInsensitiveSearch];
                    
                    // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
                    UIFont *boldSystemFont = [UIFont fontWithName:BOLDFONT size:9];
                    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                    if (font) {
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                        [mutableAttributedString addAttribute:kTTTStrikeOutAttributeName value:[NSNumber numberWithBool:YES] range:strikeRange];
                        CFRelease(font);
                    }
                    
                    return mutableAttributedString;
                }];


                
            }
        
        }
        else if([type isEqualToString:@"grouped"])
        {
            NSDictionary *if_group = [[colors objectAtIndex:i] objectAtIndex:4];
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 80, 16)];
            
            price.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil), [[SettingDataClass instance] getCurrencySymbol],[[if_group objectForKey:@"min_price"] objectForKey:@"price"]];
            price.textAlignment = NSTextAlignmentCenter;
            price.font = [UIFont fontWithName:BOLDFONT size:8];
            price.textColor = [UIColor whiteColor];
            price.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            price.layer.cornerRadius = 3;
            
            [myImgViewsse addSubview:price];
            
        }
        else if([type isEqualToString:@"variable"])
        {
              NSDictionary *if_group = [[colors objectAtIndex:i] objectAtIndex:5];
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 80, 16)];
            
            price.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil), [[SettingDataClass instance] getCurrencySymbol],[[if_group objectForKey:@"min_price"] objectForKey:@"price"]];
            price.textAlignment = NSTextAlignmentCenter;
            price.font = [UIFont fontWithName:BOLDFONT size:8];
            price.textColor = [UIColor whiteColor];
            price.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            price.layer.cornerRadius = 3;
            
            [myImgViewsse addSubview:price];
            
        }
        
        [holder setNuiClass:@"ViewInit"];
        [subview addSubview:holder];
        
        
        
        
        UserDataTapGestureRecognizer *tapGestureRecognize = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        tapGestureRecognize.userData = [[colors objectAtIndex:i] objectAtIndex:6];
        tapGestureRecognize.parentDetail = det;
        tapGestureRecognize.numberOfTapsRequired = 1;
       
        [holder addGestureRecognizer:tapGestureRecognize];
        
        // add subview to scrollview
		[imgScrollView addSubview:subview];
        
        
	}
    
    
    
    imgScrollView.contentSize = CGSizeMake(132 * colors.count, imgScrollView.frame.size.height);
    
    // comment the above and uncomment the below to show vertical scrolling
    //    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height* colors.count);
    
    imgScrollView.contentMode = UIViewContentModeScaleAspectFit;
    
    // scrollview options
    imgScrollView.zoomScale = 0;
    
    imgScrollView.pagingEnabled = NO;
    imgScrollView.showsHorizontalScrollIndicator = NO;
    imgScrollView.alwaysBounceHorizontal = YES;
    [box addSubview:imgScrollView];
    
    return box;
}
+(void) singleTapGestureRecognizer:(UserDataTapGestureRecognizer *)gr {
  
    [gr.parentDetail productYouMayLikeTapAction:gr.userData];
    
}




+ (ProductDetailBox *)option:(CGSize)size{
    
    ProductDetailBox *box = [ProductDetailBox boxWithSize:CGSizeMake(size.width, size.height)];
    
    
    
    
    
   
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    img.frame = CGRectMake(size.width-27, size.height/4.6, 18, 18);
    
    img.transform = CGAffineTransformMakeRotation(1.5707963267949);
    
    
    [box addSubview:img];
    
    return box;

    
}


+ (ProductDetailBox *)desc:(CGSize)size{
    
    ProductDetailBox *box = [ProductDetailBox boxWithSize:CGSizeMake(size.width, size.height)];
    
    
    
    return box;
    
    
}


+ (ProductDetailBox *)countDownTimer:(CGSize)size leftSmall:(NSString*)text{
    
    ProductDetailBox *box = [ProductDetailBox boxWithSize:CGSizeMake(size.width, size.height)];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (size.width*0.5)-10, size.height)];
    lbl.text = [NSString stringWithFormat:@"%@",text];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont fontWithName:PRIMARYFONT size:12];
    [box addSubview:lbl];
    
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake((size.width*0.5)-10, 0, size.width*0.5, size.height)];
    lbl2.text = [NSString stringWithFormat:@"%@",@"03:12:37"];
    lbl2.textAlignment = NSTextAlignmentRight;
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.font = [UIFont fontWithName:BOLDFONT size:17];
    [box addSubview:lbl2];
    
    
    MZTimerLabel *timerExample9 = [[MZTimerLabel alloc] initWithLabel:lbl2 andTimerType:MZTimerLabelTypeTimer];
    [timerExample9 setCountDownTime:50000];
    //timerExample9.delegate = self;
    [timerExample9 start];
    
    return box;
    
    
}


+ (ProductDetailBox *)groupItem:(NSString*)featuredImgUrl productTitle:(NSString*)title currency:(NSString*)currency price:(NSString*)regul salePrice:(NSString*)salePrices isOnSale:(BOOL)onSale{
    
    ProductDetailBox *box = [ProductDetailBox boxWithSize:CGSizeMake(300, 50)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *img2 = [[UIImageView alloc] init];
    
    
    [imgView setImageWithURL:[NSURL URLWithString:featuredImgUrl]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       img2.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(100, 100) source:image];
                       
                   }];
    
    imgView.image = img2.image;
    
    
    [box addSubview:imgView];
    
    
    
    
    if(onSale == FALSE)
    {
        
        
        
        
        UILabel *regularPrice = [[UILabel alloc] initWithFrame:CGRectMake(60, 8, 230, 20)];
         regularPrice.text = [NSString stringWithFormat:@"%@ %@",currency,regul];
        
        regularPrice.backgroundColor = [UIColor clearColor];
        regularPrice.font = [UIFont fontWithName:PRIMARYFONT size:14];
        [box addSubview:regularPrice];
        
        
    }
    else
    {
       
        
        
        TTTAttributedLabel *price = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(60, 8, 230, 20)];
        
        price.textAlignment = NSTextAlignmentLeft;
        price.font = [UIFont fontWithName:PRIMARYFONT size:14];
      
      price.backgroundColor = [UIColor clearColor];
         [box addSubview:price];
        
        NSString* regularPrice = [NSString stringWithFormat:@"%@ %@",currency,regul];
        NSString* salePrice = [NSString stringWithFormat:@"%@ %@",currency,salePrices];
        
        NSString *text = [NSString stringWithFormat:@"%@ %@",regularPrice,salePrice];
        [price setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange boldRange = [[mutableAttributedString string] rangeOfString:salePrice options:NSCaseInsensitiveSearch];
            NSRange strikeRange = [[mutableAttributedString string] rangeOfString:regularPrice options:NSCaseInsensitiveSearch];
            
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

    
    
   
    
    UILabel *productTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 24, 230, 20)];
    productTitle.text = title;
    productTitle.font = [UIFont fontWithName:PRIMARYFONT size:10];
    productTitle.backgroundColor = [UIColor clearColor];
    [box addSubview:productTitle];
    
   
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    img.frame = CGRectMake(box.size.width-30, box.size.height/3, 18, 18);
    
    
    
    
    [box addSubview:img];

   
    return box;
}




- (void)layout {
    [super layout];
    
    // speed up shadows
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}


@end
