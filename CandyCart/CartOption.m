//
//  CartOption.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 7/9/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "CartOption.h"

@implementation CartOption
+ (CartOption *) instance {
    static CartOption *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


-(UILabel*)addDropDownMenu:(CGRect)rect placeholder:(NSString*)placeholder menuItem:(NSArray*)ary{
    menuItems = ary;
    dropDownMenuContainer = [[UILabel alloc] initWithFrame:rect];
    dropDownMenuContainer.backgroundColor = [UIColor clearColor];
     dropDownMenuContainer.text = placeholder;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dropDownMenuContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f] CGColor], nil];
    [dropDownMenuContainer.layer insertSublayer:gradient atIndex:0];
   
    dropDownMenuContainer.textColor = [UIColor blackColor];
    dropDownMenuContainer.layer.shadowRadius = 1.3;
    dropDownMenuContainer.layer.shadowOpacity = 0.5;
    dropDownMenuContainer.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    dropDownMenuContainer.layer.masksToBounds = NO;
    dropDownMenuContainer.userInteractionEnabled = YES;
    TriangleDropDown *triagle = [[TriangleDropDown alloc] initWithFrame:CGRectMake(rect.size.width-20, 7, 12, 12)];
    [triagle setColor:[UIColor darkGrayColor]];
    [triagle rotateToDown];
    triagle.userInteractionEnabled = YES;
    [dropDownMenuContainer addSubview:triagle];
    
    
    UILabel *placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, rect.size.width, rect.size.height)];
    placeHolder.textColor = [UIColor darkGrayColor];
    placeHolder.backgroundColor = [UIColor clearColor];
    placeHolder.text = placeholder;
    [placeHolder setNuiClass:@"Label:DropDownMenu"];
    placeHolder.userInteractionEnabled = YES;
    [dropDownMenuContainer addSubview:placeHolder];
    
    
    UserDataTapGestureRecognizer *tapGesture = [[UserDataTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.userData = ary;
    tapGesture.currentLabel = placeHolder;
    [triagle addGestureRecognizer:tapGesture];
    [placeHolder addGestureRecognizer:tapGesture];
    [dropDownMenuContainer addGestureRecognizer:tapGesture];
    
    
    return dropDownMenuContainer;
    
}

-(UIView*)productsYouMayLikeHeader:(CGRect)rect placeHolder:(NSString*)str{
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, rect.size.width, rect.size.height)];
    lbl.text = str;
    [lbl setNuiClass:@"ProductYouMayLikeHeaderText"];
    [view addSubview:lbl];
 
     
    return view;

}


-(UIScrollView*)productYouMayLikeScrollView:(CGRect)rect{
    
    
    UIScrollView *imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,rect.size.height)];
    
    UIImageView* myImgViewsse;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:[NSString stringWithFormat:@"http://img0.etsystatic.com/006/0/7249371/il_570xN.378212052_e6vm.jpg"]];
    [colors addObject:[NSString stringWithFormat:@"http://img3.etsystatic.com/005/0/5998005/il_570xN.378598031_p44x.jpg"]];
    [colors addObject:[NSString stringWithFormat:@"http://img3.etsystatic.com/000/0/5987719/il_570xN.252582671.jpg"]];
    
    for (int i = 0; i < colors.count; i++) {
        CGRect frame;
		
        // horizontal scrolling
        frame.origin.x = 120 * i;
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
        myImgViewsse = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 100, 100)];
        
        // keep our autoresizing masks in place
        myImgViewsse.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        // async image loading & caching
        [myImgViewsse setImageWithURL:[NSURL URLWithString:[colors objectAtIndex:i]] placeholderImage:nil];
        
        UIImageView *temp = myImgViewsse;
        
        [myImgViewsse setImageWithURL:[NSURL URLWithString:[colors objectAtIndex:i]]
                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                
                                temp.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(100, 100) source:image];
                                
                            }];
        
        
        
        
        // image interaction enabled
        myImgViewsse.userInteractionEnabled = TRUE;
        
        // aspect fit mode
        //[myImgView setContentMode:UIViewContentModeScaleAspectFit];
        
        
        myImgViewsse.layer.shadowRadius = 1.3;
        myImgViewsse.layer.shadowOpacity = 0.5;
        myImgViewsse.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        myImgViewsse.layer.masksToBounds = NO;
        
        
        // add image to our subview collection
        [subview addSubview:myImgViewsse];
        
      
        
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
    
    
    return imgScrollView;
}

-(UIButton*)addToCartButton:(CGRect)frame{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(addToCartButtonAction)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Add to cart" forState:UIControlStateNormal];
    button.frame = frame;
    [button setNuiClass:@"addToCart"];
    return button;
}

-(void)addToCartButtonAction{
    
}

- (void)handleTap:(UserDataTapGestureRecognizer *)gesture {
    NSLog(@"Tapped");
    
    MenuViewController *menu = [[MenuViewController alloc] init];
    [menu setArray:gesture.userData];
    [menu setLabelToSend:gesture.currentLabel];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:menu];
    popover.border = YES;
   popover.contentSize = CGSizeMake(150,200);
        [popover.view setNuiClass:@"DropDownView"];
     popover.tint = FPPopoverWhiteTint;
    [popover presentPopoverFromView:gesture.view];
}


-(UILabel*)header:(NSString*)placeholder rect:(CGRect)rect{
    UILabel *header = [[UILabel alloc] initWithFrame:rect];
    header.backgroundColor = [UIColor clearColor];
    header.text = placeholder;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = header.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f] CGColor], nil];
    [header.layer insertSublayer:gradient atIndex:0];
    
    header.textColor = [UIColor blackColor];
    header.layer.shadowRadius = 1.3;
    header.layer.shadowOpacity = 0.5;
    header.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    header.layer.masksToBounds = NO;
    header.userInteractionEnabled = YES;
    
    TriangleDropDown *triagle = [[TriangleDropDown alloc] initWithFrame:CGRectMake(rect.size.width-20, 13, 12, 12)];
    [triagle setColor:[UIColor darkGrayColor]];
    triagle.userInteractionEnabled = YES;
    [header addSubview:triagle];
    
    
    UILabel *placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, rect.size.width, rect.size.height)];
    placeHolder.textColor = [UIColor darkGrayColor];
    placeHolder.backgroundColor = [UIColor clearColor];
    placeHolder.text = placeholder;
    [placeHolder setNuiClass:@"Label:DropDownMenu"];
    placeHolder.userInteractionEnabled = YES;
    [header addSubview:placeHolder];
    
    
    
    
    
    return header;

   
    
    
}


-(UIWebView*)productDesc:(NSString*)html frame:(CGRect)rect{
    
   UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
    webView.scrollView.scrollEnabled = NO;
    
    NSString *htmls = [NSString stringWithFormat:@"%@ %@",@"<style type=\"text/css\"> \n"
                       "body {font-family: \"Helvetica\"; font-size: 14px;}\n"
                       "</style>"
                       ,html];
    [webView loadHTMLString:htmls baseURL:nil];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    webView.delegate = self;
   
    return webView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
  
    float height = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] floatValue];
    NSLog(@"%f",height);
   
    getHeight = height+10;
}

-(float)getWebViewHeight{
    
    return getHeight;
}

@end
