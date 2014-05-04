//
//  PostDetailViewController.m
//  Candy Cart
//
//  Created by Nhuan Quang  Company Limited on 8/23/13.
//  Copyright (c) 2013 Nhuan Quang. All rights reserved.
//

#import "PostDetailViewController.h"

@interface PostDetailViewController ()

@end

@implementation PostDetailViewController

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
    self.title = [post objectForKey:@"title"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    [self compilePostView];
    
    [self createCommentView];
    
   shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(self.view.frame.size.width - 69, 8, 63, 30);
    shareBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [shareBtn setTitle:NSLocalizedString(@"product_detail_view_share_btn", nil) forState:UIControlStateNormal];
    [shareBtn addTarget:self
                 action:@selector(shareBtnAction)
       forControlEvents:UIControlEventTouchDown];
    
    [shareBtn setNuiClass:@"UiBarButtonItem"];
    [shareBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = button;
    
    
   

}

-(void)shareBtnAction{
    
    socialMediaController *menu = [[socialMediaController alloc] init];
    menu.delegate = self;
    [menu setUrl:[post objectForKey:@"permalink"]];
    
    sharePopOver = [[FPPopoverController alloc] initWithViewController:menu];
    sharePopOver.border = YES;
    
    sharePopOver.contentSize = CGSizeMake(170,170);
    [sharePopOver.view setNuiClass:@"DropDownView"];
   
    [sharePopOver presentPopoverFromView:shareBtn];
    
}


-(void)didChooseEmail{
    NSLog(@"Did Choose");
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    NSString *emailBody = [post objectForKey:@"permalink"];
    [mailer setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailer animated:YES completion:nil];
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


-(void)compilePostView{
    
    [self createTopView];
    [self createBottomView];
    
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


-(void)createTopView{
    
    
    current_index_image = 0; //init image index;
    imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,320)];
    imgScrollView.delegate = self;
    
    
    UIImageView* myImgViewsse;
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    //Get Featured Image
    [colors addObject:[[post objectForKey:@"images"] objectForKey:@"featured_image"]];
    
    //Get Other Images
    NSArray *otherImages = [[post objectForKey:@"images"] objectForKey:@"other_images"];
    
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

    UILabel *he = [[UILabel alloc] initWithFrame:topView.bounds];
    [topView addSubview:he];
    
    UITextView *tryDulu = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 310,60)];
    tryDulu.text = [post objectForKey:@"title"];
    tryDulu.backgroundColor = [UIColor clearColor];
    tryDulu.textColor = [UIColor whiteColor];
    tryDulu.font = [UIFont fontWithName:BOLDFONT size:18];
    
    
    [he addSubview:tryDulu];
    
   
    
    
    UILabel *ago = [[UILabel alloc] initWithFrame:CGRectMake(205, 200, 120, 40)];
    ago.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    ago.text = [post objectForKey:@"post_date_ago"];
    ago.font = [UIFont fontWithName:PRIMARYFONT size:13];
    ago.layer.cornerRadius = 3;
    ago.layer.masksToBounds = YES;
    ago.textAlignment = NSTextAlignmentCenter;
    ago.textColor = [UIColor whiteColor];
    [he addSubview:ago];
    
    
    [he addSubview:ago];
    
    
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [topView addGestureRecognizer:tapGesture];
    
}

- (void)commentTap:(UIGestureRecognizer *)gesture {
    
    NSLog(@"Go To Comment");
    
    CommentViewController *comment = [[CommentViewController alloc] init];
    comment.postID = [post objectForKey:@"ID"];
    comment.title = NSLocalizedString(@"product_detail_reviews_btn_title", nil);
   
    [self.navigationController pushViewController:comment animated:YES];
    
}

-(void)createBottomView{
    NSString *resources = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [NSURL fileURLWithPath:resources];
    bottomWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 335)];
    bottomWeb.delegate = self;
    
    NSString *myHTML = [NSString stringWithFormat:@"<script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><script src='%@'></script><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'><link href='%@' rel='stylesheet'> <style type=\"text/css\">body {background-color: transparent; padding:10px; font-family: \"%@\"; font-size: %@;} img{ width:100%%; height:auto; }</style><body>%@<br><br><br></body>",JQUERY,BOOTSTRAP_JS,CUSTOM_JS,SWIPER_JS,SWIPER_JS_SCROLLBAR,SWIPER_JS_3D_FLOW,BOOTSTRAP_CSS,BOOTSTRAP_THEME,CUSTOM_CSS,SWIPER_CSS,SWIPER_CSS_SCROLLBAR,SWIPER_CSS_3D,PRIMARYFONT,GENERAL_UIWEBVIEW_FONT_SIZE,[[ToolClass instance] decodeHTMLCharacterEntities:[post objectForKey:@"full_content"]]];
    [bottomWeb loadHTMLString:myHTML baseURL:baseURL];
    
    bottomWeb.backgroundColor = [UIColor clearColor];
    
    bottomWeb.scrollView.delegate = self;
    [bottomWeb setOpaque:NO];
    bottomWeb.scrollView.scrollEnabled = NO;
    bottomView = [[UIView alloc] initWithFrame:bottomWeb.bounds];
   
    [bottomView addSubview:bottomWeb];
     [bottomView setNuiClass:@"ViewInit"];
    for(UIView *wview in [[[bottomWeb subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
    }
    bottomView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(0, -1);
    bottomView.layer.shadowRadius = 1;
    bottomView.layer.shadowOpacity = 0.3;
    bottomView.userInteractionEnabled = YES;
    bottomView.multipleTouchEnabled = YES;
    
    
    
}


-(void)createCommentView{
    NSString *comment_status = [post objectForKey:@"comment_status"];
    if([comment_status isEqualToString:@"open"])
    {
    UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 30, 30)];
    commentIcon.image = [UIImage imageNamed:@"commenticon"];
    commentIcon.userInteractionEnabled = YES;
    
    UILabel *comments = [[UILabel alloc] initWithFrame:CGRectMake(260, 440, 50, 50)];
    comments.backgroundColor = [UIColor colorWithRed:210 green:210 blue:210 alpha:1];
    
    comments.userInteractionEnabled = YES;
    comments.font = [UIFont fontWithName:PRIMARYFONT size:13];
    comments.layer.cornerRadius = 25;
    comments.layer.masksToBounds = YES;
    
    comments.layer.borderColor = [UIColor lightGrayColor].CGColor;
    comments.layer.borderWidth = 0.5;
    
    [comments addSubview:commentIcon];
    
    [parallaxView addSubview:comments];
    
    UITapGestureRecognizer *tapGestureComment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap:)];
    [commentIcon addGestureRecognizer:tapGestureComment];
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
   
    
    NSString *webViewHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    bottomWeb.frame = CGRectMake(0, 0, 320, [webViewHeight floatValue]);
    bottomView.frame = CGRectMake(0, 0, 320, [webViewHeight floatValue]);
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

- (void)handleTap:(UIGestureRecognizer *)gesture {
    
    
    
    //self.title = NSLocalizedString(@"back_btn_title", nil);
    
    
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    
    
    
     
        //Get Featured Image
        
        
        [photos addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:[[post objectForKey:@"images"] objectForKey:@"featured_image"]]]];
        
        
        //Get Other Images
        NSArray *otherImages = [[post objectForKey:@"images"] objectForKey:@"other_images"];
        
        for (int otherIm = 0; otherIm<[otherImages count]; otherIm++) {
        
            
            [photos addObject:[IDMPhoto photoWithURL:[NSURL URLWithString:[otherImages objectAtIndex:otherIm]]]];
        }
    
    
    
   
    
    
    
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    
    browser.delegate = self;
    [browser setInitialPageIndex:current_index_image];
    browser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // Show
    [self presentViewController:browser animated:YES completion:nil];
    
    
    
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index
{
    //id <IDMPhoto> photo = [photoBrowser photoAtIndex:index];
    
    
    
    
}

-(void)setPostDictionary:(NSDictionary*)setPost{
    
    post = setPost;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
