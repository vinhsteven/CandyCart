

#import "PhotoBox.h"
#import "UIImageView+WebCache.h"
@implementation PhotoBox

#pragma mark - Init
static UILabel *lbl;
- (void)setup {
    
    
    
    // background
    self.backgroundColor = [UIColor whiteColor];
    
    // shadow
    //self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:0.3].CGColor;
    // self.layer.shadowOffset = CGSizeMake(0, 0.5);
    // self.layer.shadowRadius = 1;
    // self.layer.shadowOpacity = 0.3;
    //  self.layer.cornerRadius = 0;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - Factories

+(PhotoBox *)fullImageBox:(CGSize)size pictureURL:(NSString*)url title:(NSString*)pTitle currency:(NSString*)currency regularPrice:(NSString*)productPrice salePrice:(NSString*)salePrice isOnSale:(BOOL)onSale notSimple:(BOOL)notSimple{
    // positioning
    
    // basic box
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    box.tag = -1;
    
    UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIImageView *se = addView;
    
    [addView setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(size.width, size.height) source:image];
                       
                   }];
    
    
    [box addSubview:addView];
    
    UILabel *backSleek = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, size.width, 45)];
    backSleek.backgroundColor = [UIColor clearColor];
    backSleek.alpha = 1;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = backSleek.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
    [backSleek.layer insertSublayer:gradient atIndex:0];
    [box addSubview:backSleek];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, size.width-20, 60)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    [title setNuiClass:@"BoxTitleLabel"];
    title.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    title.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    title.layer.shadowOpacity = 1.0f;
    title.layer.shadowRadius = 1.0f;
    
    
    title.text = pTitle;
    [box addSubview:title];
    
    //check if product belong to slug = ca-si, don't add price and currency
    
    if(notSimple == NO)
    {
        if(onSale == NO)
        {
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 163, size.width-20, 50)];
            
            price.backgroundColor = [UIColor clearColor];
            price.textColor = [UIColor whiteColor];
            price.textAlignment = NSTextAlignmentLeft;
            [price setNuiClass:@"BoxPriceLabel"];
            price.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
            price.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
            price.layer.shadowOpacity = 1.0f;
            price.layer.shadowRadius = 1.0f;
            
            
            price.text = [NSString stringWithFormat:@"%@ %@",currency,productPrice];
            [box addSubview:price];
        }
        else
        {
            TTTAttributedLabel *price = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 163, size.width-20, 50)];
            
            price.textAlignment = NSTextAlignmentLeft;
            price.font = [UIFont fontWithName:PRIMARYFONT size:14];
            price.textColor = [UIColor whiteColor];
            price.backgroundColor = [UIColor clearColor];
            [box addSubview:price];
            
            NSString* regularPrice = [NSString stringWithFormat:@"%@ %@",currency,productPrice];
            NSString* salePrices = [NSString stringWithFormat:@"%@ %@",currency,salePrice];
            
            NSString *text = [NSString stringWithFormat:@"%@ %@",regularPrice,salePrices];
            [price setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange boldRange = [[mutableAttributedString string] rangeOfString:salePrices options:NSCaseInsensitiveSearch];
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
    }
    else
    {
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 163, size.width-20, 50)];
        
        price.backgroundColor = [UIColor clearColor];
        price.textColor = [UIColor whiteColor];
        price.textAlignment = NSTextAlignmentLeft;
        [price setNuiClass:@"BoxPriceLabel"];
        price.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        price.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        price.layer.shadowOpacity = 1.0f;
        price.layer.shadowRadius = 1.0f;
        
        price.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil),currency,productPrice];
        [box addSubview:price];
    }
    
    if(onSale == YES)
    {
        UILabel *onSaleBadge = [[UILabel alloc] initWithFrame:CGRectMake(addView.width-55, 5, 50, 50)];
        onSaleBadge.text = NSLocalizedString(@"sale_badge_title", nil);
        [onSaleBadge setNuiClass:@"OnSaleBadge"];
        onSaleBadge.textAlignment = NSTextAlignmentCenter;
        onSaleBadge.layer.cornerRadius = 25;
        
        onSaleBadge.layer.masksToBounds = YES;
        
        [addView addSubview:onSaleBadge];
    }
    
    return box;
}

+(PhotoBox *)fullImageBox:(CGSize)size pictureURL:(NSString*)url title:(NSString*)pTitle currency:(NSString*)currency regularPrice:(NSString*)productPrice salePrice:(NSString*)salePrice isOnSale:(BOOL)onSale notSimple:(BOOL)notSimple displayPrice:(BOOL)isDisplayPrice {
    // positioning
    
    // basic box
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    box.tag = -1;
    
    UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIImageView *se = addView;
    
    [addView setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(size.width, size.height) source:image];
                       
                   }];
    
    
    [box addSubview:addView];
    
    UILabel *backSleek = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, size.width, 45)];
    backSleek.backgroundColor = [UIColor clearColor];
    backSleek.alpha = 1;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = backSleek.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
    [backSleek.layer insertSublayer:gradient atIndex:0];
    [box addSubview:backSleek];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, size.width-20, 60)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    [title setNuiClass:@"BoxTitleLabel"];
    title.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    title.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    title.layer.shadowOpacity = 1.0f;
    title.layer.shadowRadius = 1.0f;
    
    
    title.text = pTitle;
    [box addSubview:title];
    
    //check if product belong to slug = ca-si, don't add price and currency
    
    if (isDisplayPrice) {
        if(notSimple == NO)
        {
            if(onSale == NO)
            {
                UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 163, size.width-20, 50)];
                
                price.backgroundColor = [UIColor clearColor];
                price.textColor = [UIColor whiteColor];
                price.textAlignment = NSTextAlignmentLeft;
                [price setNuiClass:@"BoxPriceLabel"];
                price.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
                price.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
                price.layer.shadowOpacity = 1.0f;
                price.layer.shadowRadius = 1.0f;
                
                
                price.text = [NSString stringWithFormat:@"%@ %@",currency,productPrice];
                [box addSubview:price];
            }
            else
            {
                TTTAttributedLabel *price = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 163, size.width-20, 50)];
                
                price.textAlignment = NSTextAlignmentLeft;
                price.font = [UIFont fontWithName:PRIMARYFONT size:14];
                price.textColor = [UIColor whiteColor];
                price.backgroundColor = [UIColor clearColor];
                [box addSubview:price];
                
                NSString* regularPrice = [NSString stringWithFormat:@"%@ %@",currency,productPrice];
                NSString* salePrices = [NSString stringWithFormat:@"%@ %@",currency,salePrice];
                
                NSString *text = [NSString stringWithFormat:@"%@ %@",regularPrice,salePrices];
                [price setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    NSRange boldRange = [[mutableAttributedString string] rangeOfString:salePrices options:NSCaseInsensitiveSearch];
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
        }
        else
        {
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10, 163, size.width-20, 50)];
            
            price.backgroundColor = [UIColor clearColor];
            price.textColor = [UIColor whiteColor];
            price.textAlignment = NSTextAlignmentLeft;
            [price setNuiClass:@"BoxPriceLabel"];
            price.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
            price.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
            price.layer.shadowOpacity = 1.0f;
            price.layer.shadowRadius = 1.0f;
            
            price.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"group_and_variable_pricing", nil),currency,productPrice];
            [box addSubview:price];
        }
        
        if(onSale == YES)
        {
            UILabel *onSaleBadge = [[UILabel alloc] initWithFrame:CGRectMake(addView.width-55, 5, 50, 50)];
            onSaleBadge.text = NSLocalizedString(@"sale_badge_title", nil);
            [onSaleBadge setNuiClass:@"OnSaleBadge"];
            onSaleBadge.textAlignment = NSTextAlignmentCenter;
            onSaleBadge.layer.cornerRadius = 25;
            
            onSaleBadge.layer.masksToBounds = YES;
            
            [addView addSubview:onSaleBadge];
        }
    }
    
    return box;
}


+ (PhotoBox *)loadMore:(CGSize)size {
    
    PhotoBox *box = [PhotoBox boxWithSize:size];
    box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    
    UILabel *loadMore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [loadMore setNuiClass:@"DropDownMenu"];
    
    [[MiscInstances instance] setLoadMoreUILabel:loadMore];
    
    loadMore.text = NSLocalizedString(@"browse_view_load_more", nil);
    loadMore.textAlignment = NSTextAlignmentCenter;
    
    [box addSubview:loadMore];
    
    
    UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    ind.center = CGPointMake(size.width / 2,size.height / 2);
    [[MiscInstances instance] setLoadMoreActivityView:ind];
    [ind stopAnimating];
    [ind hidesWhenStopped];
    [box addSubview:ind];
    
    return box;
}


+ (PhotoBox *)gridStyleNormal:(CGSize)size img:(NSString*)url title:(NSString*)str priceRegular:(NSString*)regularPrice{
    
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    box.tag = -1;
    
    // add the add image
    
    UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-30)];
    
    UIImageView *se = addView;
    
    [addView setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(size.width, size.width) source:image];
                       
                   }];
    
    [box addSubview:addView];
    
    
    /* NUI Class SmallBoxPriceLabelNormal */
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(size.width - 140, size.width-35, 130, 16)];
    price.text = regularPrice;
    price.textAlignment = NSTextAlignmentCenter;
    price.font = [UIFont fontWithName:BOLDFONT size:9];
    price.textColor = [UIColor whiteColor];
    price.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    price.layer.cornerRadius = 3;
    [addView addSubview:price];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, size.height-30, size.width-10, 30)];
    title.userInteractionEnabled = NO;
    title.lineBreakMode = NSLineBreakByTruncatingTail;
    title.numberOfLines = 0;
    title.text = str;
    [title setNuiClass:@"SmallBoxTitleLabel"];
    [box addSubview:title];
    
    return box;
}

+ (PhotoBox *)gridStyleNormal:(CGSize)size img:(NSString*)url title:(NSString*)str priceRegular:(NSString*)regularPrice displayPrice:(BOOL)isDisplayPrice {
    
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    box.tag = -1;
    
    // add the add image
    
    UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-30)];
    
    UIImageView *se = addView;
    
    [addView setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(size.width, size.width) source:image];
                       
                   }];
    
    [box addSubview:addView];
    
    if (isDisplayPrice) {
        /* NUI Class SmallBoxPriceLabelNormal */
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(size.width - 140, size.width-35, 130, 16)];
        price.text = regularPrice;
        price.textAlignment = NSTextAlignmentCenter;
        price.font = [UIFont fontWithName:BOLDFONT size:9];
        price.textColor = [UIColor whiteColor];
        price.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        price.layer.cornerRadius = 3;
        [addView addSubview:price];
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, size.height-30, size.width-10, 30)];
    title.userInteractionEnabled = NO;
    title.lineBreakMode = NSLineBreakByTruncatingTail;
    title.numberOfLines = 0;
    title.text = str;
    [title setNuiClass:@"SmallBoxTitleLabel"];
    [box addSubview:title];
    
    return box;
}

+ (PhotoBox *)gridStyleOnSale:(CGSize)size img:(NSString*)url title:(NSString*)str priceRegular:(NSString*)regularPrice salePrice:(NSString*)salePrice{
    
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    box.tag = -1;
    
    // add the add image
    
    UIImageView *addView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-30)];
    
    
    
    UIImageView *se = addView;
    
    [addView setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                       
                       se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(size.width, size.width) source:image];
                       
                   }];
    
    
    [box addSubview:addView];
    
    /* NUI Class SmallBoxPriceLabelOnSale */
    TTTAttributedLabel *price = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(size.width - 140, size.width-35, 130, 16)];
    
    price.textAlignment = NSTextAlignmentCenter;
    price.font = [UIFont fontWithName:PRIMARYFONT size:9];
    price.textColor = [UIColor whiteColor];
    price.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];;
    [addView addSubview:price];
    price.layer.cornerRadius = 3;
    
    
    
    UILabel *onSaleBadge = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    onSaleBadge.text = NSLocalizedString(@"sale_badge_title", nil);
    [onSaleBadge setNuiClass:@"OnSaleBadgeSmall"];
    onSaleBadge.textAlignment = NSTextAlignmentCenter;
    onSaleBadge.layer.cornerRadius = 15;
    
    onSaleBadge.layer.masksToBounds = YES;
    
    [addView addSubview:onSaleBadge];
    
    
    
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
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, size.height-30, size.width-10, 30)];
    title.userInteractionEnabled = NO;
    title.lineBreakMode = NSLineBreakByTruncatingTail;
    title.numberOfLines = 0;
    title.text = str;
    [title setNuiClass:@"SmallBoxTitleLabel"];
    [box addSubview:title];
    
    return box;
}


+ (PhotoBox *)chooseSubCategory:(CGSize)size {
    
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    UILabel *subCategoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width-20, size.height)];
    [subCategoryTitle setNuiClass:@"DropDownMenu"];
    
    subCategoryTitle.text = NSLocalizedString(@"browse_view_select_sub_category", nil);
    subCategoryTitle.textAlignment = NSTextAlignmentLeft;
    
    [box addSubview:subCategoryTitle];
    
    [self setUILabelForSubCategoryLabel:subCategoryTitle];
    
    TriangleDropDown *triagle = [[TriangleDropDown alloc] initWithFrame:CGRectMake(size.width-20, 10, 12, 12)];
    [triagle setColor:[UIColor darkGrayColor]];
    [triagle rotateToDown];
    triagle.userInteractionEnabled = YES;
    [box addSubview:triagle];
    
    return box;
}

+ (PhotoBox *)reviewHeader:(CGSize)size username:(NSString*)username imgUrl:(NSString*)url rating:(float)rate{
    
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0, 0, 50, 50);
    UIImageView *img2 = [[UIImageView alloc] init];
    
    
    [img setImageWithURL:[NSURL URLWithString:url]
        placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                   
                   img2.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(100, 100) source:image];
                   
               }];
    
    img.image = img2.image;
    img.layer.cornerRadius = 25;
    img.layer.masksToBounds = YES;
    [box addSubview:img];
    
    if(rate > 0)
    {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, size.width-70, size.height*0.5)];
        lbl.text = username;
        lbl.backgroundColor = [UIColor clearColor];
        [lbl setNuiClass:@"ReviewHeaderUsername"];
        
        DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(43, size.height*0.5+3, size.width-70, 30) andStars:5 isFractional:NO starGapCustomAdjust:0.3];
        customNumberOfStars.enabled = NO;
        
        [customNumberOfStars setStar:[UIImage imageNamed:@"verySmallStar"] highlightedStar:[UIImage imageNamed:@"verySmallStarHigh"]];
        customNumberOfStars.backgroundColor = [UIColor clearColor];
        
        customNumberOfStars.rating = rate;
        [box addSubview:customNumberOfStars];
        
        
        [box addSubview:lbl];
    }
    else
    {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, size.width-70, size.height*0.5)];
        lbl.text = username;
        lbl.backgroundColor = [UIColor clearColor];
        [lbl setNuiClass:@"ReviewHeaderUsername"];
        [box addSubview:lbl];
    }
    
    return box;
}



+(void)setUILabelForSubCategoryLabel:(UILabel*)le{
    
    lbl = le;
}

+(UILabel*)getUILabelForSubCategoryLabel
{
    return lbl;
}

#pragma mark - Layout

- (void)layout {
    [super layout];
    
    // speed up shadows
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end
